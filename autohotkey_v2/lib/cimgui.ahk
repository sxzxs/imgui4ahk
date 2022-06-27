;by ahker, 2397633100@qq.com
;modify by Starxx 2022/05/09
;https://gitee.com/kazhafeizhale/imgui4ahk
;https://github.com/thedemons/imgui-autoit
;32位编译器：
;char      short      int      long      float      double      指针
;1            2        4         4       4              8         4
;64位编译器：
;char      short      int      long      float      double      指针
;1            2         4        8        4             8         8

#DllLoad imgui.dll

class ImGuiWindowFlags{
	static None                   :=  0
	static NoTitleBar             := 1<<0
	static NoResize               := 1<<1
	static NoMove                 := 1<<2
	static NoScrollbar            := 1<<3
	static NoScrollWithMouse      := 1<<4
	static NoCollapse             := 1<<5
	static AlwaysAutoResize       := 1<<6
	static NoBackground           := 1<<7
	static NoSavedSettings        := 1<<8
	static NoMouseInputs          := 1<<9
	static MenuBar                := 1<<10
	static HorizontalScrollbar    := 1<<11
	static NoFocusOnAppearing     := 1<<12
	static NoBringToFrontOnFocus  := 1<<13
	static AlwaysVerticalScrollbar:= 1<<14
	static AlwaysHorizontalScrollbar:= 1<<15
	static AlwaysUseWindowPadding := 1<<16
	static NoNavInputs            := 1<<18
	static NoNavFocus             := 1<<19
	static UnsavedDocument        := 1<<20
	static NoDocking              := 1<<21
	static NoNav                  := this.NoNavInputs |  this.NoNavFocus
	static NoDecoration           := this.NoTitleBar | this.NoResize | this.NoScrollbar | this.NoCollapse
	static NoInputs               := this.NoMouseInputs | this.NoNavInputs |  this.NoNavFocus
	static NavFlattened           := 1<<23
	static ChildWindow            := 1<<24
	static Tooltip                := 1<<25
	static Popup                  := 1<<26
	static Modal                  := 1<<27
	static ChildMenu              := 1<<28
	static DockNodeHost           := 1<<29
}
class ImGuiInputTextFlags{
	static None                := 0
	static CharsDecimal        := 1<< 0
	static CharsHexadecimal    := 1<<1
	static CharsUppercase      := 1<<2
	static CharsNoBlank        := 1<<3
	static AutoSelectAll       := 1<<4
	static EnterReturnsTrue    := 1<<5
	static CallbackCompletion  := 1<<6
	static CallbackHistory     := 1<<7
	static CallbackAlways      := 1<<8
	static CallbackCharFilter  := 1<<9
	static AllowTabInput       := 1<<10
	static CtrlEnterForNewLine := 1<<11
	static NoHorizontalScroll  := 1<<12
	static AlwaysInsertMode    := 1<<13
	static ReadOnly            := 1<<14
	static Password            := 1<<15
	static NoUndoRedo          := 1<<16
	static CharsScientific     := 1<<17
	static CallbackResize      := 1<<18
	static Multiline           := 1<<20
	static NoMarkEdited        := 1<<21
}
class ImGuiTreeNodeFlags{
	static None                 :=  0
	static Selected             := 1<<0
	static Framed               := 1<<1
	static AllowItemOverlap     := 1<<2
	static NoTreePushOnOpen     := 1<<3
	static NoAutoOpenOnLog      := 1<<4
	static DefaultOpen          := 1<<5
	static OpenOnDoubleClick    := 1<<6
	static OpenOnArrow          := 1<<7
	static Leaf                 := 1<<8
	static Bullet               := 1<<9
	static FramePadding         := 1<<10
	static SpanAvailWidth       := 1<<11
	static SpanFullWidth        := 1<<12
	static NavLeftJumpsBackHere := 1<<13
	static CollapsingHeader     := this.Framed | this.NoTreePushOnOpen |  this.NoAutoOpenOnLog
}
class ImGuiPopupFlags{
	static None                    :=  0
	static MouseButtonLeft         :=  0
	static MouseButtonRight        :=  1
	static MouseButtonMiddle       :=  2
	static MouseButtonMask_        :=  0x1F
	static MouseButtonDefault_     :=  1
	static NoOpenOverExistingPopup := 1<<5
	static NoOpenOverItems         := 1<<6
	static AnyPopupId              := 1<<7
	static AnyPopupLevel           := 1<<8
	static AnyPopup                := this.AnyPopupId |  this.AnyPopupLevel
}
class ImGuiSelectableFlags {
	static None               :=  0
	static DontClosePopups    := 1<<0
	static SpanAllColumns     := 1<<1
	static AllowDoubleClick   := 1<<2
	static Disabled           := 1<<3
	static AllowItemOverlap   := 1<<4
}
class ImGuiComboFlags {
	static None                    :=  0
	static PopupAlignLeft          := 1<<0
	static HeightSmall             := 1<<1
	static HeightRegular           := 1<<2
	static HeightLarge             := 1<<3
	static HeightLargest           := 1<<4
	static NoArrowButton           := 1<<5
	static NoPreview               := 1<<6
	static HeightMask             := this.HeightSmall | this.HeightRegular | this.HeightLarge |  this.HeightLargest

}
class ImGuiTabBarFlags {
	static None                           :=  0
	static Reorderable                    := 1<<0
	static AutoSelectNewTabs              := 1<<1
	static TabListPopupButton             := 1<<2
	static NoCloseWithMiddleMouseButton   := 1<<3
	static NoTabListScrollingButtons      := 1<<4
	static NoTooltip                      := 1<<5
	static FittingPolicyResizeDown        := 1<<6
	static FittingPolicyScroll            := 1<<7
	static FittingPolicyMask             := this.FittingPolicyResizeDown |  this.FittingPolicyScroll
	static FittingPolicyDefault          := this.FittingPolicyResizeDown

}
class ImGuiTabItemFlags {
	static None                          :=  0
	static UnsavedDocument               := 1<<0
	static SetSelected                   := 1<<1
	static NoCloseWithMiddleMouseButton  := 1<<2
	static NoPushId                      := 1<<3
	static NoTooltip                     := 1<<4
}
class ImGuiFocusedFlags {
	static None                          :=  0
	static ChildWindows                  := 1<<0
	static RootWindow                    := 1<<1
	static AnyWindow                     := 1<<2
	static RootAndChildWindows           := this.RootWindow |  this.ChildWindows
}
class ImGuiHoveredFlags {
	static None                          :=  0
	static ChildWindows                  := 1<<0
	static RootWindow                    := 1<<1
	static AnyWindow                     := 1<<2
	static AllowWhenBlockedByPopup       := 1<<3
	static AllowWhenBlockedByActiveItem  := 1<<5
	static AllowWhenOverlapped           := 1<<6
	static AllowWhenDisabled             := 1<<7
	static RectOnly                      := this.AllowWhenBlockedByPopup | this.AllowWhenBlockedByActiveItem |  this.AllowWhenOverlapped
	static RootAndChildWindows           := this.RootWindow |  this.ChildWindows
}
class ImGuiDockNodeFlags {
	static None                         :=  0
	static KeepAliveOnly                := 1<<0
	static NoDockingInCentralNode       := 1<<2
	static PassthruCentralNode          := 1<<3
	static NoSplit                      := 1<<4
	static NoResize                     := 1<<5
	static AutoHideTabBar               := 1<<6
}
class ImGuiDragDropFlags {
	static None                         :=  0
	static SourceNoPreviewTooltip       := 1<<0
	static SourceNoDisableHover         := 1<<1
	static SourceNoHoldToOpenOthers     := 1<<2
	static SourceAllowNullID            := 1<<3
	static SourceExtern                 := 1<<4
	static SourceAutoExpirePayload      := 1<<5
	static AcceptBeforeDelivery         := 1<<10
	static AcceptNoDrawDefaultRect      := 1<<11
	static AcceptNoPreviewTooltip       := 1<<12
	static AcceptPeekOnly               := this.AcceptBeforeDelivery |  this.AcceptNoDrawDefaultRect
}
class ImGuiDataType {
	static S8 := 0
	static U8 := 1
	static S16 := 2
	static U16 := 3
	static S32 := 4
	static U32 := 5
	static S64 := 6
	static U64 := 7
	static Float := 8
	static Double := 9
	static COUNT := 10
}
class ImGuiDir {
	static None    :=  -1
	static Left    :=  0
	static Right   :=  1
	static Up      :=  2
	static Down    :=  3
}
class ImGuiKey {
	static Tab := 0
	static LeftArrow := 1
	static RightArrow := 2
	static UpArrow := 3
	static DownArrow := 4
	static PageUp := 5
	static PageDown := 6
	static Home := 7
	static End := 8
	static Insert := 9
	static Delete := 10
	static Backspace := 11
	static Space := 12
	static Enter := 13
	static Escape := 14
	static KeyPadEnter := 15
	static A := 16
	static C := 17
	static V := 18
	static X := 19
	static Y := 20
	static Z := 21
}
class ImGuiKeyModFlags {
	static None       :=  0
	static Ctrl       := 1<<0
	static Shift      := 1<<1
	static Alt        := 1<<2
	static Super      := 1<<3
}
class ImGuiNavInput {
	static Activate := 0
	static Cancel := 1
	static Input := 2
	static Menu := 3
	static DpadLeft := 4
	static DpadRight := 5
	static DpadUp := 6
	static DpadDown := 7
	static LStickLeft := 8
	static LStickRight := 9
	static LStickUp := 10
	static LStickDown := 11
	static FocusPrev := 12
	static FocusNext := 13
	static TweakSlow := 14
	static TweakFast := 15

