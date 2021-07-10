;计时器，包含正计时（设置时钟初值，暂停，清空）
;子功能A：正向计时
funA_positive_timing proc
	push ax
	push bx
	;先让用户设置计数初值
	call init_val		;设置并显示计时初值（todo只能显示一小段时间，若要持续显示须改进）
	mov ax,offset fun_a_pos_menu	;显示器显示菜单
	call dispmsg
fun_a_chooser:	;功能选择
	call readc_my	;出口参数al=char ascii
	;switch to corresponding function
check_key_again:
	cmp al,'A'
	;start positive timing
	jz a_start_timing
	cmp al,'B'
	;pause/continue
	jz a_pause_timing
	cmp al,'C'
	jz a_return_zero
	cmp al,'F'
	;return
	jz positive_timing_done
	;other：choose again
	mov ax,offset prompt_msg
	call dispmsg
	jmp fun_a_chooser
a_start_timing:
	call init_counter1	;初始化计数器1
fun_posi_again:
	call fun_posi		;正计时并显示时间
	;检测键盘是否有按键，若无继续正计时显示时间
	call readkey_my
	;--------------------------------------------------这里是jnz表示没有键盘输入
	jnz fun_posi_again
	jmp check_key_again
a_pause_timing:
	;循环显示now_time
	mov ax,now_time[0]
	mov bx,now_time[1]
pause_timing_again:
	call show_time
	call readkey_my
	;--------------------------------------------------这里是jnz表示没有键盘输入
	jnz pause_timing_again
	jmp check_key_again
a_return_zero:
	mov ax,0
	mov bx,0
	mov now_time[0],0
	mov now_time[1],0
return_zero_again:
	call show_time
	call readkey_my
	;--------------------------------------------------这里是jnz表示没有键盘输入
	jnz return_zero_again
	jmp check_key_again
positive_timing_done:
	pop bx
	pop ax
    ret
funA_positive_timing endp
