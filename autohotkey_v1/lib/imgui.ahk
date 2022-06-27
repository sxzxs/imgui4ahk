;by ahker, 2397633100@qq.com
global IMGUI := _ImGui_Load_dll()
global __imgui_created := False

Global  FLT_MAX         				          :=  3.402823466e+38

Global  ImGuiWindowFlags_None                   :=  0
Global  ImGuiWindowFlags_NoTitleBar             := 1<<0
Global  ImGuiWindowFlags_NoResize               := 1<<1
Global  ImGuiWindowFlags_NoMove                 := 1<<2
Global  ImGuiWindowFlags_NoScrollbar            := 1<<3
Global  ImGuiWindowFlags_NoScrollWithMouse      := 1<<4
Global  ImGuiWindowFlags_NoCollapse             := 1<<5
Global  ImGuiWindowFlags_AlwaysAutoResize       := 1<<6
Global  ImGuiWindowFlags_NoBackground           := 1<<7
Global  ImGuiWindowFlags_NoSavedSettings        := 1<<8
Global  ImGuiWindowFlags_NoMouseInputs          := 1<<9
Global  ImGuiWindowFlags_MenuBar                := 1<<10
Global  ImGuiWindowFlags_HorizontalScrollbar    := 1<<11
Global  ImGuiWindowFlags_NoFocusOnAppearing     := 1<<12
Global  ImGuiWindowFlags_NoBringToFrontOnFocus  := 1<<13
Global  ImGuiWindowFlags_AlwaysVerticalScrollbar:= 1<<14
Global  ImGuiWindowFlags_AlwaysHorizontalScrollbar:= 1<<15
Global  ImGuiWindowFlags_AlwaysUseWindowPadding := 1<<16
Global  ImGuiWindowFlags_NoNavInputs            := 1<<18
Global  ImGuiWindowFlags_NoNavFocus             := 1<<19
Global  ImGuiWindowFlags_UnsavedDocument        := 1<<20
Global  ImGuiWindowFlags_NoDocking              := 1<<21
Global  ImGuiWindowFlags_NoNav                  :=  ImGuiWindowFlags_NoNavInputs |  ImGuiWindowFlags_NoNavFocus
Global  ImGuiWindowFlags_NoDecoration           :=  ImGuiWindowFlags_NoTitleBar| ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar |  ImGuiWindowFlags_NoCollapse
Global  ImGuiWindowFlags_NoInputs               :=  ImGuiWindowFlags_NoMouseInputs | ImGuiWindowFlags_NoNavInputs |  ImGuiWindowFlags_NoNavFocus
Global  ImGuiWindowFlags_NavFlattened           := 1<<23
Global  ImGuiWindowFlags_ChildWindow            := 1<<24
Global  ImGuiWindowFlags_Tooltip                := 1<<25
Global  ImGuiWindowFlags_Popup                  := 1<<26
Global  ImGuiWindowFlags_Modal                  := 1<<27
Global  ImGuiWindowFlags_ChildMenu              := 1<<28
Global  ImGuiWindowFlags_DockNodeHost           := 1<<29

Global  ImGuiInputTextFlags_None                := 0
Global  ImGuiInputTextFlags_CharsDecimal        := 1<< 0
Global  ImGuiInputTextFlags_CharsHexadecimal    := 1<<1
Global  ImGuiInputTextFlags_CharsUppercase      := 1<<2
Global  ImGuiInputTextFlags_CharsNoBlank        := 1<<3
Global  ImGuiInputTextFlags_AutoSelectAll       := 1<<4
Global  ImGuiInputTextFlags_EnterReturnsTrue    := 1<<5
Global  ImGuiInputTextFlags_CallbackCompletion  := 1<<6
Global  ImGuiInputTextFlags_CallbackHistory     := 1<<7
Global  ImGuiInputTextFlags_CallbackAlways      := 1<<8
Global  ImGuiInputTextFlags_CallbackCharFilter  := 1<<9
Global  ImGuiInputTextFlags_AllowTabInput       := 1<<10
Global  ImGuiInputTextFlags_CtrlEnterForNewLine := 1<<11
Global  ImGuiInputTextFlags_NoHorizontalScroll  := 1<<12
Global  ImGuiInputTextFlags_AlwaysInsertMode    := 1<<13
Global  ImGuiInputTextFlags_ReadOnly            := 1<<14
Global  ImGuiInputTextFlags_Password            := 1<<15
Global  ImGuiInputTextFlags_NoUndoRedo          := 1<<16
Global  ImGuiInputTextFlags_CharsScientific     := 1<<17
Global  ImGuiInputTextFlags_CallbackResize      := 1<<18
Global  ImGuiInputTextFlags_Multiline           := 1<<20
Global  ImGuiInputTextFlags_NoMarkEdited        := 1<<21

