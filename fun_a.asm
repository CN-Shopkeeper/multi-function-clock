fun_a proc
;计时器，包含正计时（设置计时初值，暂停，清空），倒计时（设置计时初值，暂停计时，结束响铃）
;入口参数
;出口参数

	push eax
    ;show menu info
funAmenu_msg:
    mov eax,offset fun_a_menu
    call dispmsg

choose_2_func_again:	;二级功能选择
	call readc	;出口参数al=char ascii
	;switch to corresponding function
	cmp al,'A'
    jz call_funcA_positive_timing
	cmp al,'B'
	jz call_funcB_count_down
    cmp al,'F'
    jz fun_a_done
    ;wrong input dealing->enter again
	mov eax,offset wrong_input_msg
	call dispmsg
    jmp choose_2_func_again


call_funcA_positive_timing:
    call funcA_positive_timing
    jmp funAmenu_msg    ;这种结构可以做到子程序返回上一级时显示上一级菜单
call_funcB_count_down:
    call call_funcB_count_down
    jmp funAmenu_msg

func_a_done:
    pop eax
    ret
fun_a endp