	static KeyMenu := 16
	static KeyLeft := 17
	static KeyRight := 18
	static KeyUp := 19
	static KeyDown := 20
	static COUNT := 21
	static InternalStart :=  this.KeyMenu
}
class ImGuiConfigFlags {
	static None                   :=  0
	static NavEnableKeyboard      := 1<<0
	static NavEnableGamepad       := 1<<1
	static NavEnableSetMousePos   := 1<<2
	static NavNoCaptureKeyboard   := 1<<3
	static NoMouse                := 1<<4
	static NoMouseCursorChange    := 1<<5
	static DockingEnable          := 1<<6
	static ViewportsEnable        := 1<<10
	static DpiEnableScaleViewports:= 1<<14
	static DpiEnableScaleFonts    := 1<<15
	static IsSRGB                 := 1<<20
	static IsTouchScreen          := 1<<21
}
class ImGuiBackendFlags {
	static None                  :=  0
	static HasGamepad            := 1<<0
	static HasMouseCursors       := 1<<1
	static HasSetMousePos        := 1<<2
	static RendererHasVtxOffset  := 1<<3
	static PlatformHasViewports  := 1<<10
	static HasMouseHoveredViewport:= 1<<11
	static RendererHasViewports  := 1<<12
}
class ImGuiCol {
	static Text := 0
	static TextDisabled := 1
	static WindowBg := 2
	static ChildBg := 3
	static PopupBg := 4
	static Border := 5
	static BorderShadow := 6
	static FrameBg := 7
	static FrameBgHovered := 8
	static FrameBgActive := 9
	static TitleBg := 10
	static TitleBgActive := 11
	static TitleBgCollapsed := 12
	static MenuBarBg := 13
	static ScrollbarBg := 14
	static ScrollbarGrab := 15
	static ScrollbarGrabHovered := 16
	static ScrollbarGrabActive := 17
	static CheckMark := 18
	static SliderGrab := 19
	static SliderGrabActive := 20
	static Button := 21
	static ButtonHovered := 22
	static ButtonActive := 23
	static Header := 24
	static HeaderHovered := 25
	static HeaderActive := 26
	static Separator := 27
	static SeparatorHovered := 28
	static SeparatorActive := 29
	static ResizeGrip := 30
	static ResizeGripHovered := 31
	static ResizeGripActive := 32
	static Tab := 33
	static TabHovered := 34
	static TabActive := 35
	static TabUnfocused := 36
	static TabUnfocusedActive := 37
	static DockingPreview := 38
	static DockingEmptyBg := 39
	static PlotLines := 40
	static PlotLinesHovered := 41
	static PlotHistogram := 42
	static PlotHistogramHovered := 43
	static TextSelectedBg := 44
	static DragDropTarget := 45
	static NavHighlight := 46
	static NavWindowingHighlight := 47
	static NavWindowingDimBg := 48
	static ModalWindowDimBg := 49
	static 1 := 50
	static DockingOutLine := 51
	static DockingLine := 52
}
class ImGuiStyleVar {
	static Alpha := 0
	static WindowPadding := 1
	static WindowRounding := 2
	static WindowBorderSize := 3
	static WindowMinSize := 4
	static WindowTitleAlign := 5
	static ChildRounding := 6
	static ChildBorderSize := 7
	static PopupRounding := 8
	static PopupBorderSize := 9
	static FramePadding := 10
	static FrameRounding := 11
	static FrameBorderSize := 12
	static ItemSpacing := 13
	static ItemInnerSpacing := 14
	static IndentSpacing := 15
	static ScrollbarSize := 16
	static ScrollbarRounding := 17
	static GrabMinSize := 18
	static GrabRounding := 19
	static TabRounding := 20
	static ButtonTextAlign := 21
	static SelectableTextAlign := 22
}
class ImGuiColorEditFlags {
	static None            :=  0
	static NoAlpha         := 1<<1
	static NoPicker        := 1<<2
	static NoOptions       := 1<<3
	static NoSmallPreview  := 1<<4
	static NoInputs        := 1<<5
	static NoTooltip       := 1<<6
	static NoLabel         := 1<<7
	static NoSidePreview   := 1<<8
	static NoDragDrop      := 1<<9
	static NoBorder        := 1<<10
	static AlphaBar        := 1<<16
	static AlphaPreview    := 1<<17
	static AlphaPreviewHalf:= 1<<18
	static HDR             := 1<<19
	static DisplayRGB      := 1<<20
	static DisplayHSV      := 1<<21
	static DisplayHex      := 1<<22
	static Uint8           := 1<<23
	static Float           := 1<<24
	static PickerHueBar    := 1<<25
	static PickerHueWheel  := 1<<26
	static InputRGB        := 1<<27
	static InputHSV        := 1<<28
	static OptionsDefault := this.Uint8 | this.DisplayRGB | this.InputRGB |  this.PickerHueBar
	static DisplayMask    := this.DisplayRGB | this.DisplayHSV |  this.DisplayHex
	static DataTypeMask   := this.Uint8 |  this.Float
	static PickerMask     := this.PickerHueWheel |  this.PickerHueBar
	static InputMask      := this.InputRGB |  this.InputHSV
}
class ImGuiMouseButton {
	static Left :=  0
	static Right :=  1
	static Middle :=  2
	static COUNT :=  5
}
class ImGuiMouseCursor {
	static None :=  -1
	static Arrow :=  0
	static TextInput := 0
	static ResizeAll := 1
	static ResizeNS := 2
	static ResizeEW := 3
	static ResizeNESW := 4
	static ResizeNWSE := 5
	static Hand := 6
	static NotAllowed := 7
}
class ImGuiCond {
	static None          :=  0
	static Always        := 1<<0
	static Once          := 1<<1
	static FirstUseEver  := 1<<2
	static Appearing     := 1<<3
}
class ImDrawCornerFlags {
	static None      :=  0
	static TopLeft   := 1<<0
	static TopRight  := 1<<1
	static BotLeft   := 1<<2
	static BotRight  := 1<<3
	static Top       := this.TopLeft |  this.TopRight
	static Bot       := this.BotLeft |  this.BotRight
	static Left      := this.TopLeft |  this.BotLeft
	static Right     := this.TopRight |  this.BotRight
	static All       :=  0xF
}
class ImDrawListFlags {
	static None             :=  0
	static AntiAliasedLines := 1<<0
	static AntiAliasedFill  := 1<<1
	static AllowVtxOffset   := 1<<2
}

class Imgui{

	static EnableViewports(enable := True)
	{
		DllCall("imgui\EnableViewports","Int", enable)
	}


	static SetWindowTitleAlign(x := 0.5, y := 0.5)
	{
		imstyle :=  this.GetStyle()
		NumPut("float", x, "float", y, imstyle, 28)
	}

	;GUI_API const ImWchar*    GetGlyphRangesDefault();                // Basic Latin, Extended Latin
	;GUI_API const ImWchar*    GetGlyphRangesKorean();                 // Default + Korean characters
	;GUI_API const ImWchar*    GetGlyphRangesJapanese();               // Default + Hiragana, Katakana, Half-Width, Selection of 1946 Ideographs
	;GUI_API const ImWchar*    GetGlyphRangesChineseFull();            // Default + Half-Width + Japanese Hiragana/Katakana + full set of about 21000 CJK Unified Ideographs
	;GUI_API const ImWchar*    GetGlyphRangesChineseSimplifiedCommon();// Default + Half-Width + Japanese Hiragana/Katakana + set of 2500 CJK Unified Ideographs for common simplified Chinese
	;GUI_API const ImWchar*    GetGlyphRangesCyrillic();               // Default + about 400 Cyrillic characters
	;GUI_API const ImWchar*    GetGlyphRangesThai();                   // Default + Thai characters
	;GUI_API const ImWchar*    GetGlyphRangesVietnamese();             // Default + Vietnamese characters
	static GUICreate(title, w, h, x := -1, y := -1, style := 0, ex_style := 0, font_path := "c:/windows/fonts/simhei.ttf", font_size := 20, font_range := "GetGlyphRangesChineseFull", range_charBuf := 0)
	{
		result := DllCall("imgui\GUICreate", "wstr", title, "int", w, "int", h, "int", x, "int", y, "wstr", font_path, "float", font_size, "wstr", font_range, "ptr", range_charBuf)
		if(style != 0)
			DllCall("SetWindowLong", "Ptr", result, "Int", -16 ,"Int", style)
		if(ex_style != 0)
			DllCall("SetWindowLong", "Ptr", result, "Int", -20, "Int", ex_style)
		return result
	}
	static PeekMsg()
	{
		result := DllCall("imgui\PeekMsg")
		return result
	}

	class IO {
		__New() {
			this.__io:=DllCall("imgui\GetIO", "Cdecl Ptr")
		}
		GetIO()
		{
			return NumGet(this.__io , 0, "Int")
		}

		; 示例：io.SetIO(io.GetIO() | ImGuiConfigFlags.DockingEnable)
		SetIO(ImGuiConfigFlags)
		{
			NumPut("Int", ImGuiConfigFlags, this.__io)
		}
	}

	static GetStyle()
	{
		result := Dllcall("imgui\GetStyle", "Cdecl Ptr")
		return result
	}

	static FrameNumber:=0 , FrameTime:=0
	;  @FrameNumber 每秒运行多少次
	static BeginFrame(FrameNumber:=0)
	{
		if FrameNumber!=this.FrameNumber
		{
			this.FrameNumber:=FrameNumber
			this.FrameTime:=1000//FrameNumber
		}
		DllCall("imgui\BeginFrame", "Cdecl")
	}
	static EndFrame()
	{
		DllCall("imgui\EndFrame", "UInt", 0x004488, "Cdecl")
		Sleep(this.FrameTime)
	}

	;Style
	static StyleColorsLight()
	{
		DllCall("imgui\StyleColorsLight")
	}

	static StyleColorsDark()
	{
		DllCall("imgui\StyleColorsDark")
	}
	static StyleColorsClassic()
	{
		DllCall("imgui\StyleColorsClassic")
	}

	;window
	static Begin(title, &close_btn := 0, ImGuiWindowFlags := 0)
	{
		DllCall("imgui\Begin", "WStr", title, "Int *", &close_btn, "Int", ImGuiWindowFlags, "Cdecl")
	}
	static End()
	{
	DllCall("imgui\End", "Cdecl")
	}

	; // Child Windows
	;flags := ImGuiWindowFlags_None
	static BeginChild(text, w := 0, h := 0, border := False, ImGuiWindowFlags := 0)
	{

		result := Dllcall("imgui\BeginChild", "wstr", text, "float", w, "float", h, "int", border, "int", ImGuiWindowFlags)
		Return result
	}
	static EndChild()
	{
		Dllcall("imgui\EndChild")
	}


	static IsWindowAppearing()
	{
		result := Dllcall("imgui\IsWindowAppearing")
		Return result
	}

	static IsWindowCollapsed()
	{
		result := Dllcall("imgui\IsWindowCollapsed")
		Return result
	}

	;flags := ImGuiFocusedFlags_None
	static IsWindowFocused(ImGuiFocusedFlags := 0)
	{
		result := Dllcall("imgui\IsWindowFocused", "int", ImGuiFocusedFlags)
		Return result[0]
	}
	static IsWindowHovered(ImGuiFocusedFlags := 0)
	{
		result := Dllcall("imgui\IsWindowHovered", "int", ImGuiFocusedFlags)
		Return result[0]
	}

	static GetWindowDpiScale()
	{
		result := Dllcall("imgui\GetWindowDpiScale")
		Return result
	}

	static GetWindowViewport()
	{
		result := Dllcall("imgui\GetWindowViewport")
		return result
	}

	static GetWindowPos()
	{
		Return this.RecvImVec2("none:cdecl", "GetWindowPos")
	}

	static GetWindowSize()
	{
		Return this.RecvImVec2("none:cdecl", "GetWindowSize")
	}

	static GetWindowWidth()
	{
		result := Dllcall("imgui\GetWindowWidth")
		Return result
	}

	static GetWindowHeight()
	{
		result := Dllcall("imgui\GetWindowHeight")
		Return result
	}
	;cond := ImGuiCond_None
	static SetNextWindowPos(x, y, ImGuiCond := 0, pivot_x := 0, pivot_y := 0)
	{
		Dllcall("imgui\SetNextWindowPos", "float", x, "float", y, "int", ImGuiCond, "float", pivot_x, "float", pivot_y)
	}
	static SetNextWindowSize(x, y, ImGuiCond := 0)
	{
		Dllcall("imgui\SetNextWindowSize", "float", x, "float", y, "int", ImGuiCond)
	}
	static SetNextWindowSizeConstraints(size_min_x, size_min_y, size_max_x, size_max_y)
	{
		Dllcall("imgui\SetNextWindowSizeConstraints", "float", size_min_x, "float", size_min_y, "float", size_max_x, "float", size_max_y)
	}

	static SetNextWindowContentSize(size_x, size_y)
	{
		Dllcall("imgui\SetNextWindowContentSize", "float", size_x, "float", size_y)
	}
	static SetNextWindowCollapsed(collapsed, ImGuiCond := 0)
	{
		Dllcall("imgui\SetNextWindowCollapsed", "int", collapsed, "int", ImGuiCond)
	}
	static SetNextWindowFocus()
	{
		Dllcall("imgui\SetNextWindowFocus")
	}
	static SetNextWindowBgAlpha(alpha)
	{
		Dllcall("imgui\SetNextWindowBgAlpha", "float", alpha)
	}
	static SetNextWindowViewport(id)
	{
		Dllcall("imgui\SetNextWindowViewport", "int", id)
	}
	static SetWindowPos(pos_x, pos_y, ImGuiCond:=0)
	{
		Dllcall("imgui\SetWindowPosition", "float", pos_x, "float", pos_y, "int", ImGuiCond)
	}
	static SetWindowSize(size_x, size_y, ImGuiCond:=0)
	{
		Dllcall("imgui\SetWindowSize", "float", size_x, "float", size_y, "int", ImGuiCond)
	}

