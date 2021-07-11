;输入选项错误时的消息提示
wrong_input_msg byte 'wrong input! Please enter again!',13,10,0
;计时功能的菜单和操作提示
fun_a_menu byte 'A.positive timing',13,10
    byte 'B.countdown',13,10
    byte 'F.return',13,10
    byte 'choose A/B or press F to return',13,10,0
;提示设置计时初值
fun_a_timing_msg byte 'please set initial minute and second :',13,10,0
fun_a_timing_min_msg byte 'Input minute(<60):',13,10,0
fun_a_timing_sec_msg byte 'Input second(<60):',13,10,0

;正向计时设置计时初值后的菜单信息
fun_a_pos_menu byte 'A.start/pause positive timing',13,10
    byte 'B.return to ZERO',13,10
    byte 'F.return',13,10
    byte 'choose A/B or press F to return',13,10,0

;倒计时设置计时初值后的菜单信息
fun_a_neg_menu byte 'A.start/pause countdown',13,10
    byte 'F.return',13,10
    byte 'choose A or press F to return',13,10,0

YN byte 'Yes/No(Y/N)?:',13,10,0