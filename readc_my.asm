
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
	call dispcrlf
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
	call delay

	pop di
	pop si
	pop cx
	pop dx
	ret
readc_my endp

ttable byte 01110111b,01111011b,01111101b,01111110b
	byte 10110111b,10111011b,10111101b,10111110b
	byte 11010111b,11011011b,11011101b,11011110b
	byte 11100111b,11101011b,11101101b,11101110b
char byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
	