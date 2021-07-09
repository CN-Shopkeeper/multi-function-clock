	cli ;关中断
	pop ax ;恢复IMR
	out 21h,al
	pop dx
	pop ds
	mov ax,2509h
	int 21h
	sti ;开中断