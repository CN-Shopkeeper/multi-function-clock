	;键盘输入子程序readc
	;出口参数al，输入字符的ascii
readc_my proc
	push dx
	push cx
	push si
	push di
	;扫描键盘，判断是否有按键输入
readc_1:
	mov dx,pc
	mov al,0b;所有行置零
	out dx,al
	call delay_clock
	in al,dx
	and al,00001111b;判断列值是否为全1
	cmp al,00001111b
	jz readc_1
	call delay

	;找到循环行列值
	;al的高四位是行，低四位是列
	mov cx,4
	mov ah,11100000b
readc_2:
	mov al,ah
	out dx,al
	in al,dx
	call delay_clock
	and al,00001111b
	cmp al,00001111b
	jnz readc_3
	shl ah,1
	add ah,10000b
	loop readc_2
	jmp readc_1

	;查表找出字符
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

	;将字符保存在al并且回显
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