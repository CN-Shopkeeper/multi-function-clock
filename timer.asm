;计时器，包含正计时（设置时钟初值，暂停/开始，清空），倒计时（设置时钟初值，暂停/开始，结束响铃）
;入口参数
;出口参数
now_time byte 2 dup(?);0存分，1存秒
;正向计时
funcA_positive_timing proc
	push eax
	push bx
	mov eax,offset pos_menu
	call dispmsg
choose_2_funA:	;功能选择
	call readc	;出口参数al=char ascii
	;switch to corresponding function
	cmp al,'A'
	;start positive timing
	jz start_timing
	cmp al,'B'
	;pause/continue
	jz pause_timing
	cmp al,'C'
	jz returnZero
	cmp al,'F'
	;return
	jz positive_timing_done
	;other
	mov eax,offset prompt_msg
	call dispmsg
	jmp choose_2_funA
start_timing:
	call init_counter1	;初始化计数器1
returnZero:
	mov ax,0
	mov bx,0
	call show_time
positive_timing_done:
	pop bx
	pop eax
    ret
funcA_positive_timing endp




;倒计时
funcB_count_down proc
	push eax
	mov eax,offset neg_menu
	call dispmsg
choose_2_funB:
call readc	;出口参数al=char ascii
	;switch to corresponding function
	cmp al,'A'
	jz funcA_positive_timing
	cmp al,'B'
	jz funcB_count_down	;wrong input dealing
	mov ax,offset prompt_msg
	call dispmsg
	jmp choose_2_funA
	pop eax
    ret
funcB_count_down endp





;设置8254计数器1每25ms产生一次中断
;40000
init_counter1 proc
	push dx
	push ax
	mov dx,控制端口地址
	mov al,01110101b	;计数器1，工作方式2，10进制
	out dx,al
	mov dx,计数器1端口地址
	mov ax,40000	;写入计数初值
	out dx,al
	mov al,ah
	out dx,al
	pop ax
	pop dx
	ret
init_counter1 endp


init_val proc
	;设置时钟初值
	;低于60检查
	push eax
	push bx
	mov eax,offset timing_msg
	call dispmsg
check_minute:
	;读取分钟
	mov eax, offset timing_min_msg
	call dispmsg
	readuib	;输入无符号十进制整数，出口参数Al=8位
	cmp al,60
	ja check_minute
	mov bh,al;存储分钟数
check_second:
	;读取秒
	mov eax,offset timing_sec_msg
	call dispmsg
	readuib
	cmp al,60
	ja check_second
	mov bl,al;存储秒数
	mov eax,offset YN
	call dispmsg
	call readuib	;输入无符号十进制整数AL
	cmp al,1	;输入1则显示到数码管
	jz show_init_time
	;输入0则让用户重新输入
	jmp check_time
show_init_time:
	mov ah,0
	mov al,bh
	call divide
	push ax	;栈暂存分钟数据
	mov ah,0
	mov al,bl
	call divide
	push ax	;栈保存秒数据
	pop bx	;秒放在bx
	pop ax	;分放在ax
	call show_time	;调用子程序在数码管上显示计时初值
	mov now_time[0],ax
	mov now_time[1],bx
	pop bx
	pop eax
	ret
init_val endp
