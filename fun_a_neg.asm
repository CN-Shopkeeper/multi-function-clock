;倒计时（设置时钟初值，暂停/开始，结束响铃）
fun_a_neg proc
	push ax
	push bx
	;先让用户设置倒计时计数初值
	call init_val
	mov ax,offset fun_a_neg_menu
	call dispmsg
fun_b_chooser:
	call readc_my	;出口参数al=char ascii
	;switch to corresponding function
b_check_key_again:
	cmp al,'A'
	jz b_start_timing
	cmp al,'B'
	jz b_pause_timing
	cmp al,'F'				;若要想退出时数码管不显示，可以调用clear子程序
	jmp neg_timing_done
	;wrong input dealing
	mov ax,offset wrong_input_msg
	call dispmsg
	jmp fun_b_chooser
b_start_timing:
	mov count_flag,2
	b_start_timing_again:
	call sec_to_minsec
	call show_time
	call readkey_my	;如果没有键盘输入则持续显示时间
	jnz b_start_timing_again
fun_neg_again:
	mov count_flag,2
	call sec_to_minsec
	;检测键盘是否有按键，若无继续正计时显示时间
	call readkey_my
	jnz fun_neg_again
	jmp b_check_key_again
b_pause_timing:
	;循环显示now_time
	mov count_flag,0
	b_pause_timing_again:
	call sec_to_minsec
	call readkey_my
	jnz b_pause_timing_again
	jmp b_check_key_again
neg_timing_done:
	pop bx
	pop ax
    ret
fun_a_neg endp