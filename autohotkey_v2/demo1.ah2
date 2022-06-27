#include <log>
#include <imgui>
;这个库必须放到开头
;Download("https://www.autoahk.com/wp-content/themes/b2/Assets/fontend/images/model-bg.png", A_ScriptDir "/back.PNG")
_ImGui_EnableViewports(true)
Hotkey("#c", showwind)
main()
main()
{
    static username := "user name"
    static passwd := "paswd"
    static number := 0
    static check_state := false
    static radio_theme := 2
    static input_string := ""
    static listbox_current_item := 1
    static close := false
    static no_menu := false
    label_radio_theme := ["Light", "Dark", "Classic"]
    img := _ImGui_ImageFromURL("https://www.autoahk.com/wp-content/themes/b2/Assets/fontend/images/model-bg.png")
    arr := [1,2,3,4,5,6]

    hwnd := _ImGui_GUICreate("AHK ImGui", 1, 1, -100, -100, 0, 0x80, "from_memory_ali")

    ;hwnd := _ImGui_GUICreate("AHK ImGui", 1000, 1000, 500, 500, 0, 0x80)
    ;hwnd := _ImGui_GUICreate("AHK ImGui", 1000, 1000, 500, 500)
    WinShow(hwnd)
    WinSetAlwaysOnTop( 1,hwnd)

    _ImGui_StyleColorsClassic()

    io := _ImGui_GetIO()
    frame := NumGet(io, 216, "float")
    ;NumPut("Int", true, io, 204) ;io.ConfigWindowsMoveFromTitleBarOnly := True ; // Only drag window by title bar
    

    _ImGui_SetWindowTitleAlign(0.5, 0.5)
    _ImGui_EnableDocking(True)
    static window_flags := 0
    if (!no_menu)           
        window_flags |= ImGuiWindowFlags_MenuBar
    
    static back_img_id := _ImGui_ImageFromFile(A_ScriptDir "\image\back.PNG")

    logger.info(DllCall("GetCurrentProcessId"))
    logger.info(GetProcessMemoryUsage(DllCall("GetCurrentProcessId")))

    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
        _ImGui_Begin("AHK2", 0, window_flags)

        _imgui_PushItemWidth(_imgui_GetFontSize() * -12)

        if(_ImGui_BeginMenuBar())
        {
            if(_ImGui_BeginMenu("Menu"))
            {
                if(_ImGui_MenuItem("open"))
                {
                    SelectedFile := FileSelect(3, , "Open a file", "Text Documents (*.txt; *.doc)")
                    if SelectedFile = ""
                        MsgBox "The user didn't select anything."
                    else
                        MsgBox "The user selected the following:`n" SelectedFile
                }
                if(_ImGui_MenuItem("close"))
                {
                    ExitApp()
                }
                _ImGui_EndMenu()
            }
            if(_ImGui_BeginMenu("Examples"))
            {
                if(_ImGui_MenuItem("app"))
                {
                    str_status := "menu app"
                }
                _ImGui_EndMenu()
            }
            _ImGui_EndMenuBar()
        }
        old_theme := radio_theme 
        _ImGui_RadioButton("Light", &radio_theme, 0)
        _ImGui_SameLine()
        _ImGui_RadioButton("Dark", &radio_theme, 1)
        _ImGui_SameLine()
        _ImGui_RadioButton("Classic", &radio_theme, 2)
        _ImGui_SameLine()
        if(_ImGui_BeginCombo("##combo_theme", label_radio_theme[radio_theme+1]))
        {
            loop(label_radio_theme.Length)
            {
                static selected := (radio_theme + 1) == A_Index  ? true : false
                if(_ImGui_Selectable(label_radio_theme[A_Index], selected))
                {
				    radio_theme := A_Index - 1
				    _ImGui_SetItemDefaultFocus()
                }
            }
		    _ImGui_EndCombo()
        }
        if(old_theme != radio_theme)
        {
            switch radio_theme 
            {
                case 0:
				    _ImGui_StyleColorsLight()
                case 1:
				    _ImGui_StyleColorsDark()
                case 2:
				    _ImGui_StyleColorsClassic()
            }
        }
        _ImGui_PushStyleColor(ImGuiCol_Button, "0xffdd18d7")
        _ImGui_SameLine()
        if(_ImGui_SmallButton("close##close"))
            ExitApp()
        _ImGui_SameLine()
        if(_ImGui_SmallButton("hide##hide"))
            hidewind()
        _ImGui_PopStyleColor(1)

        frame := NumGet(io, 216, "float")
        _ImGui_Text(frame)
        win_size := _ImGui_GetWindowSize()
        _ImGui_Separator()
        ;img := _ImGui_ImageFromURL("https://www.autoahk.com/wp-content/themes/b2/Assets/fontend/images/model-bg.png")
        if(back_img_id)
        {
		    _ImGui_ImageFit(back_img_id, win_size[1] - 10, 200)
        }
        _ImGui_PushStyleColor(ImGuiCol_Button, "0xffffffff")
        _ImGui_ArrowButton("arrow", ImGuiDir_Left)
        _ImGui_PopStyleColor(1)
        _ImGui_PushStyleColor(ImGuiCol_Button, "0xffd16a6a")
        _ImGui_SameLine()
        _ImGui_ArrowButton("arrow", ImGuiDir_Right)
        _ImGui_PopStyleColor(1)
        _ImGui_SameLine()
        _ImGui_ArrowButton("arrow", ImGuiDir_Up)
        _ImGui_SameLine()
        _ImGui_ArrowButton("arrow", ImGuiDir_Down)
        static color_get := 0

        static b_pick_color := false
        _ImGui_CheckBox("color pick", &b_pick_color)

        if(b_pick_color)
        {
            _imgui_PushItemWidth(400)
            _ImGui_ColorPicker("color_pick", &color_get)
            _ImGui_PopItemWidth()
        }

        img1 := _ImGui_ImageFromFile(A_ScriptDir "\image\1.jpg")
        img2 := _ImGui_ImageFromFile(A_ScriptDir "\image\2.jpg")
        img3 := _ImGui_ImageFromFile(A_ScriptDir "\image\3.jpg")
        img4 := _ImGui_ImageFromFile(A_ScriptDir "\image\4.jpg")
        img5 := _ImGui_ImageFromFile(A_ScriptDir "\image\5.jpg")
        img6 := _ImGui_ImageFromFile(A_ScriptDir "\image\6.jpg")

        _ImGui_PushStyleColor(ImGuiCol_Button, "0xffe6107b")
        _ImGui_ImageButton(img1, 50, 50)
        _ImGui_PopStyleColor(1)
        _ImGui_SameLine()
        _ImGui_ImageButton(img2, 50, 50)
        _ImGui_SameLine()
        _ImGui_ImageButton(img3, 50, 50)
        _ImGui_SameLine()
        _ImGui_ImageButton(img4, 50, 50)
        _ImGui_SameLine()
        _ImGui_ImageButton(img5, 50, 50)
        _ImGui_SameLine()
        _ImGui_ImageButton(img6, 50, 50)

        _ImGui_Text("hello imgui")
        ;if (_ImGui_Button("close##1", 40, 40)) 
            ;ExitApp()

        static b_show_demo_window := false
        _ImGui_CheckBox("Show demo 窗口中文测试", &b_show_demo_window)
            _ImGui_EnableViewports(b_show_demo_window)
        static b_show_another_window := false
       _ImGui_CheckBox("Show another window", &b_show_another_window)
	    If(b_show_demo_window)
            _ImGui_ShowDemoWindow()
        If(b_show_another_window)
        {
            _ImGui_Begin("Another window")
            _ImGui_Text("Hello there..")
            if(_ImGui_Button("close me")) 
                b_show_another_window := False
            _ImGui_End()
        }

	    winSize := _ImGui_GetWindowSize()
        ; Seperate the window into 2 columns
        _ImGui_Columns(2)

        ; Set the width for the column 0
        _ImGui_SetColumnWidth(0, winSize[1]*0.7)

	     _ImGui_NewLine()

	    _ImGui_PushItemWidth(-1)
        _ImGui_InputTextWithHint("##username", username, &username, ImGuiInputTextFlags_CharsNoBlank)
        _ImGui_InputTextWithHint("##usernamepasswd", passwd, &passwd, ImGuiInputTextFlags_Password)
	    _ImGui_PopItemWidth()

	     _ImGui_NewLine()

        static str_status := "not login"
        _ImGui_TextColored(str_status, 0xFF33BB44)

	    _ImGui_NextColumn()
	    _ImGui_NewLine()
        _ImGui_PushStyleColor(ImGuiCol_Button, "0xff815716")
        if (_ImGui_Button("LOGIN##aa", -1, 40)) 
        {
	        str_status := input_string "  " username " " passwd " " number " " check_state " "
        }
        _ImGui_PopStyleColor(1)
	    _ImGui_Columns(1)
	    _ImGui_NewLine()

	    _ImGui_BeginChild("##child_list_view1", winSize[1]*0.6, winSize[2] *0.3, true, ImGuiWindowFlags_ChildWindow)
        static list_view_select := false
        static list_view_select_index := false
        loop(10)
        {
            list_view_select := (list_view_select_index + 1) == A_Index  ? true : false
		    if(_ImGui_Selectable("Selectable - "  (a_index-1), list_view_select))
                list_view_select_index := A_Index - 1
        }


        _ImGui_InputText("string##1", &input_string)
        _ImGui_InputInt("##number", &number)

        static list_box_items := ["aaaa", "bbbb", "cccc"]
        _ImGui_ListBox("listbox##1", &listbox_current_item, list_box_items, 4)

        _ImGui_PlotLines("Plot##array", arr, 6, "Plot", FLT_MAX, FLT_MAX, 300, 300)
        _ImGui_SameLine()
        _ImGui_CheckBox("radio", &check_state)

	    _ImGui_EndChild()

        _ImGui_End()
        _ImGui_EndFrame()
        sleep(10)
    }
    ExitApp()
    return
}

