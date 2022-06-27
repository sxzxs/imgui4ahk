#include <log4ahk>
n =
(%
DllCall\(.*?,.*?, "(.*?)"(.*)
)
r =
(%
Dllcall("imgui\$1"$2
)
^7::
text := Clipboard
log.info(text)
text := RegExReplace(text, "Func(.*)\)", "$1){")
log.info(text)
text := RegExReplace(text, "EndFunc", "}")
log.info(text)

text := RegExReplace(text, "i)Local ")
text := RegExReplace(text, "\$")
text := RegExReplace(text, "=", ":=")
text := RegExReplace(text, "result\[0\]", "result")
text := RegExReplace(text, "ByRef ", "&")
log.info(text)
text := RegExReplace(text, n, r)
log.info(text)
Clipboard := text
return

^6::
Reload
return