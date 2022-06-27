#include <imgui>
#include <log>
#Include <imgui>
;#include <log>
;这个库必须放到开头

f := 1.1
d := 1.2
i := 10

dll_test1(&f, &i, &d)
logger.info(f, i, d)
dll_test(&f, &i, &d)
logger.info(f, i, d)
dll_test(&f, &i, &d)
{
	DllCall("imgui\imgui_dll_test", "float *", &f, "int *", &i, "double *", &d)
}

dll_test1(&f, &i, &d)
{
	struct_i := buffer("4", 0)
	struct_f := buffer("4", 0)
	struct_d := buffer("8", 0)
    NumPut("int", i, struct_i)
    NumPut("float", f, struct_f)
    NumPut("double", d, struct_d)
	DllCall("imgui\imgui_dll_test", "ptr", struct_f, "ptr", struct_i, "ptr", struct_d)
    i := NumGet(struct_i, 0, "int")
    f := NumGet(struct_f, 0, "float")
    d := NumGet(struct_d, 0, "double")
}


g_gif_index := 1
_ImGui_EnableViewports(true)
main()
main()
{
    static close := false
    ;hwnd := _ImGui_GUICreate("AHK ImGui中文", 1, 1, -100, -100, 0, 0x80, 'C:\Windows\Fonts\framdit.ttf')
    hwnd := _ImGui_GUICreate("AHK ImGui中文", 1, 1, -100, -100, 0, 0x80, 'from_memory_ali', 20)
    ;hwnd := _ImGui_GUICreate("AHK ImGui中文", 100, 100, 100, 100, 0, 0x80)
    ;DllCall('imgui\igSetWindowFontScale', "float", 0.5)

    WinShow(hwnd)
    WinSetAlwaysOnTop( 1,hwnd)
    _ImGui_StyleColorsClassic()
    _ImGui_SetWindowTitleAlign(0.5, 0.5)
    _ImGui_EnableDocking(True)
    static window_flags := 0
    img1 := _ImGui_ImageFromFile(A_ScriptDir "\image\1.jpg")
    img2 := _ImGui_ImageFromFile(A_ScriptDir "\image\2.jpg")
    img3 := _ImGui_ImageFromFile(A_ScriptDir "\image\3.jpg")
    img4 := _ImGui_ImageFromFile(A_ScriptDir "\image\4.jpg")
    img5 := _ImGui_ImageFromFile(A_ScriptDir "\image\5.jpg")
    img6 := _ImGui_ImageFromFile(A_ScriptDir "\image\6.jpg")
    _Imgui_imgui_stbi__load_gif(A_ScriptDir '\image\g.gif', &out_srv_array := [], &length := 0, &out_gif_with := 0, &out_gif_height := 0, &out_gif_delay := 0)
    if(out_gif_delay == 0) 
        out_gif_delay := 200
    SetTimer(gif_setter.Bind(length), out_gif_delay)

    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()



        _ImGui_PushStyleColor(ImGuiCol_WindowBg, "0x168E8D56")
        _ImGui_SetNextWindowBgAlpha(0.35)
        _ImGui_Begin("AHK2中文", 0, window_flags)
        _ImGui_PopStyleColor(1)

        static tab_bar_flags := ImGuiTabBarFlags_None
        if(_ImGui_CollapsingHeader("help"))
        {

        }

        if(_ImGui_BeginTabBar("mytabbar", tab_bar_flags))
        {
            if(_ImGui_BeginTabItem("tab1"))
            {
                _ImGui_Text("tab1")
                _ImGui_EndTabItem()
            }
            if(_ImGui_BeginTabItem("tab2"))
            {
                _ImGui_Text("tab2")
                _ImGui_EndTabItem()
            }
            _ImGui_EndTabBar()
        }

        ;_ImGui_SetWindowFontScale(2)
        ;DllCall('imgui\igSetWindowFontScale', "float", 1.5)

        static b_show_demo_window := false
        _ImGui_CheckBox("Show demo中文 ", &b_show_demo_window)
        
        static color_get_bgr := 0x168E8D56
        _imgui_PushItemWidth(400)
        _ImGui_ColorPicker("color_pick", &color_get_bgr)
        _ImGui_PopItemWidth()

        _ImGui_ImageButton(img1, 50, 50)
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

        _ImGui_Image(out_srv_array[g_gif_index], out_gif_with, out_gif_height)
        _ImGui_ImageButton(out_srv_array[g_gif_index], 50, 50)

        _ImGui_End()
        _ImGui_EndFrame()
        Sleep(10)
    }
    return
}

gif_setter(length)
{
    global g_gif_index
    g_gif_index++
    if(g_gif_index == length)
        g_gif_index := 1
}