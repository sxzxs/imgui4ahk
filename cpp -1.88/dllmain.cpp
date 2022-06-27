// dllmain.cpp : Defines the entry point for the DLL application.
#define STB_IMAGE_IMPLEMENTATION
#include "pch.h"

#include <codecvt>
#include <string>
#include "stb_gif.h"
#include<sstream>
#include <fstream>
#include "alifont.hpp"
#include "simhei.h"
#include "iconcpp.h"

#define  OK 0
#define ERROR_PARAMETER -1

BOOL APIENTRY DllMain(HMODULE hModule,
	DWORD  ul_reason_for_call,
	LPVOID lpReserved
)
{

	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH: {
	}
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}


bool bEnableViewPort = false;

std::wstring UTF8ToUnicode(const std::string & str)
{
    std::wstring ret;
    try {
        std::wstring_convert< std::codecvt_utf8<wchar_t> > wcv;
        ret = wcv.from_bytes(str);
    } catch (const std::exception & e) {
        std::cerr << e.what() << std::endl;
    }
    return ret;
}
std::string UnicodeToUTF8(const std::wstring & wstr)
{
    std::string ret;
    try {
        std::wstring_convert< std::codecvt_utf8<wchar_t> > wcv;
        ret = wcv.to_bytes(wstr);
    } catch (const std::exception & e) {
        std::cerr << e.what() << std::endl;
    }
    return ret;
}

std::string UnicodeToANSI(const std::wstring & wstr)
{
    std::string ret;
    std::mbstate_t state = {};
    const wchar_t *src = wstr.data();
    size_t len = std::wcsrtombs(nullptr, &src, 0, &state);
    if (static_cast<size_t>(-1) != len) {
        std::unique_ptr< char [] > buff(new char[len + 1]);
        len = std::wcsrtombs(buff.get(), &src, len, &state);
        if (static_cast<size_t>(-1) != len) {
            ret.assign(buff.get(), len);
        }
    }
    return ret;
}

std::wstring ANSIToUnicode(const std::string & str)
{
    std::wstring ret;
    std::mbstate_t state = {};
    const char *src = str.data();
    size_t len = std::mbsrtowcs(nullptr, &src, 0, &state);
    if (static_cast<size_t>(-1) != len) {
        std::unique_ptr< wchar_t [] > buff(new wchar_t[len + 1]);
        len = std::mbsrtowcs(buff.get(), &src, len, &state);
        if (static_cast<size_t>(-1) != len) {
            ret.assign(buff.get(), len);
        }
    }
    return ret;
}

std::string UTF8ToANSI(const std::string & str)
{
    return UnicodeToANSI(UTF8ToUnicode(str));
}

std::string ANSIToUTF8(const std::string & str)
{
    return UnicodeToUTF8(ANSIToUnicode(str));
}

ImU32 ARGB2ABGR(ImU32 color) {
    ImU32 result = color;
    *(BYTE*)((char*)&result) = ((color >> 16) & 0xff);
    *(BYTE*)((char*)&result + 2) = ((color) & 0xff);
    return result;
}
ImVec4 GetVec4Color(ImU32 color) {
    return ImGui::ColorConvertU32ToFloat4(ARGB2ABGR(color));
}

std::string wstr_utf8(const std::wstring& str)
{
    std::wstring_convert<std::codecvt_utf8<wchar_t>> myconv;
    return myconv.to_bytes(str);
}
std::wstring utf8_wstr(const std::string& str)
{
    std::wstring_convert<std::codecvt_utf8<wchar_t>> myconv;
    return myconv.from_bytes(str);
}



EXTERN_DLL_EXPORT void EnableViewports(bool enable) {
    bEnableViewPort = enable;
}

EXTERN_DLL_EXPORT HWND GUICreate(wchar_t* title, int w, int h, int x, int y, wchar_t* font_path, float font_size, wchar_t *font_range, wchar_t *charBuf) {

    if (x == -1 || y == -1) {
        RECT rc;
        GetWindowRect(GetDesktopWindow(), &rc);
        if (x == -1) x = int(rc.right / 2 - w / 2);
        if (y == -1) y = int(rc.bottom / 2 - h / 2);
    }

    main_hwnd_wc = { sizeof(WNDCLASSEX), CS_CLASSDC, WndProc, 0L, 0L, GetModuleHandle(NULL), NULL, NULL, NULL, NULL, _T("ImGui Example"), NULL };
    ::RegisterClassEx(&main_hwnd_wc);
    main_hwnd = ::CreateWindow(main_hwnd_wc.lpszClassName, title, WS_OVERLAPPEDWINDOW, x, y, w, h, NULL, NULL, main_hwnd_wc.hInstance, NULL);




    // Initialize Direct3D
    if (!CreateDeviceD3D(main_hwnd))
    {
        CleanupDeviceD3D();
        ::UnregisterClass(main_hwnd_wc.lpszClassName, main_hwnd_wc.hInstance);
        return 0;
    }
    \
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

    //io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;       // Enable Keyboard Controls
    //io.ConfigFlags |= ImGuiConfigFlags_NavNoCaptureKeyboard;       // Enable Keyboard Controls
	
    if (bEnableViewPort) io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;
    //io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad;      // Enable Gamepad Controls

    io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;           // Enable Docking
    io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;         // Enable Multi-Viewport / Platform Windows

    //io.ConfigViewportsNoAutoMerge = true;
    io.ConfigViewportsNoTaskBarIcon = true;
    //io.ConfigViewportsNoDefaultParent = true;
    //io.ConfigDockingAlwaysTabBar = true;
    io.ConfigDockingTransparentPayload = true;
    //io.ConfigFlags |= ImGuiConfigFlags_DpiEnableScaleFonts;     // FIXME-DPI: THIS CURRENTLY DOESN'T WORK AS EXPECTED. DON'T USE IN USER APP!
    //io.ConfigFlags |= ImGuiConfigFlags_DpiEnableScaleViewports; // FIXME-DPI

    //auto pStyle = &ImGui::GetStyle();
    //pStyle->WindowTitleAlign = ImVec2(0.5f, 0.5f);
    //if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
    //{
    //    pStyle->WindowRounding = 0.0f;
    //}

    //pStyle->Colors[ImGuiCol_WindowBg].w = 1.0f;
    auto fontAtlas = ImGui::GetIO().Fonts;
    fontAtlas->ClearFonts();

    auto glyphRange = fontAtlas->GetGlyphRangesVietnamese();
	std::wstring font_rangew(font_range);
	if (font_rangew == std::wstring(L"GetGlyphRangesDefault"))
	{
		glyphRange = fontAtlas->GetGlyphRangesDefault();
	}
	else if (font_rangew == std::wstring(L"GetGlyphRangesKorean"))
	{
		glyphRange = fontAtlas->GetGlyphRangesKorean();
	}
	else if (font_rangew == std::wstring(L"GetGlyphRangesJapanese"))
	{
		glyphRange = fontAtlas->GetGlyphRangesJapanese();
	}
	else if (font_rangew == std::wstring(L"GetGlyphRangesChineseFull"))
	{
		glyphRange = fontAtlas->GetGlyphRangesChineseFull();
	}
	else if (font_rangew == std::wstring(L"GetGlyphRangesChineseSimplifiedCommon"))
	{
		glyphRange = fontAtlas->GetGlyphRangesChineseSimplifiedCommon();
	}
	else if (font_rangew == std::wstring(L"GetGlyphRangesCyrillic"))
	{
		glyphRange = fontAtlas->GetGlyphRangesCyrillic();
	}
	else if (font_rangew == std::wstring(L"GetGlyphRangesThai"))
	{
		glyphRange = fontAtlas->GetGlyphRangesThai();
	}
	else if (font_rangew == std::wstring(L"GetGlyphRangesVietnamese"))
	{
		glyphRange = fontAtlas->GetGlyphRangesVietnamese();
	}
    //fontAtlas->AddFontFromFileTTF("C:\\Windows\\Fonts\\calibri.ttf", 15.5f, 0, glyphRange);

	if (charBuf != 0)
	{
		glyphRange = (ImWchar *)charBuf;
	}
	ImFontConfig config_words{};
	config_words.OversampleH = 1;
	config_words.OversampleV = 1;
	//config_words.GlyphExtraSpacing.x = 0.1f;
	if (font_path == std::wstring(L"from_memory_ali"))
	{
		fontAtlas->AddFontFromMemoryTTF(aliFont(), alifont_size, font_size, &config_words, glyphRange);
	}
	else if (font_path == std::wstring(L"from_memory_simhei"))
	{
		fontAtlas->AddFontFromMemoryTTF(simhei_font(), simhei_size, font_size, &config_words, glyphRange);	
	}
	else
	{
		fontAtlas->AddFontFromFileTTF(wstr_utf8(font_path).c_str(), font_size, &config_words, glyphRange);
	}

    ImFontConfig icons_config;
    ImFontConfig CustomFont;
    CustomFont.FontDataOwnedByAtlas = false;
    icons_config.MergeMode = true;
    icons_config.PixelSnapH = true;
    icons_config.OversampleH = 2.5;
    icons_config.OversampleV = 2.5;
    static const ImWchar icons_ranges[] = { 0xf000, 0xf3ff, 0 };
    fontAtlas->AddFontFromMemoryCompressedTTF(font_awesome_data, font_awesome_size, font_size, &icons_config, icons_ranges);

    //ImGuiSetStyle();
    ImGui::StyleColorsDark();

    ImGui_ImplWin32_Init(main_hwnd);
    ImGui_ImplDX11_Init(g_pd3dDevice, g_pd3dDeviceContext);
    return main_hwnd;
   
}
EXTERN_DLL_EXPORT bool PeekMsg() {

    static MSG msg;
    ZeroMemory(&msg, sizeof(msg));
    if (::PeekMessage(&msg, NULL, 0U, 0U, PM_REMOVE))
    {
        ::TranslateMessage(&msg);
        ::DispatchMessage(&msg);
    }
    bool is_closed = msg_closed;
    msg_closed = false;
    return !is_closed;
}
EXTERN_DLL_EXPORT void BeginFrame() {

    ImGui_ImplDX11_NewFrame();
    ImGui_ImplWin32_NewFrame();
    ImGui::NewFrame();
}
EXTERN_DLL_EXPORT void EndFrame(ImU32 clear_color) {

    ImVec4 col = GetVec4Color(clear_color);
    ImGui::Render();
    g_pd3dDeviceContext->OMSetRenderTargets(1, &g_mainRenderTargetView, NULL);
    g_pd3dDeviceContext->ClearRenderTargetView(g_mainRenderTargetView, (float*)&col);


    ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());


    if (ImGui::GetIO().ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
    {
        ImGui::UpdatePlatformWindows();
        ImGui::RenderPlatformWindowsDefault();
    }



    g_pSwapChain->Present(1, 0); // Present with vsync
    //g_pSwapChain->Present(0, 0); // Present without vsync
}
EXTERN_DLL_EXPORT void ShutDown() {


    // Cleanup
    ImGui_ImplDX11_Shutdown();
    ImGui_ImplWin32_Shutdown();
    ImGui::DestroyContext();

    CleanupDeviceD3D();
    ::DestroyWindow(main_hwnd);
    ::UnregisterClass(main_hwnd_wc.lpszClassName, main_hwnd_wc.hInstance);

}

