
show_mon_day proc
    push ax
    push bx

;DAY
    ;get system day
    xor ax,ax
    mov al,7
    out 70h,al
    in al,71h
    call divide
    mov bx,ax
;MONTH
month_deal:
    ;get system month
    xor ax,ax
    mov al,8
    out 70h,al
    in al,71h
    call divide

    call show_time
    pop bx
    pop ax
    ret
show_mon_day endp

show_hour_min proc
    push ax
    push bx

;MINUTE
    ;get system minute
    xor ax,ax
    mov al,clock_minu
    call divide_10
    mov bx,ax
;HOUR
hour_deal:
    ;get system hour
    xor ax,ax
    mov al,4
    out 70h,al
    in al,71h
    call divide

    call show_time
    pop bx
    pop ax
    ret
show_hour_min endp

;将1个两位数分解为2个一位数
;输入参数ax
;输出参数ah,al
divide proc
    push bx
    ;------------------------------------不允许除以立即数
    mov bl,16
    div bl  ;无符号数除法，al=ax/16，ah=余数
    xchg al,ah
    pop bx
    ret
divide endp

divide_10 proc
    push bx
    ;------------------------------------不允许除以立即数
    mov bl,10
    div bl  ;无符号数除法，al=ax/16，ah=余数
    xchg al,ah
    pop bx
    ret
divide_10 endp

;todo 判断时分是否为闹钟时间