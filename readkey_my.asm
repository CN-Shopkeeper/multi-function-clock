	;键盘按键检测子程序readkey
    ;如果有按键，zf为1，al为按键输入的字符
	;流程与readc_my相同
readkey_my proc
	push dx
	push cx
	push si
	push di

	mov dx,pc
	mov al,0b
	out dx,al
	call delay_clock
	in al,dx
	and al,00001111b
	cmp al,00001111b
	jz readkey_nothing
	call delay
	mov cx,4
	mov ah,11100000b
readkey_2:
	mov al,ah
	out dx,al
	in al,dx
	call delay_clock
	and al,00001111b
	cmp al,00001111b
	jnz readkey_3
	shl ah,1
	add ah,10000b
	loop readkey_2
	jmp readkey_nothing

readkey_3:
	mov si,offset ttable
	mov di,offset char
	mov cx,16
	add al,ah
readkey_4:
	cmp al,[si]
	jz readkey_5
	inc si
	inc di
	loop readkey_4
	jmp readkey_nothing
readkey_5:
	mov al,[di]
	call dispc
	call delay
	jmp readkey_done
readkey_nothing:
	cmp al,0	;zf=0
readkey_done:
	pop di
	pop si
	pop cx
	pop dx
	ret
readkey_my endp
