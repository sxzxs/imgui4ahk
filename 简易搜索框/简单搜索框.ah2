#include <log>
#include <imgui>
#include <py>

run_as_admin()
_ImGui_EnableViewports(true)
logger.is_log_open := true

ToolTip("F3 显示搜索框， ESC 隐藏")
Sleep(1000)
ToolTip()

;全局变量
g_json_path := A_ScriptDir . "/config.json"
g_choose_total_number := 10
g_current_choose_number := 1
g_is_show := true
g_current_path := ''
g_dymanic_current_path := ''
g_current_text := ''
g_clearn_text_value_flag := false

;加载配置文件
g_config := Map()
loadconfig(&g_config, g_json_path)

all_leaf_path := recursively_get_all_leaf_path(g_config)
g_filter_leaf_path := []
logger.info(all_leaf_path)

;注册热键
Hotkey("~*$f3", show_hide_wind) ;显示界面
HotIfWinExist('ahk_class ImGui Platform')
Hotkey("~*$esc", hide_wind) 
Hotkey("~$tab", change_choose_number) 
Hotkey("~$+tab", change_choose_number)
Hotkey("~$up", change_choose_number)
Hotkey("~$down", change_choose_number)
Hotkey("~$enter", choose_select)
HotIfWinActive
main()
main()
{
	global g_dymanic_current_path
	global g_current_text
    static no_menu := false
	global g_filter_leaf_path
	global g_clearn_text_value_flag
    hwnd := _ImGui_GUICreate("AHK ImGui", 1, 1, -100, -100, 0, 0x80,"from_memory_ali", 30)
    WinShow(hwnd)
    WinSetAlwaysOnTop( 1,hwnd)
    _ImGui_StyleColorsClassic()
    io := _ImGui_GetIO()
    _ImGui_SetWindowTitleAlign(0.5, 0.5)
    _ImGui_EnableDocking(false)
    static window_flags := ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_AlwaysAutoResize
	static oo := Map('root', map('key', 10, 'key2', 30))
    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
        _ImGui_Begin("AHK2", 0, window_flags)
        ;添加代码 =====================================
		g_dymanic_current_path := ''
		_ImGui_SetKeyboardFocusHere(0)
		static text_value := ''
		static text_value_before := text_value
		_ImGui_SetNextItemWidth(500)
		_ImGui_InputText(Chr(0xf002) "##search_box" , &text_value)
		if(g_clearn_text_value_flag)
			text_value := '', g_clearn_text_value_flag := false
		if(text_value_before != text_value)
		{
			text_value_before := text_value
			g_filter_leaf_path := []
			for k,v in all_leaf_path
			{
				if(text_value != '' && is_py_match(v, text_value))
					g_filter_leaf_path.Push(v)
			}
		}
		loop(g_filter_leaf_path.Length)
		{
			if(A_Index == g_current_choose_number)
            	_ImGui_PushStyleColor(ImGuiCol_Text, "0xff7020d2")
			_ImGui_Text(g_filter_leaf_path[A_Index])
			if(A_Index == g_current_choose_number)
                _ImGui_PopStyleColor(1)
		}
        ;====================================
        _ImGui_End()
        _ImGui_EndFrame()
		Sleep(1)
    }
    ExitApp()
    return
}
show_hide_wind(*)
{
	global g_is_show
    try
    {
        WinShow("ahk_class ImGui Platform")
		WinActivate("ahk_class ImGui Platform")
    }
	g_is_show := true
}
hide_wind(*)
{
	global g_is_show
	global g_filter_leaf_path
	global g_clearn_text_value_flag
	g_is_show := false
	g_filter_leaf_path := []
	g_clearn_text_value_flag := true
	try
		WinHide("ahk_class ImGui Platform")
}

change_choose_number(key*)
{
	global g_current_choose_number
	if(g_is_show == false)
		return
	logger.info(key[1])
	switch key[1] 
	{
		case '~$tab':
			g_current_choose_number++
		case '~$+tab':
			g_current_choose_number--
		case '~$up':
			g_current_choose_number--
		case '~$down':
			g_current_choose_number++
		default:
	}
	if(g_current_choose_number > g_filter_leaf_path.Length)
		g_current_choose_number := 1
	if(g_current_choose_number < 1)
		g_current_choose_number := g_filter_leaf_path.Length
}

