speakon proc			;A0A1置一 启动扬声器
		push ax
		mov dx,288h
		in al,dx
		or al,03h
		out dx,al
		pop ax
		call delay
		ret
speakon endp

speakoff proc		;停止
		push ax 
		mov dx,288h
		in al,dx
		and al,0fch		;A0A1置0 停止
		out dx,al
		pop ax
		ret
speakoff endp

speaker proc;发音频率设置子程序
		push dx
		push ax
		
		mov al,36h
		mov dx,283h
		out dx,al
		pop ax
		mov dx,280h
		out dx,al
		mov al,ah
		out dx,al
		pop dx
		ret
speaker endp