	static SetWindowCollapsed(collapsed, ImGuiCond := 0)
	{
		Dllcall("imgui\SetWindowCollapsed", "int", collapsed, "int", ImGuiCond)
	}

	static SetWindowFocus()
	{
		Dllcall("imgui\SetWindowFocus")
	}

	static SetWindowFontScale(scale)
	{
		Dllcall("imgui\SetWindowFontScale", "float", scale)
	}
	static SetWindowPosByName(name, pos_x, pos_y, ImGuiCond := 0)
	{
		Dllcall("imgui\SetWindowPosByName", "wstr", name, "float", pos_x, "float", pos_y, "int", ImGuiCond)
	}

	static SetWindowSizeByName(name, size_x, size_y, ImGuiCond := 0)
	{
		Dllcall("imgui\SetWindowSizeByName", "wstr", name, "float", size_x, "float", size_y, "int", ImGuiCond)
	}

	static SetWindowCollapsedByName(name, collapsed, ImGuiCond := 0)
	{
		result := Dllcall("imgui\SetWindowCollapsedByName", "wstr", name, "int", collapsed, "int", ImGuiCond)
		Return result
	}
	static SetWindowFocusByName(name)
	{
		Dllcall("imgui\SetWindowFocus", "wstr", name)
	}

	static RecvImVec2(return_type, func_name)
	{
		struct_x := buffer("4", 0)
		struct_y := buffer("4", 0)
		result := DllCall("imgui\" func_name, "ptr", struct_x, "ptr", struct_y)
		ret := [NumGet(struct_x, 0, "float"), NumGet(struct_y, 0, "float")]
		Return ret
	}

	static GetContentRegionMax()
	{
		Return this.RecvImVec2("none:cdecl", "GetContentRegionMax")
	}
	static GetContentRegionAvail()
	{
		Return this.RecvImVec2("none:cdecl", "GetContentRegionAvail")
	}
	static GetWindowContentRegionMin()
	{
		Return this.RecvImVec2("none:cdecl", "GetWindowContentRegionMin")
	}
	static GetWindowContentRegionMax()
	{
		Return this.RecvImVec2("none:cdecl", "GetWindowContentRegionMax")
	}
	static GetItemRectMin()
	{
		Return this.RecvImVec2("none:cdecl", "GetItemRectMin")
	}
	static GetItemRectMax()
	{
		Return this.RecvImVec2("none:cdecl", "GetItemRectMax")
	}
	static GetItemRectSize()
	{
		Return this.RecvImVec2("none:cdecl", "GetItemRectSize")
	}
	static GetMousePos()
	{
		Return this.RecvImVec2("none:cdecl", "GetMousePos")
	}
	static GetMousePosOnOpeningCurrentPopup()
	{
		Return this.RecvImVec2("none:cdecl", "GetMousePosOnOpeningCurrentPopup")
	}
	;button := ImGuiMouseButton_Left
	static GetMouseDragDelta(ImGuiMouseButton := 0, lock_threshold := -1)
	{
		struct_x := buffer(4, 0)
		struct_y := buffer(4, 0)
		result := Dllcall("imgui\GetMouseDragDelta", "int", ImGuiMouseButton, "float", lock_threshold, "ptr", struct_x,"ptr", struct_y)
		ret := [NumGet(struct_x, 0, "float"), NumGet(struct_y, 4, "float")]
		Return ret
	}

	static GetWindowContentRegionWidth()
	{
		result := Dllcall("imgui\GetWindowContentRegionWidth")
		Return result
	}
	static GetScrollX()
	{
		result := Dllcall("imgui\GetScrollX")
		Return result
	}
	static GetScrollY()
	{
		result := Dllcall("imgui\GetScrollY")
		Return result
	}
	static GetScrollMaxX()
	{
		result := Dllcall("imgui\GetScrollMaxX")
		Return result
	}
	static GetScrollMaxY()
	{
		result := Dllcall("imgui\GetScrollMaxY")
		Return result
	}
	static SetScrollX(scroll_x)
	{
		Dllcall("imgui\SetScrollX", "float", scroll_x)
	}
	static SetScrollY(scroll_y)
	{
		Dllcall("imgui\SetScrollY", "float", scroll_y)
	}
	static SetScrollHereX(center_x_ratio := 0.5)
	{
		Dllcall("imgui\SetScrollHereX", "float", center_x_ratio)
	}
	static SetScrollHereY(center_y_ratio := 0.5)
	{
		Dllcall("imgui\SetScrollHereY", "float", center_y_ratio)
	}
	static SetScrollFromPosX(local_x, center_x_ratio := 0.5)
	{
		Dllcall("imgui\SetScrollFromPosX", "float", local_x, "float", center_x_ratio)
	}
	static SetScrollFromPosY(local_y, center_y_ratio := 0.5)
	{
		Dllcall("imgui\SetScrollFromPosY", "float", local_y, "float", center_y_ratio)
	}
	static PushFont(font)
	{
		Dllcall("imgui\PushFont", "ptr", font)
	}
	static PopFont()
	{
		Dllcall("imgui\PopFont")
	}
	static PushStyleColor(idx, col)
	{
		Dllcall("imgui\PushStyleColor", "int", idx, "uint", col)
	}
	static PopStyleColor(count := 1)
	{
		Dllcall("imgui\PopStyleColor", "int", count)
	}
	static PushStyleVar(idx, val)
	{
		Dllcall("imgui\PushStyleVar", "int", idx, "float", val)
	}
	static PushStyleVarPos(idx, val_x, val_y)
	{
		Dllcall("imgui\PushStyleVarPos", "int", idx, "float", val_x, "float", val_y)
	}
	static PopStyleVar(count := 1)
	{
		Dllcall("imgui\PopStyleVar", "int", count)
	}
	static GetFont()
	{
		result := Dllcall("imgui\GetFont")
		Return result
	}
	static GetFontSize()
	{
		result := Dllcall("imgui\GetFontSize")
		Return result
	}
	static GetFontTexUvWhitePixel()
	{
		Return this.RecvImVec2("none:cdecl", "GetFontTexUvWhitePixel")
	}


	static GetColorU32(idx, alpha_mul := 1)
	{
		result := Dllcall("imgui\GetColorU32", "int", idx, "float", alpha_mul)
		Return result
	}
	static PushItemWidth(item_width)
	{
		Dllcall("imgui\PushItemWidth", "float", item_width)
	}
	static PopItemWidth()
	{
		Dllcall("imgui\PopItemWidth")
	}
	static SetNextItemWidth(item_width)
	{
		Dllcall("imgui\SetNextItemWidth", "float", item_width)
	}
	static CalcItemWidth()
	{
		result := Dllcall("imgui\CalcItemWidth")
		Return result
	}
	static PushTextWrapPos(wrap_pos_x := 0)
	{
		Dllcall("imgui\PushTextWrapPos", "float", wrap_pos_x)
	}
	static PopTextWrapPos()
	{
		Dllcall("imgui\PopTextWrapPos")
	}
	static PushAllowKeyboardFocus(allow_keyboard_focus)
	{
		Dllcall("imgui\PushAllowKeyboardFocus", "int", allow_keyboard_focus)
	}
	static PopAllowKeyboardFocus()
	{
		Dllcall("imgui\PopAllowKeyboardFocus")
	}
	static PushButtonRepeat(repeat)
	{
		Dllcall("imgui\PushButtonRepeat", "int", repeat)
	}
	static PopButtonRepeat()
	{
		Dllcall("imgui\PopButtonRepeat")
	}
	static Separator()
	{
		Dllcall("imgui\Separator")
	}
	static SameLine(offset_from_start_x := 0, spacing_w := -1)
	{
		Dllcall("imgui\SameLine", "float", offset_from_start_x, "float", spacing_w)
	}
	static NewLine()
	{
		Dllcall("imgui\NewLine")
	}
	static Spacing()
	{
		Dllcall("imgui\Spacing")
	}
	static Dummy(size_x, size_y)
	{
		Dllcall("imgui\Dummy", "float", size_x, "float", size_y)
	}
	static Indent(indent_w := 0)
	{
		Dllcall("imgui\Indent", "float", indent_w)
	}
	static Unindent(indent_w := 0)
	{
		Dllcall("imgui\Unindent", "float", indent_w)
	}
	static BeginGroup()
	{
		Dllcall("imgui\BeginGroup")
	}
	static EndGroup()
	{
		Dllcall("imgui\EndGroup")
	}
	static GetCursorPos()
	{
		Return this.RecvImVec2("none:cdecl", "GetCursorPosition")
	}
	static SetCursorPos(local_pos_x, local_pos_y)
	{
		Dllcall("imgui\SetCursorPosition", "float", local_pos_x, "float", local_pos_y)
	}
	static GetCursorPosX()
	{
		result := Dllcall("imgui\GetCursorPosX")
		Return result
	}
	static GetCursorPosY()
	{
		result := Dllcall("imgui\GetCursorPosY")
		Return result
	}
	static SetCursorPosX(x)
	{
		Dllcall("imgui\SetCursorPosX", "float", x)
	}
	static SetCursorPosY(y)
	{
		Dllcall("imgui\SetCursorPosY", "float", y)
	}
	static GetCursorStartPos()
	{
		Return this.RecvImVec2("none:cdecl", "GetCursorStartPos")
	}
	static GetCursorScreenPos()
	{
		Return this.RecvImVec2("none:cdecl", "GetCursorScreenPos")
	}
	static SetCursorScreenPos(pos_x, pos_y)
	{
		Dllcall("imgui\SetCursorScreenPos", "float", pos_x, "float", pos_y)
	}
	static AlignTextToFramePadding()
	{
		Dllcall("imgui\AlignTextToFramePadding")
	}
	static GetTextLineHeight()
	{
		result := Dllcall("imgui\GetTextLineHeight")
		Return result
	}
	static GetTextLineHeightWithSpacing()
	{
		result := Dllcall("imgui\GetTextLineHeightWithSpacing")
		Return result
	}
	static GetFrameHeight()
	{
		result := Dllcall("imgui\GetFrameHeight")
		Return result
	}
	static GetFrameHeightWithSpacing()
	{
		result := Dllcall("imgui\GetFrameHeightWithSpacing")
		Return result
	}
	static PushID(str_id)
	{
		Dllcall("imgui\PushID", "wstr", str_id)
	}
	static PopID()
	{
		Dllcall("imgui\PopID")
	}
	static GetID(str_id)
	{
		result := Dllcall("imgui\GetID", "wstr", str_id)
		Return result
	}

	static Text(text)
	{
		Dllcall("imgui\Text", "wstr", text)
	}

	static TextColored(text, color := 0xFFFFFFFF)
	{
		Dllcall("imgui\TextColored", "uint", color, "wstr", text)
	}
	static TextDisabled(text)
	{
		Dllcall("imgui\TextDisabled", "wstr", text)
	}
	static TextWrapped(text)
	{
		Dllcall("imgui\TextWrapped", "wstr", text)
	}
	static LabelText(label, text)
	{
		Dllcall("imgui\LabelText", "wstr", label, "wstr", text)
	}

	static BulletText(text)
	{
		Dllcall("imgui\BulletText", "wstr", text)
	}
	static Button(text, w := 0, h := 0)
	{
		result := DllCall("imgui\Button", "wstr", text, "float", w, "float", h)
		return result
	}

	static SmallButton(label)
	{
		result := Dllcall("imgui\SmallButton", "wstr", label)
		Return result
	}
	static InvisibleButton(str_id, size_x, size_y)
	{
		result := Dllcall("imgui\InvisibleButton", "wstr", str_id, "float", size_x, "float", size_y)
		Return result
	}
	;ImGuiDir_Up
	static ArrowButton(str_id, ImGuiDir := 2)
	{
		result := DllCall("imgui\ArrowButton", "wstr", str_id, "int", ImGuiDir)
		Return result
	}
	static Image(user_texture_id, size_x, size_y, uv0_x := 0, uv0_y := 0, uv1_x := 1, uv1_y := 1, tint_col := 0xFFFFFFFF, border_col := 0)
	{
		Dllcall("imgui\Image", "int", user_texture_id, "float", size_x, "float", size_y, "float", uv0_x, "float", uv0_y, "float", uv1_x, "float", uv1_y, "uint", tint_col, "uint", border_col)
	}

	static ImageButton(user_texture_id, size_x, size_y, uv0_x := 0, uv0_y := 0, uv1_x := 1, uv1_y := 1, frame_padding := -1, bg_col := 0, tint_col := 0xFFFFFFFF)
	{
		result := DllCall("imgui\ImageButton", "int", user_texture_id, "float", size_x, "float", size_y, "float", uv0_x, "float", uv0_y, "float", uv1_x, "float", uv1_y, "int", frame_padding, "uint", bg_col, "uint", tint_col)
		return result
	}
	static CheckBox(text, &active)
	{
		b_active := buffer(4, 0)
		NumPut("Int", active, b_active)
		result := DllCall("imgui\Checkbox", "wstr", text, "ptr", b_active)
		active := NumGet(b_active, 0, "Int")
		return result
	}

	static CheckboxFlags(label, &flags, flags_value)
	{
		struct_flags := buffer(4, 0)
		NumPut("UInt", flags, struct_flags)
		result := Dllcall("imgui\CheckboxFlags", "wstr", label, "ptr", struct_flags, "uint", flags_value)
		flags := Numget(struct_flags, 0, "uint")
		Return result
	}
	static RadioButton(label, &v, v_button)
	{
		struct_v := buffer(4, 0)
		NumPut("Int", v, struct_v)
		result := DllCall("imgui\RadioButton", "wstr", label, "ptr", struct_v, "int", v_button)
		v := NumGet(struct_v, 0, "Int")
		return result
	}

	static ProgressBar(fraction, size_arg_x := -1, size_arg_y := 0, overlay := "")
	{
		Dllcall("imgui\ProgressBar", "float", fraction, "float", size_arg_x, "float", size_arg_y, "wstr", overlay)
	}
	static Bullet()
	{
		Dllcall("imgui\Bullet")
	}
	;flags := ImGuiComboFlags_None
	static BeginCombo(label, preview_value, ImGuiComboFlags := 0)
	{
		result := Dllcall("imgui\BeginCombo", "wstr", label, "wstr", preview_value, "int", ImGuiComboFlags)
		Return result
	}
	static EndCombo()
	{
		Dllcall("imgui\EndCombo")
	}


	static SetStyleColor(index, color := 0xFFFFFFFF)
	{
		Dllcall("imgui\SetStyleColor", "int", index, "uint", color)
	}
	;flags := ImGuiSelectableFlags_None
	static Selectable(label, selected := False, ImGuiSelectableFlags := 0, size_arg_x := 0, size_arg_y := 0)
	{
		result := Dllcall("imgui\Selectable", "wstr", label, "int", selected, "int", ImGuiSelectableFlags, "float", size_arg_x, "float", size_arg_y)
		Return result
	}
	static Columns(columns_count := 1, id := "", border := true)
	{
		Dllcall("imgui\Columns", "int", columns_count, "wstr", id, "int", border)
	}
	static NextColumn()
	{
		Dllcall("imgui\NextColumn")
	}
	static GetColumnIndex()
	{
		result := Dllcall("imgui\GetColumnIndex")
		Return result
	}
	static GetColumnWidth(column_index := -1)
	{
		result := Dllcall("imgui\GetColumnWidth", "int", column_index)
		Return result
	}
	static SetColumnWidth(column_index, width)
	{
		Dllcall("imgui\SetColumnWidth", "int", column_index, "float", width)
	}
	static GetColumnOffset(column_index := -1)
	{
		result := Dllcall("imgui\GetColumnOffset", "int", column_index)
		Return result
	}
	static SetColumnOffset(column_index, offset)
	{
		Dllcall("imgui\SetColumnOffset", "int", column_index, "float", offset)
	}
	static GetColumnsCount()
	{
		result := Dllcall("imgui\GetColumnsCount")
		Return result
	}
	static DragFloat(label, &v, v_speed := 1, v_min := 0, v_max := 0, format := "%3.f", power := 1)
	{
		struct_v := buffer(4, 0)
		numput("float", v, struct_v)
		result := Dllcall("imgui\DragFloat", "wstr", label, "ptr", struct_v, "float", v_speed, "float", v_min, "float", v_max, "wstr", format, "float", power)
		v := numget(struct_v, 0, "float")
		Return result
	}
	static DragFloat2(label, v, v_speed := 1, v_min := 0, v_max := 0, format := "%.3f", power := 1)
	{
		Return this.DragFloatN(2, label, v, v_speed, v_min, v_max, format, power)
	}
	static DragFloat3(label, v, v_speed := 1, v_min := 0, v_max := 0, format := "%.3f", power := 1)
	{
		Return this.DragFloatN(3, label, v, v_speed, v_min, v_max, format, power)
	}
	static DragFloat4(label, v, v_speed := 1, v_min := 0, v_max := 0, format := "%.3f", power := 1)
	{
		Return this.DragFloatN(4, label, v, v_speed, v_min, v_max, format, power)
	}

	static DragFloatN(n, label, &v, v_speed, v_min, v_max, format, power)
	{
		if(n < 2 || n > 4 || v.Length < n)
			return false
		struct_value := buffer(4 * n, 0)
		loop(n)
			numput("float", v[A_Index], struct_value, (a_index -1) * 4)
		result := Dllcall("imgui\DragFloatN"
			"int", n
			"wstr", label
			"ptr", struct_value
			"float", v_speed
			"float", v_min
			"float", v_max
			"wstr", format
			"float", power
		)
		loop(n)
			v[A_Index] := numget(struct_value, (a_index - 1) * 4, "float")
		Return result
	}


	static DragFloatRange2(label, &v_current_min, &v_current_max, v_speed := 1, v_min := 0, v_max := 0, format := "%.3f", format_max := "", power := 1)
	{
		struct_v_current_min := buffer(4, 0)
		numput("float", v_current_min, struct_v_current_min)
		struct_v_current_max := buffer(4, 0)
		numput("float", v_current_max, struct_v_current_max)
		result := Dllcall("imgui\DragFloatRange2", "wstr", label, "ptr", struct_v_current_min, "ptr", struct_v_current_max, "float", v_speed, "float", v_min, "float", v_max, "wstr", format, "wstr", format_max, "float", power)
		v_current_min := numget(struct_v_current_min, 0, "float")
		v_current_max := numget(struct_v_current_max, 0, "float")
		Return result
	}

	static DragInt(label, &v, v_speed := 1, v_min := 0, v_max := 0, format := "%d")
	{
		struct_v := buffer(4, 0)
		numput("int", v, struct_v)
		result := Dllcall("imgui\DragInt", "wstr", label, "ptr", struct_v, "float", v_speed, "int", v_min, "int", v_max, "wstr", format)
		v := numget(struct_v, 0, "int")
		Return result
	}
	static DragInt2(label, &v, v_speed := 1, v_min := 0, v_max := 0, format :="%d")
	{
		this.DragIntN(2, label, v, v_speed, v_min, v_max, format)
	}
	static DragInt3(label, &v, v_speed := 1, v_min := 0, v_max := 0, format :="%d")
	{
		this.DragIntN(3, label, v, v_speed, v_min, v_max, format)
	}
	static DragInt4(label, &v, v_speed := 1, v_min := 0, v_max := 0, format :="%d")
	{
		this.DragIntN(4, label, v, v_speed, v_min, v_max, format)
	}
	static DragIntN(n, label, &v, v_speed, v_min, v_max, format)
	{
		if(n < 2 || n > 4 || v.Length < n)
			return false
		struct_value := buffer(4 * n, 0)
		loop(n)
			numput("int", v[A_Index], struct_value, (a_index -1) * 4)
		result := Dllcall("imgui\DragIntN",
			"int", n,
			"wstr", label,
			"ptr", struct_value,
			"float", v_speed,
			"int", v_min,
			"int", v_max,
			"wstr", format
		)
		loop(n)
			v[A_Index] := numget(struct_value, (a_index - 1) * 4, "int")
		Return result
	}

	static DragIntRange2(label, &v_current_min, &v_current_max, v_speed := 1, v_min := 0, v_max := 0, format := "%.3f", format_max := "")
	{
		struct_v_current_min := buffer(4, 0)
		numput("int", v_current_min, struct_v_current_min)
		struct_v_current_max := buffer(4, 0)
		numput("int", v_current_max, struct_v_current_max)
		result := Dllcall("imgui\DragIntRange2", "wstr", label, "ptr", struct_v_current_min, "ptr", struct_v_current_max, "float", v_speed, "int", v_min, "int", v_max, "wstr", format, "wstr", format_max)
		v_current_min := numget(struct_v_current_min, 0, "int")
		v_current_max := numget(struct_v_current_max, 0, "int")
		Return result
	}

	static SliderFloat(text, &value, v_min, v_max, format := "%.3f", power := 1)
	{
		struct := buffer(4, 0)
		numput("float", value, struct)
		result := Dllcall("imgui\SliderFloat", "wstr", text, "ptr", struct, "float", v_min, "float", v_max, "wstr", format, "float", power)
		value := numget(struct, 0, "float")
		Return result
	}


	static SliderFloat2(label, &v, v_min, v_max, format := "%.3f", power := 1)
	{
		this.SliderFloatN(2, label, v, v_min, v_max, format, power)
	}
	static SliderFloat3(label, &v, v_min, v_max, format := "%.3f", power := 1)
	{
		this.SliderFloatN(3, label, v, v_min, v_max, format, power)
	}
	static SliderFloat4(label, &v, v_min, v_max, format := "%.3f", power := 1)
	{
		this.SliderFloatN(4, label, v, v_min, v_max, format, power)
	}

	static SliderFloatN(n, label, &v, v_min, v_max, format, power)
	{
		if(n < 2 || n > 4 || v.Length < n)
			return false
		struct_value := buffer(4 * n, 0)
		loop(n)
			numput("float", v[A_Index], struct_value, (a_index -1) * 4)
		result := Dllcall("imgui\SliderFloatN",
			"int", n,
			"wstr", label,
			"ptr", struct_value,
			"float", v_min,
			"float", v_max,
			"wstr", format,
			"float", power
		)
		loop(n)
			v[A_Index] := numget(struct_value, (a_index - 1) * 4, "float")
		Return result
	}

	static SliderInt(label, &v, v_min, v_max, format := "%d")
	{
		struct := buffer(4, 0)
		numput("int", v, struct)
		result := Dllcall("imgui\SliderInt", "wstr", label, "ptr", struct, "int", v_min, "int", v_max, "wstr", format)
		v := numget(struct, 0, "int")
		Return result
	}

	static SliderInt2(label, &v, v_min, v_max, format := "%d")
	{
		return this.SliderIntN(2, label, &v, v_min, v_max, format)
	}
	static SliderInt3(label, &v, v_min, v_max, format := "%d")
	{
		return this.SliderIntN(3, label, &v, v_min, v_max, format)
	}
	static SliderInt4(label, &v, v_min, v_max, format := "%d")
	{
		return this.SliderIntN(4, label, &v, v_min, v_max, format)
	}

	static SliderIntN(n, label, &v, v_min, v_max, format)
	{
		if(n < 2 || n > 4 || v.Length < n)
			return false
		struct_value := buffer(4 * n, 0)
		loop(n)
			numput("int", v[A_Index], struct_value, (a_index -1) * 4)
		result := Dllcall("imgui\SliderIntN",
			"int", n,
			"wstr", label,
			"ptr",struct_value,
			"int", v_min,
			"int", v_max,
			"wstr", format
		)
		loop(n)
			v[A_Index] := numget(struct_value, (a_index - 1) * 4, "int")
		Return result
	}

	static SliderAngle(label, &v_rad, v_degrees_min := -360, v_degrees_max := 360, format := "%.0f deg")
	{
		struct_v_rad := buffer(4, 0)
		numput("float", v_rad, struct_v_rad)
		result := Dllcall("imgui\SliderAngle", "wstr", label, "ptr", struct_v_rad, "float", v_degrees_min, "float", v_degrees_max, "wstr", format)
		v_rad := numget(struct_v_rad, 0, "float")
		Return result
	}
	static VSliderFloat(label, size_x, size_y, &v, v_min, v_max, format := "%.3f", power := 1)
	{
		struct_v := buffer(4, 0)
		numput("float", v, struct_v)
		result := Dllcall("imgui\VSliderFloat", "wstr", label, "float", size_x, "float", size_y, "ptr", struct_v, "float", v_min, "float", v_max, "wstr", format, "float", power)
		v := numget(struct_v, 0, "float")
		Return result
	}

	static VSliderInt(label, size_x, size_y, &v, v_min, v_max, format := "%d")
	{
		struct_v := buffer(4, 0)
		numput("int", v, struct_v)
		result := Dllcall("imgui\VSliderInt", "wstr", label, "float", size_x, "float", size_y, "ptr", struct_v, "int", v_min, "int", v_max, "wstr", format)
		v := numget(struct_v, 0, "int")
		Return result
	}
	;flags := ImGuiInputTextFlags_None := 0
	static InputText(label, &buf, ImGuiInputTextFlags := 0, buf_size := 128000, call_back := 0)
	{
		struct_buf := Buffer(buf_size, 0)
		StrPut(buf, struct_buf)
		result := Dllcall("imgui\InputText", "wstr", label, "ptr", struct_buf, "int", buf_size, "int", ImGuiInputTextFlags, "ptr", call_back, "ptr", 0)
		buf := StrGet(struct_buf, 10240)
		Return result
	}
	
	static InputTextMultiline(label, &buf, size_x := 0, size_y := 0, flags := 0, buf_size := 128000)
	{
		struct_buf := Buffer(buf_size, 0)
		StrPut(buf, struct_buf)
		result := Dllcall("imgui\InputTextMultiline", "wstr", label, "ptr", struct_buf, "int", buf_size, "float", size_x, "float", size_y, "int", flags, "ptr", 0, "ptr", 0)
		buf := StrGet(struct_buf, 10240)
		Return result
	}

	static InputTextWithHint(label, hint, &buf, flags := 0, buf_size := 128000)
	{
		struct_buf := Buffer(buf_size, 0)
		StrPut(buf, struct_buf)
		result := DllCall("imgui\InputTextWithHint", "wstr", label, "wstr", hint, "ptr", struct_buf, "int", buf_size, "int", flags)
		buf := StrGet(struct_buf, 10240)
	}


	static InputFloat(label, &v, step := 0, step_fast := 0, format := "%.3f", flags := 0)
	{
		struct_v := buffer(4, 0)
		numput("float", v, struct_v)
		result := Dllcall("imgui\InputFloat", "wstr", label, "ptr", struct_v, "float", step, "float", step_fast, "wstr", format, "int", flags)
		v := numget(struct_v, 0, "float")
		Return result
	}

	static InputFloat2(label, &v, format := "%.3f", flags := 0)
	{
		this.InputFloatN(2, label, v, format, flags)
	}
	static InputFloat3(label, &v, format := "%.3f", flags := 0)
	{
		this.InputFloatN(3, label, v, format, flags)
	}
	static InputFloat4(label, &v, format := "%.3f", flags := 0)
	{
		this.InputFloatN(4, label, v, format, flags)
	}
	static InputFloatN(n, label, &v, format, flags)
	{
		if(n < 2 || n > 4 || v.Length < n)
			return false
		struct_value := buffer(4 * n, 0)
		loop(n)
			numput("float", v[A_Index], struct_value, (a_index -1) * 4)
		result := Dllcall("imgui\InputFloatN",
			"int", n,
			"wstr", label,
			"ptr", struct_value,
			"wstr", format,
			"int", flags
		)
		loop(n)
			v[A_Index] := numget(struct_value, (a_index - 1) * 4, "float")
		Return result
	}

	;flags := ImGuiInputTextFlags_None := 0
	static InputInt(label, &v, step := 1, step_fast := 100, ImGuiInputTextFlags := 0)
	{
		struct_v := buffer(4, 0)
		numput("int", v, struct_v)
		result := Dllcall("imgui\InputInt", "wstr", label, "ptr", struct_v, "int", step, "int", step_fast, "int", ImGuiInputTextFlags)
		v := numget(struct_v, 0, "int")
		Return result
	}

	static InputInt2(label, &v, ImGuiInputTextFlags := 0)
	{
		this.InputIntN(2, label, v, ImGuiInputTextFlags := 0)
	}
	static InputInt3(label, &v, ImGuiInputTextFlags := 0)
	{
		this.InputIntN(3, label, v, ImGuiInputTextFlags := 0)
	}
	static InputInt4(label, &v, ImGuiInputTextFlags := 0)
	{
		this.InputIntN(4, label, v, ImGuiInputTextFlags)
	}

	static InputIntN(n, label, &v, ImGuiInputTextFlags)
	{
		if(n < 2 || n > 4 || v.Length < n)
			return false
		struct_value := buffer(4 * n, 0)
		loop(n)
			numput("int", v[A_Index], struct_value, (a_index -1) * 4)
		result := Dllcall("imgui\InputIntN",
			"int", n,
			"wstr", label,
			"ptr", struct_value,
			"int", ImGuiInputTextFlags
		)
		loop(n)
			v[A_Index] := numget(struct_value, (a_index - 1) * 4, "int")
		Return result
	}
	static InputDouble(label, &v, step := 0, step_fast := 0, format := "%.6f", ImGuiInputTextFlags := 0)
	{
		struct_v := buffer(8, 0)
		numput("double", v, struct_v)
		result := Dllcall("imgui\InputDouble", "wstr", label, "ptr", struct_v, "double", step, "double", step_fast, "wstr", format, "int", ImGuiInputTextFlags)
		v := numget(struct_v, 0, "double")
		Return result
	}
	;flags := ImGuiColorEditFlags_None 0
	static ColorEdit(label, &color, ImGuiColorEditFlags := 0)
	{
		struct_v := buffer(4, 0)
		numput("uint", color, struct_v)
		result := Dllcall("imgui\ColorEdit", "wstr", label, "ptr", struct_v, "int", ImGuiColorEditFlags)
		color := numget(struct_v, 0, "uint")
		Return result
	}
	static ColorPicker(label, &color, ImGuiColorEditFlags := 0)
	{
		struct_v := buffer(4, 0)
		numput("uint", color, struct_v)
		result := Dllcall("imgui\ColorPicker", "wstr", label, "ptr", struct_v, "int", ImGuiColorEditFlags)
		color := numget(struct_v, 0, "uint")
		Return result
	}
	static TreeNode(label)
	{
		result := Dllcall("imgui\TreeNode", "wstr", label)
		Return result
	}
	;flags := ImGuiTreeNodeFlags_None 0
	static TreeNodeEx(label, ImGuiTreeNodeFlags := 0)
	{
		result := Dllcall("imgui\TreeNodeEx", "wstr", label, "int", ImGuiTreeNodeFlags)
		Return result
	}
	static TreePush(str_id)
	{
		Dllcall("imgui\TreePush", "wstr", str_id)
	}
	static TreePop()
	{
		Dllcall("imgui\TreePop")
	}
	static GetTreeNodeToLabelSpacing()
	{
		result := Dllcall("imgui\GetTreeNodeToLabelSpacing")
		Return result
	}
	static CollapsingHeader(label, flags := 0)
	{
		result := Dllcall("imgui\CollapsingHeader", "wstr", label, "int", flags)
		Return result
	}
	static CollapsingHeaderEx(label, &p_open, flags := 0)
	{
		struct_p_open := buffer(4, 0)
		numput("int", p_open, struct_p_open)
		result := Dllcall("imgui\CollapsingHeaderEx", "wstr", label, "ptr", struct_p_open, "int", flags)
		p_open := numget(struct_p_open, 0, "int")
		Return result
	}
	;cond := ImGuiCond_None 0
	static SetNextItemOpen(is_open, cond := 0)
	{
		Dllcall("imgui\SetNextItemOpen", "int", is_open, "int", cond)
	}
	;item string 数组
	; 返回包含字符串的缓冲对象.
	static StrBuf(str, encoding)
	{
		; 计算所需的大小并分配缓冲.
		buf := Buffer(StrPut(str, encoding))
		; 复制或转换字符串.
		StrPut(str, buf, encoding)
		return buf
	}
	static ListBox(label, &current_item, items, height_items := -1)
	{
		if(Type(items) != "Array")
			return False
		items_count := items.Length

		struct_current_item := buffer(4, 0)
		numput("int", current_item, struct_current_item)

		struct_item_count := buffer(4 * (items_count + 1), 0)
		numput("int", items_count , struct_item_count)

		loop(items_count)
		{
			len := StrLen(items[a_index]) + 1
			NumPut("int", len, struct_item_count,  4 * a_index)
		}
		all_str := ""
		for k,v in items
			all_str .= v . chr(0)
		struct_item := this.StrBuf(all_str, "UTF-16")
		;strcut_current_item out 当前index
		;strcut_item 字符串数组 每个item包含的字符串
		;strcut_item_count int 数组
		;[0] 总个数,  [1]-[n] 每个的个数
		result := Dllcall("imgui\ListBox", "wstr", label, "ptr", struct_current_item, "ptr", struct_item, "ptr", struct_item_count, "int", height_items)
		current_item := NumGet(struct_current_item, 0, "Int")
		Return result
	}

	static ListBoxHeader(label, size_arg_x := 0, size_arg_y := 0)
	{
		result := Dllcall("imgui\ListBoxHeader", "wstr", label, "float", size_arg_x, "float", size_arg_y)
		Return result
	}
	static ListBoxHeaderEx(label, items_count, height_in_items := -1)
	{
		result := Dllcall("imgui\ListBoxHeaderEx", "wstr", label, "int", items_count, "int", height_in_items)
		Return result
	}
	static ListBoxFooter()
	{
		Dllcall("imgui\ListBoxFooter")
	}

	static PlotLines(label, values, values_offset := 0, overlay_text := "", scale_min := 3.402823466e+38, scale_max := 3.402823466e+38, graph_size_x := 0, graph_size_y := 0, stride := 4)
	{
		if(Type(values) != "Array")
			return False
		count := values.Length
		If values_offset >= count
			values_offset := Mod(values_offset, count)
		struct_values := buffer(4 * count)

		loop(count)
		{
			NumPut("float", values[a_index], struct_values, (a_index - 1) * 4)
		}
		DllCall("imgui\PlotLines", "wstr", label, "ptr", struct_values, "int",
			count, "int", values_offset, "wstr", overlay_text, "float", scale_min, "float", scale_max,
			"float", graph_size_x, "float", graph_size_y, "int", stride)
	}
	;scale_min := FLT_MAX         				          :=  3.402823466e+38
	;scale_max := FLT_MAX
	static PlotHistogram(label, values, values_offset := 0, overlay_text := "", scale_min := 3.402823466e+38, scale_max := 3.402823466e+38, graph_size_x := 0, graph_size_y := 0, stride := 4)
	{
		if(Type(values) != "Array")
			return False
		count := values.Length
		if( values_offset >= count)
			values_offset := Mod(values_offset, count)
		struct_values := buffer(4 * count, 0)
		loop(count)
			numput("float", values[A_Index], struct_values, (a_index -1) * 4)
		Dllcall("imgui\PlotHistogram", "wstr", label, "ptr", struct_values, "int", count, "int", values_offset, "wstr", overlay_text, "float", scale_min, "float", scale_max, "float", graph_size_x, "float", graph_size_y, "int", stride)
	}

	static ValueBool(prefix, b)
	{
		Dllcall("imgui\ValueBool", "wstr", prefix, "int", b)
	}
	static ValueInt(prefix, v)
	{
		Dllcall("imgui\ValueInt", "wstr", prefix, "int", v)
	}
	static ValueFloat(prefix, v, float_format := "")
	{
		Dllcall("imgui\ValueFloat", "wstr", prefix, "float", v, "wstr", float_format)
	}

	static BeginMenuBar()
	{
		result := Dllcall("imgui\BeginMenuBar")
		Return result
	}
	static EndMenuBar()
	{
		Dllcall("imgui\EndMenuBar")
	}
	static BeginMainMenuBar()
	{
		result := Dllcall("imgui\BeginMainMenuBar")
		Return result
	}
	static EndMainMenuBar()
	{
		Dllcall("imgui\EndMainMenuBar")
	}
	static BeginMenu(label, enabled := True)
	{
		result := Dllcall("imgui\BeginMenu", "wstr", label, "int", enabled)
		Return result
	}
	static EndMenu()
	{
		Dllcall("imgui\EndMenu_")
	}
	static MenuItem(label, shortcut := "", selected := False, enabled := True)
	{
		result := Dllcall("imgui\MenuItem", "wstr", label, "wstr", shortcut, "int", selected, "int", enabled)
		Return result
	}


	static MenuItemEx(label, shortcut, &p_selected, enabled := True)
	{
		struct_p_selected := buffer(4, 0)
		numput("int", p_selected, struct_p_selected)
		result := Dllcall("imgui\MenuItemEx", "wstr", label, "wstr", shortcut, "ptr", struct_p_selected, "int", enabled)
		p_selected := numget(struct_p_selected, 0, "int")
		Return result
	}
	
	static ShowDemoWindow()
	{
		Dllcall("imgui\ShowDemoWindow")
	}
	static ToolTip(text)
	{
		this.BeginTooltip()
		this.Text(text)
		this.EndTooltip()
	}
	static BeginTooltip(){
		Dllcall("imgui\BeginTooltip")
	}
	static EndTooltip()
	{
		Dllcall("imgui\EndTooltip")
	}
	static SetTooltip(text)
	{
		Dllcall("imgui\SetTooltip", "wstr", text)
	}
	;flags := ImGuiWindowFlags_None
	static BeginPopup(str_id, flags := 0)
	{
		result := Dllcall("imgui\BeginPopup", "wstr", str_id, "int", flags)
		Return result
	}

	static BeginPopupModal(name, flags := 0)
	{

		result := Dllcall("imgui\BeginPopupModal", "wstr", name, "ptr", 0, "int", flags)
		Return result
	}

	static BeginPopupModalEx(name, &p_open, flags := 0)
	{
		struct_p_open := buffer(4, 0)
		numput("int", p_open, struct_p_open)
		result := Dllcall("imgui\BeginPopupModal", "wstr", name, "ptr", struct_p_open, "int", flags)
		p_open := numget(struct_p_open, 0, "int")
		Return result
	}

	static EndPopup()
	{
		Dllcall("imgui\EndPopup")
	}
	;popup_flags := ImGuiPopupFlags_MouseButtonLeft         :=  0
	static OpenPopup(str_id, ImGuiPopupFlags := 0)
	{
		Dllcall("imgui\OpenPopup", "wstr", str_id, "int", ImGuiPopupFlags)
	}
	static OpenPopupContextItem(str_id := "", ImGuiPopupFlags := 0)
	{
		result := Dllcall("imgui\OpenPopupContextItem", "wstr", str_id, "int", ImGuiPopupFlags)
		Return result
	}
	static CloseCurrentPopup()
	{
		Dllcall("imgui\CloseCurrentPopup")
	}
	static BeginPopupContextItem(str_id := "", popup_flags := 0)
	{
		result := Dllcall("imgui\BeginPopupContextItem", "wstr", str_id, "int", popup_flags)
		Return result
	}
	static BeginPopupContextWindow(str_id := "", popup_flags := 0)
	{
		result := Dllcall("imgui\BeginPopupContextWindow", "wstr", str_id, "int", popup_flags)
		Return result
	}
	static BeginPopupContextVoid(str_id := "", popup_flags := 0)
	{
		result := Dllcall("imgui\BeginPopupContextVoid", "wstr", str_id, "int", popup_flags)
		Return result
	}
	;popup_flags := ImGuiPopupFlags_None                    :=  0
	static IsPopupOpen(str_id, ImGuiPopupFlags := 0)
	{
		result := Dllcall("imgui\IsPopupOpen", "wstr", str_id, "int", ImGuiPopupFlags)
		Return result
	}
	;flags := ImGuiTabBarFlags_None                           :=  0
	static BeginTabBar(str_id, ImGuiTabBarFlags := 0){
		result := Dllcall("imgui\BeginTabBar", "wstr", str_id, "int", ImGuiTabBarFlags)
		Return result
	}
	static EndTabBar()
	{
		Dllcall("imgui\EndTabBar")
	}

	;flags := ImGuiTabItemFlags_None                          :=  0
	static BeginTabItemEx(label, &p_open, ImGuiTabItemFlags := 0)
	{
		struct_p_open := buffer(4, 0)
		numput("float", p_open, struct_p_open)
		result := Dllcall("imgui\BeginTabItem", "wstr", label, "ptr", struct_p_open, "int", ImGuiTabItemFlags)
		p_open := numget(struct_p_open, 0, "int")
		Return result
	}

	static BeginTabItem(label, ImGuiTabItemFlags := 0)
	{
		result := Dllcall("imgui\BeginTabItem", "wstr", label, "ptr", 0, "int", ImGuiTabItemFlags)
		Return result
	}
	
	static EndTabItem(){
		Dllcall("imgui\EndTabItem")
	}
	static SetTabItemClosed(label)
	{
		Dllcall("imgui\SetTabItemClosed", "wstr", label)
	}
	;flags := ImGuiDockNodeFlags_None                         :=  0
	static DockSpace(id, size_arg_x := 0, size_arg_y := 0, ImGuiDockNodeFlags := 0)
	{
		Dllcall("imgui\DockSpace", "int", id, "float", size_arg_x, "float", size_arg_y, "int", ImGuiDockNodeFlags)
	}
	;f
	static DockSpaceOverViewport(viewport := 0, dockspace_flags := 0)
	{
		result := Dllcall("imgui\DockSpaceOverViewport", "ptr", viewport, "int", dockspace_flags)
		Return result
	}
	;cond := ImGuiCond_None 0
	static SetNextWindowDockID(id, ImGuiCond := 0)
	{
		Dllcall("imgui\SetNextWindowDockID", "int", id, "int", ImGuiCond)
	}
	static SetNextWindowClass(window_class)
	{
		Dllcall("imgui\SetNextWindowClass", "ptr", window_class)
	}
	static GetWindowDockID()
	{
		result := Dllcall("imgui\GetWindowDockID")
		Return result
	}
	static IsWindowDocked()
	{
		result := Dllcall("imgui\IsWindowDocked")
		Return result
	}
	;flags := ImGuiDragDropFlags_None                         :=  0
	static BeginDragDropSource(ImGuiDragDropFlags := 0)
	{
		result := Dllcall("imgui\BeginDragDropSource", "int", ImGuiDragDropFlags)
		Return result
	}
	static PushClipRect(clip_rect_min_x, clip_rect_min_y, clip_rect_max_x, clip_rect_max_y, intersect_with_current_clip_rect)
	{
		Dllcall("imgui\PushClipRect", "float", clip_rect_min_x, "float", clip_rect_min_y, "float", clip_rect_max_x, "float", clip_rect_max_y, "int", intersect_with_current_clip_rect)
	}
	static PopClipRect()
	{
		Dllcall("imgui\PopClipRect")
	}
	static SetItemDefaultFocus()
	{
		Dllcall("imgui\SetItemDefaultFocus")
	}
	static SetKeyboardFocusHere(offset := 0)
	{
		Dllcall("imgui\SetKeyboardFocusHere", "int", offset)
	}
	;flags := ImGuiHoveredFlags_None                          :=  0
	static IsItemHovered(ImGuiHoveredFlags := 0)
	{
		result := Dllcall("imgui\IsItemHovered", "int", ImGuiHoveredFlags)
		Return result
	}
	static IsItemActive()
	{
		result := Dllcall("imgui\IsItemActive")
		Return result
	}
	static IsItemFocused()
	{
		result := Dllcall("imgui\IsItemFocused")
		Return result
	}
	static IsItemVisible()
	{
		result := Dllcall("imgui\IsItemVisible")
		Return result
	}
	static IsItemEdited()
	{
		result := Dllcall("imgui\IsItemEdited")
		Return result
	}
	static IsItemActivated()
	{
		result := Dllcall("imgui\IsItemActivated")
		Return result
	}
	static IsItemDeactivated()
	{
		result := Dllcall("imgui\IsItemDeactivated")
		Return result
	}
	static IsItemDeactivatedAfterEdit()
	{
		result := Dllcall("imgui\IsItemDeactivatedAfterEdit")
		Return result
	}
	static IsItemToggledOpen()
	{
		result := Dllcall("imgui\IsItemToggledOpen")
		Return result
	}
	static IsAnyItemHovered()
	{
		result := Dllcall("imgui\IsAnyItemHovered")
		Return result
	}
	static IsAnyItemActive()
	{
		result := Dllcall("imgui\IsAnyItemActive")
		Return result
	}
	static IsAnyItemFocused()
	{
		result := Dllcall("imgui\IsAnyItemFocused")
		Return result
	}
	static SetItemAllowOverlap()
	{
		Dllcall("imgui\SetItemAllowOverlap")
	}
	;mouse_button := ImGuiMouseButton_Left
	static IsItemClicked(ImGuiMouseButton := 0)
	{
		result := Dllcall("imgui\IsItemClicked", "int", ImGuiMouseButton)
		Return result
	}
	static IsRectVisible(size_x, size_y)
	{
		result := Dllcall("imgui\IsRectVisible", "float", size_x, "float", size_y)
		Return result
	}
	static IsRectVisibleEx(rect_min_x, rect_min_y, rect_max_x, rect_max_y)
	{
		result := Dllcall("imgui\IsRectVisibleEx", "float", rect_min_x, "float", rect_min_y, "float", rect_max_x, "float", rect_max_y)
		Return result
	}
	static GetTime()
	{
		result := Dllcall("imgui\GetTime")
		Return result
	}
	static GetFrameCount()
	{
		result := Dllcall("imgui\GetFrameCount")
		Return result
	}
	;flags := ImGuiWindowFlags_None
	static BeginChildFrame(id, size_x, size_y, ImGuiWindowFlags := 0)
	{
		result := Dllcall("imgui\BeginChildFrame", "int", id, "float", size_x, "float", size_y, "int", ImGuiWindowFlags)
		Return result
	}
	static EndChildFrame()
	{
		Dllcall("imgui\EndChildFrame")
	}
	static CalcTextSize(text, hide_text_after_double_hash := false, wrap_width := -1)
	{
		struct_x := buffer(4, 0)
		struct_y := buffer(4, 0)
		result := Dllcall("imgui\CalcTextSize", "wstr", text, "int", hide_text_after_double_hash, "float", wrap_width, "ptr", struct_x, "ptr", struct_y)
		ret := [NumGet(struct_x, 0, "float"), NumGet(struct_y, 0, "float")]
		Return ret
	}

	static GetKeyIndex(ImguiKey)
	{
		result := Dllcall("imgui\GetKeyIndex", "int", ImguiKey)
		Return result
	}
	static IsKeyDown(user_key_index)
	{
		result := Dllcall("imgui\IsKeyDown", "int", user_key_index)
		Return result
	}
	static IsKeyPressed(user_key_index, repeat := true)
	{
		result := Dllcall("imgui\IsKeyPressed", "int", user_key_index, "int", repeat)
		Return result
	}
	static IsKeyReleased(user_key_index)
	{
		result := Dllcall("imgui\IsKeyReleased", "int", user_key_index)
		Return result
	}
	static GetKeyPressedAmount(key_index, repeat_delay, repeat_rate)
	{
		result := Dllcall("imgui\GetKeyPressedAmount", "int", key_index, "float", repeat_delay, "float", repeat_rate)
		Return result
	}
	static CaptureKeyboardFromApp(capture)
	{
		Dllcall("imgui\CaptureKeyboardFromApp", "int", capture)
	}
	;mouse_button := ImGuiMouseButton_Left
	static IsMouseDown(ImGuiMouseButton := 0)
	{
		result := Dllcall("imgui\IsMouseDown", "int", ImGuiMouseButton)
		Return result
	}
	static IsMouseClicked(ImGuiMouseButton := 0, repeat := False)
	{
		result := Dllcall("imgui\IsMouseClicked", "int", ImGuiMouseButton, "int", repeat)
		Return result
	}
	static IsMouseReleased(ImGuiMouseButton := 0)
	{
		result := Dllcall("imgui\IsMouseReleased", "int", ImGuiMouseButton)
		Return result
	}
	static IsMouseHoveringRect(r_min_x, r_min_y, r_max_x, r_max_y, clip := True)
	{
		result := Dllcall("imgui\IsMouseHoveringRect", "float", r_min_x, "float", r_min_y, "float", r_max_x, "float", r_max_y, "int", clip)
		Return result
	}
	static IsMousePosValid()
	{
		result := Dllcall("imgui\IsMousePosValid")
		Return result
	}
	static IsAnyMouseDown()
	{
		result := Dllcall("imgui\IsAnyMouseDown")
		Return result
	}
	static IsMouseDragging(button := 0, lock_threshold := -1)
	{
		result := Dllcall("imgui\IsMouseDragging", "int", button, "float", lock_threshold)
		Return result
	}
	static ResetMouseDragDelta(button := 0)
	{
		Dllcall("imgui\ResetMouseDragDelta", "int", button)
	}
	static GetMouseCursor()
	{
		result := Dllcall("imgui\GetMouseCursor")
		Return result
	}
	;cursor_type := ImGuiMouseCursor_Arrow :=  0
	static SetMouseCursor(ImGuiMouseCursor := 0)
	{
		Dllcall("imgui\SetMouseCursor", "int", ImGuiMouseCursor)
	}
	static CaptureMouseFromApp(capture)
	{
		Dllcall("imgui\CaptureMouseFromApp", "int", capture)
	}
	static LoadIniSettingsFromDisk(ini_filename)
	{
		Dllcall("imgui\LoadIniSettingsFromDisk", "wstr", ini_filename)
	}
	static SaveIniSettingsToDisk(ini_filename)
	{
		Dllcall("imgui\SaveIniSettingsToDisk", "wstr", ini_filename)
	}
	static GetMainViewport()
	{
		result := Dllcall("imgui\GetMainViewport")
		return result
	}
	static UpdatePlatformWindows()
	{
		Dllcall("imgui\UpdatePlatformWindows")
	}
	static RenderPlatformWindowsDefault(platform_render_arg, renderer_render_arg)
	{
		Dllcall("imgui\RenderPlatformWindowsDefault", "ptr", platform_render_arg, "ptr", renderer_render_arg)
	}
	static DestroyPlatformWindows()
	{
		Dllcall("imgui\DestroyPlatformWindows")
	}


	;rounding_corners := ImDrawCornerFlags_All       :=  0xF
	static ImageFit(user_texture_id, size_x := 0, size_y := 0, crop_area := True, rounding := 0, tint_col := 0xFFFFFFFF, ImDrawCornerFlags := 0xF)
	{
		DllCall("imgui\ImageFit",
			"ptr", user_texture_id,
			"float", size_x,
			"float", size_y,
			"int", crop_area,
			"float", rounding,
			"uint", tint_col,
			"int", ImDrawCornerFlags)
	}
	static ImageFromFile(file_path)
	{
		result := Dllcall("imgui\ImageFromFile", "wstr", file_path)
		Return result
	}
	static ImageFromURL(url)
	{
		result := Dllcall("imgui\ImageFromURL", "str", url)
		Return result
	}
	static ImageGetSize(user_texture_id)
	{
		if(user_texture_id == 0)
			return false
		struct_x := buffer(4, 0)
		struct_y := buffer(4, 0)
		result := Dllcall("imgui\ImageGetSize", "ptr", user_texture_id, "ptr", struct_x,"ptr", struct_y)
		ret := [NumGet(struct_x, 0, "float"), NumGet(struct_y, 0, "float")]
		Return ret
	}

	static LoadFont(font_path, font_size)
	{
		result := DllCall("imgui\LoadFont", "wstr", font_size, "float", font_size, "ptr")
		return result
	}

	static LoadTextureFromFile(filename, &out_srv, &out_width, &out_height)
	{
		result := DllCall("imgui\LoadTextureFromFile", "str", filename, "int *", &out_srv, "int *", &out_width, "int *", &out_height)
		return result
	}

	static LoadTextureFromMemory(buf, buf_size, &out_srv, &out_width, &out_height)
	{
		result := DllCall("imgui\LoadTextureFromMemory", "ptr", buf, "int", buf_size, "int *", &out_srv, "int *", &out_width, "int *", &out_height)
		return result
	}

	static TextureFree(srv)
	{
		return DllCall("imgui\TextureFree", "ptr", srv)
	}

	
	static stbi__fopen(file_path, mode)
	{
		return DllCall("imgui\imgui_stbi__fopen", "wstr", file_path, "wstr", mode)
	}

	static stbi__start_file(&stbi__context, file_handle)
	{
		DllCall("imgui\imgui_stbi__start_file", "ptr", stbi__context, "ptr", file_handle)
	}

	static stbi__gif_load_next(&stbi__context, &out_srv, &out_width := 0, &out_height := 0, req_comp := 4)
	{
		result := DllCall("imgui\imgui_stbi__gif_load_next", "ptr", stbi__context, "int *", &out_srv, "Int", req_comp, "Int *", &out_width, "Int *", &out_height)
		return result
	}

	static stbi__load_gif(file_path, &out_srv_array, &length, &w, &h, &delay)
	{
		struct_value := buffer(A_PtrSize * 1024 * 10, 0)
		DllCall("imgui\imgui_stbi__load_gif", "wstr", file_path, "ptr", struct_value, "int *", &length, "int *", &w, "int *", &h, "int *", &delay)
		loop(length)
			out_srv_array.Push(NumGet(struct_value, (A_Index -1) * A_PtrSize, "ptr"))
	}
	;EXTERN_DLL_EXPORT  bool imgui_get_custom_font_range(wchar_t* filename, int *out, int *out_length, wchar_t *buff)

	static LoadFontRange(file_path, &range_array, &length, &raw_data)
	{
		struct_value := buffer(10000 * 4, 0)
		raw_data := buffer(10000 * 4, 0)
		DllCall("imgui\imgui_get_custom_font_range", "wstr", file_path, "ptr", struct_value, "int *", &length, "ptr", raw_data)
		loop(length)
			range_array.Push(NumGet(struct_value, (A_Index -1) * 4, "int"))
	}
	/*
	* 从给定的字符串中获取字符的编码范围
	* @string 字符串， utf-16
	* @range_array 返回字符串编码数组
	* @length 数字数组的长度
	* @raw_data 原始字符范围字符串
	*/
	static LoadFontRangeFromString(string, &range_array, &length, &raw_data)
	{
		struct_value := buffer(10000 * 4, 0)
		raw_data := buffer(10000 * 4, 0)
		DllCall("imgui\imgui_get_custom_font_range_from_string", "wstr", string, "ptr", struct_value, "int *", &length, "ptr", raw_data)
		loop(length)
			range_array.Push(NumGet(struct_value, (A_Index -1) * 4, "int"))
	}

}

; 绘制样式
class ImDraw{