Global  ImGuiTreeNodeFlags_None                 :=  0
Global  ImGuiTreeNodeFlags_Selected             := 1<<0
Global  ImGuiTreeNodeFlags_Framed               := 1<<1
Global  ImGuiTreeNodeFlags_AllowItemOverlap     := 1<<2
Global  ImGuiTreeNodeFlags_NoTreePushOnOpen     := 1<<3
Global  ImGuiTreeNodeFlags_NoAutoOpenOnLog      := 1<<4
Global  ImGuiTreeNodeFlags_DefaultOpen          := 1<<5
Global  ImGuiTreeNodeFlags_OpenOnDoubleClick    := 1<<6
Global  ImGuiTreeNodeFlags_OpenOnArrow          := 1<<7
Global  ImGuiTreeNodeFlags_Leaf                 := 1<<8
Global  ImGuiTreeNodeFlags_Bullet               := 1<<9
Global  ImGuiTreeNodeFlags_FramePadding         := 1<<10
Global  ImGuiTreeNodeFlags_SpanAvailWidth       := 1<<11
Global  ImGuiTreeNodeFlags_SpanFullWidth        := 1<<12
Global  ImGuiTreeNodeFlags_NavLeftJumpsBackHere := 1<<13
Global  ImGuiTreeNodeFlags_CollapsingHeader     := ImGuiTreeNodeFlags_Framed | ImGuiTreeNodeFlags_NoTreePushOnOpen |  ImGuiTreeNodeFlags_NoAutoOpenOnLog

Global  ImGuiPopupFlags_None                    :=  0
Global  ImGuiPopupFlags_MouseButtonLeft         :=  0
Global  ImGuiPopupFlags_MouseButtonRight        :=  1
Global  ImGuiPopupFlags_MouseButtonMiddle       :=  2
Global  ImGuiPopupFlags_MouseButtonMask_        :=  0x1F
Global  ImGuiPopupFlags_MouseButtonDefault_     :=  1
Global  ImGuiPopupFlags_NoOpenOverExistingPopup := 1<<5
Global  ImGuiPopupFlags_NoOpenOverItems         := 1<<6
Global  ImGuiPopupFlags_AnyPopupId              := 1<<7
Global  ImGuiPopupFlags_AnyPopupLevel           := 1<<8
Global  ImGuiPopupFlags_AnyPopup                := ImGuiPopupFlags_AnyPopupId |  ImGuiPopupFlags_AnyPopupLevel

Global  ImGuiSelectableFlags_None               :=  0
Global  ImGuiSelectableFlags_DontClosePopups    := 1<<0
Global  ImGuiSelectableFlags_SpanAllColumns     := 1<<1
Global  ImGuiSelectableFlags_AllowDoubleClick   := 1<<2
Global  ImGuiSelectableFlags_Disabled           := 1<<3
Global  ImGuiSelectableFlags_AllowItemOverlap   := 1<<4

Global  ImGuiComboFlags_None                    :=  0
Global  ImGuiComboFlags_PopupAlignLeft          := 1<<0
Global  ImGuiComboFlags_HeightSmall             := 1<<1
Global  ImGuiComboFlags_HeightRegular           := 1<<2
Global  ImGuiComboFlags_HeightLarge             := 1<<3
Global  ImGuiComboFlags_HeightLargest           := 1<<4
Global  ImGuiComboFlags_NoArrowButton           := 1<<5
Global  ImGuiComboFlags_NoPreview               := 1<<6
Global  ImGuiComboFlags_HeightMask_             := ImGuiComboFlags_HeightSmall | ImGuiComboFlags_HeightRegular | ImGuiComboFlags_HeightLarge |  ImGuiComboFlags_HeightLargest

