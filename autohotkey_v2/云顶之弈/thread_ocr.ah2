Persistent
#ErrorStdOut
#include <wincapture> 
#include <cv2>
#include <my_lib>
#include <log>
#include <RapidOcr>
#include <CGdip>

SetKeyDelay(-1)
SetMouseDelay(-1)

logger.is_log_open := true
logger.is_out_file := true
cv := ObjFromPtr(DllCall('opencv_ahk.dll\opencv_init', 'ptr', DllCall(A_AhkPath '\ahkGetApi', 'ptr'), 'cdecl ptr'))

;必须执行这步，提前加载dll
dxcp := wincapture.DXGI()

rpd_orc := RapidOcr()
g_all_hero := Map()
g_status := false
g_position := Map()
g_screen_shot := cv.Mat()
g_screen_shot.create(A_ScreenHeight, A_ScreenWidth, cv2.CV_8UC4)
g_click_time_out := 1000
g_BackgroundColorRGB := 0x080f10
CoordMode('ToolTip', 'Screen')
CoordMode('Mouse', 'Screen')
CoordMode('Pixel', 'Screen')
CoordMode('Caret', 'Screen')

;从屏幕指定位置识别
#Lbutton::
{
	CGdip.Startup()
	GetRange(&x, &y, &w, &h)
	MsgBox(x " " y " " w " " h)
	bitmap := CGdip.Bitmap.FromScreen()
	bb := BitmapBuffer.loadGpBitmap(bitmap)

    g_position := Map('position', [x, y, w, h])

    ;计算五个图片的查找范围
    ;每个小图w
    mw := Integer(g_position['position'][3] / 5)
    mx1 := [], my1 := [], mx2 := [], my2 := []
    ;文字的w度/每一小格的宽度
    radio := 0.76
    loop(5)
    {
        i := A_Index
        mx1.Push(Integer(g_position['position'][1] + (i - 1) * mw))
        my1.Push(Integer(g_position['position'][2]))
        mx2.Push(Integer(g_position['position'][1] + (i - 1) * mw + radio * mw))
        my2.Push(Integer(g_position['position'][2] + g_position['position'][4]))
    }

    loop(5)
    {
        i := A_Index
        HighlightOutline(mx1[i], my1[i], mx2[i], my2[i],,,,50)
        mbb := bb.range(mx1[i], my1[i], mx2[i], my2[i], true)
        rtn := rpd_orc.ocr_from_bitmapdata(mbb.info)
        MsgBox(rtn)
    }
    CGdip.Shutdown()
}

