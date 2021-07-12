;存储闹钟的小时数
alarm_hour byte 0
;存储闹钟的分钟数
alarm_minu byte 0
;存储是否设置了闹钟
alarm_flag byte 0
;进入闹钟功能时的提示
alarm_start_msg byte 13,10,"input A to set or modify the alarm!",13,10
    byte "input B to cancel the alarm",13,10
    byte "input F to quit",13,10,0
;设置闹钟提示输入小时和分钟
set_alarm_msg byte 13,10,"input 4 numbers",13,10,0
;设置闹钟成功后的提示
alarm_success_msg byte 13,10,"alarm setted!",13,10,0
;设置闹钟失败的提示
alarm_input_error_msg byte 13,10,"input error! exit this function",13,10,0
;取消闹钟成功的提示
alarm_cancel_msg byte 13,10,"alarm canceled!",13,10,0
;当前已经存在一个设置了一个闹钟
has_alarm_msg byte 13,10,"now alarm is ",0
;当前没有设置过闹钟
no_alarm_msg byte 13,10,"now no alarm!",13,10,0