Global  ImGuiTabBarFlags_None                           :=  0
Global  ImGuiTabBarFlags_Reorderable                    := 1<<0
Global  ImGuiTabBarFlags_AutoSelectNewTabs              := 1<<1
Global  ImGuiTabBarFlags_TabListPopupButton             := 1<<2
Global  ImGuiTabBarFlags_NoCloseWithMiddleMouseButton   := 1<<3
Global  ImGuiTabBarFlags_NoTabListScrollingButtons      := 1<<4
Global  ImGuiTabBarFlags_NoTooltip                      := 1<<5
Global  ImGuiTabBarFlags_FittingPolicyResizeDown        := 1<<6
Global  ImGuiTabBarFlags_FittingPolicyScroll            := 1<<7
Global  ImGuiTabBarFlags_FittingPolicyMask_             := ImGuiTabBarFlags_FittingPolicyResizeDown |  ImGuiTabBarFlags_FittingPolicyScroll
Global  ImGuiTabBarFlags_FittingPolicyDefault_          := ImGuiTabBarFlags_FittingPolicyResizeDown

Global  ImGuiTabItemFlags_None                          :=  0
Global  ImGuiTabItemFlags_UnsavedDocument               := 1<<0
Global  ImGuiTabItemFlags_SetSelected                   := 1<<1
Global  ImGuiTabItemFlags_NoCloseWithMiddleMouseButton  := 1<<2
Global  ImGuiTabItemFlags_NoPushId                      := 1<<3
Global  ImGuiTabItemFlags_NoTooltip                     := 1<<4

Global  ImGuiFocusedFlags_None                          :=  0
Global  ImGuiFocusedFlags_ChildWindows                  := 1<<0
Global  ImGuiFocusedFlags_RootWindow                    := 1<<1
Global  ImGuiFocusedFlags_AnyWindow                     := 1<<2
Global  ImGuiFocusedFlags_RootAndChildWindows           := ImGuiFocusedFlags_RootWindow |  ImGuiFocusedFlags_ChildWindows


Global  ImGuiHoveredFlags_None                          :=  0
Global  ImGuiHoveredFlags_ChildWindows                  := 1<<0
Global  ImGuiHoveredFlags_RootWindow                    := 1<<1
Global  ImGuiHoveredFlags_AnyWindow                     := 1<<2
Global  ImGuiHoveredFlags_AllowWhenBlockedByPopup       := 1<<3
Global  ImGuiHoveredFlags_AllowWhenBlockedByActiveItem  := 1<<5
Global  ImGuiHoveredFlags_AllowWhenOverlapped           := 1<<6
Global  ImGuiHoveredFlags_AllowWhenDisabled             := 1<<7
Global  ImGuiHoveredFlags_RectOnly                      := ImGuiHoveredFlags_AllowWhenBlockedByPopup | ImGuiHoveredFlags_AllowWhenBlockedByActiveItem |  ImGuiHoveredFlags_AllowWhenOverlapped
Global  ImGuiHoveredFlags_RootAndChildWindows           := ImGuiHoveredFlags_RootWindow |  ImGuiHoveredFlags_ChildWindows


Global  ImGuiDockNodeFlags_None                         :=  0
Global  ImGuiDockNodeFlags_KeepAliveOnly                := 1<<0
Global  ImGuiDockNodeFlags_NoDockingInCentralNode       := 1<<2
Global  ImGuiDockNodeFlags_PassthruCentralNode          := 1<<3
Global  ImGuiDockNodeFlags_NoSplit                      := 1<<4
Global  ImGuiDockNodeFlags_NoResize                     := 1<<5
Global  ImGuiDockNodeFlags_AutoHideTabBar               := 1<<6

Global  ImGuiDragDropFlags_None                         :=  0
Global  ImGuiDragDropFlags_SourceNoPreviewTooltip       := 1<<0
Global  ImGuiDragDropFlags_SourceNoDisableHover         := 1<<1
Global  ImGuiDragDropFlags_SourceNoHoldToOpenOthers     := 1<<2
Global  ImGuiDragDropFlags_SourceAllowNullID            := 1<<3
Global  ImGuiDragDropFlags_SourceExtern                 := 1<<4
Global  ImGuiDragDropFlags_SourceAutoExpirePayload      := 1<<5
Global  ImGuiDragDropFlags_AcceptBeforeDelivery         := 1<<10
Global  ImGuiDragDropFlags_AcceptNoDrawDefaultRect      := 1<<11
Global  ImGuiDragDropFlags_AcceptNoPreviewTooltip       := 1<<12
Global  ImGuiDragDropFlags_AcceptPeekOnly               := ImGuiDragDropFlags_AcceptBeforeDelivery |  ImGuiDragDropFlags_AcceptNoDrawDefaultRect