choose_select(*)
{
	if(!(g_filter_leaf_path.Length > 0))
		return
	word_array := StrSplit(g_filter_leaf_path[g_current_choose_number], A_Space, ".")
	run_code := g_config
	for k,v in word_array
		run_code := run_code[v]
	ExecScript(run_code, "",A_ScriptDir "\AutoHotkey.exe")
	hide_wind()
}
recursively_display_directory_node(parentNode, tree_depth := 1)
{
	global g_current_path
	global g_dymanic_current_path
	for k,v in parentNode
	{
		if(Type(v) == 'String')
		{
			flag := ImGuiTreeNodeFlags_NoTreePushOnOpen | ImGuiTreeNodeFlags_Leaf | ImGuiTreeNodeFlags_SpanFullWidth | ImGuiTreeNodeFlags_OpenOnDoubleClick
			if(g_dymanic_current_path k == g_current_path)
				flag |= ImGuiTreeNodeFlags_Selected
			if (_ImGui_TreeNodeEx(k, flag))
			{
				if(_ImGui_IsItemClicked())
				{
					g_dymanic_current_path .= k
					g_current_path := g_dymanic_current_path
					logger.info(g_current_path)
				}
			}
		}
		else if(_ImGui_TreeNodeEx(k, ImGuiTreeNodeFlags_SpanFullWidth))
		{
			if(tree_depth == 1)
				g_dymanic_current_path := k
			else
				g_dymanic_current_path .= k 
			recursively_display_directory_node(v, tree_depth + 1)
			_ImGui_TreePop()
		}
	}
}

;加载配置函数
loadconfig(&config, json_path)
{
    outputvar := FileRead(json_path)
    config := JSON.parse(outputvar)
}
;保存配置函数
saveconfig(config, json_path)
{
    str := JSON.stringify(config)
    FileDelete(json_path)
    FileAppend(str, json_path, 'UTF-8')
}

recursively_get_all_leaf_path(parentNode, path := '')
{
	static all_leaf_path := []
	for k,v in parentNode
	{
		if(Type(v) == 'String')
			all_leaf_path.Push(path ' ' k)
		else if(Type(v) == 'Map')
			recursively_get_all_leaf_path(v, path . k)
	}
	return all_leaf_path
}

ExecScript(Script, Params := "", AhkPath := "") 
{
    Local Name, Pipe, Call, Shell, Exec

    Name := "AHK_CQT_" . A_TickCount
    Pipe := []

    Loop(2)
	{
        Pipe.push(DllCall("CreateNamedPipe"
        , "Str", "\\.\pipe\" . Name
        , "UInt", 2, "UInt", 0
        , "UInt", 255, "UInt", 0
        , "UInt", 0, "UPtr", 0
        , "UPtr", 0, "UPtr"))
    }

    If (!FileExist(AhkPath)) 
        AhkPath := A_AhkPath

    Call := AhkPath ' /CP65001 \\.\pipe\' Name
    Shell := ComObject("WScript.Shell")
    Exec := Shell.Exec(Call . " " . Params)
    Exec.StdIn.Write("hh")
    Exec.StdIn.Close()
    DllCall("ConnectNamedPipe", "UPtr", Pipe[1], "UPtr", 0)
    DllCall("CloseHandle", "UPtr", Pipe[1])
    DllCall("ConnectNamedPipe", "UPtr", Pipe[2], "UPtr", 0)
    FileOpen(Pipe[2], "h", "UTF-8").Write(Script)
    DllCall("CloseHandle", "UPtr", Pipe[2])

    Return Exec
}

run_as_admin()
{
	full_command_line := DllCall("GetCommandLine", "str")
	if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
	{
		try
		{
			if A_IsCompiled
				Run '*RunAs "' A_ScriptFullPath '" /restart'
			else
				Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
		}
		ExitApp
	}
}

;是否匹配
is_py_match(haystack, needle)
{
    ;拼音首字母转换
	findSign := true
    haystack .= py.allspell_muti(haystack) py.initials_muti(haystack) 
	needleArray := StrSplit(needle, " ")
	Loop(needleArray.Length)
	{
		if(needleArray[A_Index] != '' && !InStr(haystack, needleArray[A_Index], false))
		{
			findSign:=0
			break
		}	
	}
	return findSign
}