#include <imgui>
#include <User32>
_ImGui_EnableViewports(true)
main()
main()
{
    static no_menu := false
    WS_CAPTION :=  0x00C00000
    WS_THICKFRAME := 0x00040000
    WS_BORDER := 0x00800000 
    SWP_NOMOVE := 0x0002
    SWP_NOSIZE := 0x0001
    SWP_FRAMECHANGED := 0x0020
    hwnd := _ImGui_GUICreate("AHK ImGui", 0, 0, -3000, -3000, 0, 0)
    SetWindowLong(hwnd, -16, GetWindowLong(hWnd, -16) & ~WS_CAPTION & ~WS_THICKFRAME)
    SetWindowPos(hWnd, 0, 0, 0, 0, 0, SWP_NOMOVE|SWP_NOSIZE|SWP_FRAMECHANGED)
    WinShow(hwnd)
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
    set_initpos := false
    static back_img_id := _ImGui_ImageFromFile("C:\Users\hetong\Desktop\pic\卡牌.jpg")
    back_img_size := _ImGui_ImageGetSize(back_img_id)
    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()

        if(!set_initpos)
            _ImGui_SetNextWindowPos(100, 100), set_initpos := true
        _ImGui_Begin("AHK2", 0, window_flags | ImGuiWindowFlags_NoTitleBar)
        ;添加代码 =====================================
        ;https://github.com/kazhafeizhale/imgui4ahk/blob/master/cpp%20-1.88/icons.h

        window_draw_list := _ImGui_GetWindowDrawList()

        _ImDraw_SetDrawList(window_draw_list)
        p := _ImGui_GetWindowPos()
        _ImDraw_AddImage(back_img_id, p[1], p[2], p[1] + back_img_size[1], p[2] + back_img_size[2])

        _ImGui_Button(Chr(0xf019) ' 下载', 100, 100)
        _ImGui_Button(Chr(0xf15b) ' 复制', 100, 100)
        _ImGui_Button(Chr(0xf20a) ' 关闭', 100, 100)
        _ImGui_Button(Chr(0xf07c) ' 打开', 100, 100)
        ;====================================
        _ImGui_End()
        _ImGui_EndFrame()
        sleep(10)
    }
    ExitApp()
    return
}