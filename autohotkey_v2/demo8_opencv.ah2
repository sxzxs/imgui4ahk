#include <imgui>
#include <log>
#include <wincapture>
#DllLoad opencv_ahk.dll
cv := ObjFromPtr(DllCall('opencv_ahk.dll\opencv_init', 'ptr', DllCall(A_AhkPath '\ahkGetApi', 'ptr'), 'cdecl ptr'))
dxcp := wincapture.DXGI()
map_image := cv.imread(A_ScriptDir "\image\lenna_img.jpg")
bitbuf := BitmapBuffer(map_image.ptr(0, 0), map_image.step1(), map_image.cols, map_image.rows, map_image.channels)
bmp_buf := bitbuf.BMP(true)
g_gif_index := 1


map_image_wal := cv.imread(A_ScriptDir "\墙.png")
bitbuf_wal := BitmapBuffer(map_image_wal.ptr(0, 0), map_image_wal.step1(), map_image_wal.cols, map_image_wal.rows, map_image_wal.channels)
bmp_buf_wal := bitbuf_wal.BMP(true)
g_gif_index := 1


;这个库必须放到开头
_ImGui_EnableViewports(true)
Hotkey("#c", showwind)
main()
main()
{
    global bmp_buf
    static close := false
    static slider_value := [0, 0, 0, 0]
    hwnd := _ImGui_GUICreate("AHK ImGui", 1, 1, -100, -100, 0, 0x80)
    static out_with := 0
    static out_height := 0
    static dx11_image_texture := 0
    _Imgui_LoadTextureFromMemory(bmp_buf.ptr, bmp_buf.size, &dx11_image_texture, &out_with, &out_height)
    _Imgui_imgui_stbi__load_gif(A_ScriptDir '\image\a.gif', &out_srv_array := [], &length := 0, &out_gif_with := 0, &out_gif_height := 0, &out_gif_delay := 0)
    SetTimer(gif_setter.Bind(length), out_gif_delay)

    static out_with_wal := 0
    static out_height_wal := 0
    static dx11_image_texture_wal := 0
    _Imgui_LoadTextureFromMemory(bmp_buf_wal.ptr, bmp_buf_wal.size, &dx11_image_texture_wal, &out_with_wal, &out_height_wal)



    WinShow(hwnd)
    WinSetAlwaysOnTop(1, hwnd)

    _ImGui_StyleColorsClassic()
    _ImGui_SetWindowTitleAlign(0.5, 0.5)
    _ImGui_EnableDocking(True)
    static window_flags := 0

    while (_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
        _ImGui_Begin("AHK2", 0, window_flags)

        _imgui_PushItemWidth(_imgui_GetFontSize() * -12)

        _ImGui_PushStyleColor(ImGuiCol_Button, "0xff18dd71")
        _ImGui_SameLine()
        if (_ImGui_SmallButton("close##close"))
            ExitApp()
        _ImGui_SameLine()
        if (_ImGui_SmallButton("hide##hide"))
            hidewind()
        _ImGui_PopStyleColor(1)

        ;_ImGui_ImageFit(dx11_image_texture, out_with, out_height)

        _ImGui_Image(dx11_image_texture, out_with, out_height)

        ;_Imgui_TextureFree(stbi__context_buf)
        _ImGui_Image(out_srv_array[g_gif_index], out_gif_with, out_gif_height)

        _imgui_PushItemWidth(out_with)
        static rgb_color := [0, 0, 0]
        if (_ImGui_SliderInt3("Slider##slider", &rgb_color, 0, 255, format := "%d"))
        {
            R := rgb_color[1]
            G := rgb_color[2]
            B := rgb_color[3]
            map_image.setTo(cv.Mat(1, 3, cv.constants.CV_8UC3, [B, G, R]))
            bitbuf := BitmapBuffer(map_image.ptr(0, 0), map_image.step1(), map_image.cols, map_image.rows, map_image.channels)
            ;bitbuf := bitbuf.cvtBytes(3)
            bmp := bitbuf.BMP(true)
            _Imgui_TextureFree(dx11_image_texture)
            _Imgui_LoadTextureFromMemory(bmp.ptr, bmp.size, &dx11_image_texture, &out_with, &out_height)
        }
        _ImGui_PopItemWidth()

        _ImGui_End()
        _ImGui_EndFrame()
        Sleep(20)
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

gif_setter(length)
{
    global g_gif_index
    g_gif_index++
    if(g_gif_index == length)
        g_gif_index := 1
}