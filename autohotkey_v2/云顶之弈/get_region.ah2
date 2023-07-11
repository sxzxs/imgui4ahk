Area := SelectScreenRegion("LButton", "Red", 30)
if(Area != false)
    FileAppend( Area.x ' ' Area.y ' ' Area.w ' ' Area.h, "*")
else
    FileAppend('error', "*")
ExitApp

SelectScreenRegion(Key, Color := "Lime", Transparent:= 80)
{
	CoordMode("Mouse", "Screen")
    loop
    {
        ToolTip("请按下: " Key)
        sleep(50)
        if(GetKeyState("Esc"))
        {
            ToolTip
            return false
        }
    }until (GetKeyState(key))
	MouseGetPos(&sX, &sY)
	ssrGui := Gui("+AlwaysOnTop -caption +Border +ToolWindow +LastFound -DPIScale", 'section gui')
	WinSetTransparent(Transparent)
	ssrGui.BackColor := Color
	Loop 
	{
		Sleep 10
		MouseGetPos(&eX, &eY)
		W := Abs(sX - eX), H := Abs(sY - eY)
		X := Min(sX, eX), Y := Min(sY, eY)
		ssrGui.Show("x" X " y" Y " w" W " h" H)
	} Until !GetKeyState(Key, "p")
	ssrGui.Destroy()
    ToolTip
	Return { X: X, Y: Y, W: W, H: H, X2: X + W, Y2: Y + H }
}