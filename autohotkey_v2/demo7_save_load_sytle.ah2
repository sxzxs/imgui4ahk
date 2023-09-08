#Requires AutoHotkey v2.0
#include <imgui>

_ImGui_EnableViewports(true)
main()
main()
{
    static no_menu := false
    WS_CAPTION :=  0x00C00000
    WS_THICKFRAME := 0x00040000
    hwnd := _ImGui_GUICreate("AHK ImGui", 0, 0, -5000, -5000, 0, 0x80)
    ;hwnd := _Imgui_GUICreate_Unbackground('AHK Imgui')
    ;SetWindowLong(hwnd, -16, GetWindowLong(hWnd, -16) & ~WS_CAPTION & ~WS_THICKFRAME)
	;WinHide(hwnd)
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

        _ImGui_Begin("AHK2_1", 0, window_flags | ImGuiWindowFlags_NoTitleBar)
        view := _ImGui_GetMainViewport()
        _ImGui_Text(view)
        current_view := _ImGui_GetWindowViewport()
        _ImGui_Text(current_view)
        _ImGui_End()




        _ImGui_EndFrame()
        ;sleep(20)
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