hidewind(*)
{
    WinHide("ahk_class ImGui Platform")
}
showwind(*)
{
    WinShow("ahk_class ImGui Platform")
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
/*
1>class ImGuiIO	size(14344):
1>	+---
1> 0	| ConfigFlags
1> 4	| BackendFlags
1> 8	| ImVec2 DisplaySize
1>16	| DeltaTime
1>20	| IniSavingRate
1>24	| IniFilename
1>32	| LogFilename
1>40	| MouseDoubleClickTime
1>44	| MouseDoubleClickMaxDist
1>48	| MouseDragThreshold
1>52	| KeyRepeatDelay
1>56	| KeyRepeatRate
1>  	| <alignment member> (size=4)
1>64	| UserData
1>72	| Fonts
1>80	| FontGlobalScale
1>84	| FontAllowUserScaling
1>  	| <alignment member> (size=3)
1>88	| FontDefault
1>96	| ImVec2 DisplayFramebufferScale
1>104	| ConfigDockingNoSplit
1>105	| ConfigDockingWithShift
1>106	| ConfigDockingAlwaysTabBar
1>107	| ConfigDockingTransparentPayload
1>108	| ConfigViewportsNoAutoMerge
1>109	| ConfigViewportsNoTaskBarIcon
1>110	| ConfigViewportsNoDecoration
1>111	| ConfigViewportsNoDefaultParent
1>112	| MouseDrawCursor
1>113	| ConfigMacOSXBehaviors
1>114	| ConfigInputTrickleEventQueue
1>115	| ConfigInputTextCursorBlink
1>116	| ConfigDragClickToInputText
1>117	| ConfigWindowsResizeFromEdges
1>118	| ConfigWindowsMoveFromTitleBarOnly
1>  	| <alignment member> (size=1)
1>120	| ConfigMemoryCompactTimer
1>  	| <alignment member> (size=4)
1>128	| BackendPlatformName
1>136	| BackendRendererName
1>144	| BackendPlatformUserData
1>152	| BackendRendererUserData
1>160	| BackendLanguageUserData
1>168	| GetClipboardTextFn
1>176	| SetClipboardTextFn
1>184	| ClipboardUserData
1>192	| SetPlatformImeDataFn
1>200	| ImeWindowHandle
1>208	| WantCaptureMouse
1>209	| WantCaptureKeyboard
1>210	| WantTextInput
1>211	| WantSetMousePos
1>212	| WantSaveIniSettings
1>213	| NavActive
1>214	| NavVisible
1>  	| <alignment member> (size=1)
1>216	| Framerate
1>220	| MetricsRenderVertices
1>224	| MetricsRenderIndices
1>228	| MetricsRenderWindows
1>232	| MetricsActiveWindows
1>236	| MetricsActiveAllocations
1>240	| ImVec2 MouseDelta
1>248	| KeyMap
1>2828	| KeysDown
1>  	| <alignment member> (size=3)
1>3476	| ImVec2 MousePos
1>3484	| MouseDown
1>  	| <alignment member> (size=3)
1>3492	| MouseWheel
1>3496	| MouseWheelH
1>3500	| MouseHoveredViewport
1>3504	| KeyCtrl
1>3505	| KeyShift
1>3506	| KeyAlt
1>3507	| KeySuper
1>3508	| NavInputs
1>3588	| KeyMods
1>3592	| KeysData
1>13912	| WantCaptureMouseUnlessPopupClose
1>  	| <alignment member> (size=3)
1>13916	| ImVec2 MousePosPrev
1>13924	| MouseClickedPos
1>  	| <alignment member> (size=4)
1>13968	| MouseClickedTime
1>14008	| MouseClicked
1>14013	| MouseDoubleClicked
1>14018	| MouseClickedCount
1>14028	| MouseClickedLastCount
1>14038	| MouseReleased
1>14043	| MouseDownOwned
1>14048	| MouseDownOwnedUnlessPopupClose
1>  	| <alignment member> (size=3)
1>14056	| MouseDownDuration
1>14076	| MouseDownDurationPrev
1>14096	| MouseDragMaxDistanceAbs
1>14136	| MouseDragMaxDistanceSqr
1>14156	| NavInputsDownDuration
1>14236	| NavInputsDownDurationPrev
1>14316	| PenPressure
1>14320	| AppFocusLost
1>14321	| BackendUsingLegacyKeyArrays
1>14322	| BackendUsingLegacyNavInputArray
1>  	| <alignment member> (size=1)
1>14324	| InputQueueSurrogate
1>  	| <alignment member> (size=2)
1>14328	| ?$ImVector@G InputQueueCharacters
1>	+---
*/