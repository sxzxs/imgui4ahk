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