Global  ImGuiDataType_S8 := 0
Global  ImGuiDataType_U8 := 1
Global  ImGuiDataType_S16 := 2
Global  ImGuiDataType_U16 := 3
Global  ImGuiDataType_S32 := 4
Global  ImGuiDataType_U32 := 5
Global  ImGuiDataType_S64 := 6
Global  ImGuiDataType_U64 := 7
Global  ImGuiDataType_Float := 8
Global  ImGuiDataType_Double := 9
Global  ImGuiDataType_COUNT := 10

Global  ImGuiDir_None    :=  -1
Global  ImGuiDir_Left    :=  0
Global  ImGuiDir_Right   :=  1
Global  ImGuiDir_Up      :=  2
Global  ImGuiDir_Down    :=  3

Global  ImGuiKey_Tab := 0
Global  ImGuiKey_LeftArrow := 1
Global  ImGuiKey_RightArrow := 2
Global  ImGuiKey_UpArrow := 3
Global  ImGuiKey_DownArrow := 4
Global  ImGuiKey_PageUp := 5
Global  ImGuiKey_PageDown := 6
Global  ImGuiKey_Home := 7
Global  ImGuiKey_End := 8
Global  ImGuiKey_Insert := 9
Global  ImGuiKey_Delete := 10
Global  ImGuiKey_Backspace := 11
Global  ImGuiKey_Space := 12
Global  ImGuiKey_Enter := 13
Global  ImGuiKey_Escape := 14
Global  ImGuiKey_KeyPadEnter := 15
Global  ImGuiKey_A := 16
Global  ImGuiKey_C := 17
Global  ImGuiKey_V := 18
Global  ImGuiKey_X := 19
Global  ImGuiKey_Y := 20
Global  ImGuiKey_Z := 21

Global  ImGuiKeyModFlags_None       :=  0
Global  ImGuiKeyModFlags_Ctrl       := 1<<0
Global  ImGuiKeyModFlags_Shift      := 1<<1
Global  ImGuiKeyModFlags_Alt        := 1<<2
Global  ImGuiKeyModFlags_Super      := 1<<3
Global  ImGuiNavInput_Activate := 0
Global  ImGuiNavInput_Cancel := 1
Global  ImGuiNavInput_Input := 2
Global  ImGuiNavInput_Menu := 3
Global  ImGuiNavInput_DpadLeft := 4
Global  ImGuiNavInput_DpadRight := 5
Global  ImGuiNavInput_DpadUp := 6
Global  ImGuiNavInput_DpadDown := 7
Global  ImGuiNavInput_LStickLeft := 8
Global  ImGuiNavInput_LStickRight := 9
Global  ImGuiNavInput_LStickUp := 10
Global  ImGuiNavInput_LStickDown := 11
Global  ImGuiNavInput_FocusPrev := 12
Global  ImGuiNavInput_FocusNext := 13
Global  ImGuiNavInput_TweakSlow := 14
Global  ImGuiNavInput_TweakFast := 15

Global  ImGuiNavInput_KeyMenu_ := 16
Global  ImGuiNavInput_KeyLeft_ := 17
Global  ImGuiNavInput_KeyRight_ := 18
Global  ImGuiNavInput_KeyUp_ := 19
Global  ImGuiNavInput_KeyDown_ := 20
Global  ImGuiNavInput_COUNT := 21
Global  ImGuiNavInput_InternalStart_ :=  ImGuiNavInput_KeyMenu_


Global  ImGuiConfigFlags_None                   :=  0
Global  ImGuiConfigFlags_NavEnableKeyboard      := 1<<0
Global  ImGuiConfigFlags_NavEnableGamepad       := 1<<1
Global  ImGuiConfigFlags_NavEnableSetMousePos   := 1<<2
Global  ImGuiConfigFlags_NavNoCaptureKeyboard   := 1<<3
Global  ImGuiConfigFlags_NoMouse                := 1<<4
Global  ImGuiConfigFlags_NoMouseCursorChange    := 1<<5
Global  ImGuiConfigFlags_DockingEnable          := 1<<6

