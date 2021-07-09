include io.inc 
.model small
.stack
.data
    pa=288h
	pb=289h
.code
start: mov ax,@data
	mov ds,ax
	mov ax,3509h ;获取原来的09h的中断向量表项、
	int 21h
	push es 
	push bx
	cli
	push ds
	mov ax,seg keyboard_int
	mov ds,ax
	mov dx,offset keyboard_int
	mov ax,2509h
	int 21h
	pop ds
	in al,21h;获取IMR
	push ax;保存原IMR内容
	and al,0fdh;允许IRQ1，其他不变 1111,1101
	out 21h,al
	sti ;开中断
main_again:
	call readkey
	xor cx,cx
	jz de
	call dispc
	call crlf
de:
    call delay
    loop de
	jmp main_again
main_done:
	cli ;关中断
	pop ax ;恢复IMR
	out 21h,al
	pop dx
	pop ds
	mov ax,2509h
	int 21h
	sti ;开中断
	.exit 0
	
	;键盘中断子程序
	;出口参数AL
keyboard_int proc
	sti
	push dx
	push cx
	push si
	push di
key1:
	;pa4~pa7为行，pb0~pb4为列
	and al,00001111b ;行值清零
	mov dx,pa  	
	out dx,al
	mov dx,pb
	in al,dx
	and al,00001111b
	cmp al,00001111b
	jz key1
	call delay

	mov cx,4
	mov ah,11100000b
key2:
	mov al,ah
	mov dx,pa
	out dx,al
	mov dx,pb
	in al,dx
	and al,00001111b
	cmp al,00001111b
	jnz key3
	shl ah,1
	add ah,10000b
	loop key2
	jmp key1

key3:
	mov si,offset table
	mov di,offset char
	mov cx,16
key4:
	add al,ah
	cmp al,[si]
	jz key5
	inc si
	inc di
	loop key4
	jmp key1
key5:
	mov al,[di]
	call delay

	pop di
	pop si
	pop cx
	pop dx
	iret
keyboard_int endp
table byte 01110111b,01111011b,01111101b,01111110b
	byte 10110111b,10111011b,10111101b,10111110b
	byte 11010111b,11011011b,11011101b,11011110b
	byte 11100111b,11101011b,11101101b,11101110b
char byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
;延时子程序
delay proc
	push cx
	xor cx,cx
delay_again:
	loop delay_again
	pop cx
	ret
delay endp
	end start