	DrawList := 0, offset_x := 0, offset_y := 0
	__New(draw_list,offset_x:=0,offset_y:=0)
	{
		this.DrawList := draw_list
		, this.offset_x:=offset_x , this.offset_y:=offset_y
	}
	
	static GetWindowDrawList()
	{
		result := Dllcall("imgui\GetWindowDrawList")
		Return ImDraw(result)
	}

	; static GetOverlayDrawList()
	; {
	; 	result := Dllcall("imgui\GetOverlayDrawList")
	; 	Return ImDraw(result)
	; }
	static GetBackgroundDrawList()
	{
		result := Dllcall("imgui\GetBackgroundDrawList")
		Return ImDraw(result)
	}
	static GetForegroundDrawList()
	{
		result := Dllcall("imgui\GetForegroundDrawList")
		Return ImDraw(result)
	}

	SetOffset(x, y)
	{
		this.offset_x := x
		this.offset_y := y
	}

	SetDrawList(draw_list)
	{
		this.DrawList := draw_list
	}

	GetDrawList()
	{
		Return this.DrawList
	}

	AddLine(p1_x, p1_y, p2_x, p2_y, col := 0xFFFFFFFF, thickness := 1)
	{
		Dllcall("imgui\AddLine", "ptr", this.DrawList, "float", p1_x, "float", p1_y, "float", p2_x, "float", p2_y, "uint", col, "float", thickness)
	}