Global  ImGuiConfigFlags_ViewportsEnable        := 1<<10
Global  ImGuiConfigFlags_DpiEnableScaleViewports:= 1<<14
Global  ImGuiConfigFlags_DpiEnableScaleFonts    := 1<<15
Global  ImGuiConfigFlags_IsSRGB                 := 1<<20
Global  ImGuiConfigFlags_IsTouchScreen          := 1<<21

Global  ImGuiBackendFlags_None                  :=  0
Global  ImGuiBackendFlags_HasGamepad            := 1<<0
Global  ImGuiBackendFlags_HasMouseCursors       := 1<<1
Global  ImGuiBackendFlags_HasSetMousePos        := 1<<2
Global  ImGuiBackendFlags_RendererHasVtxOffset  := 1<<3
Global  ImGuiBackendFlags_PlatformHasViewports  := 1<<10
Global  ImGuiBackendFlags_HasMouseHoveredViewport:= 1<<11
Global  ImGuiBackendFlags_RendererHasViewports  := 1<<12

Global  ImGuiCol_Text := 0
Global  ImGuiCol_TextDisabled := 1
Global  ImGuiCol_WindowBg := 2
Global  ImGuiCol_ChildBg := 3
Global  ImGuiCol_PopupBg := 4
Global  ImGuiCol_Border := 5
Global  ImGuiCol_BorderShadow := 6
Global  ImGuiCol_FrameBg := 7
Global  ImGuiCol_FrameBgHovered := 8
Global  ImGuiCol_FrameBgActive := 9
Global  ImGuiCol_TitleBg := 10
Global  ImGuiCol_TitleBgActive := 11
Global  ImGuiCol_TitleBgCollapsed := 12
Global  ImGuiCol_MenuBarBg := 13
Global  ImGuiCol_ScrollbarBg := 14
Global  ImGuiCol_ScrollbarGrab := 15
Global  ImGuiCol_ScrollbarGrabHovered := 16
Global  ImGuiCol_ScrollbarGrabActive := 17
Global  ImGuiCol_CheckMark := 18
Global  ImGuiCol_SliderGrab := 19
Global  ImGuiCol_SliderGrabActive := 20
Global  ImGuiCol_Button := 21
Global  ImGuiCol_ButtonHovered := 22
Global  ImGuiCol_ButtonActive := 23
Global  ImGuiCol_Header := 24
Global  ImGuiCol_HeaderHovered := 25
Global  ImGuiCol_HeaderActive := 26
Global  ImGuiCol_Separator := 27
Global  ImGuiCol_SeparatorHovered := 28
Global  ImGuiCol_SeparatorActive := 29
Global  ImGuiCol_ResizeGrip := 30
Global  ImGuiCol_ResizeGripHovered := 31
Global  ImGuiCol_ResizeGripActive := 32
Global  ImGuiCol_Tab := 33
Global  ImGuiCol_TabHovered := 34
Global  ImGuiCol_TabActive := 35
Global  ImGuiCol_TabUnfocused := 36
Global  ImGuiCol_TabUnfocusedActive := 37
Global  ImGuiCol_DockingPreview := 38
Global  ImGuiCol_DockingEmptyBg := 39
Global  ImGuiCol_PlotLines := 40
Global  ImGuiCol_PlotLinesHovered := 41
Global  ImGuiCol_PlotHistogram := 42
Global  ImGuiCol_PlotHistogramHovered := 43
Global  ImGuiCol_TextSelectedBg := 44
Global  ImGuiCol_DragDropTarget := 45
Global  ImGuiCol_NavHighlight := 46
Global  ImGuiCol_NavWindowingHighlight := 47
Global  ImGuiCol_NavWindowingDimBg := 48
Global  ImGuiCol_ModalWindowDimBg := 49
Global  ImGuiCol_DockingPreview_1 := 50
Global  ImGuiCol_DockingOutLine := 51
Global  ImGuiCol_DockingLine := 52