;查找图片并点击
find_and_click(pic_path, is_spend_all := false, is_run_one_time := false)
{
    global g_status
    global g_screen_shot
    BackgroundColorRGB := g_position['HX']['BackgroundColorRGB']
    logger.info(pic_path)
    logger.info(is_spend_all)
    logger.in(pic_path, g_position)
    ;rtn := dxgi_pixelgetcolor(0, 0, &p_vitmap_file := 0, &p_bitmap_info := 0 , &p_bitmap_data := 0, &is_time_out := false)
    if(pic_path.Count == 0)
    {
        logger.info("no hero check!")
        MsgBox("请先选择英雄!")
        return
    }
    HighlightOutline(g_position['position'][1], g_position['position'][2], g_position['position'][1] + g_position['position'][3], g_position['position'][2] + g_position['position'][4],,,,2000)
    ;Ocr 流程

    CGdip.Startup()
    ;计算五个图片的查找范围
    ;每个小图w
    mw := Integer(g_position['position'][3] / 5)
    mx1 := [], my1 := [], mx2 := [], my2 := []
    ;文字的w度/每一小格的宽度
    radio := 0.76
    loop(5)
    {
        i := A_Index
        mx1.Push(Integer(g_position['position'][1] + (i - 1) * mw))
        my1.Push(Integer(g_position['position'][2]))
        mx2.Push(Integer(g_position['position'][1] + (i - 1) * mw + radio * mw))
        my2.Push(Integer(g_position['position'][2] + g_position['position'][4]))
    }
    logger.info(mx1, mx2)

    loop
    {
        canbuy := true
        ;截图
        bitmap := CGdip.Bitmap.FromScreen()
        bb := BitmapBuffer.loadGpBitmap(bitmap)
        hero_ocr := '' 
        loop(5)
        {
            i := A_Index
            ;HighlightOutline(mx1[i], my1[i], mx2[i], my2[i],,,,50)
            mbb := bb.range(mx1[i], my1[i], mx2[i], my2[i], true)
            rtn := rpd_orc.ocr_from_bitmapdata(mbb.info)
            rtn := RegExReplace(rtn, "\s", "")
            hero_ocr .= A_Index ': ' rtn '`n'
            logger.info(A_Index hero_ocr)
            logger.info(g_status, canbuy, is_run_one_time)
            logger.info('>' rtn '<')

            CoordMode('Mouse')
            StartTime := A_TickCount
            x := mx1[i] + Integer(mw / 2)
            y := my1[i] - Integer(mw / 2)
            if(pic_path.Has(rtn) && pic_path[rtn] != 0)
            {
                if(g_position['is_stop'])
                {
                    loop
                    {
                        SendInput("{Click " x " " y " 0}")
                        sendinput("{LButton down}")
                        sleep(g_position['HX']['mouse_hold_time'])
                        sendinput("{LButton up}")
                        sendinput("{LButton up}")

                        color := PixelGetColor(x+10, y - 10)
                        colorA := PixelGetColor(x+20, y - 20)
                        colorB := PixelGetColor(x+40, y - 40)
                        ElapsedTime := A_TickCount - StartTime
                        if((color == BackgroundColorRGB) || (colorA == BackgroundColorRGB) || (colorB == BackgroundColorRGB) || (ElapsedTime>=g_click_time_out))
                        {
                            if(ElapsedTime >= g_click_time_out)
                            {
                                canbuy := false
                                logger.info(BackgroundColorRGB, "  -- ", color, colorA, colorB)
                            }
                            break
                        }
                    }
                }
                else
                {
                    loop(g_position['click_on_the_number_of_times'])
                    {
                        SendInput("{Click " x " " y " 0}")
                        sendinput("{LButton down}")
                        sleep(g_position['HX']['mouse_hold_time'])
                        sendinput("{LButton up}")
                        sendinput("{LButton up}")
                    }
                }
                MouseMove(g_position['HX']['back_position'][1], g_position['HX']['back_position'][2])
            }
        }until ((g_status == false) || !canbuy)
        ToolTip(A_Index '`n' hero_ocr, 0, 0)

        if(is_spend_all && canbuy && (g_status == true))
        {
            SendInput("{d Down}")
            logger.info(g_position['HX']['key_hold_time'])
            sleep(g_position['HX']['key_hold_time'])
            SendInput("{d Up}")
        }
        logger.info(A_index, "  <--end")
        Sleep(g_position['HX']['find_fs'])
    }until ((g_status == false) || !canbuy || is_run_one_time)
    CGdip.Shutdown()

    ToolTip("退出", 0, 0)
    logger.out("end")
    ;Gdip_Shutdown(pToken)
}

;停止循环找图
stop_all()
{
    global g_status
    g_status := false
}


set_position_config(position_config)
{
    global g_position
    logger.in(position_config)
    g_position := position_config
    logger.out()
}
set_all_hero(config)
{
    global g_all_hero
    for k,v in config
    {
        for i,j in v
        {
            g_all_hero[j] := 0
        }
    }
    logger.info(g_all_hero)
}

myexit()
{
    ;RunWait(A_ScriptDir "/lib/empty.exe AutoHotkey.exe",,'Hide')
    try{
        logger.in()
        ExitApp
        logger.out()
    }
}