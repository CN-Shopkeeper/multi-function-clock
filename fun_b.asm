;闹钟功能
;输入A以设置闹钟，闹钟的时间将存储在暂存DX中，当数值合法时，alarm_flag为1，表示有闹钟设置成功，闹钟时间存在内存变量alarm_hour和alarm_minu中
;输入B以取消闹钟，直接将alarm_flag设置为0即可
fun_b proc
	push ax
	push bx
	push dx
fun_b_begin:
	mov ax,offset alarm_start_msg
	call dispmsg
	;输入分支选择
	call readc_my
	cmp al,'A'
	jz set_alarm
	cmp al,'B'
	jz cancel_alarm
	cmp al,'F'
	jz fun_b_done
	jmp fun_b_begin
;设置闹钟功能
set_alarm:
	mov ax,offset set_alarm_msg
	call dispmsg
	xor dx,dx
	;读入小时
	call read2bit
	mov dh,al
	;比较输入的小时数，如果大于24就报错
	cmp dh,23
	jg alarm_input_error
	;todo 将设置的小时数显示到数码管上
	
	;读入分钟
	call read2bit
	mov dl,al
	;比较输入的分钟数，如果大于59就报错
	cmp dl,59
	ja alarm_input_error
	;todo 将设置的分钟数显示到数码管上
	
	;存储设置的闹钟配置
	mov alarm_flag,1
	mov alarm_hour,dh
	mov alarm_minu,dl
	mov ax,offset alarm_success_msg
	call dispmsg
	jmp fun_b_done
alarm_input_error:
	mov ax,offset alarm_input_error_msg
	call dispmsg
	jmp fun_b_done
;取消闹钟功能
cancel_alarm:
	mov alarm_flag,0
	mov ax,offset alarm_cancel_msg
	call dispmsg
;程序结束处
fun_b_done:
	pop dx
	pop bx
	pop ax
	ret
fun_b endp

;播放当前设置的闹钟铃声
;used_music表示选择的铃声
play_alarm proc
	;判断铃声
	cmp used_music,0
	je play_alarm_birthday
	cmp used_music,1
	je play_alarm_blackteam
	jmp play_alarm_sky
play_alarm_birthday:
	call play_birthday
	jmp play_alarm_done
play_alarm_blackteam:
	call play_blackteam
	jmp play_alarm_done
play_alarm_sky:
	call play_sky
play_alarm_done:
	ret
play_alarm endp