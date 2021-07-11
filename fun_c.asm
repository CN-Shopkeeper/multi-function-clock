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
	call play_blackteam
	jmp confirm_music
test_music_2:
	mov dl,2	;暂存选择
	call play_sky
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
	mov ax,offset music_used_msg
	call dispmsg
	jmp fun_c_done
not_use:
	mov ax,offset music_not_used_msg
	call dispmsg
fun_c_done:
	pop dx
	pop ax
	ret
fun_c endp

;播放生日歌
play_birthday proc ;HappyBirthDay 音频播放
	push si
    push bx
	push ax
	push cx
	push dx
    mov si,offset birthday
    mov bx,12
again_birthday:
    mov ax,[si]			;定义在数据段的音符（计数初值）
	add si,2
    mov cx ,[si]		;自定义延时
	add si,2
	call speaker
	call speakon
play_birthday_again:
	call delay_clock
	loop play_birthday_again
	sub bx,1
    jnz again_birthday
done_birthday:
	call speakoff
	pop dx
	pop cx
	pop ax
	pop bx
	pop si
	ret
play_birthday endp

;播放blackteam
play_blackteam proc ;blackteam 音频播放
	push si
    push bx
	push ax
	push cx
	push dx
    mov si,offset blackteam
    mov bx,12
again_blackteam:
    mov ax,[si]			;定义在数据段的音符（计数初值）
	add si,2
    mov cx ,[si]		;自定义延时
	add si,2
	call speaker
	call speakon
play_blackteam_again:
	call delay_clock
	loop play_blackteam_again
	sub bx,1
    jnz again_blackteam
done_blackteam:
	call speakoff
	pop dx
	pop cx
	pop ax
	pop bx
	pop si
	ret
play_blackteam endp

;播放sky
play_sky proc ;sky 音频播放
	push si
    push bx
	push ax
	push cx
	push dx
    mov si,offset sky
    mov bx,7
again_sky:
    mov ax,[si]			;定义在数据段的音符（计数初值）
	add si,2
    mov cx ,[si]		;自定义延时
	add si,2
	call speaker
	call speakon
play_sky_again:
	call delay_clock
	loop play_sky_again
	sub bx,1
    jnz again_sky
done_sky:
	call speakoff
	pop dx
	pop cx
	pop ax
	pop bx
	pop si
	ret
play_sky endp