Global  ImGuiStyleVar_Alpha := 0
Global  ImGuiStyleVar_WindowPadding := 1
Global  ImGuiStyleVar_WindowRounding := 2
Global  ImGuiStyleVar_WindowBorderSize := 3
Global  ImGuiStyleVar_WindowMinSize := 4
Global  ImGuiStyleVar_WindowTitleAlign := 5
Global  ImGuiStyleVar_ChildRounding := 6
Global  ImGuiStyleVar_ChildBorderSize := 7
Global  ImGuiStyleVar_PopupRounding := 8
Global  ImGuiStyleVar_PopupBorderSize := 9
Global  ImGuiStyleVar_FramePadding := 10
Global  ImGuiStyleVar_FrameRounding := 11
Global  ImGuiStyleVar_FrameBorderSize := 12
Global  ImGuiStyleVar_ItemSpacing := 13
Global  ImGuiStyleVar_ItemInnerSpacing := 14
Global  ImGuiStyleVar_IndentSpacing := 15
Global  ImGuiStyleVar_ScrollbarSize := 16
Global  ImGuiStyleVar_ScrollbarRounding := 17
Global  ImGuiStyleVar_GrabMinSize := 18
Global  ImGuiStyleVar_GrabRounding := 19
Global  ImGuiStyleVar_TabRounding := 20
Global  ImGuiStyleVar_ButtonTextAlign := 21
Global  ImGuiStyleVar_SelectableTextAlign := 22

Global  ImGuiColorEditFlags_None            :=  0
Global  ImGuiColorEditFlags_NoAlpha         := 1<<1
Global  ImGuiColorEditFlags_NoPicker        := 1<<2
Global  ImGuiColorEditFlags_NoOptions       := 1<<3
Global  ImGuiColorEditFlags_NoSmallPreview  := 1<<4
Global  ImGuiColorEditFlags_NoInputs        := 1<<5
Global  ImGuiColorEditFlags_NoTooltip       := 1<<6
Global  ImGuiColorEditFlags_NoLabel         := 1<<7
Global  ImGuiColorEditFlags_NoSidePreview   := 1<<8
Global  ImGuiColorEditFlags_NoDragDrop      := 1<<9
Global  ImGuiColorEditFlags_NoBorder        := 1<<10
Global  ImGuiColorEditFlags_AlphaBar        := 1<<16
Global  ImGuiColorEditFlags_AlphaPreview    := 1<<17
Global  ImGuiColorEditFlags_AlphaPreviewHalf:= 1<<18
Global  ImGuiColorEditFlags_HDR             := 1<<19
Global  ImGuiColorEditFlags_DisplayRGB      := 1<<20
Global  ImGuiColorEditFlags_DisplayHSV      := 1<<21
Global  ImGuiColorEditFlags_DisplayHex      := 1<<22
Global  ImGuiColorEditFlags_Uint8           := 1<<23
Global  ImGuiColorEditFlags_Float           := 1<<24
Global  ImGuiColorEditFlags_PickerHueBar    := 1<<25
Global  ImGuiColorEditFlags_PickerHueWheel  := 1<<26
Global  ImGuiColorEditFlags_InputRGB        := 1<<27
Global  ImGuiColorEditFlags_InputHSV        := 1<<28

Global  ImGuiColorEditFlags__OptionsDefault := ImGuiColorEditFlags_Uint8 | ImGuiColorEditFlags_DisplayRGB | ImGuiColorEditFlags_InputRGB |  ImGuiColorEditFlags_PickerHueBar
Global  ImGuiColorEditFlags__DisplayMask    := ImGuiColorEditFlags_DisplayRGB | ImGuiColorEditFlags_DisplayHSV |  ImGuiColorEditFlags_DisplayHex
Global  ImGuiColorEditFlags__DataTypeMask   := ImGuiColorEditFlags_Uint8 |  ImGuiColorEditFlags_Float
Global  ImGuiColorEditFlags__PickerMask     := ImGuiColorEditFlags_PickerHueWheel |  ImGuiColorEditFlags_PickerHueBar
Global  ImGuiColorEditFlags__InputMask      := ImGuiColorEditFlags_InputRGB |  ImGuiColorEditFlags_InputHSV

Global  ImGuiMouseButton_Left :=  0
Global  ImGuiMouseButton_Right :=  1
Global  ImGuiMouseButton_Middle :=  2
Global  ImGuiMouseButton_COUNT :=  5

Global  ImGuiMouseCursor_None :=  -1
Global  ImGuiMouseCursor_Arrow :=  0
Global  ImGuiMouseCursor_TextInput := 0
Global  ImGuiMouseCursor_ResizeAll := 1
Global  ImGuiMouseCursor_ResizeNS := 2
Global  ImGuiMouseCursor_ResizeEW := 3
Global  ImGuiMouseCursor_ResizeNESW := 4
Global  ImGuiMouseCursor_ResizeNWSE := 5
Global  ImGuiMouseCursor_Hand := 6
Global  ImGuiMouseCursor_NotAllowed := 7


