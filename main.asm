include io.inc
.model small
.stack
.data
	pa=288h
	pb=289h
	pc=28ah
	pcontroller=28bh
	;选择器输入错误
	chooser_error_msg byte "input error!",13,10,0
	;数字输入错误
	readnum_input_error_msg byte "please input a number between 0 and 9!",13,10,0
	;音乐数据
	include data_music.asm
	;闹钟数据
	include data_alarm.asm
	;
	include data_keyboard.asm
.code
start: mov ax,@data
	mov ds,ax
	;设置08h号中断
	;mov dx,3508h
	;int 21h
	;push es
	;push bx
	;cli
	;push ds
	;mov ax,seg new08h
	;mov ds,ax
	;mov kdx,offset new08h
	;mov ax,2508h
	;int 21h
	;pop ds
	;in al,21h
	;push ax
	;and al,0feh
	;out 21h,al
	;sti

	;设置8255并行端口控制字
	mov dx,pcontroller
	mov al,10000001b
	;A端口：用于位控制
	;B端口：用于
	;C端口：用于读取简易键盘
	out dx,al
main_again:
	call readkey_my
	;如果没有键盘输入
	jnz disp_time
	;有键盘输入，就检查输入值
	cmp al,'F'
	jz main_done
	call fun_chooser 
disp_time:
	;显示时分
	call show_hour_min
	;判断有无闹钟，判断该时间是否为闹钟时刻
	cmp alarm_flag,0
	jz continue_disp
	;有闹钟
	mov al,origin_hour
	;比较小时数
	cmp alarm_hour,al
	jnz continue_disp
	mov al,origin_min
	;比较分钟数
	cmp alarm_minu,al
	jnz continue_disp
	;当前时间为闹钟时间播放响铃
	call play_alarm
continue_disp:	
	call readkey_my
	;如果没有键盘输入
	jnz disp_date
	;有键盘输入，就检查输入值
	cmp al,'F'
	jz main_done
	call fun_chooser
disp_date:
	;todo 显示日期
	call show_mon_day
	jmp main_again
main_done:
	;恢复08h号中断
	;cli
	;pop ax
	;out 21h,al
	;pop dx
	;pop ds
	;mov ax,2508h
	;int 21h
	;sti
	.exit 0
	
	;键盘服务子程序
	include readc_my.asm
	include readkey_my.asm
	include readnum.asm
	;子程序选择器
	include fun_chooser.asm
	;扬声器子程序
	include speaker.asm
	;功能A，计时器
	;include fun_a.asm
	;include fun_a_timer.asm
	;功能B，闹钟
	include fun_b.asm
	;功能C，铃声设置
	include fun_c.asm
	;主程序时间显示
	include fun_clock.asm
	;
	include show_time.asm
;延时子程序
delay proc
	push cx
	push bx
	mov bx,20
delay1:xor cx,cx
delay2:
	loop delay2
	dec bx
	jnz delay1
	pop bx
	pop cx
	ret
delay endp

;响应计数器1的中断
new08h proc
	;每40次中断时间counter-1
	sti
	push ax
	push dx
	push ds
	mov ax,@data
	mov dx,ax
	;dec count40

	mov al,20h	;send EOI
	out 20h,al
	pop ds
	pop dx
	pop ax
	iret
new08h endp

end start