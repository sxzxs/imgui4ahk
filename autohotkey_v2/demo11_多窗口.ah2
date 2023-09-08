#Requires AutoHotkey v2.0
#include <imgui>

_ImGui_EnableViewports(true)
main()
main()
{
    global sub_window_hwnd
    static no_menu := false
    WS_CAPTION :=  0x00C00000
    WS_THICKFRAME := 0x00040000
    hwnd := _Imgui_GUICreate_Unbackground("AHK ImGui")
    WinSetAlwaysOnTop(1, hwnd)

    io := _ImGui_GetIO()
    io := Imgui_io(io)
    _ImGui_SetWindowTitleAlign(0.5, 0.5)
    _ImGui_EnableDocking(True)
    static window_flags := 0
    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
        _ImGui_Begin("AHK2", 0, window_flags | ImGuiWindowFlags_NoTitleBar)
        ;添加代码 =====================================
        ;_ImGui_SetWindowPos(0, 0)
        if(_ImGui_Button('save'))
        {
            _Imgui_save_style_to_file(A_ScriptDir '\style.ini')
        }
        if(_ImGui_Button('load'))
        {
            _Imgui_load_style_from_file(A_ScriptDir '\style.ini')
        }
        _ImGui_Text(io.Framerate)

        view := _ImGui_GetMainViewport()
        _ImGui_Text(view)
        current_view := _ImGui_GetWindowViewport()
        _ImGui_Text(current_view)
        ;====================================
        _ImGui_End()

        _ImGui_SetNextWindowBgAlpha(0.5)
        _ImGui_PushStyleColor(ImGuiCol_WindowBg, '0xff000000')
        _ImGui_Begin("AHK2_1", 0, window_flags | ImGuiWindowFlags_NoTitleBar)
        view := _ImGui_GetMainViewport()
        _ImGui_Text(view)
        current_view := _ImGui_GetWindowViewport()
        _ImGui_Text(current_view)
        hwnd := _Imgui_get_viewport_hwnd(current_view)
        _ImGui_Text(hwnd)
        sub_window_hwnd := hwnd
        _ImGui_End()
        _ImGui_PopStyleColor()

        _ImGui_EndFrame()
    }
    return
}


set_style()
{
    style := _ImGui_GetStyle()

	style.WindowBorderSize := 0
	style.WindowTitleAlign := [0.5, 0.5]
	style.WindowMinSize := [500, 430]
	style.FramePadding := [8, 6]

	style.Colors[ImGuiCol_TitleBg] := [255, 101, 53, 255]
	style.Colors[ImGuiCol_TitleBgActive] := [255, 101, 53, 255]
	style.Colors[ImGuiCol_TitleBgCollapsed] := [0, 0, 0, 130]

	style.Colors[ImGuiCol_Button] := [31, 30, 31, 255]
	style.Colors[ImGuiCol_ButtonActive] := [41, 40, 41, 255]
	style.Colors[ImGuiCol_ButtonHovered] := [41, 40, 41, 255]

	style.Colors[ImGuiCol_Separator] := [70, 70, 70, 255]
	style.Colors[ImGuiCol_SeparatorActive] := [76, 76, 76, 255]
	style.Colors[ImGuiCol_SeparatorHovered] := [76, 76, 76, 255]

	style.Colors[ImGuiCol_FrameBg] := [37, 36, 37, 255]
	style.Colors[ImGuiCol_FrameBgActive] := [37, 36, 37, 255]
	style.Colors[ImGuiCol_FrameBgHovered] := [37, 36, 37, 255]

	style.Colors[ImGuiCol_Header] := [0, 0, 0, 0]
	style.Colors[ImGuiCol_HeaderActive] := [0, 0, 0, 0]
	style.Colors[ImGuiCol_HeaderHovered] := [46, 46, 46, 255]
}

#c::
{
    WinHide(sub_window_hwnd)
}

#s::
{
    WinShow(sub_window_hwnd)
    ;_Imgui_EnableAlphaCompositing(sub_window_hwnd)
    WinSetTransparent 150, sub_window_hwnd  
    ;WinSetTransColor "000000 150", sub_window_hwnd
}