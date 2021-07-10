;计时器，包含正计时，倒计时，返回
fun_a proc
	push ax

    ;show menu info
funAmenu_msg:
    mov ax,offset fun_a_menu
    call dispmsg

choose_2_func_again:
	call readc_my	;出口参数al=char
	cmp al,'A'
    jz call_funcA_positive_timing
	cmp al,'B'
	jz call_funcB_count_down
    cmp al,'F'
    jz fun_a_done
    ;wrong input dealing->enter again
	mov ax,offset wrong_input_msg
	call dispmsg
    jmp choose_2_func_again


call_funcA_positive_timing:
    call funcA_positive_timing
    jmp funAmenu_msg    ;这种结构可以做到子程序返回上一级时显示上一级菜单
call_funcB_count_down:
    call call_funcB_count_down
    jmp funAmenu_msg

func_a_done:
    pop ax
    ret
fun_a endp

