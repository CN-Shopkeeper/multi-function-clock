;从简易键盘读取一个数字0~9
;如果读取的是字母将会提示重新输入
;出口al
readnum proc
readnum_begin:
    call readc_my
    cmp al,'0'
	jl readnum_input_error
	cmp al,'9'
	ja readnum_input_error
	sub al,'0'
    jmp readnum_done
readnum_input_error:
    mov ax,offset readnum_input_error_msg
    call dispmsg
    jmp readnum_begin
readnum_done:
    ret
readnum endp

;从简易键盘读取一个两位数
;调用readnum，错误处理交给readnum
;结果保存在al
read2bit proc
    push bx
    mov bl,10
    ;读到了十位的数
	call readnum
    ;相乘得到十位
	mul bl
	mov bh,al
    ;读到了个位的数
	call readnum
	add al,bh
    pop bx
    ret
read2bit endp