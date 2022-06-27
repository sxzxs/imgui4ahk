a := mtt("100", 500, 500)

loop
{
    mtt("10", 100, ,1000)
}
mtt("10", 100, ,1000)
mtt("10", 200, ,1000)
mtt("10", 300, ,1000)
mtt("10", 400, ,1000)
sleep(10000)
a.Stop()

class mtt 
{
    static s_tooltip_number := 1
    static s_max_btt := 20
    __New(txt := "btt", x := 0, y := 0, show_time := 999999999, BulitInStyleOrStyles := "", BulitInOptionOrOptions := "") 
    {
        this.timer := ObjBindMethod(this, "Tick")
        this.x := x
        this.BulitInStyleOrStyles := BulitInStyleOrStyles
        this.BulitInOptionOrOptions := BulitInOptionOrOptions
        this.y := y
        this.txt := txt
        this.show_time := show_time
        this.which := mtt.s_tooltip_number
        if(mtt.s_tooltip_number == mtt.s_max_btt)
        {
            mtt.s_tooltip_number := 0
        }
        mtt.s_tooltip_number++
        this.Start()
    }
    __Delete()
    {
    }
    Start() 
    {
        timer := this.timer
        SetTimer timer, -this.show_time
        ToolTip(this.txt, this.x, this.y, this.which)
    }
    Stop() 
    {
        try
        {
            timer := this.timer
            SetTimer timer, 0
            ToolTip(,,, this.which)
            this.timer := 0
        }
    }
    Tick() 
    {
        this.stop()
    }
}