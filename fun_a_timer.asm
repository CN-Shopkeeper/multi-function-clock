clock_interrupt proc
	sti
	push ds
	push ax
	mov ax,@data
	mov ds,ax
	call update_clock_hour_minu
	cmp count_flag,0	;0则无操作
	jz clock_interrupt_done
	cmp count_flag,1	;1正计时
	jz posi_timing
	;2 倒计时
	cmp now_time,0	;00:00
	jz count_flag0
	;sub now_time,1
	dec now_time
	jmp clock_interrupt_done
posi_timing:
	cmp now_time,3599	;59:59
	jz count_flag0
	;add now_time,1
	inc now_time
	jmp clock_interrupt_done
count_flag0:
	mov count_flag,0
clock_interrupt_done:
	mov al,20h	;send EOI
	out 20h,al
	pop ax
	pop ds
	iret
clock_interrupt endp

update_clock_hour_minu proc
	inc clock_sec
	cmp clock_sec,60
	jnz update_clock_hour_minu_done
	mov clock_sec,0
	inc clock_minu
	cmp clock_minu,60
	jnz update_clock_hour_minu_done
	mov clock_minu,0
	inc clock_hour
	cmp clock_hour,24
	jnz update_clock_hour_minu_done
	mov clock_hour,0
update_clock_hour_minu_done:
	ret
update_clock_hour_minu endp

;秒转化为分秒，入口参数now_time，返回到ax,bx！！！！！！！！！！！！调用前需要先保护ax,bx的内容！！！！！！！！！！！！
sec_to_minsec proc
	mov ax,now_time
	mov bl,60
	div bl
	xor bx,bx
	mov bl,al	;min
	mov al,ah	;sec
	and ax,0ffh	;sec
	call divide_10
	xchg ax,bx	;ax: min bx: sec
	call divide_10
	ret
sec_to_minsec endp


;设置8254计数器1、计数器2每1s产生一次中断
;CLK1接1M HZ时钟频率，CLK2接OUT1
;计数初值1000
init_counter proc
	push dx
	push ax
	mov dx,countercontroller
	mov al,01110110b	;计数器1，工作方式3，2进制
	out dx,al
	mov dx,counter1
	mov ax,1000	;写入计数初值
	out dx,al
	mov al,ah
	out dx,al

	mov dx,countercontroller
	mov al,10110110b	;计数器2，工作方式3，2进制
	out dx,al
	mov dx,counter2
	mov ax,1000	;写入计数初值
	out dx,al
	mov al,ah
	out dx,al
	pop ax
	pop dx
	ret
init_counter endp

;设置计时初值，并显示一小段时间
init_val proc
	;设置时钟初值
	;低于60检查
	push ax
	push bx
	mov ax,offset fun_a_timing_msg
	call dispmsg
check_minute:
	;读取分钟
	mov ax, offset fun_a_timing_min_msg
	call dispmsg
	;使用我写的read2bit来实现
	call read2bit
	cmp al,60
	jae check_minute
	mov bh,al	;save min
check_second:
	;读取秒
	mov ax,offset fun_a_timing_sec_msg
	call dispmsg
	;使用我写的read2bit来实现
	call read2bit
	cmp al,60
	jae check_second
	mov bl,al	;save sec
	mov ax,offset YN
	call dispmsg
	call readc_my
	cmp al,'A'	;输入A则显示到数码管
	jz show_init_time	;bh: min bl: sec
	;输入B则让用户重新输入
	jmp check_minute
show_init_time:
	xor ax,ax	;ax=bh*60+bl
	mov al,bh
	mov bh,60
	mul bh
	and bx,0ffh
	add ax,bx
	mov now_time,ax	;更新计时初值到now_time
	;call sec_to_minsec;-------------------------------------------------------------这两个也可以放在计时子程序
	;call show_time	;调用子程序在数码管上显示计时初值---------------------------------
	pop bx
	pop ax
	ret
init_val endp

