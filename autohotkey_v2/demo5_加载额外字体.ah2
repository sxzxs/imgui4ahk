#Requires AutoHotkey v2.0
#include <imgui>

_ImGui_EnableViewports(true)
main()
main()
{
    static no_menu := false
    hwnd := _ImGui_GUICreate("AHK ImGui", 1, 1, -100, -100, 0, 0x80,,20, 'GetGlyphRangesDefault',,,,true)
    font1 := _Imgui_load_font(, 40, 'GetGlyphRangesDefault',, 3, 3)

	WinHide(hwnd)
    WinSetAlwaysOnTop( 1,hwnd)

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

    io := _ImGui_GetIO()
    _ImGui_SetWindowTitleAlign(0.5, 0.5)
    _ImGui_EnableDocking(True)
    static window_flags := 0
    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
        _ImGui_Begin("AHK2", 0, window_flags | ImGuiWindowFlags_NoTitleBar)
        _ImGui_ShowDemoWindow()
        ;添加代码 =====================================
        ;https://github.com/kazhafeizhale/imgui4ahk/blob/master/cpp%20-1.88/icons.h
        _ImGui_Text('TEST')
        _ImGui_PushFont(font1)
        _ImGui_Text('TEST')
        _ImGui_PopFont()
        _ImGui_Text('TEST')
        if(_ImGui_Button('Close'))
            ExitApp
        ;====================================
        _ImGui_End()
        _ImGui_EndFrame()
        sleep(10)
    }
    ExitApp()
    return
}


