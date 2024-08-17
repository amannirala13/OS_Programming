org 0x7c00
bits 16

.data:
    temp    dw  0
    c       dw  32

_start:
    .loop:
        mov ax, c
    .end:
        ret

_

_ctof:
    .loop:
    .end:
        ret

_printChar:
    mov ah, 0eh
    int 10h
    xor ax, ax
    ret

_readChar:
    xor ah, ah
    int 16h
    ret

_input:
    xor ax, ax
    xor bx, bx
    xor dx, dx
    .loop:
        call _readChar
        cmp ah, 1Ch
        je .done
        movzx ax, al
        imul bx, bx, 10
        sub ax, '0'
        add bx, bx
        add ax, '0'
        call _printChar
        jmp .loop
    .done:
        ret

times 512 - ($ - $$) db 0       ; Padding the program with 0s
dw 0xAA55                       ; Boot signature
