class py
{
    static DLL_USE_MAP := map("cpp2ahk.dll" , map("chinese_convert_pinyin_allspell_muti", 0, "chinese_convert_pinyin_initials_muti", 0))
    static __New() => this.load_all_dll_path()
    static load_all_dll_path()
    {
        SplitPath(A_LineFile,,&dir)
        path := ""
        lib_path := dir
        if(A_IsCompiled)
        {
            path := (A_PtrSize == 4) ? A_ScriptDir . "\lib\dll_32\" : A_ScriptDir . "\lib\dll_64\"
            lib_path := A_ScriptDir . "\lib"
        }
        else
        {
            path := (A_PtrSize == 4) ? dir . "\dll_32\" : dir . "\dll_64\"
        }
        dllcall("SetDllDirectory", "Str", path)
        for k,v in this.DLL_USE_MAP
        {
            for k1, v1 in v 
            {
                this.DLL_USE_MAP[k][k1] := DllCall("GetProcAddress", "Ptr", DllCall("LoadLibrary", "Str", k, "Ptr"), "AStr", k1, "Ptr")
            }
        }
        dllcall("SetDllDirectory", "Str", A_ScriptDir)
    }
    static allspell_muti(in_str)
    {
        out_str_size := 1040
	    out_str := Buffer(out_str_size, 0)
        DllCall(this.DLL_USE_MAP["cpp2ahk.dll"]["chinese_convert_pinyin_allspell_muti"], "Str", in_str, "ptr", out_str, "Cdecl Int")
        return StrGet(out_str, out_str_size, "UTF-8")
    }
    static initials_muti(in_str)
    {
        out_str_size := 1040
	    out_str := Buffer(out_str_size, 0)
        DllCall(this.DLL_USE_MAP["cpp2ahk.dll"]["chinese_convert_pinyin_initials_muti"], "Str", in_str, "ptr", out_str, "Cdecl Int")
        return StrGet(out_str, out_str_size, "UTF-8")
    }
    static strbuf(str, encoding)
    {
        buf := buffer(strput(str, encoding))
        strput(str, buf, encoding)
        return buf
    }
}