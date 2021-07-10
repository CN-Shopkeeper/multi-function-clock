;倒计时（设置时钟初值，暂停/开始，结束响铃）
;子功能B：倒计时
funB_count_down proc
	push ax
	;先让用户设置倒计时计数初值
	mov ax,offset fun_a_neg_menu
	call dispmsg
fun_b_chooser:
	call readc_my	;出口参数al=char ascii
	;switch to corresponding function
	cmp al,'A'
	jz b_start_timing
	cmp al,'B'
	jz b_pause_timing
	cmp al,'F'				;若要想退出时数码管不显示，可以调用clear子程序
	jmp neg_timing_done
	;wrong input dealing
	mov ax,offset prompt_msg
	call dispmsg
	jmp fun_b_chooser
b_start_timing:
	call init_counter1	;初始化计数器1
fun_posi_again:
	call fun_posi		;正计时并显示时间
	;检测键盘是否有按键，若无继续正计时显示时间
	;--------------------------------------------------这里是jnz表示没有键盘输入
	call readkey_my
	jnz fun_posi_again
	jmp check_key_again
b_pause_timing:
	;循环显示now_time
	mov ax,now_time[0]
	mov bx,now_time[1]
pause_timing_again:
	call show_time
	call readkey_my
	;--------------------------------------------------这里是jnz表示没有键盘输入
	jnz pause_timing_again
	jmp check_key_again
neg_timing_done:
	pop ax
    ret
funB_count_down endp