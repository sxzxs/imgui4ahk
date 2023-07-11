Persistent
#ErrorStdOut
#include <wincapture> 
#include <cv2>
#include <my_lib>
#include <log>
;#include <Gdip_All>
#include <ImagePut>

#include <RapidOcr>
#include <CGdip>

SetKeyDelay(-1)
SetMouseDelay(-1)

logger.is_log_open := true
logger.is_out_file := false
cv := ObjFromPtr(DllCall('opencv_ahk.dll\opencv_init', 'ptr', DllCall(A_AhkPath '\ahkGetApi', 'ptr'), 'cdecl ptr'))
dxcp := {}
;rpd_orc := RapidOcr()
g_status := false
g_position := Map()
g_screen_shot := cv.Mat()
g_screen_shot.create(A_ScreenHeight, A_ScreenWidth, cv2.CV_8UC4)
g_click_time_out := 1000
g_BackgroundColorRGB := 0x080f10
g_is_dx_init := false
CoordMode('ToolTip', 'Screen')
CoordMode('Mouse', 'Screen')
CoordMode('Pixel', 'Screen')
CoordMode('Caret', 'Screen')

/*
;从屏幕指定位置识别
#a::
{
    global g_is_dx_init
    global dxcp
    if(!g_is_dx_init)
    {
        dxcp := wincapture.DXGI()
        g_is_dx_init := true
    }
	CGdip.Startup()
    if(!my_select_region(&x, &y, &w, &h))
        return
	bitmap := CGdip.Bitmap.FromScreen()
	bb := BitmapBuffer.loadGpBitmap(bitmap)

    mbb := bb.range(x, y, x + w, y + h, true)
    rtn := rpd_orc.ocr_from_bitmapdata(mbb.info)
    MsgBox(rtn)
    CGdip.Shutdown()
}
*/

