#include <Windowsconstants.au3>
#include <WinAPI.au3>
#include "imgui.au3"


_ImGui_EnableViewports()

Local $hwnd = _ImGui_GUICreate("Example multiple viewports - Hide main window", 1, 1, -100, -100, 0, $WS_EX_TOOLWINDOW)
_WinAPI_ShowWindow($hwnd)

_ImGui_StyleColorsLight()

Local $io = _ImGui_GetIO()
$io.ConfigWindowsMoveFromTitleBarOnly = True ; // Only drag window by title bar

Local $is_first_run = True

While 1

	if Not _ImGui_PeekMsg() Then Exit

	_ImGui_BeginFrame()

	If Not _ImGui_Begin("Test", True, $ImGuiWindowFlags_NoCollapse) Then Exit

	If $is_first_run Then
		$is_first_run = False
		Local $win_size[] = [800, 600]
		Local $win_pos_x = (@DesktopWidth - $win_size[0]) / 2
		Local $win_pos_y = (@DesktopHeight - $win_size[1]) / 2
		_ImGui_SetWindowPos($win_pos_x, $win_pos_y)
		_ImGui_SetWindowSize($win_size[0], $win_size[1])
	EndIf

  	_ImGui_Text("Hello")
	_ImGui_End()

	_ImGui_EndFrame()
Wend
