;include io16.inc
    origin_hour byte ?
    origin_min byte ?
    origin_mon byte ?
    origin_day byte ?

show_mon_day proc
    push ax
    push bx
;DAY
    ;get system day
    mov al,7
    out 70h,al
    in al,71h
    mov origin_day,al
    ;processing and show
    mov ah,0
    mov al,origin_day
    cmp origin_day,10
    jb month_deal
    call divide
    mov bx,ax
;MONTH
month_deal:
    ;get system month
    mov al,8
    out 70h,al
    in al,71h
    mov origin_mon,al
    ;processing and show
    mov ah,0
    mov al,origin_mon
    cmp origin_mon,10
    jb show_md
    call divide
show_md:
    call show_time
    pop bx
    pop ax
    ret
show_mon_day endp

show_hour_min proc
    push ax
    push bx

hour_min_again:
;MINUTE
    ;get system minute
    mov al,2
    out 70h,al
    in al,71h
    mov origin_min,al
    ;processing and show
    mov ah,0
    mov al,origin_min
    cmp origin_min,10
    jb hour_deal
    call divide
    mov bx,ax
;HOUR
hour_deal:
    ;get system hour
    mov al,4
    out 70h,al
    in al,71h
    mov origin_hour,al
    ;processing and show
    mov ah,0
    mov al,origin_hour
    cmp origin_hour,10
    jb show_hm
    call divide
show_hm:
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
    mov bl,10
    div bl  ;无符号数除法，al=ax/10，ah=余数
    mov bl,al   ;交换，按输出要求得到结果
    mov al,ah
    mov ah,bl
    pop bx
    ret
divide endp


;todo 判断时分是否为闹钟时间