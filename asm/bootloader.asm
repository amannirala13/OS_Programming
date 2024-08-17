;   This is a demo bootloader program for x86 architecture. This program demonstrates several useful concepts like
;   logical operations, slow multiplication and division, 16 bit ASM program, reading an input from IO devices, system
;   interrupts, converting ASCII values to int and vice versa, using video memory to render text and numbers.

            org 0x7c00
            bits 16
            ;-------------------- [ data section ]
            .data:
                res dw 0
                temp dw 0
                v1 dw 0
                v2 dw 0
                rem dw 0
                quo dw 0
                ans dw 0
                counter dw 0
            ;-------------------- [ start functions ]

            start:
                call _greetings
                mov si, enter_value
                call _printString
                call _readNumber
                mov ax, [temp]
                mov [v1], ax
                mov ax, '+'
                call _printChar
                call _readNumber
                mov ax, [temp]
                mov [v2], ax
                mov ax, '='
                call _printChar
                mov ax, [v1]
                add ax, [v2]
                mov [temp], ax
                call _printNumber
                jmp start

            ;-------------------- [ helper functions ]

            _mulBy10:
                xor bx, bx
                xor dx, dx
                mov dx, [temp]
                .loop:
                   add dx, dx
                   inc bx
                   cmp bx, 10
                   je .done
                   jne .loop
                .done:
                    mov [temp], dx
                    xor dx, dx
                    xor bx, bx
                    ret


            _divBy10:
                xor dx, dx
                xor bx, bx
                xor ax, ax
                mov [quo], bx
                mov [rem], dx
                mov bx, [temp]
                mov dx, 10
                .loop:
                    cmp bx, dx
                    jl .done
                    sub bx, dx
                    inc ax
                    jmp .loop
                .done:
                    mov [quo], ax
                    mov [rem], bx
                    xor dx, dx
                    xor bx, bx
                    ret

            ;-------------------- [ reading functions ]

            _readNumber:
                xor bx, bx
                xor dx, dx
                xor ax, ax
                .loop:
                    call _readChar
                    cmp ah, 1Ch
                    je .done
                    movzx ax, al
                    imul bx, bx, 10
                    sub ax, '0'
                    add bx, ax
                    add ax, '0'
                    call _printChar
                    jmp .loop
                .done:
                    mov [temp], bx
                    xor bx, bx
                    xor dx, dx
                    xor ax, ax
                    ;call _clearScreen
                    ret


            _readChar:
                xor ah, ah
                int 16h
                ret

            ;-------------------- [ printing functions ]
            _greetings:
                .greet:
                    mov si, hlw_msg
                    call _printString
                .continue:
                    mov si, press_any_key
                    call _printString
                    call _readChar
                .done:
                    call _clearScreen
                    xor ax, ax
                    ret

            _clearScreen:
                    mov ax, 0x0003  ; Set video mode 0x03 (text mode, 16 colors)
                    int 0x10        ; BIOS video services interrupt

            _printChar:
                mov ah, 0eh
                int 10h
                xor ax, ax
                ret

            _printNumber:
                xor ax, ax
                xor bx, bx
                xor cx, cx
                xor dx, dx
                mov bx, [temp]
                .loop:
                    mov [temp], bx
                    call _divBy10
                    mov bx, [quo]
                    mov dx, [rem]
                    mov ax, dx
                    add ax, '0'
                    ;call _printChar
                    push ax
                    inc cx
                    mov ax, 0
                    mov dx, 0
                    cmp bx, 0
                    jg .loop
                 .writeOnScreen:
                     pop ax
                     dec cx
                     call _printChar
                     cmp cx, 0
                     jg .writeOnScreen
                .done:
                    xor ax, ax
                    xor bx, bx
                    xor cx, cx
                    xor dx, dx
                    ret

            _printString:
                .loop:
                    lodsb       ; Load a byte from SI into AL
                    cmp al, 0   ; Check if it's the null terminator
                    je .done
                    call _printChar
                    jmp .loop
                .done:
                    ret

            hlw_msg: db 0x0a, 0x0a, 0xd, "A simple boot loader program for adding numbers and displaying", 0x0a,0x0a,0xd, "Developed by Aman Nirala", 0
            press_any_key: db 0x0a, 0x0a, 0xd, "Press any key to continue... ", 0
            enter_value: db 0x0a, 0x0a, 0xd, "Enter the values to sum: ", 0
            times 510 - ($ - $$) db 0  ; Pad the bootloader with zeros
            dw 0xAA55                  ; Boot signature