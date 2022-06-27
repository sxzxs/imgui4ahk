
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include "imgui.au3"


;_ImGui_EnableViewports()
$hwnd = _ImGui_GUICreate("AutoIt ImGui", 1024, 768)
_WinAPI_ShowWindow($hwnd)
;~ GUISetState(@SW_SHOW, $Hwnd)

_ImGui_StyleColorsLight()

$io = _ImGui_GetIO()
$imstyle = _ImGui_GetStyle()

_ImGui_SetWindowTitleAlign(0.5, 0.5)
_ImGui_EnableDocking()


Local $i_list_view = 0
Local $i_radio_theme = 0
Local $f_slider = 5
Local $label_radio_theme[] = ["Light", "Dark", "Classic"]

Local $list_box_items[] = ["aaaa","bbbb","cccc"]
Local $i_list_box = 0


Local $username = ""
Local $password = ""
Local $str_status = ""
Local $b_show_demo_window = False
Local $b_show_another_window = False


While 1

	; when the user click close button on the window, this will return false
	if Not _ImGui_PeekMsg() Then Exit

	; must call
	_ImGui_BeginFrame()

	; Begin a new window
	_ImGui_Begin("Demo ImGui-AutoIt")

	_ImGui_Text("Chọn theme")

    _imgui_PushItemWidth(_imgui_GetFontSize() * -12)
	; Put next item to the same line (don't line break)
	_ImGui_SameLine();

	Local $old_theme = $i_radio_theme
	_ImGui_RadioButton("Light", $i_radio_theme, 0)
	_ImGui_SameLine();
	_ImGui_RadioButton("Dark", $i_radio_theme, 1)
	_ImGui_SameLine();
	_ImGui_RadioButton("Classic", $i_radio_theme, 2)
	_ImGui_SameLine();


	if _ImGui_BeginCombo("##combo_theme", $label_radio_theme[$i_radio_theme]) Then

		for $i = 0 To UBound($label_radio_theme) - 1

			Local $selected = ($i_radio_theme == $i) ; if $i_radio_theme = $i then $selected = True
			if _ImGui_Selectable($label_radio_theme[$i], $selected) Then
				$i_radio_theme = $i
				_ImGui_SetItemDefaultFocus()
			EndIf
		Next

		_ImGui_EndCombo()
	EndIf

	If $old_theme <> $i_radio_theme Then
		Switch $i_radio_theme
			Case 0
				_ImGui_StyleColorsLight()
			Case 1
				_ImGui_StyleColorsDark()
			Case 2
				_ImGui_StyleColorsClassic()
		EndSwitch
	EndIf


	Local $winSize = _ImGui_GetWindowSize()

	_ImGui_Separator()

	; Download an image
	;Local $img = _ImGui_ImageFromURL("https://aommaster.com/blog/wp-content/uploads/2014/07/AutoItlogo.png")
	Local $img = _ImGui_ImageFromURL("https://www.autoahk.com/wp-content/themes/b2/Assets/fontend/images/model-bg.png")
	;MsgBox(16, "Error", $img)

	If $img Then

		; Get window size 
		Local $win_size = _ImGui_GetWindowSize()
		
		; Draw the image
		_ImGui_ImageFit($img, $win_size[0] - 10, 140)
	EndIf
	
	_ImGui_NewLine()

	If _ImGui_CheckBox("Show demo window", $b_show_demo_window) Then _ImGui_EnableViewports($b_show_demo_window)
	_ImGui_CheckBox("Show another window", $b_show_another_window)
	if _ImGui_IsItemHovered() Then _ImGui_ToolTip("what's up")

	; Seperate the window into 2 columns
	_ImGui_Columns(2)

	; Set the width for the column 0
	_ImGui_SetColumnWidth(0, $winSize[0]*0.7)

	; like line break
	_ImGui_NewLine()

	; put "##" before labels to hide then, remember to call _ImGui_PushItemWidth(-1) to expand the widget
	_ImGui_PushItemWidth(-1)
	_ImGui_InputTextWithHint("##username", "username", $username, $ImGuiInputTextFlags_CharsNoBlank)
	_ImGui_InputTextWithHint("##password", "password", $password, $ImGuiInputTextFlags_Password)
	_ImGui_PopItemWidth()

	if $str_status <> "" then _ImGui_TextColored($str_status, 0xFF33BB44)

	; go to the next column
	_ImGui_NextColumn()
	_ImGui_NewLine()

	; _ImGui_Button return true if being clicked
	if _ImGui_Button("LOGIN", -1, 40) Then $str_status = ($str_status == "" ? "Login success" & $username : "")


	_ImGui_Columns(1)
	_ImGui_NewLine()

	; begin a child window inside the main window
	_ImGui_BeginChild("##child_list_view1", $winSize*0.6, $winSize[1] *0.3, true, $ImGuiWindowFlags_ChildWindow)
	for $i = 0 To 10
		if _ImGui_Selectable("Selectable - " & $i, $i = $i_list_view) Then
			$i_list_view = $i
            $str_status = $i
		EndIf
	Next
    _ImGui_ListBox("litbox##listbox",$i_list_box,$list_box_items, 4)


	_ImGui_EndChild()

	; call after done with _ImGui_Begin
	_ImGui_End()

	If $b_show_another_window Then

		_ImGui_Begin("Another window")
		_ImGui_Text("Hello there..")
		if _ImGui_Button("close me") Then $b_show_another_window = False
		_ImGui_End()
	EndIf

	If $b_show_demo_window Then _ImGui_ShowDemoWindow()

	; must call
	_ImGui_EndFrame()

WEnd