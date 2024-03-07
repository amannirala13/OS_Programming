ORG 0x7c00          ; location of the bootloader
BITS 16             ; boots in 16 bit for legacy support

start:
    MOV si, HLW_MSG ; move the message to si register
    CALL print      ; call print routine
    JMP $           ; jump back to itself to prevent end
print:
    MOV bx, 0       ; reset bx register
.loop:
    LODSB           ; loading current si pointer and shifting it to the right by one index
    CMP al, 0       ; checking if the loaded char is 0
    je .done        ; jump tp .done if the above statement is true
    call print_char ; else call .print_char
    JMP .loop       ; jump back to the loop to print the next char
.done:
    ret             ; return

print_char:
    MOV ah, 0eh     ; ah -> eax
    int 0x10        ; calling the bios through 0x10 interrupt to print char to video memo
    ret             ; return

HLW_MSG: db 0x0A, 0x0A, 'Hello world of Kernels!', 0x0A, 'This boot loader is written by Aman Nirala!', 0    ; message to be printed, ends with a 0

TIMES 510-  ($ - $$) db 0   ; bios size
dw 0xAA55           ; magic number for boot sector



