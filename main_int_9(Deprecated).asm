mainint9 proc
	sti ;开中断
	push ax ;保护寄存器
	push ds
	mov ax,@data ;必须设置ds
	mov ds,ax
	inc flag
	mov al,20h ;发送中断处理结束命令
	out 20h,al
	pop ds
	pop ax
	iret ;中断返回
mainint9 endp