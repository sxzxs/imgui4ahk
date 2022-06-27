#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
#include <imgui>
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1

hwnd := _ImGui_GUICreate("AHK ImGui", 1024, 768)
WinShow, ahk_id %hwnd%

io := _ImGui_GetIO()
_ImGui_StyleColorsLight()
_ImGui_EnableDocking(True)

while(_ImGui_PeekMsg())
{
    _ImGui_BeginFrame()
    _ImGui_Begin("AHK1")
   state1 := Checkbox(" My Checkbox", 0)
   state2 := Checkbox(" Another Checkbox", 1)
   _ImGui_End()
    _ImGui_Begin("AHK2")
   _ImGui_End()

   _ImGui_EndFrame()
}
return

Checkbox(text, initialState := 0) {
   static state := {}
   if !state.HasKey(text)
      state[text] := [initialState, initialState]
   s := state[text]
   if DllCall("imgui\Checkbox", "WStr", text, "UIntP", s[1], "Cdecl")
      s[1] := s[2] := !s[2]
   Return s[1]
}