;查找图片并点击
find_and_click(pic_path, is_spend_all := false, is_run_one_time := false)
{
    global g_status
    global g_screen_shot
    BackgroundColorRGB := g_position['HX']['BackgroundColorRGB']
    last_money := 0
    logger.info(pic_path)
    logger.info(is_spend_all)
    logger.in(pic_path, g_position)
    logger.info(g_position['min_money'])
    ;rtn := dxgi_pixelgetcolor(0, 0, &p_vitmap_file := 0, &p_bitmap_info := 0 , &p_bitmap_data := 0, &is_time_out := false)
    if(pic_path.Count == 0)
    {
        logger.info("no hero check!")
        MsgBox("请先选择英雄!")
        return
    }
    HighlightOutline(g_position['position'][1], g_position['position'][2], g_position['position'][1] + g_position['position'][3], g_position['position'][2] + g_position['position'][4],,,,2000)

    HighlightOutline(g_position['ocr_money_position'][1], 
                        g_position['ocr_money_position'][2], 
                        g_position['ocr_money_position'][1] + g_position['ocr_money_position'][3], 
                        g_position['ocr_money_position'][2] + g_position['ocr_money_position'][4],,,,1000)
    loop
    {
        ToolTip(A_Index 'begin', 0, 0)
        logger.info(A_index, " -->in")
        canbuy := true
        ;设置匹配map，当有英雄匹配到的时候，放进去
        match_hero_map := Map()
        loop(5)  ;有五张卡
        {
            loop_index := A_Index
            try
            {
                if(g_position['HX']['dxgi'])
                    screen_shot_dx()
                else
                {
                    ;screen_shot()
                    dxgi_screen_shot_to_mat(g_screen_shot.ptr)
                }
            }
            for pic in pic_path
            {
                if(pic_path[pic] == 0)
                    continue
                ;后面几轮只找第一轮匹配到的英雄
                if(!match_hero_map.Has(pic) && (loop_index != 1))
                    continue
                if(!FileExist(A_ScriptDir "\image\hero\" pic ".bmp"))
                    continue
                rtn := find_image_from_screen(g_screen_shot, A_ScriptDir "\image\hero\" pic ".bmp", 
                                                g_position['position'][1], 
                                                g_position['position'][2], 
                                                g_position['position'][3], 
                                                g_position['position'][4])
                if(rtn["sim"] > g_position['HX']['sim'])
                {
                    ;在第一轮中，放入匹配的英雄, 后面四轮只找map中的英雄
                    if(loop_index == 1)
                        match_hero_map[pic] := 1
                    x := rtn["x"], y := rtn["y"]
                    x := x + g_position['position'][1] + 20
                    y := y + g_position['position'][2] + 20
                    CoordMode('Mouse')
                    StartTime := A_TickCount
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
                    if(!canbuy)
                        break
                }
                if(g_status == false)
                    break
            }
        }until (g_status == false || !canbuy)

        /*
        identification_numbers(g_screen_shot, A_ScriptDir '\image\number', 
                                g_position['ocr_money_position'][1], g_position['ocr_money_position'][2], 
                                g_position['ocr_money_position'][3], g_position['ocr_money_position'][4], 
                                &text,
                                thresh := 150)
        ToolTip('ocr money >' text '<', 0, 200, 2)
        */
        if(is_spend_all && canbuy && (g_status == true))
        {
            ;通过ocr判定是否停止
            if(g_position['is_use_ocr_find_money'])
            {
                text := ''
                ;ocr_get_text_form_postion(g_position['ocr_money_position'][1], g_position['ocr_money_position'][2], 
                                            ;g_position['ocr_money_position'][3], g_position['ocr_money_position'][4], &text)
                try
                {
                    identification_numbers(g_screen_shot, A_ScriptDir '\image\number', 
                                            g_position['ocr_money_position'][1], g_position['ocr_money_position'][2], 
                                            g_position['ocr_money_position'][3], g_position['ocr_money_position'][4], 
                                            &text,
                                            thresh := 150)
                }
                logger.err('ocr money >' text '<')
                ToolTip('ocr money >' text '<', 0, 200, 2)
                if(IsInteger(text) && text >=  g_position['min_money'])
                {
                    if(text > last_money)
                    {
                        last_money := text
                        continue
                    }
                    SendInput("{d Down}")
                    logger.info(g_position['HX']['key_hold_time'])
                    sleep(g_position['HX']['key_hold_time'])
                    SendInput("{d Up}")
                }
                if(IsInteger(text))
                    last_money := text
            }
            else
            {
                SendInput("{d Down}")
                logger.info(g_position['HX']['key_hold_time'])
                sleep(g_position['HX']['key_hold_time'])
                SendInput("{d Up}")
            }
        }
        logger.info(A_index, "  <--end")
        Sleep(g_position['HX']['find_fs'])
        ToolTip(A_Index 'end', 0, 20)
    }until ((g_status == false) || !canbuy || is_run_one_time)
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

/**
* 屏幕指定区域找图
* @src 图像
* @param template_path 目标图像路径
* @param thresh 图像灰度二值化 0-255
* @param x ROI x
* @param y ROI y
* @param w ROI w
* @param h ROI h
* @return  {map}
* Map("src", l_screen_shot_roi,"x", x, "y", y, "sim", sim, "template", Map("w", template.cols ,"h", template.rows))
*/
find_image_from_screen(src, template_path, x, y, w, h, thresh := 100)
{
	;截屏
	logger.info("in", template_path)
	l_screen_shot := src
	l_screen_shot.copyTo(l_screen_shot_roi := cv.Mat())
	l_screen_shot_roi := l_screen_shot_roi([x, y, w, h])
	;读取模板
	template := cv.imread(template_path)
	;转换为灰度
	cv.cvtColor(l_screen_shot_roi, gray_src := cv.Mat(), cv2.CV_COLOR_BGRA2GRAY)
	cv.cvtColor(template, gray_template := cv.Mat(), cv2.CV_COLOR_BGRA2GRAY)
	;二值化
	cv.threshold(gray_src, gray_src, thresh, 255, cv2.CV_THRESH_BINARY)
	cv.threshold(gray_template, gray_template, thresh, 255, cv2.CV_THRESH_BINARY)

    ;cv.imshow("src", gray_src)
    ;MsgBox("暂停")
    ;cv.imshow("src", gray_template)
    ;MsgBox("暂停")

	method := cv2.CV_TM_CCORR_NORMED
	;method := cv2.CV_TM_SQDIFF_NORMED
	;method := cv2.CV_TM_CCOEFF_NORMED
	;mask参数目前opencv好像没有实现
	cv.matchTemplate(gray_src, gray_template, res := cv.Mat(), method)
	cv.minMaxLoc(res, &minVal, &maxVal, &minLoc, &maxLoc)

	if(method == cv2.CV_TM_SQDIFF || method == cv2.CV_TM_SQDIFF_NORMED)
		matchLoc := minLoc, sim := minVal
	else
		matchLoc := maxLoc, sim := maxVal

	x := matchLoc[1]
	y := matchLoc[2]
	rtn := Map("src", l_screen_shot_roi,"x", x, "y", y, "sim", sim, "template", Map("w", template.cols ,"h", template.rows), 'thread_id', A_ThreadID)
    logger.info(rtn)
	logger.info('exit')
	return rtn
}

screen_to_memory_mat()
{
	hwindowDC := GetDC(0)
	hwindowCompatibleDC := CreateCompatibleDC(hwindowDC)
	SetStretchBltMode(hwindowCompatibleDC, 4)

    nScreenWidth := A_ScreenWidth
    nScreenHeight := A_ScreenHeight

    srcheight := nScreenHeight
    srcwidth := nScreenWidth
    height := nScreenHeight ;//change this to whatever size you want to resize to
    width := nScreenWidth

	g_screen_shot.create(height, width, cv2.CV_8UC4)
    MsgBox(g_screen_shot.ptr)

    ;create a bitmap
    hbwindow := CreateCompatibleBitmap(hwindowDC, width, height)
    bi := Buffer(40, 0)
    NumPut("uint", 40, "int", width, "int", -height, "ushort", 1, "ushort", 32, "uint", 0, "uint", 0, "int", 0, "int", 0, "uint", 0, "uint", 0, bi)

	;use the previously created device context with the bitmap
	SelectObject(hwindowCompatibleDC, hbwindow)
    ; copy from the window device context to the bitmap device context
    StretchBlt(hwindowCompatibleDC, 0, 0, width, height, hwindowDC, 0, 0, srcwidth, srcheight) ;change SRCCOPY to NOTSRCCOPY for wacky colors !
	DllCall("gdi32\GetDIBits"
                , "UPtr", hwindowCompatibleDC
                , "UPtr", hbwindow
                , "uint", 0
                , "uint", height
                , "ptr", g_screen_shot.ptr
                , "ptr", bi.Ptr
                , "uint", 0)
    ;GetDIBits(hwindowCompatibleDC, hbwindow, 0, height, g_screen_shot.ptr, bi, DIB_RGB_COLORS := 0) ;copy from hwindowCompatibleDC to hbwindow

	DeleteObject(hbwindow), DeleteDC(hwindowCompatibleDC), ReleaseDC(hwindowDC, 0)
    cv.imshow("src", g_screen_shot)
    MsgBox("暂停")
}
screen_shot_image_put()
{
    buf := ImagePutBuffer(0)
    Channels := 4
    src := cv.Mat(buf.height, buf.width, cv.constants.CV_8UC4, buf.Ptr, (buf.width * Channels + 3) & -4)
    src.copyTo(g_screen_shot)
	cv.cvtColor(g_screen_shot, g_screen_shot, cv2.CV_COLOR_ARGB2BGRA)
}

/*
screen_shot_gdip()
{
    wid := A_ScreenWidth
    hei := A_ScreenHeight
    pBits := 0x00000000
    pToken := Gdip_StartUp()
    chdc := CreateCompatibleDC(GetDC(0))
    ;hbm := CreateDIBSection(wid, hei, chdc, 24, &pBits)
    hbm := CreateDIBSection(wid, hei, chdc, 32, &pBits)
    obm := SelectObject(chdc, hbm)
    hhdc := GetDC(0)
    BitBlt(chdc, 0, 0, wid, hei, hhdc, 0, 0, 0xCC0020)

    logger.info(hei, wid, pBits)
    ;Channels := 3
    Channels := 4
    ;src := cv.Mat(hei, wid, cv.constants.CV_8UC3, pBits, (wid * Channels + 3) & -4)
    src := cv.Mat(hei, wid, cv.constants.CV_8UC4, pBits, (wid * Channels + 3) & -4)
    cv.flip(src, src, 0)
    src.copyTo(g_screen_shot)

    SelectObject(chdc, obm)
    DeleteObject(hbm)
    DeleteDC(chdc)
    ReleaseDC(hhdc)    
    Gdip_Shutdown(pToken)
}
*/

screen_shot()
{
    global g_screen_shot
    rtn := dxgi_pixelgetcolor(0, 0, &p_vitmap_file := 0, &p_bitmap_info := 0 , &p_bitmap_data := 0, &is_time_out := false)
    bb := BitmapBuffer(p_bitmap_data, A_ScreenWidth * 4, A_ScreenWidth, A_ScreenHeight, 4)
    ;bb := bb.cvtBytes(3)
    wid := bb.width ,hei := bb.height, pBits:= bb.Ptr, Channels := 4 ;通道
    cv.Mat(hei, wid, cv.constants.CV_8UC4, pBits, (wid * Channels + 3) & -4).copyTo(g_screen_shot)
}
screen_shot_dx()
{
    global g_is_dx_init
    global dxcp
    if(!g_is_dx_init)
    {
        dxcp := wincapture.DXGI()
        g_is_dx_init := true
    }
    global g_screen_shot
    logger.in()
	l_new_image := false
    logger.info("screen 1")
    static cb := CallbackCreate(revice)
    dxcp.capture(cb)
    logger.info("screen 4")
    cv.cvtColor(g_screen_shot, g_screen_shot, cv2.CV_COLOR_BGR2BGRA)
    ;cv.imshow("src", g_screen_shot)

    ;DXGI截图回调函数
    revice(pdata, pitch, sw, sh, tick) 
    {
        logger.info("screen 2")
        if tick && pdata 
        {
            bb := BitmapBuffer(pdata, pitch, sw, sh)
            bb := bb.cvtBytes(3)
            wid := bb.width ,hei := bb.height, pBits:= bb.Ptr, Channels := 3 ;通道
            cv.Mat(hei, wid, cv.constants.CV_8UC3, pBits, (wid * Channels + 3) & -4).copyTo(g_screen_shot)
        }
        logger.info("screen 3")
    }
}

set_position_config(position_config)
{
    global g_position
    logger.in(position_config)
    g_position := position_config
    logger.out()
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

/*
ocr_get_text_form_postion(x, y, w, h, &text)
{
	CGdip.Startup()
	bitmap := CGdip.Bitmap.FromScreen()
	bb := BitmapBuffer.loadGpBitmap(bitmap)
    ;计算五个图片的查找范围
    mbb := bb.range(x, y, x + w, y + h, true)
    text := rpd_orc.ocr_from_bitmapdata(mbb.info)
    text := RegExReplace(text, "\s", "")
    CGdip.Shutdown()
}
*/

my_select_region(&x, &y, &w, &h)
{
    rtn := ReadProcessStdOut(A_ScriptDir '\get_region.exe')
    logger.info(rtn)
    if(rtn != 'error')
    {
        word_array := StrSplit(rtn, A_Space, ".")  ; 忽略句点.
        x := word_array[1], y := word_array[2]
        w := word_array[3], h := word_array[4]
    }
    else
    {
        return false
    }
    return true
}
;屏幕区域数字识别
identification_numbers(src, template_path, x, y, w, h, &number_result, thresh := 150)
{
    static is_read_template := false
    static template_array := Map()
    if(false == is_read_template)
    {
        rtn := read_template(template_path, &template_array)
        if(!rtn)
        {
            logger.info('读取模板失败')
            return rtn
        }
        is_read_template := true
    }

    rtn := true
	logger.info("in", template_path)
	src.copyTo(img := cv.Mat())
	img := img([x, y, w, h])

    ;灰度图像
    cv.cvtColor(img, img_grey := cv.Mat(), cv2.CV_COLOR_BGR2GRAY)
    logger.info('灰度')
    ;cv.imshow('img', img_grey)
    ;cv.waitkey()
    ;二值化
    thresh := 150
	cv.threshold(img_grey, img_grey, thresh, 255, cv2.CV_THRESH_BINARY)

    logger.info('二值化')
    ;cv.imshow('img', img_grey)
    ;cv.waitkey()

    ;膨胀
    ;k := cv.getStructuringElement(cv2.CV_MORPH_RECT, [3, 3], [-1, -1])
    ;cv.dilate(img_grey, img_grey_copy := cv.mat(), k)
    ;logger.info('膨胀')
    ;cv.imshow('img', img_grey_copy)
    ;cv.waitkey()

    ;边缘检测，字符分割
    cv.findContours(img_grey, contours := cv.Vector_Vector_Point(), cv2.CV_RETR_EXTERNAL, cv2.CV_CHAIN_APPROX_SIMPLE, [])
    ;cv.findContours(img_grey, contours := cv.Vector_Vector_Point(), cv2.CV_RETR_LIST, cv2.CV_CHAIN_APPROX_SIMPLE, [])
    ;cv.findContours(img_grey, contours := cv.Vector_Vector_Point(), cv2.CV_RETR_LIST, cv2.CV_CHAIN_APPROX_NONE, [])
    ;cv.findContours(img_grey, contours := cv.Vector_Vector_Point(), hierarchy := cv.vector_vec4i(), cv2.CV_RETR_TREE, cv2.CV_CHAIN_APPROX_SIMPLE)

    ;显示边缘检测
    ;cv.drawContours(img, contours, -1, [0, 0, 255, 0], 1)

    logger.info('检测')
    ;cv.imshow('img', img)
    ;cv.waitkey()

    logger.info(contours.size)
    rect_array := []
    loop(contours.size)
    {
        logger.info(contours[A_Index - 1].toArray())
        rect := cv.boundingRect(contours[A_Index - 1])
        logger.info(rect)
        number := img_grey(rect)
        rect_array.Push(rect)
        ;cv.imshow('number', number)
        ;cv.waitkey()
    }
    logger.info(rect_array)
    ;冒泡排序
    sort_rect := []
    if(rect_array.Length > 1)
    {
        loop(rect_array.Length - 1)
        {
            loop(rect_array.Length - A_Index)
            {
                if(rect_array[A_Index][1] > rect_array[A_Index + 1][1])
                {
                    temp := rect_array[A_Index]
                    rect_array[A_Index] := rect_array[A_Index + 1]
                    rect_array[A_Index + 1] := temp
                }
            }
        }
    }
    logger.info(rect_array)
    ;cv.imshow('img', img_grey)
    ;cv.waitkey()


    ;模板匹配
    number_result := ''
    loop(contours.size)
    {
        gray_src_index := A_Index
        max_score := 0
        number := 0
        is_ok := false

        gray_src := cv.imread(template_path '\back.bmp')
        cv.cvtColor(gray_src, gray_src, cv2.CV_COLOR_BGR2GRAY)

        ;cv.imshow(A_index, gray_src)
        ;cv.waitkey()

        logger.info(rect_array[gray_src_index])
        img_grey(rect_array[gray_src_index]).copyTo(gray_src(rect_array[gray_src_index]))

        ;cv.imshow('img', gray_src)
        ;cv.waitkey()

        for k,v in template_array
        {
            method := cv2.CV_TM_CCORR_NORMED
            gray_template := v

            ;cv.resize(gray_src, gray_src, [gray_template.cols, gray_template.rows])
            logger.info(gray_src.cols, gray_src.rows)
            logger.info(gray_template.cols, gray_template.rows)

            if(gray_template.cols > gray_src.cols || gray_template.rows > gray_src.rows)
            {
                logger.info('匹配大小不对')
                number_result := ''
                return false
            }

            cv.matchTemplate(gray_src, gray_template, res := cv.Mat(), method)
            cv.minMaxLoc(res, &minVal, &maxVal, &minLoc, &maxLoc)

            if(method == cv2.CV_TM_SQDIFF || method == cv2.CV_TM_SQDIFF_NORMED)
                matchLoc := minLoc, sim := minVal
            else
                matchLoc := maxLoc, sim := maxVal
            logger.info(k, sim)
            if(sim > max_score && sim > 0.9)
            {
                is_ok := true
                max_score := sim
                number := k
            }
        }
        if(is_ok)
            number_result .= number
    }
    number_result := RegExReplace(number_result, '[^0-9]', "")
    logger.info(number_result)
    return rtn
}
read_template(template_path, &template_array := Map(), thresh := 150)
{
    rtn := true
    ;读取模板图像
    loop(10)
    {
        template_array[A_Index - 1] := cv.mat()
    }
    for k,v in template_array
    {
        ;读取图像
        template_array[k] := cv.imread(template_path '\'  k '.bmp')
        ;灰度图像
        cv.cvtColor(template_array[k], template_array[k], cv2.CV_COLOR_BGR2GRAY)
        ;二值化
        cv.threshold(template_array[k], template_array[k], thresh, 255, cv2.CV_THRESH_BINARY)

        ;边缘检测，字符分割
        cv.findContours(template_array[k], temp_contours := cv.Vector_Vector_Point(), cv2.CV_RETR_EXTERNAL, cv2.CV_CHAIN_APPROX_SIMPLE, [])

        ;显示边缘检测
        ;cv.drawContours(img, temp_contours, -1, [0, 0, 255, 0], 1)
        if(temp_contours.size != 1)
        {
            logger.info('模板不对')
            return false
        }
        rect := cv.boundingRect(temp_contours[0])
        logger.info(rect)
        template_array[k] := template_array[k](rect)
        ;cv.imshow('img', template_array[k])
        ;cv.waitkey()
    }
    return rtn
}