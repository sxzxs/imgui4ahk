#include <imgui>
_ImGui_EnableViewports(false)

w::game_control.key_handle('up')
s::game_control.key_handle('down')
a::game_control.key_handle('left')
d::game_control.key_handle('right')
space::game_control.fire()

main()
main()
{
    static no_menu := false
    global g_tank_move_step := 20
    global g_bullect_move_step := 20
    global hwnd := _ImGui_GUICreate("AHK ImGui", 500, 500, 0, 0, 0, 0)
    global image_wall := _ImGui_ImageFromFile(A_ScriptDir '\image\墙.png')
    global image_steel := _ImGui_ImageFromFile(A_ScriptDir '\image\钢墙.png')
    global image_home := _ImGui_ImageFromFile(A_ScriptDir '\image\老鹰.png')
    global image_tank_up := _ImGui_ImageFromFile(A_ScriptDir '\image\坦克上.png')
    global image_tank_down := _ImGui_ImageFromFile(A_ScriptDir '\image\坦克下.png')
    global image_tank_right := _ImGui_ImageFromFile(A_ScriptDir '\image\坦克右.png')
    global image_tank_left := _ImGui_ImageFromFile(A_ScriptDir '\image\坦克左.png')
    global image_bullect := _ImGui_ImageFromFile(A_ScriptDir '\image\炮弹.png')
    global image_enemy_tank_up := _ImGui_ImageFromFile(A_ScriptDir '\image\敌方坦克上.png')
    global image_enemy_tank_down := _ImGui_ImageFromFile(A_ScriptDir '\image\敌方坦克下.png')
    global image_enemy_tank_right := _ImGui_ImageFromFile(A_ScriptDir '\image\敌方坦克右.png')
    global image_enemy_tank_left := _ImGui_ImageFromFile(A_ScriptDir '\image\敌方坦克左.png')
	WinShow(hwnd)
    change_window_icon(hwnd, A_ScriptDir "\image\main.ico")
    WinSetAlwaysOnTop( 1,hwnd)

    game_data := Data()
    game_view := View(game_data)
    global game_control := Game(game_data, game_view, g_tank_move_step)

    _ImGui_EnableDocking(True)
    static window_flags := 0
    while(_ImGui_PeekMsg())
    {
        _ImGui_BeginFrame()
        _ImGui_Begin("AHK2", 0, window_flags | ImGuiWindowFlags_NoTitleBar)
        ;添加代码 =====================================
        wp := _ImGui_GetWindowPos()
        draw_list := _ImGui_GetWindowDrawList()

        _ImDraw_SetDrawList(draw_list)
        
        game_control.run() 
        game_control.render()

        _ImGui_SetCursorPos(8, 50)
        _ImGui_PushStyleColor(ImGuiCol_Button, "0xffdd18d7")
        _ImGui_TextColored("分数：")
        _ImGui_TextColored("生命值：")
        _ImGui_TextColored("坦克 X: " game_control.data.tk.position_x)
        _ImGui_TextColored("坦克 y: " game_control.data.tk.position_y)
        _ImGui_TextColored("炮弹 x: " game_control.data.tk.bl.position_x)
        _ImGui_TextColored("炮弹 y: " game_control.data.tk.bl.position_y)
        _ImGui_TextColored("炮弹 状态: " game_control.data.tk.bl.status)
        _ImGui_Button('Start', 80, 30)
        _ImGui_Button('Stop', 80, 30)
        _ImGui_PopStyleColor(1)

        ;====================================
        _ImGui_End()
        ;_ImGui_ShowDemoWindow()
        _ImGui_EndFrame()
        sleep(20)
    }
    ExitApp()
    return
}

change_window_icon(hwnd, ico_path)
{
    hIcon := DllCall( "LoadImage", 'UInt',0, 'Str', ico_path, 'uint',1, 'UInt',0, 'UInt',0, 'UInt',0x10 )
    SendMessage(0x80, 0, hIcon,, hwnd)
    SendMessage(0x80, 1, hIcon,, hwnd)
}
class Const
{
    static __New() 
    {
        this.ENUM_DIRECTION_UP := 1
        this.ENUM_DIRECTION_DOWN := 2
        this.ENUM_DIRECTION_LEFT := 3
        this.ENUM_DIRECTION_RIGHT := 4
    }
}

