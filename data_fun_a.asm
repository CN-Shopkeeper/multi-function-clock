;输入选项错误时的消息提示
wrong_input_msg byte 13,10,'wrong input! Please enter again!',13,10,0
;计时功能的菜单和操作提示
fun_a_menu byte 13,10,35 dup('*'),13,10
    byte '*     A.positive timing     *',13,10
    byte '*     B.countdown           *',13,10
    byte '*     F.return              *',13,10
    byte 35 dup('*'),13,10,0
;提示设置计时初值
fun_a_timing_msg byte 13,10,'please set initial minute and second :',13,10,0
fun_a_timing_min_msg byte 13,10,'Input minute(<60):',13,10,0
fun_a_timing_sec_msg byte 13,10,'Input second(<60):',13,10,0

;正向计时设置计时初值后的菜单信息
fun_a_pos_menu byte 13,10,35 dup('*'),13,10
    byte '*     A.start/pause positive timing   *',13,10
    byte '*     B.return to ZERO                *',13,10
    byte '*     F.return                        *',13,10
    byte 35 dup('*'),13,10,0

;倒计时设置计时初值后的菜单信息
fun_a_neg_menu byte 13,10, 35 dup('*'),13,10
    byte 'A.start/pause countdown',13,10
    byte 'F.return',13,10
    byte 35 dup('*'),13,10,0

YN byte 13,10,'Yes(A)/No(B)?:',13,10,0