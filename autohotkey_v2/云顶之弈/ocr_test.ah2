#include <RapidOcr>
#include <wincapture>
#include <CGdip>
;#include <Gdip_All>

rpd_orc := RapidOcr()
dxcp := wincapture.DXGI()
CGdip.Startup()

/*
;从图片识别
rtn := rpd_orc.ocr_from_file(A_ScriptDir '\test.png')
MsgBox(rtn)

;从屏幕识别
bitmap := CGdip.Bitmap.FromScreen()
bb := BitmapBuffer.loadGpBitmap(bitmap)
rtn := rpd_orc.ocr_from_bitmapdata(bb.info)
MsgBox(rtn)
CGdip.Shutdown()

;从内存图片识别
fo := FileOpen(A_ScriptDir '/test.png', "r")
raw_data := Buffer(1024000)
fo.RawRead(raw_data)
rtn := rpd_orc.ocr_from_binary(raw_data, raw_data.Size)
MsgBox(rtn)
fo.Close()
*/

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

;清理

;依赖函数
;左键拖动选择范围
GetRange(&x, &y, &w, &h)
{
    CoordMode "Mouse", "Screen"
    GetRange_begin := true
    loop
    {
        ToolTip("请按下鼠标左键")
        sleep(50)
        if(GetKeyState("Esc"))
        {
            ToolTip
            return false
        }
    }until (GetKeyState("LButton", 'P'))
    while GetKeyState("LButton", 'P')
    {
        if(GetRange_begin)
        {
            GetRange_begin :=  !GetRange_begin
            MouseGetPos( &begin_x, &begin_y)
        }
        MouseGetPos &now_x, &now_y
        ToolTip begin_x ", " begin_y "`n" Abs(begin_x-now_x) " x " Abs(begin_y-now_y)
        HighlightOutline(begin_x, begin_y, now_x, now_y,,,,50)
        Sleep 10
    }
    x := begin_x, y := begin_y, w := Abs(begin_x-now_x), h := Abs(begin_y-now_y)
    ToolTip
    return true
}
class HighlightOutline 
{
    gui := []
	__New(x1, y1, x2, y2, b := 3,color := "red", Transparent := 255, time_out := unset) 
    {
        this.gui.Length := 4
		Loop 4 {
            this.gui[A_index] := Gui("-Caption +AlwaysOnTop +ToolWindow -DPIScale +E0x20 +E0x00080000")
            this.gui[A_index].BackColor := color
			DllCall("SetLayeredWindowAttributes", "Ptr", this.gui[A_index].hwnd, "Uint", 0, "Uchar", Transparent, "int", 2)
		}
        if(IsSet(time_out))
        {
            this.timer := ObjBindMethod(this, "Destroy")
            this.Show(x1, y1, x2, y2)
            SetTimer(this.timer, -time_out)
        }
	}
	Show(x1, y1, x2, y2, b := 3) 
    {
		Try 
        {
            this.gui[1].Show("NA x" x1-b " y" y1-b " w" x2-x1+b*2 " h" b)
            this.gui[2].show("NA x" x2 " y" y1 " w" b " h" y2-y1)
            this.gui[3].Show("NA x" x1-b " y" y2 " w" x2-x1+2*b " h" b)
            this.gui[4].Show("NA x" x1-b " y" y1 " w" b " h" y2-y1)
		}
	}
	Hide() 
    {
		Loop(4)
        {
            try 
            { 
                this.gui[A_Index].Hide()
            }
        }
	}
	Destroy()
    {
        this.timer := 0
		Loop(4)
        {
            try
            {
                this.gui[A_Index].Destroy()
            }
        }
	}
}