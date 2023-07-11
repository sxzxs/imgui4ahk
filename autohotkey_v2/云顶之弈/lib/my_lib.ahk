G_MY_DLL_BUFFER_SIZE := 4000
G_MY_DLL_USE_MAP := map("DXGICapture.dll" , map("dxgi_init", 0, "dxgi_pixelgetcolor", 0, "dxgi_save2file", 0, "dxgi_dib2ddb", 0, "dxgi_free_memory", 0, "screenshot_to_mat", 0))
load_all_dll_path()
load_all_dll_path()
{
  SplitPath(A_LineFile,,&dir)
  path := ""
  lib_path := dir
  if(A_IsCompiled)
  {
      path := (A_PtrSize == 4) ? A_ScriptDir . "\lib\dll_32\" : A_ScriptDir . "\lib\dll_64\"
      lib_path := A_ScriptDir . "\lib"
  }
  else
  {
      path := (A_PtrSize == 4) ? dir . "\dll_32\" : dir . "\dll_64\"
  }
  dllcall("SetDllDirectory", "Str", path)
  for k,v in G_MY_DLL_USE_MAP
  {
      for k1, v1 in v 
      {
          G_MY_DLL_USE_MAP[k][k1] := DllCall("GetProcAddress", "Ptr", DllCall("LoadLibrary", "Str", k, "Ptr"), "AStr", k1, "Ptr")
      }
  }
  DllCall("SetConsoleTitle", "Str", A_ScriptName)
  dllcall("SetDllDirectory", "Str", A_ScriptDir)
}

dxgi_screen_shot_to_mat(ptr)
{
    DllCall(G_MY_DLL_USE_MAP["DXGICapture.dll"]["screenshot_to_mat"], "ptr", ptr)
}

dxgi_free_memory()
{
    hbitmap := DllCall(G_MY_DLL_USE_MAP["DXGICapture.dll"]["dxgi_free_memory"])
}

dxgi_dib2ddb(dc)
{
    hbitmap := DllCall(G_MY_DLL_USE_MAP["DXGICapture.dll"]["dxgi_dib2ddb"],"Ptr", dc, "Cdecl Ptr")
    return hbitmap
}

dxgi_pixelgetcolor(x, y, &ptr_bitmap_file := 0, &ptr_bitmap_info := 0, &ptr_bitmap_data := 0, &is_time_out := false)
{
    out_str := Buffer(6, 0)
    rtn := DllCall(G_MY_DLL_USE_MAP["DXGICapture.dll"]["dxgi_pixelgetcolor"], "Int", x, "Int", y, "ptr", out_str, "ptr *", &ptr_bitmap_data, "Ptr *", &ptr_bitmap_info, "Ptr *", &ptr_bitmap_file, "Int *", &is_time_out, "Cdecl Int")
	rtn := "0x" StrGet(out_str, 6,"UTF-8")
    return rtn
}

; 返回包含字符串的缓冲对象.
mylib_StrPutVar(str, encoding)
{
    ; 计算所需的大小并分配缓冲.
    buf := Buffer(StrPut(str, encoding))
    ; 复制或转换字符串.
    StrPut(str, buf, encoding)
    return buf
}

