include io.inc
.model small
.stack
.data
	;8255端口
	pa=288h
	pb=289h
	pc=28ah
	pcontroller=28bh
	;8254端口
	counter0=280h
	counter1=281h
	counter2=282h
	countercontroller=283h
	now_time word ?
	count_flag byte 0	;记录状态信息，0表示无操作，1表示正计时状态，2表示倒计时状态
	;时钟时间的分钟
	clock_minu byte ?
	;时钟时间的秒
	clock_sec byte ?
	;选择器输入错误
	chooser_error_msg byte "input error!",13,10,0
	;数字输入错误
	readnum_input_error_msg byte "please input a number between 0 and 9!",13,10,0
	;功能选择器提示
	fun_chooser_msg byte "press A to set counter!",13,10,"press B to set alarm!",13,10,"press C to set music!",13,10,0
	;音乐数据
	include data_music.asm
	;闹钟数据
	include data_alarm.asm
	;
	include data_keyboard.asm
	;
	include data_led.asm
	;
	include data_fun_a.asm
.code
start: mov ax,@data
	mov ds,ax
	;设置0bh号中断,IRQ3
	mov ax,350bh
	int 21h
	push es
	push bx
	cli
	push ds
	mov ax,seg clock_interrupt
	mov ds,ax
	mov dx,offset clock_interrupt
	mov ax,250bh
	int 21h
	pop ds
	in al,21h
	push ax
	and al,11110111b	;IRQ3
	out 21h,al
	sti

	;初始化时钟的分钟
	xor ax,ax
    mov al,2
    out 70h,al
    in al,71h
    mov bl,16
    div bl
	mov bh,ah
	mov bl,10
	mul bl
	add al,bh
	mov clock_minu,al
	;初始化时钟的秒
	mov clock_sec,0

	call init_counter	;初始化计数器,启动计时
	
	;设置8255并行端口控制字
	mov dx,pcontroller
	mov al,10000001b
	;A端口：用于位控制
	;B端口：用于
	;C端口：用于读取简易键盘
	out dx,al
	
	mov ax,offset fun_chooser_msg
	call dispmsg
main_again:
	mov cx,10
main_time:
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
	call has_alarm
	jnz continue_disp
	;取消闹钟
	mov alarm_flag,0
	call play_alarm
continue_disp:	
	loop main_time

	mov cx,10
main_date:
	call readkey_my
	;如果没有键盘输入
	jnz disp_date
	;有键盘输入，就检查输入值
	cmp al,'F'
	jz main_done
	call fun_chooser
disp_date:
	;显示日期
	call show_mon_day
	loop main_date
	jmp main_again
main_done:
	;恢复0bh号中断
	cli
	pop ax
	out 21h,al
	pop dx
	pop ds
	mov ax,250bh
	int 21h
	sti
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
	include fun_a.asm
	include fun_a_neg.asm
	include fun_a_posi.asm
	include fun_a_timer.asm
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

;延时子程序
delay_clock proc
	push cx
	xor cx,cx
delay_clock1:
	loop delay_clock1
	pop cx
	ret
delay_clock endp

;判断现在是否是闹钟时间
has_alarm proc
	push ax
	push bx

	xor ax,ax
	mov al,clock_minu
	cmp al,alarm_minu
	;如果不相同就退出，zf=1
	jnz has_alarm_done

	xor ax,ax
	mov al,4
    out 70h,al
    in al,71h
	mov bl,16
    div bl  ;无符号数除法，al=ax/10，ah=余数
	mov bh,ah	;保存ah中的余数
	mov bl,10	;al扩大十倍
	mul bl
	add al,bh	;al相加得到原十进制数字
	cmp al,alarm_hour

has_alarm_done:
	pop bx
	pop ax
	ret
has_alarm endp

end start