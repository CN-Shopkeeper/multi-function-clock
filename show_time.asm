;使数码管高速无线循环显示数字
;输入参数显示效果：ah al. bh bl

show_time proc
    ;先保存参数
    push dx
	push cx
	mov numtb[0],ah
    mov numtb[1],al
    mov numtb[2],bh
    mov numtb[3],bl
	xor bx,bx
	mov cx,10
	;------------------------------------------------8255控制字在main中设置
	;以下均由我改写
show_time1:
	;mov cl,08h	;0000 1000b 设置位码，选择第一个数码管
	mov al,10000000b
	mov dx,pa
	out dx,al
	call delay_clock
	mov bl,numtb[0]
	mov al,ledtb[bx]
	mov dx,pb
	out dx,al
	call delay_clock
	call clear

	mov al,01000000b
	mov dx,pa
	out dx,al
	call delay_clock
	mov bl,numtb[1]
	mov al,ledtb_point[bx]	;显示al，需要显示小数点
	mov dx,pb
	out dx,al
	call delay_clock
	call clear


	mov al,00100000b
	mov dx,pa
	out dx,al
	call delay_clock
	mov bl,numtb[2]
	mov al,ledtb[bx]	;显示bh
	mov dx,pb
	out dx,al
	call delay_clock
	call clear

	mov al,00010000b
	mov dx,pa
	out dx,al
	call delay_clock
	mov bl,numtb[3]
	mov al,ledtb[bx]	;显示bl
	mov dx,pb
	out dx,al
	call delay_clock
	call clear

	loop show_time1

	pop cx
    pop dx
    ret
show_time endp


;-------------------------------------delay已经在主程序中有

;防止重影显示不清晰
clear proc
	mov al,0
	mov dx,289h
	out dx,al
	mov dx,288h
	out dx,al
	ret
clear endp

