#ErrorStdOut
#include <imgui>
#include <log>
#include <my_lib>
#include <cv2>
#include <ImagePut>
#include <Gdip_All>

;配置及全局变量
logger.is_log_open := false
logger.is_out_file := false
g_json_path := A_ScriptDir . "/config/config.json"
g_position_json_path := A_ScriptDir . "/config/position.json"
config := Map()
g_position_config := Map()
loadconfig(&config, g_json_path)
loadconfig(&g_position_config, g_position_json_path)
logger.info(g_position_config)
g_now_hero := g_position_config["back_hero"]
g_gif_index := 1
g_gif_index_small := 1
g_find_status := false
g_main_window_collapse_status := true

;dx及cv初始化
;dxgi_init(0)
;rtn := dxgi_pixelgetcolor(0, 0, &p_vitmap_file := 0, &p_bitmap_info := 0 , &p_bitmap_data := 0, &is_time_out := false)
#DllLoad opencv_ahk.dll
cv := ObjFromPtr(DllCall('opencv_ahk.dll\opencv_init', 'ptr', DllCall(A_AhkPath '\ahkGetApi', 'ptr'), 'cdecl ptr'))
g_screen_shot := cv.Mat()

;开找图线程
thread_find_image := Worker('#include ' A_scriptdir '/thread.ah2')
loop
{ 
}until(thread_find_image.Ready)
thread_find_image['set_position_config'](g_position_config)

;注册消息
OnExit(back)
;Numpad5 / NumpadClear 启动和暂停循环
hotkey("*$^5", on_vent_run) ;启动和暂停循环
Hotkey("~*$Numpad5", on_vent_run) ;启动和暂停循环
Hotkey("~*$NumpadClear", on_vent_run) ;启动和暂停循环
Hotkey("~*$Numpad1", on_event_run_one) ;找一次
Hotkey("~*$NumpadEnd", on_event_run_one) ;找一次
Hotkey("~*$Numpad0", on_event_spend_all) ;花光模式
Hotkey("~*$NumpadIns", on_event_spend_all) ;花光模式
Hotkey("~*$^1", show_hide_wind) ;显示界面
Hotkey("~*$^2", show_hide_window_clollapse) ;卷帘状态


