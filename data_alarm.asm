;存储闹钟的小时数
alarm_hour byte 0
;存储闹钟的分钟数
alarm_minu byte 0
;存储是否设置了闹钟
alarm_flag byte 0
;进入闹钟功能时的提示
alarm_start_msg byte 13,10,"input A to set or modify the alarm!",13,10,"input B to cancel the alarm",13,10,0
;
set_alarm_msg byte 13,10,"input 4 numbers",13,10,0
;设置闹钟成功后的提示
alarm_success_msg byte 13,10,"alarm setted!",13,10,0
;设置闹钟失败的提示
alarm_input_error_msg byte 13,10,"input error! exit this function",13,10,0
;取消闹钟成功的提示
alarm_cancel_msg byte 13,10,"alarm canceled!",13,10,0