;通过键盘中断进入子程序选择器
;输入A进入计时器功能
;输入B进入闹钟设置功能
;输入C进入铃声选择功能
fun_chooser proc
	cmp al,'A'
	je go_fun_a
	cmp al,'B'
	je go_fun_b
	cmp al,'C'
	je go_fun_c
	jmp chooser_input_error
go_fun_a:
	call fun_a
	jmp done
go_fun_b:
	call fun_b
	jmp done
go_fun_c:
	call fun_c
	jmp done
	;输入不合法字符，退出选择器
chooser_input_error:
	mov ax,offset chooser_error_msg
	call dispmsg
done:
	ret
fun_chooser endp