_ImGui_EnableViewports(true)
main()
main()
{
    global thread_find_image
    global g_now_hero
    global out_gif_delay
    global g_find_status := false
    static no_menu := false
    global g_main_window_collapse_status
    _Imgui_load_font_range(A_ScriptDir '/font/ImguiText.txt', &range_array := [], &length := 0, &raw_data)
    hwnd := _ImGui_GUICreate("AHK ImGui", 1, 1, -100, -100, 0, 0x80, 'from_memory_simhei', 18, , raw_data)

    WinSetAlwaysOnTop( 1,hwnd)
    _ImGui_StyleColorsDark()
    io := _ImGui_GetIO()
    _ImGui_SetWindowTitleAlign(0.1, 0.1)
    _ImGui_EnableDocking(True)
    static window_flags := 0
    _Imgui_imgui_stbi__load_gif(A_ScriptDir '\image\gg.gif', &out_srv_array := [], &length := 0, &out_gif_with := 0, &out_gif_height := 0, &out_gif_delay := 0)
    _Imgui_imgui_stbi__load_gif(A_ScriptDir '\image\run.gif', &out_srv_array_small := [], &length_small := 0, &out_gif_with_small := 0, &out_gif_height_small := 0, &out_gif_delay_small := 0)
    static dynamic_image_pause_id := _ImGui_ImageFromFile(A_ScriptDir "\image\run.gif")
    if(out_gif_delay == 0) 
        out_gif_delay := 200
    if(out_gif_delay_small == 0) 
        out_gif_delay_small := 100
    SetTimer(gif_setter.Bind(1, length), out_gif_delay)
    SetTimer(gif_setter.Bind(2, length_small), out_gif_delay_small)
    static empty_memory := false
    WinShow(hwnd)
    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
        if(!empty_memory)
            RunWait(A_ScriptDir "/lib/empty.exe AutoHotkey.exe",,'Hide'), empty_memory := true
        if(!_ImGui_Begin("云顶之弈", show_close := true, ImGuiWindowFlags_AlwaysAutoResize))
            my_exit()

        if(_ImGui_IsWindowCollapsed())
            g_main_window_collapse_status := true
        else
            g_main_window_collapse_status := false

        static tab_bar_flags := ImGuiTabBarFlags_None

        _ImGui_PushStyleColor(ImGuiCol_TabActive, "0xffe5b83d")
        if(_ImGui_BeginTabBar("mytabbar", tab_bar_flags))
        {
            if(_ImGui_BeginTabItem("选择英雄"))
            {
                ;背景图片
                window_draw_list := _ImGui_GetWindowDrawList()

                _ImDraw_SetDrawList(window_draw_list)
                p := _ImGui_GetWindowPos()
                _ImDraw_AddImage(out_srv_array[g_gif_index], p[1], p[2] + 200, p[1] + out_gif_with, p[2] + out_gif_height + 200)

                if(g_find_status)
                    _ImGui_ImageButton(out_srv_array_small[g_gif_index_small], out_gif_with_small, out_gif_height_small)
                else
                    _ImGui_ImageButton(dynamic_image_pause_id, out_gif_with_small, out_gif_height_small)

                _ImGui_SameLine()
                if(_ImGui_CheckBox("循环(CTRL+5)", &g_find_status))
                {
                    start_and_stop_thread()
                }
                _ImGui_SameLine()
                if(_ImGui_Button("一键花光"))
                {
                    if(g_find_status)
                    {
                        ToolTip("结束挂机!", 0, 0)
                        g_find_status := false
                        start_and_stop_thread()
                        loop
                        {
                        }until (g_find_status == false)
                    }
                    g_find_status := !g_find_status
                    start_and_stop_thread(true)
                }
                _ImGui_NewLine()

                _ImGui_PushStyleColor(ImGuiCol_Button, "0xff415911")
                _ImGui_Text("选择的英雄"), _ImGui_SameLine()
                for k,v in g_now_hero
                {
                    if(!FileExist(A_ScriptDir "\image\hero\" k ".bmp"))
                        _ImGui_PushStyleColor(ImGuiCol_Button, "0xff3717ac")
                    if(_ImGui_Button(k))
                        g_now_hero.Delete(k)
                    if(!FileExist(A_ScriptDir "\image\hero\" k ".bmp"))
                        _ImGui_PopStyleColor(1)
                    _ImGui_SameLine()
                }
                _ImGui_PopStyleColor(1)
                _ImGui_NewLine()

                if(_ImGui_CollapsingHeader("英雄列表"))
                {
                    _ImGui_PushStyleColor(ImGuiCol_Button, "0xff0dae4a")
                    _ImGui_SetWindowFontScale(0.8)
                    job_number := 0
                    for k,v in config
                    {
                        job_hero_number := 0
                        for i,j in v
                        {
                            if(g_now_hero.Has(j))
                                job_hero_number++
                        }
                        if(job_hero_number > 0)
                        {
                            job_number++, _ImGui_Button(k '(' job_hero_number ')')
                            (job_number == 6) ? _ImGui_NewLine() : _ImGui_SameLine()
                        }
                    }
                    _ImGui_SetWindowFontScale(1)
                    _ImGui_PopStyleColor(1)
                    _ImGui_NewLine()
                    ;添加代码 =====================================
                    for k,v in config
                    {
                        _ImGui_PushStyleColor(ImGuiCol_Button, "0xffe12fa0")
                        _ImGui_Button(k ':')
                        _ImGui_PopStyleColor(1)
                        _ImGui_SameLine()
                        for i,j in v
                        {
                            if(!FileExist(A_ScriptDir "\image\hero\" j ".bmp"))
                            {
                                _ImGui_PushStyleColor(ImGuiCol_Button, "0xff3717ac")
                            }
                            else
                            {
                                if(g_now_hero.Has(j))
                                    _ImGui_PushStyleColor(ImGuiCol_Button, "0xff130960")
                                else
                                    _ImGui_PushStyleColor(ImGuiCol_Button, "0xff0a3f27")
                            }
                            if(_ImGui_Button(j '##' k j))
                            {
                                if(g_now_hero.Has(j))
                                    g_now_hero.Delete(j)
                                else
                                    g_now_hero[j] := 1
                            }
                            _ImGui_PopStyleColor(1)
                            _ImGui_SameLine()
                        }
                        _ImGui_NewLine()
                    }
                }
                _ImGui_EndTabItem()
            }
            if(_ImGui_BeginTabItem("设置"))
            {
                if(_ImGui_Button("设置取图范围"))
                {
                    if(GetRange(&x, &y, &w, &h))
                    {
                        g_position_config['position'][1] := x
                        g_position_config['position'][2] := y
                        g_position_config['position'][3] := w
                        g_position_config['position'][4] := h
                    }
                }
                static search_fps := g_position_config['HX']['find_fs']
                static key_hold_time := g_position_config['HX']['key_hold_time']
                static mouse_hold_time := g_position_config['HX']['mouse_hold_time']
                static d_time := g_position_config['HX']['d_time']
                static BackgroundColorRGB := g_position_config['HX']['BackgroundColorRGB']
                static is_dxgi := g_position_config['HX']['dxgi']
                static sim := g_position_config['HX']['sim']
                _ImGui_InputInt("搜索间隔ms##search_fps", &search_fps)
                _ImGui_InputInt("按键按住时间ms##key_hold_time", &key_hold_time)
                ;_ImGui_InputInt("D牌后延迟ms##D_time", &d_time)
                _ImGui_InputInt("鼠标按住时间ms##mouse_hold_time", &mouse_hold_time)
                _ImGui_InputDouble("相似度",&sim)
                _ImGui_InputTextWithHint("取牌后颜色##BackgroundColorRGB", BackgroundColorRGB , &BackgroundColorRGB, ImGuiInputTextFlags_CharsNoBlank)
                if(_ImGui_CheckBox("是否使用DXGI截图", &is_dxgi))
                {
                    g_position_config['HX']['dxgi'] := is_dxgi
                }
                if(_ImGui_Button("确定##SET"))
                {
                    g_position_config['HX']['find_fs'] := search_fps
                    g_position_config['HX']['key_hold_time'] := key_hold_time
                    g_position_config['HX']['mouse_hold_time'] := mouse_hold_time
                    g_position_config['HX']['d_time'] := d_time
                    g_position_config['HX']['BackgroundColorRGB'] := BackgroundColorRGB
                    g_position_config['HX']['sim'] := sim
                }
                _ImGui_Text("CTRL+5 : 循环找图, 暂停")
                _ImGui_Text("CTRL+1 : 显示隐藏界面")
                _ImGui_Text("CTRL+2 : 卷帘收起展开")
                _ImGui_Text("数字小键盘 5 : 循环找图, 暂停")
                _ImGui_Text("数字小键盘 1 : 找一次")
                _ImGui_Text("数字小键盘 0 : 花光模式")
                _ImGui_EndTabItem()
            }
            _ImGui_EndTabBar()
        }
        _ImGui_PopStyleColor(1)
        _ImGui_End()
        _ImGui_EndFrame()
        Sleep(1)
        ;logger.info(ProcessInformation(DllCall("GetCurrentProcessId"))['WorkingSetPrivateSize'])
    }
    return
}

;加载配置函数
loadconfig(&config, json_path)
{
    outputvar := FileRead(json_path)
    config := JSON.parse(outputvar)
}
;保存配置函数
saveconfig(config, json_path)
{
    str := JSON.stringify(config)
    FileDelete(json_path)
    FileAppend(str, json_path, 'UTF-8')
}
;gif加载函数
gif_setter(id, length)
{
    global g_gif_index
    global g_gif_index_small
    try
    {
        if(id == 1)
        {
            g_gif_index++
            if(g_gif_index == length)
                g_gif_index := 1
        }
        else if(id == 2)
        {
            g_gif_index_small++
            if(g_gif_index_small == length)
                g_gif_index_small := 1
        }
    }
}
;循环找图热键
on_vent_run(*)
{
    global g_find_status
    g_find_status := !g_find_status
    start_and_stop_thread()
}
;只允许一次
on_event_run_one(*)
{
    global g_find_status
    if(g_find_status)
    {
        ToolTip("先结束挂机!", 0, 0)
        return
    }
    g_find_status := !g_find_status
    start_and_stop_thread(,true)
}
;花光模式
on_event_spend_all(*)
{
    global g_find_status
    if(g_find_status)
    {
        ToolTip("结束挂机!", 0, 0)
        g_find_status := false
        start_and_stop_thread()
        loop
        {
        }until (g_find_status == false)
    }
    g_find_status := !g_find_status
    start_and_stop_thread(true)
}
;退出执行
my_exit()
{
    try{
        RunWait(A_ScriptDir "/lib/empty.exe AutoHotkey.exe",,'Hide')
        ExitApp
    }
}
;DX截图
screen_shot()
{
    global g_screen_shot
    rtn := dxgi_pixelgetcolor(0, 0, &p_vitmap_file := 0, &p_bitmap_info := 0 , &p_bitmap_data := 0, &is_time_out := false)
    ;bb := BitmapBuffer(p_bitmap_data, A_ScreenWidth * 4, A_ScreenWidth, A_ScreenHeight, 4)
    ;wid := bb.width ,hei := bb.height, pBits:= bb.Ptr, Channels := 4 ;通道
    wid := A_ScreenWidth ,hei := A_ScreenHeight, pBits:= p_bitmap_data, Channels := 4 ;通道
    cv.Mat(hei, wid, cv.constants.CV_8UC4, pBits, (wid * Channels + 3) & -4).copyTo(g_screen_shot)
}
;保存配置
back(*)
{
    global g_now_hero
    global g_position_config
    g_position_config["back_hero"] := g_now_hero
    saveconfig(g_position_config, g_position_json_path)
    dxgi_free_memory()
}
;ui出发找图和停止
start_and_stop_thread(is_spend_all := false, is_run_one_time := false)
{
    global thread_find_image
    global g_find_status
    static s_is_spend_all
    static s_is_run_one_time
    s_is_spend_all := is_spend_all
    s_is_run_one_time := is_run_one_time

    if(g_find_status)
    {
        if(g_now_hero.Count == 0)
        {
            g_find_status := false
        }
        else
        {
            thread_find_image["g_status"] := true
            if(thread_find_image["g_status"] == true)
            {
                logger.info("set status to thread success!", "start")
                ;异步回调
                c := thread_find_image.AsyncCall('find_and_click', g_now_hero, s_is_spend_all, s_is_run_one_time)
                c.Then(thread_back)
            }
            else
                logger.info("set status run to thread error!")
        }
    }
    else
    {
        logger.info("start wait before thread exit...")
        thread_find_image["g_status"] := false
        g_find_status := true
        ToolTip()
    }
}
;线程找图异步回调
thread_back(*)
{
    global g_find_status
    logger.info("thread back!")
    g_find_status := false
}

show_hide_wind(*)
{
    try
    {
        if WinActive("ahk_class ImGui Platform")
            WinHide("ahk_class ImGui Platform")
        else
            WinShow("ahk_class ImGui Platform")
    }
}
;设置主窗口卷帘状态
show_hide_window_clollapse(*)
{
    if(g_main_window_collapse_status)
        _ImGui_SetWindowCollapsedByName("云顶之弈", false)
    else
        _ImGui_SetWindowCollapsedByName("云顶之弈", true)
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

; 传入带有中文字符的脚本路径
GetScriptUsedText(FilePath*)
{
    a:=A_TickCount
    ImguiTextFilePath:=A_ScriptDir "\font\ImguiText.txt"
    rtime:=FileGetTime(A_ScriptFullPath)
    fe:=!FileExist(ImguiTextFilePath)
    ; 若脚本未修改不重复创建
    if(fe || FileGetTime(ImguiTextFilePath)!=rtime)
    {
        ScriptText:=""
        for v in FilePath
            ScriptText.=FileRead(v)
        ; 清除换行符与空格
        ScriptText:=StrReplace(ScriptText, "`r`n") , ScriptText:=StrReplace(ScriptText, A_Space) , ScriptText:=StrReplace(ScriptText, A_Tab)
        ; 删除重复字符
        ok:=1,i:=0
        while(ok)
            i+=1,ScriptText:=RegExReplace(ScriptText,'Ss)(.)(.*)(\1)',"$2$3",&ok)
        OutputDebug "次数：" i "`n"
        if(!fe)
            FileDelete(ImguiTextFilePath)
        FileEncoding("UTF-8") , FileAppend(ScriptText,ImguiTextFilePath) , FileSetTime(rtime,ImguiTextFilePath)
    }
    return ImguiTextFilePath
}

;获取制定进程内存
GetProcessMemoryUsage(ProcessID)
{
	static PMC_EX
    PMC_EX := Buffer(8 + A_PtrSize * 9, 0)
    size := PMC_EX.Size
	if (hProcess := DllCall("OpenProcess", "uint", 0x1000, "int", 0, "uint", ProcessID)) 
    {
		if !(DllCall("psapi\GetProcessMemoryInfo", "ptr", hProcess, "ptr", PMC_EX, "uint", size))
			return false
		DllCall("CloseHandle", "ptr", hProcess)
		return Round(NumGet(PMC_EX, 8 + A_PtrSize * 8, "uptr") / 1024**2, 2)
	}
	return false
}
;获取制定进程内存信息
ProcessInformation(PID)
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS              := 0x00000000
	static STATUS_INFO_LENGTH_MISMATCH := 0xC0000004
	static STATUS_BUFFER_TOO_SMALL     := 0xC0000023
	static SYSTEM_PROCESS_INFORMATION  := 0x00000005

	Buf := Buffer(0x0100, 0)
	NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESS_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")

	while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL)
	{
		Buf := Buffer(Size, 0)
		NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESS_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
	}

	if (NT_STATUS = STATUS_SUCCESS)
	{
		Addr := Buf.Ptr
		while (Addr)
		{
			PROCESS := Map()
			PROCESS["NumberOfThreads"]              := NumGet(Addr, 0x0004, "UInt")
			PROCESS["WorkingSetPrivateSize"]        := NumGet(Addr, 0x0008, "Int64")
			PROCESS["HardFaultCount"]               := NumGet(Addr, 0x0010, "UInt")
			PROCESS["NumberOfThreadsHighWatermark"] := NumGet(Addr, 0x0014, "UInt")
			PROCESS["CycleTime"]                    := NumGet(Addr, 0x0018, "UInt64")
			PROCESS["CreateTime"]                   := NumGet(Addr, 0x0020, "Int64")
			PROCESS["UserTime"]                     := NumGet(Addr, 0x0028, "Int64")
			PROCESS["KernelTime"]                   := NumGet(Addr, 0x0030, "Int64")
			PROCESS["ImageName"]                    := (Ptr := NumGet(Addr, 0x0040, "Ptr")) ? StrGet(Ptr) : ""
			PROCESS["BasePriority"]                 := NumGet(Addr, 0x0048, "Int")
			PROCESS["UniqueProcessId"]              := NumGet(Addr, 0x0050, "Ptr")
			PROCESS["InheritedFromUniqueProcessId"] := NumGet(Addr, 0x0058, "Ptr*")
			PROCESS["HandleCount"]                  := NumGet(Addr, 0x0060, "UInt")
			PROCESS["SessionId"]                    := NumGet(Addr, 0x0064, "UInt")
			PROCESS["UniqueProcessKey"]             := NumGet(Addr, 0x0068, "UPtr")
			PROCESS["PeakVirtualSize"]              := NumGet(Addr, 0x0070, "UPtr")
			PROCESS["VirtualSize"]                  := NumGet(Addr, 0x0078, "UPtr")
			PROCESS["PageFaultCount"]               := NumGet(Addr, 0x0080, "UInt")
			PROCESS["PeakWorkingSetSize"]           := NumGet(Addr, 0x0088, "UPtr")
			PROCESS["WorkingSetSize"]               := NumGet(Addr, 0x0090, "UPtr")
			PROCESS["QuotaPeakPagedPoolUsage"]      := NumGet(Addr, 0x0098, "UPtr")
			PROCESS["QuotaPagedPoolUsage"]          := NumGet(Addr, 0x00A0, "UPtr")
			PROCESS["QuotaPeakNonPagedPoolUsage"]   := NumGet(Addr, 0x00A8, "UPtr")
			PROCESS["QuotaNonPagedPoolUsage"]       := NumGet(Addr, 0x00B0, "UPtr")
			PROCESS["PagefileUsage"]                := NumGet(Addr, 0x00B8, "UPtr")
			PROCESS["PeakPagefileUsage"]            := NumGet(Addr, 0x00C0, "UPtr")
			PROCESS["PrivatePageCount"]             := NumGet(Addr, 0x00C8, "UPtr")
			PROCESS["ReadOperationCount"]           := NumGet(Addr, 0x00D0, "Int64")
			PROCESS["WriteOperationCount"]          := NumGet(Addr, 0x00D8, "Int64")
			PROCESS["OtherOperationCount"]          := NumGet(Addr, 0x00E0, "Int64")
			PROCESS["ReadTransferCount"]            := NumGet(Addr, 0x00E8, "Int64")
			PROCESS["WriteTransferCount"]           := NumGet(Addr, 0x00F0, "Int64")
			PROCESS["OtherTransferCount"]           := NumGet(Addr, 0x00F8, "Int64")

            if(PROCESS["UniqueProcessId"] == PID)
                return PROCESS

			if !(NumGet(Addr, 0x0000, "UInt"))
				break
			Addr += NumGet(Addr, 0x0000, "UInt")
		}
	}
	return false
}