	;rounding_corners := ImDrawCornerFlags_All       :=  0xF
	AddRect(x, y, w, h, col := 0xFFFFFFFF, rounding := 0, ImDrawCornerFlags := 0xF, thickness := 1)
	{
		Dllcall("imgui\AddRect",  "ptr", this.DrawList, "float", x, "float", y, "float", x+w, "float", y+h, "uint", col, "float", rounding, "int", ImDrawCornerFlags, "float", thickness)
	}
	;rounding_corners := ImDrawCornerFlags_All       :=  0xF
	AddRectFilled( x, y, w, h, col := 0xFFFFFFFF, rounding := 0, ImDrawCornerFlags := 0xF)
	{
		Dllcall("imgui\AddRectFilled", "ptr", this.DrawList, "float", x, "float", y, "float", x+w, "float", y+h, "uint", col, "float", rounding, "int", ImDrawCornerFlags)
	}
	AddBezierCurve(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col := 0xFFFFFFFF, thickness := 1, num_segments := 30)
	{
		Dllcall("imgui\AddBezierCurve", "ptr", this.DrawList, "float", p1_x, "float", p1_y, "float", p2_x, "float", p2_y, "float", p3_x, "float", p3_y, "float", p4_x, "float", p4_y, "uint", col, "float", thickness, "int", num_segments)
	}
	AddCircle(center_x, center_y, radius, col := 0xFFFFFFFF, num_segments := 30, thickness := 1)
	{
		Dllcall("imgui\AddCircle", "ptr", this.DrawList, "float", center_x, "float", center_y, "float", radius, "uint", col, "int", num_segments, "float", thickness)
	}
	AddCircleFilled(center_x, center_y, radius, col := 0xFFFFFFFF, num_segments := 0)
	{
		if(!IsSet(p))
			num_segments := radius /3 + 10
		if(ImGuiTreeNodeFlags.DefaultOpen)
		Dllcall("imgui\AddCircleFilled", "ptr", this.DrawList, "float", center_x, "float", center_y, "float", radius, "uint", col, "int", num_segments)
	}