class Tank
{
    static __New() 
    {
    }
    __New(x := 0, y := 0, is_enemy := false) 
    {
        this.position_x := x
        this.position_y := y
        this.direction := Const.ENUM_DIRECTION_UP
        this.bl := Bullect(x, y)
        this.speed := 2
        this.m_is_enemy := is_enemy
        this.move_frame := 5 ;每五帧移动一次
        this.current_frame := 1
        this.m_is_die := false
    }
    is_enemy()
    {
        return this.m_is_enemy
    }
    is_die()
    {
        return this.m_is_die
    }
    set_die(d)
    {
        this.m_is_die := d
    }
    current_bullect()
    {
        return this.bl
    }
    set_position(x, y)
    {
        this.position_x := x
        this.position_y := y
    }
    get_position()
    {
        return [this.position_x, this.position_y]
    }
    get_speed()
    {
        return this.speed
    }
    set_speed(speed)
    {
        this.speed := speed
    }
    set_direction(direction)
    {
        this.direction := direction
    }
    get_direction()
    {
        return this.direction
    }
}

class Bullect
{
    static __New() 
    {
        this.ENUM_BULLECT_STATUS_EXIST := 1 
        this.ENUM_BULLECT_STATUS_NO_EXIST := 2
        this.move_step := 5
        this.width := 20
        this.height := 20
    }
    __New(x := 0, y := 0) 
    {
        this.position_x := x
        this.position_y := y
        this.direction := Const.ENUM_DIRECTION_UP
        this.status := Bullect.ENUM_BULLECT_STATUS_NO_EXIST
    }
    set_position(x, y)
    {
        this.position_x := x
        this.position_y := y
    }
    get_four_dot_row_col()
    {
        x := this.position_x
        y := this.position_y
        p1 := [Integer(y / 20) + 1, Integer(x / 20) + 1]
        p2 := [Integer((y + 20) / 20) + 1, Integer(x / 20) + 1]
        p3 := [Integer((y + 20) / 20) + 1, Integer((x + 20) / 20) + 1]
        p4 := [Integer(y / 20) + 1, Integer((x + 20) / 20) + 1]
        return [p1, p2, p3, p4]
    }
    set_position_y(y)
    {
        this.position_y := y
    }
    set_position_x(x)
    {
        this.position_x := x
    }
    get_position()
    {
        return [this.position_x, this.position_y]
    }
    get_direction()
    {
        return this.direction
    }
    set_direction(direction)
    {
        this.direction := direction
    }
    get_status()
    {
        return this.status
    }
    set_status(status)
    {
        this.status := status
    }
}

class Game
{
    __New(data, view, move_step) 
    {
        this.data := data
        this.view := view
        this.move_step := move_step

        this.key_down_time := 0
        this.tank_is_move := false
    }
    fire()
    {
        this.data.fire_bullect(this.data.get_tank())
    }
    key_handle(key)
    {
        if('up' == key)
        {
            if(this.data.get_tank().get_direction() == Const.ENUM_DIRECTION_UP)
                this.data.tank_move_r(0, -this.move_step, this.data.get_tank())
            this.data.get_tank().set_direction(Const.ENUM_DIRECTION_UP)
        }
        else if('down' == key)
        {
            if(this.data.get_tank().get_direction() == Const.ENUM_DIRECTION_DOWN)
                this.data.tank_move_r(0, this.move_step, this.data.get_tank())
            this.data.get_tank().set_direction(Const.ENUM_DIRECTION_DOWN)
        }
        else if('left' == key)
        {
            if(this.data.get_tank().get_direction() == Const.ENUM_DIRECTION_LEFT)
                this.data.tank_move_r(-this.move_step, 0, this.data.get_tank())
            this.data.get_tank().set_direction(Const.ENUM_DIRECTION_LEFT)
        }
        else if('right' == key)
        {
            if(this.data.get_tank().get_direction() == Const.ENUM_DIRECTION_RIGHT)
                this.data.tank_move_r(this.move_step, 0, this.data.get_tank())
            this.data.get_tank().set_direction(Const.ENUM_DIRECTION_RIGHT)
        }
    }
    run()
    {
        if(this.data.is_no_home())
        {
            _ImGui_Text('Game over!!')
            return
        }
        if(this.data.is_all_die())
        {
            _ImGui_Text('Good !!')
            return
        }
        this.data.bullect_move(this.data.get_tank())
        for k,v in this.data.the_enemy_tks
        {
            if(v.is_die())
                continue
            this.data.bullect_move(v)
            this.data.fire_bullect(v)
            v.current_frame++
            if(v.current_frame > 10)
                v.current_frame := 1
            if(v.current_frame == 1)
            {
                direction := v.get_direction()
                if(direction == Const.ENUM_DIRECTION_UP)
                    can_move := this.data.tank_move_r(0, -20, v, false)
                else if(direction == Const.ENUM_DIRECTION_DOWN)
                    can_move := this.data.tank_move_r(0, 20, v, false)
                else if(direction == Const.ENUM_DIRECTION_LEFT)
                    can_move := this.data.tank_move_r(-20, 0, v, false)
                else if(direction == Const.ENUM_DIRECTION_RIGHT)
                    can_move := this.data.tank_move_r(20, 0, v, false)

                if(!can_move)
                {
                    r := Random(1, 4)
                    v.set_direction(r)
                }
            }
        }
    }
    render()
    {
        this.view.draw()
    }
}

