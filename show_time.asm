;使数码管高速无线循环显示数字
;输入参数显示效果：ah al. bh bl

ledtb byte 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,6fh ;0~9的段码
ledtb_point byte 0bfh,86h,0dbh,0cfh,0e6h,0edh,0fdh,87h,0ffh,0efh ;0~9的段码带小数点
counter word 300  ;注意counter
numtb byte 4 dup(?)
show_time proc
    ;先保存参数
    mov numtb[0],ah
    mov numtb[1],al
    mov numtb[2],bh
    mov numtb[3],bl

    push dx
    push bx
    push ax

	mov ax,@data
	mov ds,ax
	;设置8255并行端口控制字
	mov dx,28Bh
	mov al,10000000B
	out dx,al
show_time1:
	mov bl,08h	;0000 1000b 设置位码，选择第一个数码管
	mov al,bl
	mov dx,289h
	out dx,al
	mov al,ledtb[ah]	;显示ah
	mov dx,288h
	out dx,al
	call delay
	call clear

	shr bl,1
	mov al,bl
	mov dx,289h
	out dx,al
	mov al,ledtb_point[al]	;显示al，需要显示小数点
	mov dx,288h
	out dx,al
	call delay
	call clear



	shr bl,1
	mov al,bl
	mov dx,289h
	out dx,al
	mov al,ledtb[bh]	;显示bh
	mov dx,288h
	out dx,al
	call delay
	call clear

	shr bl,1
	mov al,bl
	mov dx,289h
	out dx,al
	mov al,ledtb[bl]	;显示bl
	mov dx,288h
	out dx,al
	call delay
	call clear

	dec counter
	jnz show_time1

    pop ax
    pop bx
    pop dx
    ret
show_time endp


delay proc
	push bx
	push cx
	mov bx,2
	delay1: xor cx,cx
	delay2: loop delay2
	dec bx
	jnz delay1
	pop cx
	pop bx
	ret
delay endp

;防止重影显示不清晰
clear proc
	mov al,0
	mov dx,289h
	out dx,al
	mov dx,288h
	out dx,al
	ret
clear endp

