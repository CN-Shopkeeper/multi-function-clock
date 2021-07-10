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
    jz call_fun_a_posi
	cmp al,'B'
	jz call_fun_a_neg
    cmp al,'F'
    jz fun_a_done
    ;wrong input dealing->enter again
	mov ax,offset wrong_input_msg
	call dispmsg
    jmp choose_2_func_again


call_fun_a_posi:
    call fun_a_posi
    jmp funAmenu_msg    ;这种结构可以做到子程序返回上一级时显示上一级菜单
call_fun_a_neg:
    call fun_a_neg
    jmp funAmenu_msg

fun_a_done:
    pop ax
    ret
fun_a endp