class Data
{
    __New() 
    {
        this.map_width := 520
        this.map_height := 520
        this.tk := Tank(180, 480)

        this.the_enemy_tk := Tank(0, 0, true)
        this.the_enemy_tks := [Tank(0, 0, true), Tank(0, 0, true), Tank(0, 0, true), Tank(0, 0, true), Tank(0, 0, true)]
        this.mp := [
                        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ],
                        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,2,2,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,2,2,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0 ],
                        [0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0 ],
                        [1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1 ],
                        [2,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1 ],
                        [0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0 ],
                        [0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,1,1,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,1,1,0,0,1,1,0,0,0,1,1,1,1,0,0,0,1,1,0,0,1,1,0,0 ],
                        [0,0,0,0,0,0,0,0,0,0,0,1,3,4,1,0,0,0,0,0,0,0,0,0,0,0 ],
                        [0,0,0,0,0,0,0,0,0,0,0,1,4,4,1,0,0,0,0,0,0,0,0,0,0,0 ]
                    ]
    }
    is_no_home()
    {
        if(this.mp[25][13] == 0 || this.get_tank().is_die())
            return true
        return false
    }
    is_all_die()
    {
        for k,v in this.the_enemy_tks
        {
            if(!v.is_die())
                return false
        }
        return true
    }
    get_tank()
    {
        return this.tk
    }
    get_map_width()
    {
        return this.map_width
    }
    get_map_height()
    {
        return this.map_height
    }
    fire_bullect(tank)
    {
        if(tank.current_bullect().get_status() == Bullect.ENUM_BULLECT_STATUS_EXIST)
            return
        tank.current_bullect().set_status(Bullect.ENUM_BULLECT_STATUS_EXIST)
        tank.current_bullect().set_position(tank.get_position()[1], tank.get_position()[2])
        bl := tank.current_bullect()
        dr := tank.get_direction()
        bl.set_direction(dr)
        if(Const.ENUM_DIRECTION_UP == dr)
        {
            x := bl.get_position()[1]
            bl.set_position_x(x + 10)
        }
        else if(const.ENUM_DIRECTION_DOWN == dr)
        {
            x := bl.get_position()[1]
            y := bl.get_position()[2]
            bl.set_position_x(x + 10)
            bl.set_position_y(y + 40)
        }
        else if(const.ENUM_DIRECTION_LEFT == dr)
        {
            y := bl.get_position()[2]
            bl.set_position_y(y + 10)
        }
        else if(const.ENUM_DIRECTION_RIGHT == dr)
        {
            x := bl.get_position()[1]
            y := bl.get_position()[2]
            bl.set_position_x(x + 40)
            bl.set_position_y(y + 10)
        }
    }
    tank_move_r(x, y, tank := unset, is_our := true)
    {
        if(!is_our)
        {
            if(x > 0)
                tank.set_direction(Const.ENUM_DIRECTION_RIGHT)
            else if(x < 0)
                tank.set_direction(Const.ENUM_DIRECTION_LEFT)
            else if(y > 0)
                tank.set_direction(Const.ENUM_DIRECTION_DOWN)
            else if(y < 0)
                tank.set_direction(Const.ENUM_DIRECTION_UP)
        }

        old_position := tank.get_position()
        old_col := Integer(old_position[1] / 20) + 1
        old_row := Integer(old_position[2] / 20) + 1

        px := tank.get_position()[1] + x
        py := tank.get_position()[2] + y
        col := Integer(px / 20) + 1
        row := Integer(py / 20) + 1
        is_can_move := false
        if(col >= 1 && col <= 25 && row >= 1 && row <= 25)
        {
            if((this.mp[row][col] == 0 || this.mp[row][col] == 200 || this.mp[row][col] == 100) 
                && (this.mp[row + 1][col] == 0 || this.mp[row + 1][col] == 200 || this.mp[row + 1][col] == 100) 
                && (this.mp[row][col + 1] == 0 || this.mp[row][col + 1] == 200 || this.mp[row][col + 1] == 100) 
                && (this.mp[row + 1][col + 1] == 0 || this.mp[row + 1][col + 1] == 200 || this.mp[row + 1][col + 1] == 100))
                is_can_move := true
        }
        if(is_can_move)
        {
            tank.set_position(px, py)
            this.mp[old_row][old_col] := 0
            this.mp[old_row][old_col + 1] := 0
            this.mp[old_row + 1][old_col] := 0
            this.mp[old_row + 1][old_col + 1] := 0
            if(is_our)
            {
                this.mp[row][col] := 200
                this.mp[row][col + 1] := 200
                this.mp[row + 1][col] := 200 
                this.mp[row + 1][col + 1] := 200
            }
            else
            {
                this.mp[row][col] := 100
                this.mp[row][col + 1] := 100
                this.mp[row + 1][col] := 100 
                this.mp[row + 1][col + 1] := 100
            }
        }
        return is_can_move
    }
    bullect_move(tank)
    {
        if(tank.current_bullect().get_status() == Bullect.ENUM_BULLECT_STATUS_EXIST)
        {
            dr := tank.current_bullect().get_direction()
            if(Const.ENUM_DIRECTION_UP == dr)
            {
                y := tank.current_bullect().get_position()[2]
                tank.current_bullect().set_position_y(y - Bullect.move_step)
            }
            else if(const.ENUM_DIRECTION_DOWN == dr)
            {
                y := tank.current_bullect().get_position()[2]
                tank.current_bullect().set_position_y(y + Bullect.move_step)
            }
            else if(const.ENUM_DIRECTION_LEFT == dr)
            {
                x := tank.current_bullect().get_position()[1]
                tank.current_bullect().set_position_x(x - Bullect.move_step)
            }
            else if(const.ENUM_DIRECTION_RIGHT == dr)
            {
                x := tank.current_bullect().get_position()[1]
                tank.current_bullect().set_position_x(x + Bullect.move_step)
            }
        }
        ;炮弹位置检测
        four_dot_row_col := tank.current_bullect().get_four_dot_row_col()
        if(!this.the_scope_of_overrun_detection(four_dot_row_col[1][1], four_dot_row_col[1][2])
            || !this.the_scope_of_overrun_detection(four_dot_row_col[2][1], four_dot_row_col[2][2])
            || !this.the_scope_of_overrun_detection(four_dot_row_col[3][1], four_dot_row_col[3][2])
            || !this.the_scope_of_overrun_detection(four_dot_row_col[4][1], four_dot_row_col[4][2]))
        {
            tank.current_bullect().set_status(Bullect.ENUM_BULLECT_STATUS_NO_EXIST)
            return
        }

        loop 4
        {
            a := A_Index
            if(this.collision_detection(four_dot_row_col[A_Index][1], four_dot_row_col[A_Index][2]))
            {
                this.mp[four_dot_row_col[A_Index][1]][four_dot_row_col[A_Index][2]] := 0
                tank.current_bullect().set_status(Bullect.ENUM_BULLECT_STATUS_NO_EXIST)
            }
            if(this.collision_detection_the_steel_plate(four_dot_row_col[A_Index][1], four_dot_row_col[A_Index][2]))
            {
                tank.current_bullect().set_status(Bullect.ENUM_BULLECT_STATUS_NO_EXIST)
            }
            ;有没有触碰敌方坦克
            if(!tank.is_enemy())
            {
                for k,v in this.the_enemy_tks
                {
                    r := Integer(v.position_y / 20) + 1
                    c := Integer(v.position_x / 20) + 1
                    if(four_dot_row_col[a][1] == r && four_dot_row_col[a][2] == c)
                    {
                        v.set_die(true)
                        break
                    }
                }
            }
            else
            {
                r := Integer(this.get_tank().get_position()[2] / 20) + 1
                c := Integer(this.get_tank().get_position()[1] / 20) + 1
                if(four_dot_row_col[a][1] == r && four_dot_row_col[a][2] == c)
                {
                    this.get_tank().set_die(true)
                    break
                }
                
            }
        }
    }
    ;炮弹碰撞检测,并消砖
    collision_detection(r, c)
    {
        if(this.mp[r][c] == 1 || this.mp[r][c] == 3 || this.mp[r][c] == 4)
            return true
        return false
    }
    ;炮弹碰撞检测,并消砖
    collision_detection_the_steel_plate(r, c)
    {
        if(this.mp[r][c] == 2)
            return true
        return false
    }
    ;地图范围检测
    the_scope_of_overrun_detection(r, c)
    {
        if(r >= 1 && r <= 26 && c >= 1 && c <= 26)
            return true
        return false
    }
}