EXTERN_DLL_EXPORT void Begin(const wchar_t* name, bool* open, int flags) {
    ImGui::Begin(wstr_utf8(name).c_str(), open, flags);
}

EXTERN_DLL_EXPORT void Text(const wchar_t* text) {
    ImGui::TextUnformatted(wstr_utf8(text).c_str());
}

EXTERN_DLL_EXPORT void SameLine(float offset_from_start_x, float spacing) {
    ImGui::SameLine(offset_from_start_x, spacing);
}

EXTERN_DLL_EXPORT bool Button(const wchar_t* text, float w, float h) {
    return ImGui::Button(wstr_utf8(text).c_str(), { w, h });
}

EXTERN_DLL_EXPORT bool Checkbox(const wchar_t* text, bool* v) {
    return ImGui::Checkbox(wstr_utf8(text).c_str(), v);
}

EXTERN_DLL_EXPORT bool SliderFloat(const wchar_t* text, float *v, float v_min, float v_max, const wchar_t* format, float power) {
    return ImGui::SliderFloat(wstr_utf8(text).c_str(), v, v_min, v_max, wstr_utf8(format).c_str(), power);
}

EXTERN_DLL_EXPORT bool InputText(const wchar_t* label, wchar_t* buf, int buf_size, int flags, ImGuiInputTextCallback callback, void* user_data) {
    std::string str = wstr_utf8(buf);
    char *buffer = new char[buf_size+1];
    ZeroMemory(buffer, buf_size + 1);
    
    memcpy(buffer, str.c_str(), str.length());

    bool result = ImGui::InputText(wstr_utf8(label).c_str(), buffer, buf_size, flags, callback, user_data);
    
    std::wstring new_str = utf8_wstr(buffer);
    memcpy(buf, new_str.c_str(), new_str.length()*2 + 1);
    delete[] buffer;    
    return result;

}
EXTERN_DLL_EXPORT bool InputTextMultiline(const wchar_t* label, wchar_t* buf, size_t buf_size, float size_x, float size_y, ImGuiInputTextFlags flags, void* callback, void* user_data) {
    std::string str = wstr_utf8(buf);
    char* buffer = new char[buf_size + 1];
    ZeroMemory(buffer, buf_size + 1);

    memcpy(buffer, str.c_str(), str.length());

    bool result = ImGui::InputTextMultiline(wstr_utf8(label).c_str(), buffer, buf_size, { size_x, size_y }, flags, (ImGuiInputTextCallback)callback, user_data);
    std::wstring new_str = utf8_wstr(buffer);
    memcpy(buf, new_str.c_str(), new_str.length() * 2 + 1);
    delete[] buffer;

    return result;
}


EXTERN_DLL_EXPORT bool InputTextWithHint(const wchar_t* label, const wchar_t* hint, wchar_t* buf, size_t buf_size, ImGuiInputTextFlags flags) {
    std::string str = wstr_utf8(buf);
    char* buffer = new char[buf_size + 1];
    ZeroMemory(buffer, buf_size + 1);

    memcpy(buffer, str.c_str(), str.length());

    bool result = ImGui::InputTextWithHint(wstr_utf8(label).c_str(), wstr_utf8(hint).c_str(), buffer, buf_size, flags);
    std::wstring new_str = utf8_wstr(buffer);
    memcpy(buf, new_str.c_str(), new_str.length() * 2 + 1);
    delete[] buffer;

    return result;
}

EXTERN_DLL_EXPORT bool BeginChild(const wchar_t* text, float w, float h, bool border, int flags) {
    return ImGui::BeginChild(wstr_utf8(text).c_str(), { w, h }, border, flags);
}

EXTERN_DLL_EXPORT void EndChild() {
    return ImGui::EndChild();
}

EXTERN_DLL_EXPORT void End() {
    ImGui::End();
}

EXTERN_DLL_EXPORT void ShowDemoWindow() {

    ImGui::ShowDemoWindow();
}
EXTERN_DLL_EXPORT void DrawTest() {

     //printf("%d\n", ImGui::GetIO().KeyMap[ImGuiKey_Backspace]);
    static char fpsInfo[255];
    sprintf_s(fpsInfo, "FPS: %.f", ImGui::GetIO().Framerate);
	// ImGui::GetOverlayDrawList()->AddText({ 10, 5 }, 0xFFDDDDDD, fpsInfo);
}

EXTERN_DLL_EXPORT void StyleColorsDark() {
    return ImGui::StyleColorsDark();
}
EXTERN_DLL_EXPORT void StyleColorsLight() {
    return ImGui::StyleColorsLight();
}
EXTERN_DLL_EXPORT void StyleColorsClassic() {
    return ImGui::StyleColorsClassic();
}
EXTERN_DLL_EXPORT bool IsWindowAppearing() {
    return ImGui::IsWindowAppearing();
}
EXTERN_DLL_EXPORT void SetWindowFocus() {
    return ImGui::SetWindowFocus();
}
EXTERN_DLL_EXPORT void SetWindowCollapsedByName(const wchar_t* name, bool collapsed, ImGuiCond cond) {
    return ImGui::SetWindowCollapsed(wstr_utf8(name).c_str(), collapsed, cond);
}
EXTERN_DLL_EXPORT bool IsWindowCollapsed() {
    return ImGui::IsWindowCollapsed();
}
EXTERN_DLL_EXPORT bool IsWindowFocused(ImGuiFocusedFlags flags) {
    return ImGui::IsWindowFocused(flags);
}
EXTERN_DLL_EXPORT bool IsWindowHovered(ImGuiHoveredFlags flags) {
    return ImGui::IsWindowHovered(0);
}

EXTERN_DLL_EXPORT void* GetWindowDrawList() {
    return ImGui::GetWindowDrawList();
}
EXTERN_DLL_EXPORT void* GetBackgroundDrawList() {
    return ImGui::GetBackgroundDrawList();
}
EXTERN_DLL_EXPORT void* GetForegroundDrawList() {
    return ImGui::GetForegroundDrawList();
}
EXTERN_DLL_EXPORT void* GetOverlayDrawList() {
    //return ImGui::GetOverlayDrawList();
	return NULL;
}
EXTERN_DLL_EXPORT void GetWindowPos(float* x, float* y) {
    ImVec2 pos = ImGui::GetWindowPos();
    *x = pos.x;
    *y = pos.y;
}
EXTERN_DLL_EXPORT void GetWindowSize(float* x, float* y) {
    ImVec2 pos = ImGui::GetWindowSize();
    *x = pos.x;
    *y = pos.y;
}
EXTERN_DLL_EXPORT void SetNextWindowPos(float x, float y, ImGuiCond cond, float pivot_x, float pivot_y){
    ImGui::SetNextWindowPos({ x,y }, cond, {pivot_x,pivot_y});
}
EXTERN_DLL_EXPORT void SetNextWindowSize(float x, float y, ImGuiCond cond){
    ImGui::SetNextWindowSize({ x,y }, cond);
}

EXTERN_DLL_EXPORT void SetNextWindowSizeConstraints(float size_min_x, float size_min_y, float size_max_x, float size_max_y) {
    return ImGui::SetNextWindowSizeConstraints({ size_min_x, size_min_y }, { size_max_x, size_max_y });
}

EXTERN_DLL_EXPORT void SetNextWindowContentSize(float size_x, float size_y) {
    ImGui::SetNextWindowContentSize({ size_x, size_y });
}
EXTERN_DLL_EXPORT void SetNextWindowCollapsed(bool collapsed, ImGuiCond cond) {
    ImGui::SetNextWindowCollapsed(collapsed, cond);
}
EXTERN_DLL_EXPORT void SetNextWindowFocus() {
    ImGui::SetNextWindowFocus();
}




EXTERN_DLL_EXPORT void SetNextWindowBgAlpha(float alpha){
	return ImGui::SetNextWindowBgAlpha(alpha);
}
EXTERN_DLL_EXPORT void SetNextWindowViewport(ImGuiID id) {
	return ImGui::SetNextWindowViewport(id);
}
EXTERN_DLL_EXPORT void SetWindowPosition(float pos_x, float pos_y, ImGuiCond cond){
	return ImGui::SetWindowPos({ pos_x, pos_y}, cond);
}
EXTERN_DLL_EXPORT void SetWindowSize(float size_x, float size_y, ImGuiCond cond){
	return ImGui::SetWindowSize({ size_x, size_y}, cond);
}
EXTERN_DLL_EXPORT void SetWindowCollapsed(bool collapsed, ImGuiCond cond){
	return ImGui::SetWindowCollapsed(collapsed, cond);
}
EXTERN_DLL_EXPORT void SetWindowFontScale(float scale){
	return ImGui::SetWindowFontScale(scale);
}
EXTERN_DLL_EXPORT void SetWindowPosByName(const wchar_t* name, float pos_x, float pos_y, ImGuiCond cond){
	return ImGui::SetWindowPos(wstr_utf8(name).c_str(), { pos_x, pos_y}, cond);
}

