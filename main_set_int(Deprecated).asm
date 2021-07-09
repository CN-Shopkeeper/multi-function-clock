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