include io.inc
.model small
.stack
.data
	pa=288h
	pb=289h
	;音乐数据
	include data_music.asm
	;闹钟数据
	include data_alarm.asm
.code
start: mov ax,@data
	mov ds,ax
	include main_set_int.asm
main_again:
	call readkey
	;如果没有键盘输入
	jz disp_time
	;有键盘输入，就检查输入值
	cmp al,'F'
	jz main_done
	call fun_chooser
disp_time:
	;todo: 显示时分
	call show_hour_min
	;todo: 判断有无闹钟，判断该时间是否为闹钟时刻
	
	call readkey
	;如果没有键盘输入
	jz disp_date
	;有键盘输入，就检查输入值
	cmp al,'F'
	jz main_done
	call fun_chooser
disp_date:
	;todo 显示日期
	call show_mon_day
	jmp main_again
main_done:
	include main_rec_int.asm
	.exit 0
	
	;键盘中断子程序
	include keyboard_int.asm
	;子程序选择器
	include fun_chooser.asm
	;扬声器子程序
	include speaker.asm
	;功能A，计时器
	;todo
	;功能B，闹钟
	include fun_b.asm
	;功能C，铃声设置
	include fun_c.asm
;延时子程序
delay proc
	push cx
	xor cx,cx
delay_again:
	loop delay_again
	pop cx
	ret
delay endp
	end start