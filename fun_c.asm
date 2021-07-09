fun_c proc
	push ax
	push dx
test_music:
	mov ax,offset test_music_msg
	call dispmsg
	call readc_my
	cmp al,'0'
	jz test_music_0
	cmp al,'1'
	jz test_music_1
	cmp al,'2'
	jz test_music_2
	jmp test_music
test_music_0:
	mov dl,0	;暂存选择
	call play_birthday
	jmp confirm_music
test_music_1:
	mov dl,1	;暂存选择
	jmp confirm_music
test_music_2:
	mov dl,2	;暂存选择
	jmp confirm_music
confirm_music:
	mov ax,offset confirm_music_msg
	call dispmsg
	call readc_my
	cmp al,'A'
	jz use_it
	cmp al,'B'
	jz not_use
	jmp confirm_music
use_it:
	mov used_music,dl
not_use:
	pop dx
	pop ax
	ret
fun_c endp

play_birthday proc ;HappyBirthDay 音频播放
	push si
    push bx
	push ax
	push dx ;
	push cx
    mov si,offset birthday
    mov bx,0
again_birthday:
    mov ax,[si+bx]			;定义在数据段的音符（计数初值）
    mov cx ,[si+bx+2]		;自定义延时
	mov dx ,[si+bx+4]		;音符对应的1~7，显示灯光
    mov timer,cx
    cmp bx,144				;定义的数据的长
    ja done_birthday
	call speaker
	call speakon
    add bx,6				;每6个字节一个音符，延时，灯光（1~7）
    mov ah,0bh ;中断判断是否键盘有输入，没有输入al 00h
    int 21h
    cmp al,00h
    jz again_birthday
done_birthday:
	call speakoff
	pop cx
	pop dx
	pop ax
	pop bx
	pop si
	ret
play_birthday endp