	AddConvexPolyFilled(points, col := 0xFFFFFFFF)
	{
		if(Type(points) != "Array")
			return false

		points_count := points.Length
		struct_points := buffer(4 * points_count * 2, 0)
		loop(points_count)
		{
			NumPut("float", points[A_Index][0], 2 * 4 * A_Index)
			NumPut("float", points[A_Index][1], 2 * 4 * A_Index + 1)
		}
		Dllcall("imgui\AddConvexPolyFilled", "ptr", this.DrawList, "ptr", struct_points, "int", points_count, "uint", col)
	}

	AddImage(user_texture_id, p_min_x, p_min_y, p_max_x, p_max_y, uv_min_x := 0, uv_min_y := 0, uv_max_x := 1, uv_max_y := 1, col := 0xFFFFFFFF)
	{
		Dllcall("imgui\AddImage", "ptr", this.DrawList, "int", user_texture_id, "float", p_min_x, "float", p_min_y, "float", p_max_x, "float", p_max_y, "float", uv_min_x, "float", uv_min_y, "float", uv_max_x, "float", uv_max_y, "uint", col)
	}
	AddImageQuad(user_texture_id, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, uv1_x := 0, uv1_y := 0, uv2_x := 1, uv2_y := 0, uv3_x := 1, uv3_y := 1, uv4_x := 0, uv4_y := 1, col := 0xFFFFFFFF)
	{
		Dllcall("imgui\AddImageQuad", "ptr", this.DrawList, "int", user_texture_id, "float", p1_x, "float", p1_y, "float", p2_x, "float", p2_y, "float", p3_x, "float", p3_y, "float", p4_x, "float", p4_y, "float", uv1_x, "float", uv1_y, "float", uv2_x, "float", uv2_y, "float", uv3_x, "float", uv3_y, "float", uv4_x, "float", uv4_y, "uint", col)
	}
	;rounding_corners := ImDrawCornerFlags_All       :=  0xF
	AddImageRounded(user_texture_id, p_min_x, p_min_y, p_max_x, p_max_y, uv_min_x := 0, uv_min_y := 0, uv_max_x := 1, uv_max_y := 1, col := 0xFFFFFFFF, rounding := 5, ImDrawCornerFlags := 0xF)
	{
		Dllcall("imgui\AddImageRounded", "ptr", this.DrawList, "int", user_texture_id, "float", p_min_x, "float", p_min_y, "float", p_max_x, "float", p_max_y, "float", uv_min_x, "float", uv_min_y, "float", uv_max_x, "float", uv_max_y, "uint", col, "float", rounding, "int", ImDrawCornerFlags)
	}
	AddNgon(center_x, center_y, radius, col := 0xFFFFFFFF, num_segments := 5, thickness := 1)
	{
		Dllcall("imgui\AddNgon", "ptr", this.DrawList, "float", center_x, "float", center_y, "float", radius, "uint", col, "int", num_segments, "float", thickness)
	}
	AddNgonFilled(center_x, center_y, radius, col := 0xFFFFFFFF, num_segments := 5)
	{
		Dllcall("imgui\AddNgonFilled", "ptr", this.DrawList, "float", center_x, "float", center_y, "float", radius, "uint", col, "int", num_segments)
	}