Global  ImGuiCond_None          :=  0
Global  ImGuiCond_Always        := 1<<0
Global  ImGuiCond_Once          := 1<<1
Global  ImGuiCond_FirstUseEver  := 1<<2
Global  ImGuiCond_Appearing     := 1<<3


Global  ImDrawCornerFlags_None      :=  0
Global  ImDrawCornerFlags_TopLeft   := 1<<0
Global  ImDrawCornerFlags_TopRight  := 1<<1
Global  ImDrawCornerFlags_BotLeft   := 1<<2
Global  ImDrawCornerFlags_BotRight  := 1<<3
Global  ImDrawCornerFlags_Top       := ImDrawCornerFlags_TopLeft |  ImDrawCornerFlags_TopRight
Global  ImDrawCornerFlags_Bot       := ImDrawCornerFlags_BotLeft |  ImDrawCornerFlags_BotRight
Global  ImDrawCornerFlags_Left      := ImDrawCornerFlags_TopLeft |  ImDrawCornerFlags_BotLeft
Global  ImDrawCornerFlags_Right     := ImDrawCornerFlags_TopRight |  ImDrawCornerFlags_BotRight
Global  ImDrawCornerFlags_All       :=  0xF

Global  ImDrawListFlags_None             :=  0
Global  ImDrawListFlags_AntiAliasedLines := 1<<0
Global  ImDrawListFlags_AntiAliasedFill  := 1<<1
Global  ImDrawListFlags_AllowVtxOffset   := 1<<2

_ImGui_Load_dll()
{
    local
    SplitPath,A_LineFile,,dir
    path := ""
    if(A_IsCompiled)
    {
        path := A_PtrSize == 4 ? (A_ScriptDir . "/lib/dll_32/") : (A_ScriptDir . "/lib/dll_64/")
    }
    else
    {
        path := A_PtrSize == 4 ? (dir . "/dll_32/") : (dir . "/dll_64/")
    }
    dllcall("SetDllDirectory", "Str", path)
    hModule := DllCall("LoadLibrary", "Str", "imgui.dll", "Ptr")
    if(!hModule)
        MsgBox,% A_ThisFunc ",dll call error! :" ErrorLevel
    return hModule
}
_ImGui_GUICreate(title, w, h, x := -1, y := -1, style := 0, ex_style := 0)
{
    if(__imgui_created)
        return False
	result := DllCall("imgui\GUICreate", "wstr", title, "int", w, "int", h, "int", x, "int", y)
    if(ErrorLevel)
        MsgBox,% A_ThisFunc ",dll call error! :" ErrorLevel
	__imgui_created := True
    return result
}
_ImGui_PeekMsg()
{
	result := DllCall("imgui\PeekMsg")
    if(ErrorLevel)
        MsgBox,% A_ThisFunc ",dll call error! :" ErrorLevel
    return result
}

; ####======================================================================================================
; ####\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
; ####======================================================================================================
; ####\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

; // Main
_ImGui_GetIO()
{
	result := DllCall("imgui\GetIO", "Cdecl Ptr")
    if(ErrorLevel)
        MsgBox,% A_ThisFunc ",dll call error! :" ErrorLevel
	return result
}
_ImGui_BeginFrame()
{
   DllCall("imgui\BeginFrame", "Cdecl")
}
_ImGui_EndFrame()
{
   DllCall("imgui\EndFrame", "UInt", 0x004488, "Cdecl")
}
_ImGui_Begin(title, close_btn := 0, flags := 0)
{
    DllCall("imgui\Begin", "WStr", title, "Int", close_btn, "Int", flags, "Cdecl")
}
_ImGui_End()
{
   DllCall("imgui\End", "Cdecl")
}
;Style
_ImGui_StyleColorsLight()
{
	DllCall("imgui\StyleColorsLight")
}
_ImGui_EnableDocking(enable := True)
{
	io := _ImGui_GetIO()
    ConfigFlags := NumGet(io , 0, "Short")
    log.info(ConfigFlags)
    set := enable ? (ConfigFlags | ImGuiConfigFlags_DockingEnable ) : (ConfigFlags ^ ImGuiConfigFlags_DockingEnable )
    NumPut(set, io, 0, "Short")
}