EXTERN_DLL_EXPORT void SetWindowSizeByName(const wchar_t* name, float size_x, float size_y, ImGuiCond cond){
	return ImGui::SetWindowSize(wstr_utf8(name).c_str(), { size_x, size_y}, cond);
}
EXTERN_DLL_EXPORT void SetWindowFocusByName(const wchar_t* name){
	return ImGui::SetWindowFocus(wstr_utf8(name).c_str());
}
EXTERN_DLL_EXPORT void GetContentRegionMax(float* x, float* y){
	ImVec2 pos = ImGui::GetContentRegionMax(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetContentRegionAvail(float* x, float* y){
	ImVec2 pos = ImGui::GetContentRegionAvail(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetWindowContentRegionMin(float* x, float* y){
	ImVec2 pos = ImGui::GetWindowContentRegionMin(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetWindowContentRegionMax(float* x, float* y){
	ImVec2 pos = ImGui::GetWindowContentRegionMax(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetItemRectMin(float* x, float* y){
	ImVec2 pos = ImGui::GetItemRectMin(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetItemRectMax(float* x, float* y){
	ImVec2 pos = ImGui::GetItemRectMax(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetItemRectSize(float* x, float* y){
	ImVec2 pos = ImGui::GetItemRectSize(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetMousePos(float* x, float* y){
	ImVec2 pos = ImGui::GetMousePos(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetMousePosOnOpeningCurrentPopup(float* x, float* y){
	ImVec2 pos = ImGui::GetMousePosOnOpeningCurrentPopup(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetMouseDragDelta(ImGuiMouseButton button, float lock_threshold, float* x, float* y){
	ImVec2 pos = ImGui::GetMouseDragDelta(button, lock_threshold); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void ImageGetSize(ImTextureID image, float *x, float*y){
	ImVec2 pos = ukit::GetImageDimension(image); *x = pos.x; *y = pos.y;
}

EXTERN_DLL_EXPORT float GetWindowContentRegionWidth( ){
	return ImGui::GetWindowContentRegionWidth();
}
EXTERN_DLL_EXPORT float GetScrollX( ){
	return ImGui::GetScrollX();
}
EXTERN_DLL_EXPORT float GetScrollY( ){
	return ImGui::GetScrollY();
}
EXTERN_DLL_EXPORT float GetScrollMaxX( ){
	return ImGui::GetScrollMaxX();
}
EXTERN_DLL_EXPORT float GetScrollMaxY( ){
	return ImGui::GetScrollMaxY();
}
EXTERN_DLL_EXPORT void SetScrollX(float scroll_x){
	return ImGui::SetScrollX(scroll_x);
}
EXTERN_DLL_EXPORT void SetScrollY(float scroll_y){
	return ImGui::SetScrollY(scroll_y);
}
EXTERN_DLL_EXPORT void SetScrollHereX(float center_x_ratio){
	return SetScrollHereX(center_x_ratio);
}
EXTERN_DLL_EXPORT void SetScrollHereY(float center_y_ratio){
	return SetScrollHereY(center_y_ratio);
}
EXTERN_DLL_EXPORT void SetScrollFromPosX(float local_x, float center_x_ratio){
	return ImGui::SetScrollFromPosX(local_x, center_x_ratio);
}
EXTERN_DLL_EXPORT void SetScrollFromPosY(float local_y, float center_y_ratio){
	return ImGui::SetScrollFromPosY(local_y, center_y_ratio);
}

EXTERN_DLL_EXPORT void PushFont(void* font){
	return ImGui::PushFont((ImFont*)font);
}
EXTERN_DLL_EXPORT void PopFont( ){
	return ImGui::PopFont();
}
EXTERN_DLL_EXPORT void PushStyleColor(ImGuiCol idx, ImU32 col){
	return ImGui::PushStyleColor(idx, col);
}
EXTERN_DLL_EXPORT void PopStyleColor(int count){
	return ImGui::PopStyleColor(count);
}
EXTERN_DLL_EXPORT void PushStyleVar(ImGuiStyleVar idx, float val){
	return ImGui::PushStyleVar(idx, val);
}
EXTERN_DLL_EXPORT void PushStyleVarPos(ImGuiStyleVar idx, float val_x, float val_y){
	return ImGui::PushStyleVar(idx, { val_x, val_y});
}
EXTERN_DLL_EXPORT void PopStyleVar(int count){
	return ImGui::PopStyleVar(count);
}
EXTERN_DLL_EXPORT ImFont* GetFont( ){
	return ImGui::GetFont();
}
EXTERN_DLL_EXPORT float GetFontSize( ){
	return ImGui::GetFontSize();
}

EXTERN_DLL_EXPORT void GetFontTexUvWhitePixel(float* x, float* y) {
    ImVec2 pos = ImGui::GetFontTexUvWhitePixel(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT ImU32 GetColorU32(ImGuiCol idx, float alpha_mul){
	return ImGui::GetColorU32(idx, alpha_mul);
}
EXTERN_DLL_EXPORT void PushItemWidth(float item_width){
	return ImGui::PushItemWidth(item_width);
}
EXTERN_DLL_EXPORT void PopItemWidth( ){
	return ImGui::PopItemWidth();
}
EXTERN_DLL_EXPORT void SetNextItemWidth(float item_width){
	return ImGui::SetNextItemWidth(item_width);
}
EXTERN_DLL_EXPORT float CalcItemWidth( ){
	return ImGui::CalcItemWidth();
}
EXTERN_DLL_EXPORT void PushTextWrapPos(float wrap_pos_x){
	return ImGui::PushTextWrapPos(wrap_pos_x);
}
EXTERN_DLL_EXPORT void PopTextWrapPos( ){
	return ImGui::PopTextWrapPos();
}
EXTERN_DLL_EXPORT void PushAllowKeyboardFocus(bool allow_keyboard_focus){
	return ImGui::PushAllowKeyboardFocus(allow_keyboard_focus);
}
EXTERN_DLL_EXPORT void PopAllowKeyboardFocus( ){
	return ImGui::PopAllowKeyboardFocus();
}
EXTERN_DLL_EXPORT void PushButtonRepeat(bool repeat){
	return ImGui::PushButtonRepeat(repeat);
}
EXTERN_DLL_EXPORT void PopButtonRepeat( ){
	return ImGui::PopButtonRepeat();
}
EXTERN_DLL_EXPORT void Separator( ){
	return ImGui::Separator();
}
EXTERN_DLL_EXPORT void NewLine( ){
	return ImGui::NewLine();
}
EXTERN_DLL_EXPORT void Spacing( ){
	return ImGui::Spacing();
}
EXTERN_DLL_EXPORT void Dummy(float size_x, float size_y){
	return ImGui::Dummy({ size_x, size_y});
}
EXTERN_DLL_EXPORT void Indent(float indent_w){
	return ImGui::Indent(indent_w);
}
EXTERN_DLL_EXPORT void Unindent(float indent_w){
	return ImGui::Unindent(indent_w);
}
EXTERN_DLL_EXPORT void BeginGroup( ){
	return ImGui::BeginGroup();
}
EXTERN_DLL_EXPORT void EndGroup( ){
	return ImGui::EndGroup();
}

EXTERN_DLL_EXPORT void GetCursorPosition(float* x, float* y) {
    ImVec2 pos = ImGui::GetCursorPos(); *x = pos.x; *y = pos.y;
}


EXTERN_DLL_EXPORT void SetCursorPosition(float local_pos_x, float local_pos_y){
	return ImGui::SetCursorPos({ local_pos_x, local_pos_y});
}

EXTERN_DLL_EXPORT void GetCursorStartPos(float* x, float* y) {
    ImVec2 pos = ImGui::GetCursorStartPos(); *x = pos.x; *y = pos.y;
}
EXTERN_DLL_EXPORT void GetCursorScreenPos(float* x, float* y) {
    ImVec2 pos = ImGui::GetCursorScreenPos(); *x = pos.x; *y = pos.y;
}EXTERN_DLL_EXPORT void SetCursorScreenPos(float pos_x, float pos_y){
	return ImGui::SetCursorScreenPos({ pos_x, pos_y});
}
EXTERN_DLL_EXPORT void AlignTextToFramePadding( ){
	return ImGui::AlignTextToFramePadding();
}
EXTERN_DLL_EXPORT float GetTextLineHeight( ){
	return ImGui::GetTextLineHeight();
}
EXTERN_DLL_EXPORT float GetTextLineHeightWithSpacing( ){
	return ImGui::GetTextLineHeightWithSpacing();
}
EXTERN_DLL_EXPORT float GetFrameHeight( ){
	return ImGui::GetFrameHeight();
}
EXTERN_DLL_EXPORT float GetFrameHeightWithSpacing( ){
	return ImGui::GetFrameHeightWithSpacing();
}
EXTERN_DLL_EXPORT void PushID(const wchar_t* str_id){
	return ImGui::PushID(wstr_utf8(str_id).c_str());
}
EXTERN_DLL_EXPORT void PopID( ){
	return ImGui::PopID();
}
EXTERN_DLL_EXPORT ImGuiID GetID(const wchar_t* str_id){
	return ImGui::GetID(wstr_utf8(str_id).c_str());
}
EXTERN_DLL_EXPORT void TextColored(ImU32 col, const wchar_t* text){
	return ImGui::TextColored(GetVec4Color(col), wstr_utf8(text).c_str());
}
EXTERN_DLL_EXPORT void TextDisabled(const wchar_t* text){
	return ImGui::TextDisabled(wstr_utf8(text).c_str());
}
EXTERN_DLL_EXPORT void TextWrapped(const wchar_t* text){
	return ImGui::TextWrapped(wstr_utf8(text).c_str());
}
EXTERN_DLL_EXPORT void LabelText(const wchar_t* label, const wchar_t* text){
	return ImGui::LabelText(wstr_utf8(label).c_str(), wstr_utf8(text).c_str());
}
EXTERN_DLL_EXPORT void BulletText(const wchar_t* text){
	return ImGui::BulletText(wstr_utf8(text).c_str());
}
EXTERN_DLL_EXPORT bool SmallButton(const wchar_t* label){
	return ImGui::SmallButton(wstr_utf8(label).c_str());
}
EXTERN_DLL_EXPORT bool InvisibleButton(const wchar_t* str_id, float size_x, float size_y){
	return ImGui::InvisibleButton(wstr_utf8(str_id).c_str(), { size_x, size_y});
}
EXTERN_DLL_EXPORT bool ArrowButton(const wchar_t* str_id, ImGuiDir dir){
	return ImGui::ArrowButton(wstr_utf8(str_id).c_str(), dir);
}
EXTERN_DLL_EXPORT void Image(ImTextureID user_texture_id, float size_x, float size_y, float uv0_x, float uv0_y, float uv1_x, float uv1_y, ImU32 tint_col, ImU32 border_col){
	return ImGui::Image(user_texture_id, { size_x, size_y}, { uv0_x, uv0_y}, { uv1_x, uv1_y}, GetVec4Color(tint_col), GetVec4Color(border_col));
}
EXTERN_DLL_EXPORT void ImageFit(ImTextureID user_texture_id, float size_x, float size_y, bool clipping, float rounding, ImU32 tint_col, ImDrawCornerFlags rounding_corners){
	ImVec2 imgSize = ukit::DrawImageFit(ImGui::GetWindowDrawList(), user_texture_id, ImGui::GetCursorScreenPos(), { size_x, size_y }, clipping, true, rounding, tint_col, rounding_corners);
	ImGui::InvisibleButton("hidden_image", imgSize);
}
EXTERN_DLL_EXPORT bool ImageButton(ImTextureID user_texture_id, float size_x, float size_y, float uv0_x, float uv0_y, float uv1_x, float uv1_y, int frame_padding, ImU32 bg_col, ImU32 tint_col){
	return ImGui::ImageButton(user_texture_id, { size_x, size_y}, { uv0_x, uv0_y}, { uv1_x, uv1_y}, frame_padding, GetVec4Color(bg_col), GetVec4Color(tint_col));
}
EXTERN_DLL_EXPORT bool CheckboxFlags(const wchar_t* label, unsigned int* flags, unsigned int flags_value){
	return ImGui::CheckboxFlags(wstr_utf8(label).c_str(), flags, flags_value);
}
EXTERN_DLL_EXPORT bool RadioButton(const wchar_t* label, int* v, int v_button){
	return ImGui::RadioButton(wstr_utf8(label).c_str(), v, v_button);
}
EXTERN_DLL_EXPORT void ProgressBar(float fraction, float size_arg_x, float size_arg_y, const wchar_t* overlay){
	return ImGui::ProgressBar(fraction, { size_arg_x, size_arg_y}, (overlay == 0 ? 0 : wstr_utf8(overlay).c_str()));
}
EXTERN_DLL_EXPORT void Bullet( ){
	return ImGui::Bullet();
}
EXTERN_DLL_EXPORT bool BeginCombo(const wchar_t* label, const wchar_t* preview_value, ImGuiComboFlags flags){
	return ImGui::BeginCombo(wstr_utf8(label).c_str(), wstr_utf8(preview_value).c_str(), flags);
}
EXTERN_DLL_EXPORT void EndCombo( ){
	return ImGui::EndCombo();
}


EXTERN_DLL_EXPORT void AddLine(ImDrawList* pDrawlist, float p1_x, float p1_y, float p2_x, float p2_y, ImU32 col, float thickness){
	return pDrawlist->AddLine({ p1_x, p1_y}, { p2_x, p2_y}, ARGB2ABGR(col), thickness);
}
EXTERN_DLL_EXPORT void AddRect(ImDrawList* pDrawlist, float p_min_x, float p_min_y, float p_max_x, float p_max_y, ImU32 col, float rounding, ImDrawCornerFlags rounding_corners, float thickness){
	return pDrawlist->AddRect({ p_min_x, p_min_y}, { p_max_x, p_max_y}, ARGB2ABGR(col), rounding, rounding_corners, thickness);
}
EXTERN_DLL_EXPORT void AddRectFilled(ImDrawList* pDrawlist, float p_min_x, float p_min_y, float p_max_x, float p_max_y, ImU32 col, float rounding, ImDrawCornerFlags rounding_corners){
	return pDrawlist->AddRectFilled({ p_min_x, p_min_y}, { p_max_x, p_max_y}, ARGB2ABGR(col), rounding, rounding_corners);
}
EXTERN_DLL_EXPORT void AddBezierCurve(ImDrawList* pDrawlist, float p1_x, float p1_y, float p2_x, float p2_y, float p3_x, float p3_y, float p4_x, float p4_y, ImU32 col, float thickness, int num_segments){
	return pDrawlist->AddBezierCurve({ p1_x, p1_y}, { p2_x, p2_y}, { p3_x, p3_y}, { p4_x, p4_y}, ARGB2ABGR(col), thickness, num_segments);
}
EXTERN_DLL_EXPORT void AddCircle(ImDrawList* pDrawlist, float center_x, float center_y, float radius, ImU32 col, int num_segments, float thickness){
	return pDrawlist->AddCircle({ center_x, center_y}, radius, ARGB2ABGR(col), num_segments, thickness);
}
EXTERN_DLL_EXPORT void AddCircleFilled(ImDrawList* pDrawlist, float center_x, float center_y, float radius, ImU32 col, int num_segments){
	return pDrawlist->AddCircleFilled({ center_x, center_y}, radius, ARGB2ABGR(col), num_segments);
}
EXTERN_DLL_EXPORT void AddConvexPolyFilled(ImDrawList* pDrawlist, ImVec2* points, int points_count, ImU32 col) {
    return pDrawlist->AddConvexPolyFilled(points, points_count, ARGB2ABGR(col));
}
EXTERN_DLL_EXPORT void AddImage(ImDrawList* pDrawlist, ImTextureID user_texture_id, float p_min_x, float p_min_y, float p_max_x, float p_max_y, float uv_min_x, float uv_min_y, float uv_max_x, float uv_max_y, ImU32 col){
	return pDrawlist->AddImage(user_texture_id, { p_min_x, p_min_y}, { p_max_x, p_max_y}, { uv_min_x, uv_min_y}, { uv_max_x, uv_max_y}, ARGB2ABGR(col));
}
EXTERN_DLL_EXPORT void AddImageFit(ImDrawList* pDrawlist, ImTextureID user_texture_id, float pos_x, float pos_y, float size_x, float size_y, bool clipping, float rounding, ImU32 tint_col, ImDrawCornerFlags rounding_corners){

	ukit::DrawImageFit(pDrawlist, user_texture_id, { pos_x, pos_y }, { size_x, size_y }, clipping, true, rounding, tint_col, rounding_corners);
}
EXTERN_DLL_EXPORT void AddImageQuad(ImDrawList* pDrawlist, ImTextureID user_texture_id, float p1_x, float p1_y, float p2_x, float p2_y, float p3_x, float p3_y, float p4_x, float p4_y, float uv1_x, float uv1_y, float uv2_x, float uv2_y, float uv3_x, float uv3_y, float uv4_x, float uv4_y, ImU32 col){
	return pDrawlist->AddImageQuad(user_texture_id, { p1_x, p1_y}, { p2_x, p2_y}, { p3_x, p3_y}, { p4_x, p4_y}, { uv1_x, uv1_y}, { uv2_x, uv2_y}, { uv3_x, uv3_y}, { uv4_x, uv4_y}, col);
}
EXTERN_DLL_EXPORT void AddImageRounded(ImDrawList* pDrawlist, ImTextureID user_texture_id, float p_min_x, float p_min_y, float p_max_x, float p_max_y, float uv_min_x, float uv_min_y, float uv_max_x, float uv_max_y, ImU32 col, float rounding, ImDrawCornerFlags rounding_corners){
	return pDrawlist->AddImageRounded(user_texture_id, { p_min_x, p_min_y}, { p_max_x, p_max_y}, { uv_min_x, uv_min_y}, { uv_max_x, uv_max_y}, ARGB2ABGR(col), rounding, rounding_corners);
}
EXTERN_DLL_EXPORT void AddNgon(ImDrawList* pDrawlist, float center_x, float center_y, float radius, ImU32 col, int num_segments, float thickness){
	return pDrawlist->AddNgon({ center_x, center_y}, radius, ARGB2ABGR(col), num_segments, thickness);
}
EXTERN_DLL_EXPORT void AddNgonFilled(ImDrawList* pDrawlist, float center_x, float center_y, float radius, ImU32 col, int num_segments){
	return pDrawlist->AddNgonFilled({ center_x, center_y}, radius, ARGB2ABGR(col), num_segments);
}
EXTERN_DLL_EXPORT void AddPolyline(ImDrawList* pDrawlist, ImVec2* points, const int points_count, ImU32 col, bool closed, float thickness) {
    return pDrawlist->AddPolyline(points, points_count, ARGB2ABGR(col), closed, thickness);
}
EXTERN_DLL_EXPORT void AddQuad(ImDrawList* pDrawlist, float p1_x, float p1_y, float p2_x, float p2_y, float p3_x, float p3_y, float p4_x, float p4_y, ImU32 col, float thickness){
	return pDrawlist->AddQuad({ p1_x, p1_y}, { p2_x, p2_y}, { p3_x, p3_y}, { p4_x, p4_y}, ARGB2ABGR(col), thickness);
}
EXTERN_DLL_EXPORT void AddQuadFilled(ImDrawList* pDrawlist, float p1_x, float p1_y, float p2_x, float p2_y, float p3_x, float p3_y, float p4_x, float p4_y, ImU32 col){
	return pDrawlist->AddQuadFilled({ p1_x, p1_y}, { p2_x, p2_y}, { p3_x, p3_y}, { p4_x, p4_y}, ARGB2ABGR(col));
}
EXTERN_DLL_EXPORT void AddRectFilledMultiColor(ImDrawList* pDrawlist, float p_min_x, float p_min_y, float p_max_x, float p_max_y, ImU32 col_upr_left, ImU32 col_upr_right, ImU32 col_bot_right, ImU32 col_bot_left) {
    return pDrawlist->AddRectFilledMultiColor({ p_min_x, p_min_y }, { p_max_x, p_max_y }, col_upr_left, col_upr_right, col_bot_right, col_bot_left);
}
EXTERN_DLL_EXPORT void AddText(ImDrawList* pDrawlist, ImFont* font, float font_size, float pos_x, float pos_y, ImU32 col, const wchar_t* text, float wrap_width) {
    return pDrawlist->AddText(font, font_size, { pos_x, pos_y }, ARGB2ABGR(col), wstr_utf8(text).c_str(), 0, wrap_width);
}
EXTERN_DLL_EXPORT void AddTriangle(ImDrawList* pDrawlist, float p1_x, float p1_y, float p2_x, float p2_y, float p3_x, float p3_y, ImU32 col, float thickness) {
	return pDrawlist->AddTriangle({ p1_x, p1_y }, { p2_x, p2_y }, { p3_x, p3_y }, col, thickness);
}
EXTERN_DLL_EXPORT void AddTriangleFilled(ImDrawList* pDrawlist, float p1_x, float p1_y, float p2_x, float p2_y, float p3_x, float p3_y, ImU32 col) {
	return pDrawlist->AddTriangleFilled({ p1_x, p1_y }, { p2_x, p2_y }, { p3_x, p3_y }, col);
}

EXTERN_DLL_EXPORT void PathClear(ImDrawList* pDrawlist) {
	return pDrawlist->PathClear();
}
EXTERN_DLL_EXPORT void PathLineTo(ImDrawList* pDrawlist, float pos_x, float pos_y) {
	return pDrawlist->PathLineTo({ pos_x, pos_y });
}
EXTERN_DLL_EXPORT void PathLineToMergeDuplicate(ImDrawList* pDrawlist, float pos_x, float pos_y) {
	return pDrawlist->PathLineToMergeDuplicate({ pos_x, pos_y });
}
EXTERN_DLL_EXPORT void PathFillConvex(ImDrawList* pDrawlist, ImU32 col) {
	return pDrawlist->PathFillConvex(ARGB2ABGR(col));
}
EXTERN_DLL_EXPORT void PathStroke(ImDrawList* pDrawlist, ImU32 col, boolean closed, float thickness) {
	return pDrawlist->PathStroke(ARGB2ABGR(col), closed, thickness);
}
EXTERN_DLL_EXPORT void PathArcTo(ImDrawList* pDrawlist, float center_x, float center_y, float radius, float a_min, float a_max, int num_segments) {
	return pDrawlist->PathArcTo({ center_x, center_y }, radius, a_min, a_max, num_segments);
}
EXTERN_DLL_EXPORT void PathArcToFast(ImDrawList* pDrawlist, float center_x, float center_y, float radius, int a_min_of_12, int a_max_of_12) {
	return pDrawlist->PathArcToFast({ center_x, center_y }, radius, a_min_of_12, a_max_of_12);
}
EXTERN_DLL_EXPORT void PathBezierCurveTo(ImDrawList* pDrawlist, float p2_x, float p2_y, float p3_x, float p3_y, float p4_x, float p4_y, int num_segments) {
	return pDrawlist->PathBezierCurveTo({ p2_x, p2_y }, { p3_x, p3_y }, { p4_x, p4_y }, num_segments);
}
EXTERN_DLL_EXPORT void PathRect(ImDrawList* pDrawlist, float rect_min_x, float rect_min_y, float rect_max_x, float rect_max_y, float rounding, ImDrawCornerFlags rounding_corners) {
	return pDrawlist->PathRect({ rect_min_x, rect_min_y }, { rect_max_x, rect_max_y }, rounding, rounding_corners);
}


EXTERN_DLL_EXPORT void* GetIO() {
    return &ImGui::GetIO();
}
EXTERN_DLL_EXPORT void* GetStyle() {
    return &ImGui::GetStyle();
}
EXTERN_DLL_EXPORT void SetStyleColor(ImGuiCol idx, ImU32 col) {
    ImGui::GetStyle().Colors[idx] = GetVec4Color(col);
}
EXTERN_DLL_EXPORT bool Selectable(const wchar_t* label, bool selected, ImGuiSelectableFlags flags, float size_arg_x, float size_arg_y){
	return ImGui::Selectable(wstr_utf8(label).c_str(), selected, flags, { size_arg_x, size_arg_y});
}
EXTERN_DLL_EXPORT void SetItemDefaultFocus( ){
	return ImGui::SetItemDefaultFocus();
}
EXTERN_DLL_EXPORT void Columns(int columns_count, const wchar_t* id, bool border){
	return ImGui::Columns(columns_count, wstr_utf8(id).c_str(), border);
}
EXTERN_DLL_EXPORT void NextColumn( ){
	return ImGui::NextColumn();
}
EXTERN_DLL_EXPORT int GetColumnIndex( ){
	return ImGui::GetColumnIndex();
}
EXTERN_DLL_EXPORT float GetColumnWidth(int column_index){
	return ImGui::GetColumnWidth(column_index);
}
EXTERN_DLL_EXPORT void SetColumnWidth(int column_index, float width){
	return ImGui::SetColumnWidth(column_index, width);
}
EXTERN_DLL_EXPORT float GetColumnOffset(int column_index){
	return ImGui::GetColumnOffset(column_index);
}
EXTERN_DLL_EXPORT void SetColumnOffset(int column_index, float offset){
	return ImGui::SetColumnOffset(column_index, offset);
}
EXTERN_DLL_EXPORT int GetColumnsCount( ){
	return ImGui::GetColumnsCount();
}

EXTERN_DLL_EXPORT bool DragFloat(const wchar_t* label, float* v, float v_speed, float v_min, float v_max, const wchar_t* format, float power){
    static float a = 5.f;
	return ImGui::DragFloat(wstr_utf8(label).c_str(), &a, v_speed, v_min, v_max, wstr_utf8(format).c_str(), power);
}
EXTERN_DLL_EXPORT bool DragInt(const wchar_t* label, int* v, float v_speed, int v_min, int v_max, const wchar_t* format){
	return ImGui::DragInt(wstr_utf8(label).c_str(), v, v_speed, v_min, v_max, wstr_utf8(format).c_str());
}
EXTERN_DLL_EXPORT bool SliderAngle(const wchar_t* label, float* v_rad, float v_degrees_min, float v_degrees_max, const wchar_t* format){
	return ImGui::SliderAngle(wstr_utf8(label).c_str(), v_rad, v_degrees_min, v_degrees_max, wstr_utf8(format).c_str());
}
EXTERN_DLL_EXPORT bool VSliderFloat(const wchar_t* label, float size_x, float size_y, float* v, float v_min, float v_max, const wchar_t* format, float power){
	return ImGui::VSliderFloat(wstr_utf8(label).c_str(), { size_x, size_y}, v, v_min, v_max, wstr_utf8(format).c_str(), power);
}
EXTERN_DLL_EXPORT bool VSliderInt(const wchar_t* label, float size_x, float size_y, int* v, int v_min, int v_max, const wchar_t* format){
	return ImGui::VSliderInt(wstr_utf8(label).c_str(), { size_x, size_y}, v, v_min, v_max, wstr_utf8(format).c_str());
}
EXTERN_DLL_EXPORT bool InputFloat(const wchar_t* label, float* v, float step, float step_fast, const wchar_t* format, ImGuiInputTextFlags flags){
	return ImGui::InputFloat(wstr_utf8(label).c_str(), v, step, step_fast, wstr_utf8(format).c_str(), flags);
}
EXTERN_DLL_EXPORT bool InputInt(const wchar_t* label, int* v, int step, int step_fast, ImGuiInputTextFlags flags){
	return ImGui::InputInt(wstr_utf8(label).c_str(), v, step, step_fast, flags);
}
EXTERN_DLL_EXPORT bool InputDouble(const wchar_t* label, double* v, double step, double step_fast, const wchar_t* format, ImGuiInputTextFlags flags){
	return ImGui::InputDouble(wstr_utf8(label).c_str(), v, step, step_fast, wstr_utf8(format).c_str(), flags);
}
EXTERN_DLL_EXPORT bool TreeNode(const wchar_t* label){
	return ImGui::TreeNode(wstr_utf8(label).c_str());
}
EXTERN_DLL_EXPORT bool TreeNodeEx(const wchar_t* label, ImGuiTreeNodeFlags flags){
	return ImGui::TreeNodeEx(wstr_utf8(label).c_str(), flags);
}
EXTERN_DLL_EXPORT void TreePush(const wchar_t* str_id){
	return ImGui::TreePush(wstr_utf8(str_id).c_str());
}
EXTERN_DLL_EXPORT void TreePop( ){
	return ImGui::TreePop();
}
EXTERN_DLL_EXPORT float GetTreeNodeToLabelSpacing( ){
	return ImGui::GetTreeNodeToLabelSpacing();
}
EXTERN_DLL_EXPORT bool CollapsingHeader(const wchar_t* label, ImGuiTreeNodeFlags flags){
	return ImGui::CollapsingHeader(wstr_utf8(label).c_str(), flags);
}
EXTERN_DLL_EXPORT bool CollapsingHeaderEx(const wchar_t* label, bool* p_open, ImGuiTreeNodeFlags flags){
	return ImGui::CollapsingHeader(wstr_utf8(label).c_str(), p_open, flags);
}
EXTERN_DLL_EXPORT void SetNextItemOpen(bool is_open, ImGuiCond cond){
	return ImGui::SetNextItemOpen(is_open, cond);
}
EXTERN_DLL_EXPORT bool ListBox(const wchar_t* label, int* current_item, wchar_t* items, int* items_count, int height_items){
    //ImGui::ListBox()
    int count = *items_count;
    int offset = 0;
    int total_len = 0;
    for (int i = 0; i < count; i++) total_len += items_count[i + 1];

    char** buffer = new char*[count];

    for (int i = 0; i < count; i++) {
        int t_len = items_count[i + 1];
        buffer[i] = new char[t_len];

        memcpy(buffer[i], wstr_utf8(&items[offset]).c_str(), t_len);
        offset += t_len;
    }

	bool result = ImGui::ListBox(wstr_utf8(label).c_str(), current_item, buffer, count, height_items);
	for(int i = 0; i < count; i++)
	{ 
		delete[] buffer[i];
	}
	delete[] buffer;
    return result;
}
EXTERN_DLL_EXPORT bool ListBoxHeader(const wchar_t* label, float size_arg_x, float size_arg_y){
	return ImGui::ListBoxHeader(wstr_utf8(label).c_str(), { size_arg_x, size_arg_y});
}
EXTERN_DLL_EXPORT bool ListBoxHeaderEx(const wchar_t* label, int items_count, int height_in_items){
	return ImGui::ListBoxHeader(wstr_utf8(label).c_str(), items_count, height_in_items);
}
EXTERN_DLL_EXPORT void ListBoxFooter( ){
	return ImGui::ListBoxFooter();
}
EXTERN_DLL_EXPORT void PlotLines(const wchar_t* label, const float* values, int values_count, int values_offset, const wchar_t* overlay_text, float scale_min, float scale_max, float graph_size_x, float graph_size_y, int stride){
	return ImGui::PlotLines((label == 0 ? 0 : wstr_utf8(label).c_str()), values, values_count, values_offset, (overlay_text == 0 ? 0 : wstr_utf8(overlay_text).c_str()), scale_min, scale_max, { graph_size_x, graph_size_y}, stride);
}
EXTERN_DLL_EXPORT void PlotHistogram(const wchar_t* label, const float* values, int values_count, int values_offset, const wchar_t* overlay_text, float scale_min, float scale_max, float graph_size_x, float graph_size_y, int stride){
	return ImGui::PlotHistogram((label == 0 ? 0 : wstr_utf8(label).c_str()), values, values_count, values_offset, (overlay_text == 0 ? 0 : wstr_utf8(overlay_text).c_str()), scale_min, scale_max, { graph_size_x, graph_size_y}, stride);
}

EXTERN_DLL_EXPORT void ValueBool(const wchar_t* prefix, bool b){
	return ImGui::Value((prefix == 0 ? 0 : wstr_utf8(prefix).c_str()), b);
}
EXTERN_DLL_EXPORT void ValueInt(const wchar_t* prefix, int v){
	return ImGui::Value((prefix == 0 ? 0 : wstr_utf8(prefix).c_str()), v);
}
EXTERN_DLL_EXPORT void ValueFloat(const wchar_t* prefix, float v, const wchar_t* float_format){
	return ImGui::Value((prefix == 0 ? 0 : wstr_utf8(prefix).c_str()), v, (float_format == 0 ? 0 : wstr_utf8(float_format).c_str()));
}
EXTERN_DLL_EXPORT bool BeginMenuBar( ){
	return ImGui::BeginMenuBar();
}
EXTERN_DLL_EXPORT void EndMenuBar( ){
	return ImGui::EndMenuBar();
}
EXTERN_DLL_EXPORT bool BeginMainMenuBar( ){
	return ImGui::BeginMainMenuBar();
}
EXTERN_DLL_EXPORT void EndMainMenuBar( ){
	return ImGui::EndMainMenuBar();
}
EXTERN_DLL_EXPORT bool BeginMenu(const wchar_t* label, bool enabled){
	return ImGui::BeginMenu((label == 0 ? 0 : wstr_utf8(label).c_str()), enabled);
}
EXTERN_DLL_EXPORT void EndMenu_( ){
	return ImGui::EndMenu();
}
EXTERN_DLL_EXPORT bool MenuItem(const wchar_t* label, const wchar_t* shortcut, bool selected, bool enabled){
	return ImGui::MenuItem((label == 0 ? 0 : wstr_utf8(label).c_str()), (shortcut == 0 ? 0 : wstr_utf8(shortcut).c_str()), selected, enabled);
}
EXTERN_DLL_EXPORT bool MenuItemEx(const wchar_t* label, const wchar_t* shortcut, bool* p_selected, bool enabled){
	return ImGui::MenuItem((label == 0 ? 0 : wstr_utf8(label).c_str()), (shortcut == 0 ? 0 : wstr_utf8(shortcut).c_str()), p_selected, enabled);
}
EXTERN_DLL_EXPORT void BeginTooltip( ){
	return ImGui::BeginTooltip();
}
EXTERN_DLL_EXPORT void EndTooltip( ){
	return ImGui::EndTooltip();
}
EXTERN_DLL_EXPORT void SetTooltip(const wchar_t* text){
	return ImGui::SetTooltip((text == 0 ? 0 : wstr_utf8(text).c_str()));
}
EXTERN_DLL_EXPORT bool BeginPopup(const wchar_t* str_id, ImGuiWindowFlags flags){
	return ImGui::BeginPopup((str_id == 0 ? 0 : wstr_utf8(str_id).c_str()), flags);
}
EXTERN_DLL_EXPORT bool BeginPopupModal(const wchar_t* name, bool* p_open, ImGuiWindowFlags flags){
	return ImGui::BeginPopupModal((name == 0 ? 0 : wstr_utf8(name).c_str()), p_open, flags);
}
EXTERN_DLL_EXPORT void EndPopup( ){
	return ImGui::EndPopup();
}
EXTERN_DLL_EXPORT void OpenPopup(const wchar_t* str_id, ImGuiPopupFlags popup_flags){
	return ImGui::OpenPopup((str_id == 0 ? 0 : wstr_utf8(str_id).c_str()), popup_flags);
}
EXTERN_DLL_EXPORT void OpenPopupContextItem(const wchar_t* str_id, ImGuiPopupFlags popup_flags){
	ImGui::OpenPopupContextItem((str_id == 0 ? 0 : wstr_utf8(str_id).c_str()), popup_flags);
}
EXTERN_DLL_EXPORT void CloseCurrentPopup( ){
	return ImGui::CloseCurrentPopup();
}
EXTERN_DLL_EXPORT bool BeginPopupContextItem(const wchar_t* str_id, ImGuiPopupFlags popup_flags){
	return ImGui::BeginPopupContextItem((str_id == 0 ? 0 : wstr_utf8(str_id).c_str()), popup_flags);
}
EXTERN_DLL_EXPORT bool BeginPopupContextWindow(const wchar_t* str_id, ImGuiPopupFlags popup_flags){
	return ImGui::BeginPopupContextWindow((str_id == 0 ? 0 : wstr_utf8(str_id).c_str()), popup_flags);
}
EXTERN_DLL_EXPORT bool BeginPopupContextVoid(const wchar_t* str_id, ImGuiPopupFlags popup_flags){
	return ImGui::BeginPopupContextVoid((str_id == 0 ? 0 : wstr_utf8(str_id).c_str()), popup_flags);
}
EXTERN_DLL_EXPORT bool IsPopupOpen(const wchar_t* str_id, ImGuiPopupFlags popup_flags){
	return ImGui::IsPopupOpen((str_id == 0 ? 0 : wstr_utf8(str_id).c_str()), popup_flags);
}
EXTERN_DLL_EXPORT bool BeginTabBar(const wchar_t* str_id, ImGuiTabBarFlags flags){
	return ImGui::BeginTabBar((str_id == 0 ? 0 : wstr_utf8(str_id).c_str()), flags);
}
EXTERN_DLL_EXPORT void EndTabBar( ){
	return ImGui::EndTabBar();
}
EXTERN_DLL_EXPORT bool BeginTabItem(const wchar_t* label, bool* p_open, ImGuiTabItemFlags flags){
	return ImGui::BeginTabItem((label == 0 ? 0 : wstr_utf8(label).c_str()), p_open, flags);
}
EXTERN_DLL_EXPORT void EndTabItem( ){
	return ImGui::EndTabItem();
}
EXTERN_DLL_EXPORT void SetTabItemClosed(const wchar_t* label){
	return ImGui::SetTabItemClosed((label == 0 ? 0 : wstr_utf8(label).c_str()));
}
EXTERN_DLL_EXPORT void DockSpace(ImGuiID id, float size_arg_x, float size_arg_y, ImGuiDockNodeFlags flags){
	ImGui::DockSpace(id, { size_arg_x, size_arg_y}, flags);
}
EXTERN_DLL_EXPORT ImGuiID DockSpaceOverViewport(ImGuiViewport* viewport, ImGuiDockNodeFlags dockspace_flags){
	return ImGui::DockSpaceOverViewport(viewport, dockspace_flags);
}
EXTERN_DLL_EXPORT void SetNextWindowDockID(ImGuiID id, ImGuiCond cond){
	return ImGui::SetNextWindowDockID(id, cond);
}
EXTERN_DLL_EXPORT void SetNextWindowClass(ImGuiWindowClass* window_class){
	return ImGui::SetNextWindowClass(window_class);
}
EXTERN_DLL_EXPORT ImGuiID GetWindowDockID( ){
	return ImGui::GetWindowDockID();
}
EXTERN_DLL_EXPORT bool IsWindowDocked( ){
	return ImGui::IsWindowDocked();
}
EXTERN_DLL_EXPORT bool BeginDragDropSource(ImGuiDragDropFlags flags){
	return ImGui::BeginDragDropSource(flags);
}
EXTERN_DLL_EXPORT void PushClipRect(float clip_rect_min_x, float clip_rect_min_y, float clip_rect_max_x, float clip_rect_max_y, boolean intersect_with_current_clip_rect){
	return ImGui::PushClipRect({ clip_rect_min_x, clip_rect_min_y}, { clip_rect_max_x, clip_rect_max_y}, intersect_with_current_clip_rect);
}
EXTERN_DLL_EXPORT void PopClipRect( ){
	return ImGui::PopClipRect();
}
EXTERN_DLL_EXPORT void SetKeyboardFocusHere(int offset){
	return ImGui::SetKeyboardFocusHere(offset);
}
EXTERN_DLL_EXPORT bool IsItemHovered(ImGuiHoveredFlags flags){
	return ImGui::IsItemHovered(flags);
}
EXTERN_DLL_EXPORT bool IsItemActive( ){
	return ImGui::IsItemActive();
}
EXTERN_DLL_EXPORT bool IsItemFocused( ){
	return ImGui::IsItemFocused();
}
EXTERN_DLL_EXPORT bool IsItemVisible( ){
	return ImGui::IsItemVisible();
}
EXTERN_DLL_EXPORT bool IsItemEdited( ){
	return ImGui::IsItemEdited();
}
EXTERN_DLL_EXPORT bool IsItemActivated( ){
	return ImGui::IsItemActivated();
}
EXTERN_DLL_EXPORT bool IsItemDeactivated( ){
	return ImGui::IsItemDeactivated();
}
EXTERN_DLL_EXPORT bool IsItemDeactivatedAfterEdit( ){
	return ImGui::IsItemDeactivatedAfterEdit();
}
EXTERN_DLL_EXPORT bool IsItemToggledOpen( ){
	return ImGui::IsItemToggledOpen();
}
EXTERN_DLL_EXPORT bool IsAnyItemHovered( ){
	return ImGui::IsAnyItemHovered();
}
EXTERN_DLL_EXPORT bool IsAnyItemActive( ){
	return ImGui::IsAnyItemActive();
}
EXTERN_DLL_EXPORT bool IsAnyItemFocused( ){
	return ImGui::IsAnyItemFocused();
}
EXTERN_DLL_EXPORT void SetItemAllowOverlap( ){
	return ImGui::SetItemAllowOverlap();
}
EXTERN_DLL_EXPORT bool IsItemClicked(ImGuiMouseButton mouse_button){
	return ImGui::IsItemClicked(mouse_button);
}
EXTERN_DLL_EXPORT bool IsRectVisible(float size_x, float size_y){
	return ImGui::IsRectVisible({ size_x, size_y});
}
EXTERN_DLL_EXPORT bool IsRectVisibleEx(float rect_min_x, float rect_min_y, float rect_max_x, float rect_max_y){
	return ImGui::IsRectVisible({ rect_min_x, rect_min_y}, { rect_max_x, rect_max_y});
}
EXTERN_DLL_EXPORT double GetTime( ){
	return ImGui::GetTime();
}
EXTERN_DLL_EXPORT int GetFrameCount( ){
	return ImGui::GetFrameCount();
}EXTERN_DLL_EXPORT bool BeginChildFrame(ImGuiID id, float size_x, float size_y, ImGuiWindowFlags extra_flags){
	return ImGui::BeginChildFrame(id, { size_x, size_y}, extra_flags);
}
EXTERN_DLL_EXPORT void EndChildFrame( ){
	return ImGui::EndChildFrame();
}
EXTERN_DLL_EXPORT void CalcTextSize(const wchar_t* text, boolean hide_text_after_double_hash, float wrap_width, float*x, float*y){
	ImVec2 size = ImGui::CalcTextSize((text == 0 ? 0 : wstr_utf8(text).c_str()), 0, hide_text_after_double_hash, wrap_width);
    *x = size.x; *y = size.y;
}
EXTERN_DLL_EXPORT int GetKeyIndex(ImGuiKey imgui_key){
	return ImGui::GetKeyIndex(imgui_key);
}
EXTERN_DLL_EXPORT bool IsKeyDown(int user_key_index){
	return ImGui::IsKeyDown(user_key_index);
}
EXTERN_DLL_EXPORT bool IsKeyPressed(int user_key_index, boolean repeat){
	return ImGui::IsKeyPressed(user_key_index, repeat);
}
EXTERN_DLL_EXPORT bool IsKeyReleased(int user_key_index){
	return ImGui::IsKeyReleased(user_key_index);
}
EXTERN_DLL_EXPORT int GetKeyPressedAmount(int key_index, float repeat_delay, float repeat_rate){
	return ImGui::GetKeyPressedAmount(key_index, repeat_delay, repeat_rate);
}
EXTERN_DLL_EXPORT void CaptureKeyboardFromApp(boolean capture){
	return ImGui::CaptureKeyboardFromApp(capture);
}
EXTERN_DLL_EXPORT bool IsMouseDown(ImGuiMouseButton button){
	return ImGui::IsMouseDown(button);
}
EXTERN_DLL_EXPORT bool IsMouseClicked(ImGuiMouseButton button, boolean repeat){
	return ImGui::IsMouseClicked(button, repeat);
}
EXTERN_DLL_EXPORT bool IsMouseReleased(ImGuiMouseButton button){
	return ImGui::IsMouseReleased(button);
}
EXTERN_DLL_EXPORT bool IsMouseHoveringRect(float r_min_x, float r_min_y, float r_max_x, float r_max_y, boolean clip){
	return ImGui::IsMouseHoveringRect({ r_min_x, r_min_y}, { r_max_x, r_max_y}, clip);
}
EXTERN_DLL_EXPORT bool IsMousePosValid( ){
	return ImGui::IsMousePosValid();
}
EXTERN_DLL_EXPORT bool IsAnyMouseDown( ){
	return ImGui::IsAnyMouseDown();
}
EXTERN_DLL_EXPORT bool IsMouseDragging(ImGuiMouseButton button, float lock_threshold){
	return ImGui::IsMouseDragging(button, lock_threshold);
}
EXTERN_DLL_EXPORT void ResetMouseDragDelta(ImGuiMouseButton button){
	return ImGui::ResetMouseDragDelta(button);
}
EXTERN_DLL_EXPORT ImGuiMouseCursor GetMouseCursor( ){
	return ImGui::GetMouseCursor();
}
EXTERN_DLL_EXPORT void SetMouseCursor(ImGuiMouseCursor cursor_type){
	return ImGui::SetMouseCursor(cursor_type);
}
EXTERN_DLL_EXPORT void CaptureMouseFromApp(boolean capture){
	return ImGui::CaptureMouseFromApp(capture);
}
EXTERN_DLL_EXPORT void LoadIniSettingsFromDisk(const wchar_t* ini_filename){
	return ImGui::LoadIniSettingsFromDisk((ini_filename == 0 ? 0 : wstr_utf8(ini_filename).c_str()));
}
EXTERN_DLL_EXPORT void SaveIniSettingsToDisk(const wchar_t* ini_filename){
	return ImGui::SaveIniSettingsToDisk((ini_filename == 0 ? 0 : wstr_utf8(ini_filename).c_str()));
}
EXTERN_DLL_EXPORT ImGuiViewport* GetMainViewport( ){
	return ImGui::GetMainViewport();
}
EXTERN_DLL_EXPORT void UpdatePlatformWindows( ){
	return ImGui::UpdatePlatformWindows();
}
EXTERN_DLL_EXPORT void RenderPlatformWindowsDefault(void* platform_render_arg, void* renderer_render_arg){
	return ImGui::RenderPlatformWindowsDefault(platform_render_arg, renderer_render_arg);
}
EXTERN_DLL_EXPORT void DestroyPlatformWindows( ){
	return ImGui::DestroyPlatformWindows();
}

EXTERN_DLL_EXPORT ImTextureID ImageFromURL(const char* url) {
	return DownloadImage(url);
}

std::map<std::wstring, ImTextureID> MapImageFromFile;
EXTERN_DLL_EXPORT ImTextureID ImageFromFile(const wchar_t* path) {

	auto find = MapImageFromFile.find(path);
	if ( find == MapImageFromFile.end()) {
		ID3D11ShaderResourceView* texture;
		HRESULT result2;
		HRESULT result1 = D3DX11CreateShaderResourceViewFromFileW(g_pd3dDevice, path, NULL, NULL, &texture, &result2);
		ImTextureID tid = texture;

		if (result1 != S_OK) return 0;

		MapImageFromFile[path] = tid;
		return tid;
	}
	else {
		return find->second;
	}
}EXTERN_DLL_EXPORT ImGuiViewport* GetWindowViewport( ){
	return ImGui::GetWindowViewport();
}
EXTERN_DLL_EXPORT float GetWindowDpiScale( ){
	return ImGui::GetWindowDpiScale();
}
EXTERN_DLL_EXPORT float GetWindowWidth( ){
	return ImGui::GetWindowWidth();
}
EXTERN_DLL_EXPORT float GetWindowHeight( ){
	return ImGui::GetWindowHeight();
}
EXTERN_DLL_EXPORT bool DragFloatN(int n, const wchar_t* label, float* v, float v_speed, float v_min, float v_max, const wchar_t* format, float power){
	switch (n) {
	case 2:
		return ImGui::DragFloat2(wstr_utf8(label).c_str(), v, v_speed, v_min, v_max, wstr_utf8(format).c_str(), power);
	case 3:
		return ImGui::DragFloat3(wstr_utf8(label).c_str(), v, v_speed, v_min, v_max, wstr_utf8(format).c_str(), power);
	case 4:
		return ImGui::DragFloat4(wstr_utf8(label).c_str(), v, v_speed, v_min, v_max, wstr_utf8(format).c_str(), power);
	}
	return false;
}
EXTERN_DLL_EXPORT bool DragFloatRange2(const wchar_t* label, float* v_current_min, float* v_current_max, float v_speed, float v_min, float v_max, const wchar_t* format, const wchar_t* format_max, float power){
	return ImGui::DragFloatRange2((label == 0 ? 0 : wstr_utf8(label).c_str()), v_current_min, v_current_max, v_speed, v_min, v_max, (format == 0 ? 0 : wstr_utf8(format).c_str()), (format_max == 0 ? 0 : wstr_utf8(format_max).c_str()), power);
}

EXTERN_DLL_EXPORT bool DragIntN(int n, const wchar_t* label, int* v, float v_speed, int v_min, int v_max, const wchar_t* format) {
	switch (n) {
	case 2:
		return ImGui::DragInt2(wstr_utf8(label).c_str(), v, v_speed, v_min, v_max, wstr_utf8(format).c_str());
	case 3:
		return ImGui::DragInt3(wstr_utf8(label).c_str(), v, v_speed, v_min, v_max, wstr_utf8(format).c_str());
	case 4:
		return ImGui::DragInt4(wstr_utf8(label).c_str(), v, v_speed, v_min, v_max, wstr_utf8(format).c_str());
	}
	return false;
}
EXTERN_DLL_EXPORT bool DragIntRange2(const wchar_t* label, int* v_current_min, int* v_current_max, float v_speed, int v_min, int v_max, const wchar_t* format, const wchar_t* format_max){
	return ImGui::DragIntRange2((label == 0 ? 0 : wstr_utf8(label).c_str()), v_current_min, v_current_max, v_speed, v_min, v_max, (format == 0 ? 0 : wstr_utf8(format).c_str()), (format_max == 0 ? 0 : wstr_utf8(format_max).c_str()));
}

EXTERN_DLL_EXPORT bool SliderFloatN(int n, const wchar_t* label, float* v, float v_min, float v_max, const wchar_t* format, float power) {
	switch (n) {
	case 2:
		return ImGui::SliderFloat2(wstr_utf8(label).c_str(), v, v_min, v_max, wstr_utf8(format).c_str(), power);
	case 3:
		return ImGui::SliderFloat3(wstr_utf8(label).c_str(), v, v_min, v_max, wstr_utf8(format).c_str(), power);
	case 4:
		return ImGui::SliderFloat4(wstr_utf8(label).c_str(), v, v_min, v_max, wstr_utf8(format).c_str(), power);
	}
	return false;
}

EXTERN_DLL_EXPORT bool SliderInt(const wchar_t* label, int* v, int v_min, int v_max, const wchar_t* format) {
	return ImGui::SliderInt(wstr_utf8(label).c_str(), v, v_min, v_max, wstr_utf8(format).c_str());
}
EXTERN_DLL_EXPORT bool SliderIntN(int n, const wchar_t* label, int* v, int v_min, int v_max, const wchar_t* format) {
	switch (n) {
	case 2:
		return ImGui::SliderInt2(wstr_utf8(label).c_str(), v, v_min, v_max, wstr_utf8(format).c_str());
	case 3:
		return ImGui::SliderInt3(wstr_utf8(label).c_str(), v, v_min, v_max, wstr_utf8(format).c_str());
	case 4:
		return ImGui::SliderInt4(wstr_utf8(label).c_str(), v, v_min, v_max, wstr_utf8(format).c_str());
	}
	return false;
}




EXTERN_DLL_EXPORT bool InputFloatN(int n, const wchar_t* label, float* v, const wchar_t* format, ImGuiInputTextFlags flags) {
	switch (n) {
	case 2:
		return ImGui::InputFloat2(wstr_utf8(label).c_str(), v, wstr_utf8(format).c_str(), flags);
	case 3:
		return ImGui::InputFloat3(wstr_utf8(label).c_str(), v, wstr_utf8(format).c_str(), flags);
	case 4:
		return ImGui::InputFloat4(wstr_utf8(label).c_str(), v, wstr_utf8(format).c_str(), flags);
	}
	return false;
}

EXTERN_DLL_EXPORT bool InputIntN(int n, const wchar_t* label, int* v, ImGuiInputTextFlags flags) {
	switch (n) {
	case 2:
		return ImGui::InputInt2(wstr_utf8(label).c_str(), v, flags);
	case 3:
		return ImGui::InputInt3(wstr_utf8(label).c_str(), v, flags);
	case 4:
		return ImGui::InputInt4(wstr_utf8(label).c_str(), v, flags);
	}
	return false;
}


EXTERN_DLL_EXPORT bool ColorEdit(const wchar_t *label, ImU32* color, ImGuiColorEditFlags flags){
	ImVec4 col = GetVec4Color(*color);
	bool result = ImGui::ColorEdit4(wstr_utf8(label).c_str(), (float*)&col, flags);
	*color = ImColor(col);;
	return result;
}
EXTERN_DLL_EXPORT bool ColorPicker(const wchar_t *label, ImU32* color, ImGuiColorEditFlags flags){
	//ImVec4 col = GetVec4Color(*color);
	ImVec4 col = ImGui::ColorConvertU32ToFloat4(*color);
	bool result = ImGui::ColorPicker4(wstr_utf8(label).c_str(), (float*)&col, flags);
	*color = ImColor(col);
	return result;
}EXTERN_DLL_EXPORT float GetCursorPosX( ){
	return ImGui::GetCursorPosX();
}
EXTERN_DLL_EXPORT float GetCursorPosY( ){
	return ImGui::GetCursorPosY();
}
EXTERN_DLL_EXPORT void SetCursorPosX(float x){
	return ImGui::SetCursorPosX(x);
}
EXTERN_DLL_EXPORT void SetCursorPosY(float y){
	return ImGui::SetCursorPosY(y);
}


void back_func(int a, int b)
{
	std::cout << a << b << std::endl;
}
typedef void(*FUC)(int a, int b);
typedef struct FUNC_STRUCT
{
	int b;
	int c;
	FUC f;
}FUNC_STRUCT;

FUNC_STRUCT g_f = {1, 2, back_func};
EXTERN_DLL_EXPORT FUNC_STRUCT *LoadFont(wchar_t* font_path, float font_size)
{
	g_f =
	{
		10,
		15,
		back_func
	};
	std::string s = "heont";
	if (s == "")
	{
		return NULL;
	}
	std::cout << font_path << "  " << font_size << std::endl;
	std::cout << &g_f << std::endl;
	std::cout << g_f.f << std::endl;
	return &g_f;
}


// Simple helper function to load an image into a DX11 texture with common settings
EXTERN_DLL_EXPORT bool LoadTextureFromFile(const wchar_t* filename, ID3D11ShaderResourceView** out_srv, int* out_width, int* out_height)
{
    // Load from disk into a raw RGBA buffer
    int image_width = 0;
    int image_height = 0;
    unsigned char* image_data = stbi_load(wstr_utf8(filename).c_str(), &image_width, &image_height, NULL, 4);
    if (image_data == NULL)
        return false;

    // Create texture
    D3D11_TEXTURE2D_DESC desc;
    ZeroMemory(&desc, sizeof(desc));
    desc.Width = image_width;
    desc.Height = image_height;
    desc.MipLevels = 1;
    desc.ArraySize = 1;
    desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    desc.SampleDesc.Count = 1;
    desc.Usage = D3D11_USAGE_DEFAULT;
    desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
    desc.CPUAccessFlags = 0;

    ID3D11Texture2D *pTexture = NULL;
    D3D11_SUBRESOURCE_DATA subResource;
    subResource.pSysMem = image_data;
    subResource.SysMemPitch = desc.Width * 4;
    subResource.SysMemSlicePitch = 0;
    g_pd3dDevice->CreateTexture2D(&desc, &subResource, &pTexture);

    // Create texture view
    D3D11_SHADER_RESOURCE_VIEW_DESC srvDesc;
    ZeroMemory(&srvDesc, sizeof(srvDesc));
    srvDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    srvDesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
    srvDesc.Texture2D.MipLevels = desc.MipLevels;
    srvDesc.Texture2D.MostDetailedMip = 0;
    g_pd3dDevice->CreateShaderResourceView(pTexture, &srvDesc, out_srv);
    pTexture->Release();

    *out_width = image_width;
    *out_height = image_height;
    stbi_image_free(image_data);

    return true;
}

// Simple helper function to load an image into a DX11 texture with common settings
EXTERN_DLL_EXPORT bool LoadTextureFromMemory(unsigned char* buf, int buf_size, ID3D11ShaderResourceView** out_srv, int* out_width, int* out_height)
{
    // Load from disk into a raw RGBA buffer
    int image_width = 0;
    int image_height = 0;
    unsigned char* image_data = stbi_load_from_memory(buf, buf_size, &image_width, &image_height, NULL, 4);
    if (image_data == NULL)
        return false;

    // Create texture
    D3D11_TEXTURE2D_DESC desc;
    ZeroMemory(&desc, sizeof(desc));
    desc.Width = image_width;
    desc.Height = image_height;
    desc.MipLevels = 1;
    desc.ArraySize = 1;
    desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    desc.SampleDesc.Count = 1;
    desc.Usage = D3D11_USAGE_DEFAULT;
    desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
    desc.CPUAccessFlags = 0;

    ID3D11Texture2D *pTexture = NULL;
    D3D11_SUBRESOURCE_DATA subResource;
    subResource.pSysMem = image_data;
    subResource.SysMemPitch = desc.Width * 4;
    subResource.SysMemSlicePitch = 0;
    g_pd3dDevice->CreateTexture2D(&desc, &subResource, &pTexture);

    // Create texture view
    D3D11_SHADER_RESOURCE_VIEW_DESC srvDesc;
    ZeroMemory(&srvDesc, sizeof(srvDesc));
    srvDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    srvDesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
    srvDesc.Texture2D.MipLevels = desc.MipLevels;
    srvDesc.Texture2D.MostDetailedMip = 0;
    g_pd3dDevice->CreateShaderResourceView(pTexture, &srvDesc, out_srv);
    pTexture->Release();

    *out_width = image_width;
    *out_height = image_height;
    stbi_image_free(image_data);

    return true;
}

EXTERN_DLL_EXPORT bool TextureFree(ID3D11ShaderResourceView *p)
{
	if(p)
		p->Release();
	return true;
}

EXTERN_DLL_EXPORT  FILE *imgui_stbi__fopen(wchar_t const *filename, wchar_t const *mode)
{
	return stbi__fopen(wstr_utf8(filename).c_str(), wstr_utf8(mode).c_str());
}

EXTERN_DLL_EXPORT void imgui_stbi__start_file(stbi__context* s, FILE* f)
{
	std::cout << sizeof(stbi__context) << std::endl;
	stbi__start_file(s, f);
}

EXTERN_DLL_EXPORT bool imgui_stbi__gif_load_next(stbi__context *s,ID3D11ShaderResourceView** out_srv, int req_comp, int* out_width, int* out_height)
{
	stbi__gif g = {};
	memset(&g, 0, sizeof(g));
	int c;
	stbi__result_info gg = {};
	unsigned char* image_data = stbi__gif_load_next(s, &g, &c, req_comp, NULL);
    *out_width = g.h;
    *out_height = g.w;
	
	//unsigned char* image_data = (unsigned char *)stbi__gif_load(s, out_width, out_height, &c, req_comp, &gg);


    if (image_data == NULL)
        return false;

    // Create texture
    D3D11_TEXTURE2D_DESC desc;
    ZeroMemory(&desc, sizeof(desc));
    desc.Width = *out_width;
    desc.Height = *out_height;
    desc.MipLevels = 1;
    desc.ArraySize = 1;
    desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    desc.SampleDesc.Count = 1;
    desc.Usage = D3D11_USAGE_DEFAULT;
    desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
    desc.CPUAccessFlags = 0;

    ID3D11Texture2D *pTexture = NULL;
    D3D11_SUBRESOURCE_DATA subResource;
    subResource.pSysMem = image_data;
    subResource.SysMemPitch = desc.Width * 4;
    subResource.SysMemSlicePitch = 0;
    g_pd3dDevice->CreateTexture2D(&desc, &subResource, &pTexture);

    // Create texture view
    D3D11_SHADER_RESOURCE_VIEW_DESC srvDesc;
    ZeroMemory(&srvDesc, sizeof(srvDesc));
    srvDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    srvDesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
    srvDesc.Texture2D.MipLevels = desc.MipLevels;
    srvDesc.Texture2D.MostDetailedMip = 0;
    g_pd3dDevice->CreateShaderResourceView(pTexture, &srvDesc, out_srv);
    pTexture->Release();

    stbi_image_free(image_data);

    return true;
}

EXTERN_DLL_EXPORT  bool imgui_stbi__load_gif(wchar_t  *filename, ID3D11ShaderResourceView* out_srv_array[1024], int *length_array, int *out_w, int *out_h, int *out_delay)
{
	int index = 0;
	*length_array = 0;
	int req_comp = 4;
	int c = 4;
	stbgif_data out_gif_data{};
	ID3D11ShaderResourceView* out_srv = nullptr;
	stbgif__context *s = new stbgif__context;
	ZeroMemory(s, sizeof(stbgif__context));
	stbi__result_info gg = {};
	int** delays = NULL;
	if (stbgif_test(s))
		std::cout << " error" << std::endl;
	unsigned char* image_data = NULL;

	FILE *f = stbgif__fopen(wstr_utf8(filename).c_str(), "rb");

	stbgif__start_file(s, f);
	bool is_set_data = false;


	D3D11_TEXTURE2D_DESC desc{};
	D3D11_SHADER_RESOURCE_VIEW_DESC srvDesc{};

	ID3D11Texture2D *pTexture = NULL;
	D3D11_SUBRESOURCE_DATA subResource{};
	while (image_data = stbgif__load_next(s, &out_gif_data, &c, req_comp, NULL))
	{
		if (image_data == (stbgif_uc*)s)
		{
			image_data = 0;
			break;
		}
         image_data = stbgif__convert_format(image_data, 4, req_comp, out_gif_data.w, out_gif_data.h);
		if (!is_set_data)
		{
			*out_w = out_gif_data.w;
			*out_h = out_gif_data.h;
			*out_delay = out_gif_data.delay;
			is_set_data = true;
		}
		// Create texture
		ZeroMemory(&desc, sizeof(desc));
		desc.Width = out_gif_data.w;
		desc.Height = out_gif_data.h;
		desc.MipLevels = 1;
		desc.ArraySize = 1;
		desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
		desc.SampleDesc.Count = 1;
		desc.Usage = D3D11_USAGE_DEFAULT;
		desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
		desc.CPUAccessFlags = 0;
		desc.MiscFlags = 0;

		pTexture = NULL;
		ZeroMemory(&subResource, sizeof(subResource));
		subResource.pSysMem = image_data;
		subResource.SysMemPitch = desc.Width * 4;
		subResource.SysMemSlicePitch = 0;
		g_pd3dDevice->CreateTexture2D(&desc, &subResource, &pTexture);

	// Create texture view
		ZeroMemory(&srvDesc, sizeof(srvDesc));
		srvDesc.Format = desc.Format;
		srvDesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
		srvDesc.Texture2D.MipLevels = desc.MipLevels;
		srvDesc.Texture2D.MostDetailedMip = 0;
		g_pd3dDevice->CreateShaderResourceView(pTexture, &srvDesc, &out_srv);
		out_srv_array[index] = out_srv;
		index++;
		if(pTexture != NULL)
			pTexture->Release();

		//stbgif_image_free(image_data);
	}
	if (s != nullptr)
		delete s;
	*length_array = index;
	return true;

}

EXTERN_DLL_EXPORT  bool imgui_get_custom_font_range_from_string(wchar_t* str, int *out, int *out_length, wchar_t *buff)
{
	ImVector<ImWchar> myRange;
	ImFontGlyphRangesBuilder myGlyph;

	myGlyph.AddText(wstr_utf8(str).c_str());
	myGlyph.BuildRanges(&myRange);

	int i = 0;
	while (myRange.Data[i] != 0)
	{
		out[i] = myRange.Data[i];
		i++;
	}
	out[i] = myRange.Data[i];
	wcscpy(buff, (wchar_t *)myRange.Data);
	*out_length = i;
	return true;
}

EXTERN_DLL_EXPORT  bool imgui_get_custom_font_range(wchar_t* filename, int *out, int *out_length, wchar_t *buff)
{
	FILE *inFile = stbgif__fopen(wstr_utf8(filename).c_str(), "rb");

   if (inFile == 0)
	   return false;

	unsigned char *charBuf;

	fseek(inFile, 0, SEEK_END);
	int fileLen = ftell(inFile);
	charBuf = new unsigned char[fileLen];
	fseek(inFile, 0, SEEK_SET);
	fread(charBuf, fileLen, 1, inFile);

	fclose(inFile);

	ImVector<ImWchar> myRange;
	ImFontGlyphRangesBuilder myGlyph;

	myGlyph.AddText((const char*)charBuf);
	myGlyph.BuildRanges(&myRange);

	delete[] charBuf;
	int i = 0;
	while (myRange.Data[i] != 0)
	{
		out[i] = myRange.Data[i];
		i++;
	}
	out[i] = myRange.Data[i];
	wcscpy(buff, (wchar_t *)myRange.Data);
	*out_length = i;
	return true;
}




EXTERN_DLL_EXPORT  bool imgui_dll_test(float *f, int *i, double *d)
{
	std::cout << *f << std::endl;
	std::cout << *i << std::endl;
	std::cout << *d << std::endl;
	*f = 9.12345;
	*i = 99;
	*d = 99.12345;
	return true;
}
