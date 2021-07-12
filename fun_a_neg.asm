;倒计时（设置时钟初值，暂停/开始，结束响铃）
fun_a_neg proc
	push ax
	push bx
	;先让用户设置倒计时计数初值
	call init_val
	mov ax,offset fun_a_neg_menu
	call dispmsg
fun_a_neg_chooser:
	call readc_my	;出口参数al=char ascii
	;switch to corresponding function
neg_check_key_again:
	cmp al,'A'
	jz neg_start_timing
	cmp al,'F'				;若要想退出时数码管不显示，可以调用clear子程序
	jmp neg_timing_done
	;wrong input dealing
	mov ax,offset wrong_input_msg
	call dispmsg
	jmp fun_a_neg_chooser
neg_start_timing:
	cmp count_flag,0
	jz neg_count_flag_set2
	mov count_flag,0
	jmp neg_start_timing_again
	neg_count_flag_set2:
	mov count_flag,2
	neg_start_timing_again:
	call sec_to_minsec
	call show_time
	mov al,bl
	call dispuib
	call delay
	cmp now_time,0
	jz fun_a_neg_play_alarm
	call readkey_my	;如果没有键盘输入则持续显示时间
	jnz neg_start_timing_again
	jmp neg_check_key_again	;有输入则检查功能
fun_a_neg_play_alarm:
	call play_alarm
neg_timing_done:
	mov count_flag,0
	pop bx
	pop ax
    ret
fun_a_neg endp