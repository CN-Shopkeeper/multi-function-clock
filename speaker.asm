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

speaklighton proc				; 包括speakon子程序   外加控制灯
		push ax
		push dx
		mov dx,288h
		in al,dx
		or al,03h
		out dx,al		;以上是speakon子程序，以下控制灯
		pop dx
		mov ax,dx ;		
		mov dx,289h		;B端口接灯
		out dx,al ;
		pop ax
		call delay
		ret
speaklighton endp


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