	AddPolyline(points, col := 0xFFFFFFFF, closed := True, thickness := 1)
	{
		if(Type(points) != "Array")
			return false
		points_count := points.Length
		struct_points := buffer(4 * points_count * 2, 0)
		loop(points_count)
		{
			NumPut("float", points[A_Index][0], 2 * 4 * A_Index)
			NumPut("float", points[A_Index][1], 2 * 4 * A_Index + 1)
		}
		Dllcall("imgui\AddPolyline", "ptr", this.DrawList, "ptr", struct_points, "int", points_count, "uint", col, "int", closed, "float", thickness)
	}

	AddQuad(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col := 0xFFFFFFFF, thickness := 1)
	{
		Dllcall("imgui\AddQuad", "ptr", this.DrawList, "float", p1_x, "float", p1_y, "float", p2_x, "float", p2_y, "float", p3_x, "float", p3_y, "float", p4_x, "float", p4_y, "uint", col, "float", thickness)
	}
	AddQuadFilled(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, col := 0xFFFFFFFF)
	{
		Dllcall("imgui\AddQuadFilled", "ptr", this.DrawList, "float", p1_x, "float", p1_y, "float", p2_x, "float", p2_y, "float", p3_x, "float", p3_y, "float", p4_x, "float", p4_y, "uint", col)
	}
	AddRectFilledMultiColor(p_min_x, p_min_y, p_max_x, p_max_y, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
	{
		Dllcall("imgui\AddRectFilledMultiColor", "ptr", this.DrawList, "float", p_min_x, "float", p_min_y, "float", p_max_x, "float", p_max_y, "uint", col_upr_left, "uint", col_upr_right, "uint", col_bot_right, "uint", col_bot_left)
	}
	AddText(text, font, font_size, pos_x, pos_y, col := 0xFFFFFFFF, wrap_width := 0)
	{
		Dllcall("imgui\AddText", "ptr", this.DrawList, "ptr", font, "float", font_size, "float", pos_x, "float", pos_y, "uint", col, "wstr", text, "float", wrap_width)
	}
	AddTriangle(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col := 0xFFFFFFFF, thickness := 1)
	{
		Dllcall("imgui\AddTriangle", "ptr", this.DrawList, "float", p1_x, "float", p1_y, "float", p2_x, "float", p2_y, "float", p3_x, "float", p3_y, "uint", col, "float", thickness)
	}
	AddTriangleFilled(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, col := 0xFFFFFFFF)
	{
		Dllcall("imgui\AddTriangleFilled", "ptr", this.DrawList, "float", p1_x, "float", p1_y, "float", p2_x, "float", p2_y, "float", p3_x, "float", p3_y, "uint", col)
	}
	PathClear()
	{
		Dllcall("imgui\PathClear", "ptr", this.DrawList)
	}
	PathLineTo(pos_x, pos_y)
	{
		Dllcall("imgui\PathLineTo", "ptr", this.DrawList, "float", pos_x, "float", pos_y)
	}
	PathLineToMergeDuplicate(pos_x, pos_y)
	{
		Dllcall("imgui\PathLineToMergeDuplicate", "ptr", this.DrawList, "float", pos_x, "float", pos_y)
	}
	PathFillConvex(col)
	{
		Dllcall("imgui\PathFillConvex", "ptr", this.DrawList, "uint", col)
	}
	PathStroke(col, closed, thickness := 1)
	{
		Dllcall("imgui\PathStroke", "ptr", this.DrawList, "uint", col, "boolean", closed, "float", thickness)
	}
	PathArcTo(center_x, center_y, radius, a_min_a, a_max, num_segments := 20)
	{
		Dllcall("imgui\PathArcTo", "ptr", this.DrawList, "float", center_x, "float", center_y, "float", radius, "float", a_min, "float", a_max, "int", num_segments)
	}
	PathArcToFast(center_x, center_y, radius, a_min_of_12, a_max_of_12)
	{
		Dllcall("imgui\PathArcToFast", "ptr", this.DrawList, "float", center_x, "float", center_y, "float", radius, "int", a_min_of_12, "int", a_max_of_12)
	}
	PathBezierCurveTo(p2_x, p2_y, p3_x, p3_y, p4_x, p4_y, num_segments := 0)
	{
		Dllcall("imgui\PathBezierCurveTo", "ptr", this.DrawList, "float", p2_x, "float", p2_y, "float", p3_x, "float", p3_y, "float", p4_x, "float", p4_y, "int", num_segments)
	}
	;rounding_corners := ImDrawCornerFlags_All       :=  0xF
	PathRect(rect_min_x, rect_min_y, rect_max_x, rect_max_y, rounding := 0, ImDrawCornerFlags := 0xf)
	{
		Dllcall("imgui\PathRect", "ptr", this.DrawList, "float", rect_min_x, "float", rect_min_y, "float", rect_max_x, "float", rect_max_y, "float", rounding, "int", ImDrawCornerFlags)
	}

	;rounding_corners := ImDrawCornerFlags_All       :=  0xF
	AddImageFit(user_texture_id, pos_x, pos_y, size_x := 0, size_y := 0, crop_area := True, rounding := 0, tint_col := 0xFFFFFFFF, ImDrawCornerFlags := 0xf)
	{
		Dllcall("imgui\AddImageFit",
		"ptr", this.DrawList,
		"ptr", user_texture_id,
		"float", pos_x,
		"float", pos_y,
		"float", size_x,
		"float", size_y,
		"boolean", crop_area,
		"float", rounding,
		"uint", tint_col,
		"int", ImDrawCornerFlags)
	}
}


; 返回文件中去重后的字符，并将其储存在脚本目录下的 ImguiText.txt 文件里
GetScriptUsedText(FilePath*)
{
    ; a:=A_TickCount
    ImguiTextFilePath:=A_ScriptDir "\ImguiText.txt"
    rtime:=FileGetTime(A_ScriptFullPath)
    fe:=!FileExist(ImguiTextFilePath)
    if(fe || FileGetTime(ImguiTextFilePath)!=rtime)
    {
        ScriptText:=""
        for v in FilePath
            ScriptText.=FileRead(v)

        ; 删除重复字符
        ScriptText:= RegExReplace(ScriptText,"is)[" Chr(1) "-" chr(126) "]*","")
        OrderedText:=Map()
        Loop Parse,ScriptText
            OrderedText[Ord(A_LoopField)]:=A_LoopField
        Loop(126)
            OrderedText_2.=Chr(A_Index)
        for i,v in OrderedText
            OrderedText_2.=v
        if(!fe)
            FileDelete(ImguiTextFilePath)
        FileAppend(OrderedText_2,ImguiTextFilePath)
        FileSetTime(rtime,ImguiTextFilePath)
    }
	else
		OrderedText_2:=FileRead(ImguiTextFilePath)
    ; OutputDebug "用时: " A_TickCount-a "结果：`n" OrderedText_2
	return OrderedText_2
}