;time_out:超时时间 默认5ms，如果图像不刷新就用上次图像
dxgi_init(time_out := 5)
{
    rtn := DllCall(G_MY_DLL_USE_MAP["DXGICapture.dll"]["dxgi_init"],"Int",time_out,"Cdecl Int")
    return rtn
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
    __Delete()
    {
        loop(4)
        {
            this.gui[A_Index].Destroy()
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

class mtt 
{
    static s_tooltip_number := 1
    static s_max_btt := 20
    __New(txt := "btt", x := 0, y := 0, show_time := 999999999, BulitInStyleOrStyles := "", BulitInOptionOrOptions := "") 
    {
        this.timer := ObjBindMethod(this, "Tick")
        this.x := x
        this.BulitInStyleOrStyles := BulitInStyleOrStyles
        this.BulitInOptionOrOptions := BulitInOptionOrOptions
        this.y := y
        this.txt := txt
        this.show_time := show_time
        this.which := mtt.s_tooltip_number
        if(mtt.s_tooltip_number == mtt.s_max_btt)
        {
            mtt.s_tooltip_number := 0
        }
        mtt.s_tooltip_number++
        this.Start()
    }
    __Delete()
    {
    }
    Start() 
    {
        timer := this.timer
        SetTimer timer, -this.show_time
        ToolTip(this.txt, this.x, this.y, this.which)
    }
    Stop() 
    {
        try
        {
            timer := this.timer
            SetTimer timer, 0
            ToolTip(,,, this.which)
            this.timer := 0
        }
    }
    Tick() 
    {
        this.stop()
    }
}
deepclone(obj) {
	objs := Map(), objs.Default := ''
	return clone(obj)

	clone(obj) {
		switch Type(obj) {
			case 'Array', 'Map':
				o := obj.Clone()
				for k, v in o
					if IsObject(v)
						o[k] := objs[p := ObjPtr(v)] || (objs[p] := clone(v))
				return o
			case 'Object':
				o := obj.Clone()
				for k, v in o.OwnProps()
					if IsObject(v)
						o.%k% := objs[p := ObjPtr(v)] || (objs[p] := clone(v))
				return o
			default:
				return obj
		}
	}
}

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
    }until (GetKeyState("LButton"))
    while GetKeyState("LButton")
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
SelectScreenRegion(Key, Color := "Lime", Transparent:= 80)
{
	CoordMode("Mouse", "Screen")
    loop
    {
        ToolTip("请按下: " Key)
        sleep(50)
        if(GetKeyState("Esc"))
        {
            ToolTip
            return false
        }
    }until (GetKeyState(key))
	MouseGetPos(&sX, &sY)
	ssrGui := Gui("+AlwaysOnTop -caption +Border +ToolWindow +LastFound -DPIScale", 'section gui')
	WinSetTransparent(Transparent)
	ssrGui.BackColor := Color
	Loop 
	{
		Sleep 10
		MouseGetPos(&eX, &eY)
		W := Abs(sX - eX), H := Abs(sY - eY)
		X := Min(sX, eX), Y := Min(sY, eY)
		ssrGui.Show("x" X " y" Y " w" W " h" H)
	} Until !GetKeyState(Key, "p")
	ssrGui.Destroy()
    ToolTip
	Return { X: X, Y: Y, W: W, H: H, X2: X + W, Y2: Y + H }
}
ReadProcessStdOut(cmd, stdin := "", encoding := "cp0", is_wait := true) {
    sa := Buffer(24)
    NumPut("uint", sa.Size, sa)
    NumPut("ptr", 0, "uint", 1, sa, 8)

    if !DllCall("CreatePipe", "ptr*", &hReadPipeOut := 0, "ptr*", &hWritePipeOut := 0, "ptr", sa, "uint", 0)
        throw OSError()
    DllCall("SetHandleInformation", "ptr", hReadPipeOut, "uint", 1, "uint", 0)

    si := Buffer(104, 0)
    NumPut("uint", si.Size, si)
    NumPut("uint", 0x101, si, 60)
    NumPut("ptr", hWritePipeOut, si, 88)

    if stdin !== "" {
        if !DllCall("CreatePipe", "ptr*", &hReadPipeIn := 0, "ptr*", &hWritePipeIn := 0, "ptr", sa, "uint", 0)
            throw OSError()
        DllCall("SetHandleInformation", "ptr", hWritePipeIn, "uint", 1, "uint", 0)
        NumPut("ptr", hReadPipeIn, si, 80)
    }

    if !DllCall("CreateProcessW", "ptr", 0, "str", cmd, "ptr", 0, "ptr", 0, "int", true, "uint", 0, "ptr", 0, "ptr", 0, "ptr", si, "ptr", pi := Buffer(24)) {
        DllCall("CloseHandle", "ptr", hWritePipeOut)
        DllCall("CloseHandle", "ptr", hReadPipeOut)
        throw OSError()
    }
    DllCall("CloseHandle", "ptr", NumGet(pi, "ptr"))
    DllCall("CloseHandle", "ptr", NumGet(pi, 8, "ptr"))
    DllCall("CloseHandle", "ptr", hWritePipeOut)


    if stdin !== "" {
        DllCall("CloseHandle", "ptr", hReadPipeIn)
        if !DllCall("WriteFile", "ptr", hWritePipeIn, "astr", stdin, "uint", StrPut(stdin, encoding) - 1, "uint*", &lpNumberOfBytesWritten := 0, "ptr", 0){
            DllCall("CloseHandle", "ptr", hWritePipeIn)
            throw OSError()
        }
        DllCall("CloseHandle", "ptr", hWritePipeIn)
    }

	if(!is_wait)
		return

    stdout := ""
    while DllCall("ReadFile", "ptr", hReadPipeOut, "ptr", buf := Buffer(4096), "uint", buf.Size, "uint*", &lpNumberOfBytesRead := 0, "ptr", 0) && lpNumberOfBytesRead
        stdout .= StrGet(buf, lpNumberOfBytesRead, encoding)
    DllCall("CloseHandle", "ptr", hReadPipeOut)

    return stdout
}