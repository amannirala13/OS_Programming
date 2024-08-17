.global _start
.data:
    v1 dw 0
    v2 dw 0
    res dw 0
_start:
    mov ax, 10
    mov bx, 10
    add ax, bx
    mov [res], bx
