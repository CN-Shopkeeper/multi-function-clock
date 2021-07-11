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
	cmp al,'F'				;若要想退出时数码管不显示，可以调用clear子程序
	jmp neg_timing_done
	;wrong input dealing
	mov ax,offset wrong_input_msg
	call dispmsg
	jmp fun_b_chooser
b_start_timing:
	cmp count_flag,0
	jz count_flag_set2
	mov count_flag,0
	jmp b_start_timing_again
	count_flag_set2:
	mov count_flag,2
	b_start_timing_again:
	call sec_to_minsec
	call show_time
	call readkey_my	;如果没有键盘输入则持续显示时间
	jnz b_start_timing_again
	jmp b_check_key_again	;有输入则检查功能
neg_timing_done:
	pop bx
	pop ax
    ret
fun_a_neg endp