class view
{
    __New(data) 
    {
        this.data := data
    }
    draw()
    {
        bc_draw_list := _ImGui_GetBackgroundDrawList()
        _ImDraw_SetDrawList(bc_draw_list)

        this.draw_back()
        this.draw_mp()
        this.draw_tank(this.data.get_tank())
        for k,v in this.data.the_enemy_tks
        {
            this.draw_tank(v)
        }
    }
    draw_back()
    {
        w := this.data.get_map_width()
        h := this.data.get_map_height()
        _ImDraw_AddQuadFilled(0, 0, w, 0, w, h, 0, h, 0xff000000)
    }
    draw_tank(tank)
    {
        if(tank.is_die())
            return
        position_x := tank.get_position()[1]
        position_y := tank.get_position()[2]
        direction := tank.get_direction()
        if(!tank.is_enemy())
        {
            if(Const.ENUM_DIRECTION_DOWN == direction)
                _ImDraw_AddImageFit(image_tank_down, position_x, position_y, 40, 40)
            else if(Const.ENUM_DIRECTION_UP == direction)
                _ImDraw_AddImageFit(image_tank_up, position_x, position_y, 40, 40)
            else if(Const.ENUM_DIRECTION_LEFT == direction)
                _ImDraw_AddImageFit(image_tank_left, position_x, position_y, 40, 40)
            else if(Const.ENUM_DIRECTION_RIGHT == direction)
                _ImDraw_AddImageFit(image_tank_right, position_x, position_y, 40, 40)
        }
        else
        {
            if(Const.ENUM_DIRECTION_DOWN == direction)
                _ImDraw_AddImageFit(image_enemy_tank_down, position_x, position_y, 40, 40)
            else if(Const.ENUM_DIRECTION_UP == direction)
                _ImDraw_AddImageFit(image_enemy_tank_up, position_x, position_y, 40, 40)
            else if(Const.ENUM_DIRECTION_LEFT == direction)
                _ImDraw_AddImageFit(image_enemy_tank_left, position_x, position_y, 40, 40)
            else if(Const.ENUM_DIRECTION_RIGHT == direction)
                _ImDraw_AddImageFit(image_enemy_tank_right, position_x, position_y, 40, 40)
        }

        if(tank.bl.status == Bullect.ENUM_BULLECT_STATUS_EXIST)
            _ImDraw_AddImageFit(image_bullect, tank.bl.position_x, tank.bl.position_y, 20, 20)
    }
    draw_mp()
    {
        for k,v in this.data.mp
        {
            current_row := A_Index
            for i,j in v
            {
                current_colum := A_Index
                current_postion := [20 * (current_colum - 1), 20 * (current_row - 1)]
                if(1 == j)
                {
                    _ImDraw_AddImageFit(image_wall, current_postion[1], current_postion[2], 20, 20)
                }
                else if(2 == j)
                {
                    _ImDraw_AddImageFit(image_steel, current_postion[1], current_postion[2], 20, 20)
                }
                else if(3 == j)
                {
                    _ImDraw_AddImageFit(image_home, current_postion[1], current_postion[2], 40, 40)
                }
            }
        }
    }
}