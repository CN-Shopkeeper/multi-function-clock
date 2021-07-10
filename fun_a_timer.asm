;now_time byte 2 dup(?);[0]存分，[1]存秒
;count40 byte 40

now_time word ?
count_flag byte 0	;记录状态信息，0表示无操作，1表示正计时状态，2表示倒计时状态

clock_interrupt proc
	sti
	push ds
	push ax
	mov ax,@data
	mov ds,ax
	cmp count_flag,0	;0则无操作
	jz clock_interrupt_done
	cmp count_flag,1	;1正计时
	jz posi_timing
	;2 倒计时
	cmp now_time,0	;00:00
	jz stop_neg
	sub now_time,1
posi_timing:
	cmp now_time,3599	;59:59
	jz posi_max
	add now_time,1
clock_interrupt_done:
	mov al,20h	;send EOI
	out 20h,al
	pop ax
	pop ds
	iret
clock_interrupt endp

;秒转化为分秒，入口参数now_time，返回到ax,bx！！！！！！！！！！！！调用前需要先保护ax,bx的内容！！！！！！！！！！！！
sec_to_minsec proc
	mov ax,now_time
	mov bl,60
	div bl
	xor bx,bx
	mov bl,al	;min
	mov al,ah	;sec
	and ax,0fh	;sec
	call divide
	xchg ax,bx	;ax: min bx: sec
	call divide
	ret
sec_to_minsec endp






























	;--------------------------------------------------将中断设置和恢复，中断子程序都放到了main里面
	;无限产生一秒钟的信号，你真狠啊。。。不过这个不是严格的一秒时间，因为计时一秒后还有其它的操作
fun_posi proc
	mov count40,40
	;主程序
unreach40_again:
	cmp count40,0
	ja unreach40_again
	;一旦减为0，则变化时钟显示
	;判断当前时间是否为59.59
	cmp now_time[0],01011001b	;分59
	jnz next1
	cmp now_time[1],01011001b	;秒为59
	;分秒都已经达到最大59
	jz keep_5959
	call add1_clock
	call show_time
	jz fun_posi_done
keep_5959:
	mov ax,now_time[0]
	mov bx,now_time[1]
	call show_time
fun_posi_done:
	ret
fun_posi endp

;--------------------------------------------------将中断设置和恢复，中断子程序都放到了main里面
fun_neg proc
	mov count40,40
	;主程序
unreach40_again:
	cmp count40,0
	ja unreach40_again
	;一旦减为0，则变化时钟显示
	;判断当前时间是否为00.00
	cmp now_time[0],0	;分为0
	jnz next1
	cmp now_time[1],0	;秒为0
	;分秒都已经达00.00
	jz keep_0000
	call sub1_clock
	call show_time
	jz fun_neg_done
keep_0000:
	mov ax,now_time[0]
	mov bx,now_time[1]
	call show_time	;但是有个问题，数码管不会一直显示，一旦CPU去处理响铃子程序数码管就不显示了
	call play_alarm
	;call 按键停止响铃，屏幕显示当前菜单，跳转到子功能
fun_neg_done:
	ret
fun_neg endp

;ps:某人不要吐槽我的弱智加减法
;只对now_time进行修改,结果保存到now_time
sub1_clock proc
	push ax
	push bx
	;若为00.00则不做变化
	cmp now_time[1],0	;秒不为0
	jnz sub1
	cmp now_time[0],0
	jz sub1_done		;分秒皆为0
sub1:
	;把时间拆分到ah,al,bh,bl内
	mov ax,now_time[0]
	mov bx,now_time[1]
	;秒个位
	cmp bl,0
	jz sub_bh
	sub bl,1
	mov now_time[1],bx
	jz sub1_done
	;秒十位
sub_bh:
	cmp bh,0
	jz sub_al
	sub bh,1
	mov bl,9
	mov now_time[1],bx
	jz sub1_done
	;分个位
sub_al:
	cmp al,0
	jz sub_ah
	sub al,1
	mov bh,5
	mov bl,9
	mov now_time[0],ax
	mov now_time[1],bx
	jz sub1_done
	;分十位
sub_ah:
	cmp ah,0
	jz sub1_done	;为00.00
	sub ah,1
	mov al,9
	mov bh,5
	mov bl,9
	mov now_time[0],ax
	mov now_time[1],bx
sub1_done:
	pop bx
	pop ax
	ret
sub1_clock endp


;只对now_time进行修改,结果保存到now_time
add1_clock proc
push ax
	push bx
	;若为59.59则不做变化
	cmp now_time[1],01011001b	;秒不为59
	jnz add1
	cmp now_time[0],01011001b	;分不为59
	jz add1_done		;分秒皆为59
add1:
	;把时间拆分到ah,al,bh,bl内
	mov ax,now_time[0]
	mov bx,now_time[1]
	;秒个位
	cmp bl,9
	jz add_bh
	add bl,1
	mov now_time[1],bx
	jz add1_done
	;秒十位
add_bh:
	cmp bh,5
	jz add_al
	add bh,1
	mov bl,0
	mov now_time[1],bx
	jz add1_done
	;分个位
add_al:
	cmp al,9
	jz add_ah
	add al,1
	mov now_time[0],ax
	mov now_time[1],0
	jz add1_done
	;分十位
add_ah:
	cmp ah,5
	jz add1_done
	add ah,1
	mov al,0
	mov now_time[0],ax
	mov now_time[1],0
add1_done:
	pop bx
	pop ax
	ret
add1_clock endp



;设置8254计数器1每25ms产生一次中断
;CLK1接1M HZ时钟频率
;计数初值40000
init_counter1 proc
	push dx
	push ax
	mov dx,控制端口地址
	mov al,01110101b	;计数器1，工作方式2，10进制
	out dx,al
	mov dx,计数器1端口地址
	mov ax,40000	;写入计数初值
	out dx,al
	mov al,ah
	out dx,al
	pop ax
	pop dx
	ret
init_counter1 endp

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
	mov bh,al;存储分钟数
check_second:
	;读取秒
	mov ax,offset fun_a_timing_sec_msg
	call dispmsg
	;使用我写的read2bit来实现
	call read2bit
	cmp al,60
	jae check_second
	mov bl,al;存储秒数
	mov ax,offset YN
	call dispmsg
	call readuib	;输入无符号十进制整数AL			---------------------------todo需要改为从小键盘输入
	cmp al,1	;输入1则显示到数码管			-------------------todo改为字符'1'
	jz show_init_time
	;输入0则让用户重新输入
	jmp check_time
show_init_time:
	mov ah,0
	mov al,bh
	call divide
	push ax	;栈暂存分钟数据
	mov ah,0
	mov al,bl
	call divide
	push ax	;栈保存秒数据
	pop bx	;秒放在bx
	pop ax	;分放在ax
	call show_time	;调用子程序在数码管上显示计时初值
	mov now_time[0],ax		;一定要更新到now_time
	mov now_time[1],bx
	pop bx
	pop ax
	ret
init_val endp
