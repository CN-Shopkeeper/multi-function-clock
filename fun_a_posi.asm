;正计时（设置时钟初值，暂停，清空）
fun_a_posi proc
	push ax
	push bx
	;先让用户设置计数初值
	call init_val		;设置并显示计时初值
fun_a_posi_show_menu:
	mov ax,offset fun_a_pos_menu	;显示器显示菜单
	call dispmsg
fun_a_posi_chooser:	;功能选择
	call readc_my	;出口参数al
	;switch to corresponding function
posi_check_key_again:
	cmp al,'A'
	;start positive timing
	jz posi_start_timing
	cmp al,'B'
	jz posi_return_zero
	cmp al,'F'
	;return
	jz positive_timing_done
	;other：choose again
	mov ax,offset wrong_input_msg
	call dispmsg
	jmp fun_a_posi_show_menu
posi_start_timing:
	cmp count_flag,0
	jz posi_count_flag_set1	;若初始count_flag为0则置1
	mov count_flag,0	;若初始count_flag为1则置0
	jmp posi_start_timing_again
posi_count_flag_set1:
	mov count_flag,1
posi_start_timing_again:
	call sec_to_minsec
	call show_time
	mov al,bl
	call dispuib
	call delay
	call readkey_my	;如果没有键盘输入则持续显示时间
	jnz posi_start_timing_again
	jmp posi_check_key_again
posi_return_zero:
	mov now_time,0
	mov count_flag,0
	return_zero_again:
	call sec_to_minsec
	call show_time
	call delay
	call readkey_my
	jnz return_zero_again
	jmp posi_check_key_again
positive_timing_done:
	mov count_flag,0
	pop bx
	pop ax
    ret
fun_a_posi endp