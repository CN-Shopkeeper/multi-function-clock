
	;键盘输入子程序readc
readc_my proc
	push dx
	push cx
	push si
	push di
readc_1:
	mov dx,pc
	mov al,0b
	out dx,al
	call delay
	in al,dx
	and al,00001111b
	cmp al,00001111b
	jz readc_1
	call delay
	mov cx,4
	mov ah,11100000b
readc_2:
	mov al,ah
	out dx,al
	in al,dx
	call delay
	and al,00001111b
	cmp al,00001111b
	jnz readc_3
	shl ah,1
	add ah,10000b
	loop readc_2
	jmp readc_1

readc_3:
	mov si,offset ttable
	mov di,offset char
	mov cx,16
	add al,ah
readc_4:
	cmp al,[si]
	jz readc_5
	inc si
	inc di
	loop readc_4
	jmp readc_1
readc_5:
	mov al,[di]
	call dispc
	call delay

	pop di
	pop si
	pop cx
	pop dx
	ret
readc_my endp