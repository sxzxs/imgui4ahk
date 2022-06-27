#include <imgui>
#include <log>

json_path := A_ScriptDir . "/config/config.json"
config := {}
loadconfig(&config, json_path)
g_now_hero := Map()
g_gif_index := 1

str := '
(
习近平：世上没有从天而降的英雄，只有挺身而出的凡人。青年一代不怕苦、不畏难、不惧牺牲，用臂膀扛起如山的责任，展现出青春激昂的风采，展现出中华民族的希望！

这段话出自2020年9月8日习近平总书记在全国抗击新冠肺炎疫情表彰大会上的讲话。

新时代的中国青年应该是什么样子？我们可以在伟大实践中寻找答案。新时代中国青年不畏难、不惧苦，危难之中显精神，关键时刻见真章，总能够在祖国和人民需要的时候挺身而出，在体现综合国力、弘扬民族志气的重大工程之中，在抗击重大自然灾害面前，在应对突发公共危机时刻，青年的身影始终挺立在最前沿。新冠肺炎疫情发生以来，32万余支青年突击队、550余万名青年奋战在医疗救护、交通物流、项目建设等抗疫一线，为打赢疫情防控的人民战争、总体战、阻击战作出重大贡献；在打赢脱贫攻坚战的过程中，涌现了许多像黄文秀那样用生命坚守初心和使命的优秀青年共产党员，谱写了新时代的青春之歌。截至2021年，47万名“三支一扶”人员参加基层支教、支农、支医和帮扶乡村振兴（扶贫），数百万青年学生参与“三下乡”社会实践活动，为脱贫攻坚和乡村振兴提供新助力。有志气、有骨气、有底气，不负时代，不负韶华，不负党和人民的殷切期望！这就是中国青年在新时代的样子。

清风正气，守正创新。新时代中国青年要顺应社会发展潮流，适应国家治理体系和治理能力现代化要求，在社会文明建设中引领时代新风，争当正能量的倡导者、新风尚的践行者。全面建设社会主义现代化强国，不仅要物质强，还要精神强。在农村为乡亲们排忧解难，在社区为邻里们倾心服务，在边疆为祖国巡逻戍边……有越来越多的青年深入基层、投身现代化建设最需要的地方，在复杂艰苦环境中成就人生。新时代中国青年要做能创新、有活力的一代，执着创新创造走在前列，始终追求更有高度、更有境界、更有品位的人生。

胸怀世界，堪当重任。新时代中国青年既有家国情怀，也有人类关怀，与世界各国青年共同推动构建人类命运共同体，共同弘扬和平、发展、公平、正义、民主、自由的全人类共同价值，携手创造人类更加美好的未来。在世界百年未有之大变局与中华民族伟大复兴的历史交汇期，在迈向第二个百年奋斗目标的新征程中，作为堪当民族复兴重任的时代新人，广大中国青年既是国家的未来，更是世界的未来。中国青年，未来可期！

本期特约专家：王慧 中央党校（国家行政学院）马克思主义学院

)'
str1 := "abcd"

_ImGui_EnableViewports(true)
main()
main()
{
    global str
    global g_now_hero
    global out_gif_delay
    static no_menu := false
    ;_Imgui_load_font_range(A_ScriptDir '/font/ImguiText.txt', &range_array := [], &length := 0, &raw_data)
    _Imgui_load_font_range_from_string(str1, &range_array := [], &length := 0, &raw_data)
    logger.info(range_array)
	hwnd := _ImGui_GUICreate("AHK ImGui", 1, 1, -100, -100, 0, 0x80, 'from_memory_simhei', 20,, raw_data)
    
	WinSetAlwaysOnTop( 1,hwnd)
    _ImGui_StyleColorsClassic()
    io := _ImGui_GetIO()
    _ImGui_SetWindowTitleAlign(0.1, 0.1)
    _ImGui_EnableDocking(True)
    static window_flags := 0
    _Imgui_imgui_stbi__load_gif(A_ScriptDir '\image\b.gif', &out_srv_array := [], &length := 0, &out_gif_with := 0, &out_gif_height := 0, &out_gif_delay := 0)
    if(out_gif_delay == 0) 
        out_gif_delay := 200
    SetTimer(gif_setter.Bind(length), out_gif_delay)
    close := 1
    WinShow(hwnd)
    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
        if(!_ImGui_Begin("云顶之弈", show_close := true, window_flags))
            ExitApp
        _ImGui_Image(out_srv_array[g_gif_index], out_gif_with, out_gif_height)
        _ImGui_SameLine()

        _ImGui_PushStyleColor(ImGuiCol_Button, "0xff415911")
        _ImGui_Text("选择的英雄"), _ImGui_SameLine()
        for k,v in g_now_hero
        {
            if(_ImGui_Button(k))
                g_now_hero.Delete(k)
            _ImGui_SameLine()
        }
        _ImGui_PopStyleColor(1)
        _ImGui_NewLine()
        ;添加代码 =====================================
        for k,v in config
        {
            _ImGui_PushStyleColor(ImGuiCol_Button, "0xffe12fa0")
            _ImGui_Button(k ':')
            _ImGui_PopStyleColor(1)
            _ImGui_SameLine()
            for i,j in v
            {
                if(g_now_hero.Has(j))
                    _ImGui_PushStyleColor(ImGuiCol_Button, "0xff0a3f27")
                else
                    _ImGui_PushStyleColor(ImGuiCol_Button, "0xff130960")
                if(_ImGui_Button(j '##' k j))
                {
                    if(g_now_hero.Has(j))
                        g_now_hero.Delete(j)
                    else
                        g_now_hero[j] := 1
                }
                _ImGui_PopStyleColor(1)
                _ImGui_SameLine()
            }
            _ImGui_NewLine()
        }

        ;====================================
        _ImGui_End()
        _ImGui_EndFrame()
        Sleep(1)
    }
    ExitApp()
    sleep(1)
    return
}


loadconfig(&config, json_path)
{
    outputvar := FileRead(json_path)
    config := JSON.parse(outputvar)
}

saveconfig(config, json_path)
{
    str := JSON.stringify(config)
    FileDelete(json_path)
    FileAppend(str, json_path)
}

gif_setter(length)
{
    global g_gif_index
    g_gif_index++
    if(g_gif_index == length)
        g_gif_index := 1
}
; 传入带有中文字符的脚本路径
GetScriptUsedText(FilePath*)
{
    a:=A_TickCount
    ImguiTextFilePath:=A_ScriptDir "\font\ImguiText.txt"
    rtime:=FileGetTime(A_ScriptFullPath)
    fe:=!FileExist(ImguiTextFilePath)
    ; 若脚本未修改不重复创建
    if(fe || FileGetTime(ImguiTextFilePath)!=rtime)
    {
        ScriptText:=""
        for v in FilePath
            ScriptText.=FileRead(v)
        ; 清除换行符与空格
        ScriptText:=StrReplace(ScriptText, "`r`n") , ScriptText:=StrReplace(ScriptText, A_Space) , ScriptText:=StrReplace(ScriptText, A_Tab)
        ; 删除重复字符
        ok:=1,i:=0
        while(ok)
            i+=1,ScriptText:=RegExReplace(ScriptText,'Ss)(.)(.*)(\1)',"$2$3",&ok)
        OutputDebug "次数：" i "`n"
        if(!fe)
            FileDelete(ImguiTextFilePath)
        FileEncoding("UTF-8") , FileAppend(ScriptText,ImguiTextFilePath) , FileSetTime(rtime,ImguiTextFilePath)
    }
    return ImguiTextFilePath
}
