;正计时（设置时钟初值，暂停，清空）
fun_a_posi proc
	push ax
	push bx
	;先让用户设置计数初值
	call init_val		;设置并显示计时初值（todo只能显示一小段时间，若要持续显示须改进）
	mov ax,offset fun_a_pos_menu	;显示器显示菜单
	call dispmsg
fun_a_chooser:	;功能选择
	call readc_my	;出口参数al
	;switch to corresponding function
a_check_key_again:
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
	mov count_flag,1
	call init_counter	;初始化计数器,启动计时
	a_start_timing_again:
	call sec_to_minsec
	call show_time
	call readkey_my	;如果没有键盘输入则持续显示时间
	jnz a_start_timing_again
	jmp a_check_key_again
fun_posi_again:
	mov count_flag,1
	call sec_to_minsec
	;检测键盘是否有按键，若无继续正计时显示时间
	call readkey_my
	jnz fun_posi_again
	jmp a_check_key_again
a_pause_timing:
	;循环显示now_time
	mov count_flag,0
	a_pause_timing_again:
	call sec_to_minsec
	call readkey_my
	jnz a_pause_timing_again
	jmp a_check_key_again
a_return_zero:
	mov now_time,0
	mov count_flag,0
	return_zero_again:
	call sec_to_minsec
	call show_time
	call readkey_my
	jnz return_zero_again
	jmp check_key_again
positive_timing_done:
	pop bx
	pop ax
    ret
fun_a_posi endp