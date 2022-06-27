#include <log>
#include <imgui>

_ImGui_EnableViewports(true)

logger.is_log_open := true

;全局变量
g_json_path := A_ScriptDir . "/config.json"
g_choose_total_number := 10
g_current_choose_number := 1
g_is_show := true
g_current_path := ''
g_dymanic_current_path := ''

;加载配置文件
g_config := Map()
loadconfig(&g_config, g_json_path)

;注册热键
Hotkey("~*$^5", show_hide_wind) ;显示界面
Hotkey("~*$esc", hide_wind) 
Hotkey("~$tab", change_choose_number) 
Hotkey("~$+tab", change_choose_number)
Hotkey("~$up", change_choose_number)
Hotkey("~$down", change_choose_number)
main()
main()
{
	global g_dymanic_current_path
    static no_menu := false
    hwnd := _ImGui_GUICreate("AHK ImGui", 1, 1, -100, -100, 0, 0x80,"from_memory_ali")
    WinShow(hwnd)
    WinSetAlwaysOnTop( 1,hwnd)
    _ImGui_StyleColorsClassic()
    io := _ImGui_GetIO()
    _ImGui_SetWindowTitleAlign(0.5, 0.5)
    _ImGui_EnableDocking(True)
    static window_flags := ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoTitleBar
	static oo := Map('root', map('key', 10, 'key2', 30))
    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
		;_ImGui_SetNextWindowPos(1066, 119, cond := 0, pivot_x := 0, pivot_y := 0)
        _ImGui_Begin("AHK2", 0, window_flags)
        ;添加代码 =====================================
		g_dymanic_current_path := ''
		RecursivelyDisplayDirectoryNode(g_config)

		;_ImGui_SetKeyboardFocusHere(0)
		static text_value := ''
		static text_value_before := text_value
		static v := 1
		_ImGui_InputText("##text", &text_value)
		if(text_value_before != text_value)
		{
			text_value_before := text_value
			v++
		}
		loop(g_choose_total_number)
		{
			if(A_Index == g_current_choose_number)
            	_ImGui_PushStyleColor(ImGuiCol_Text, "0xff7020d2")
			_ImGui_Text(v)
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
	g_is_show := false
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
	if(g_current_choose_number > g_choose_total_number)
		g_current_choose_number := 1
	if(g_current_choose_number < 1)
		g_current_choose_number := g_choose_total_number
}
RecursivelyDisplayDirectoryNode(parentNode, tree_depth := 1)
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
			RecursivelyDisplayDirectoryNode(v, tree_depth + 1)
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