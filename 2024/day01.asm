%include "macro.asm"

extern exit, prints, memset, stoi, read_line, read_file

section .data
    filename db "day01-sample.txt", 0

section .bss
    raw_data resb 32768 ; 32kb
    buf resb 256
    col1 resd 1024
    col2 resd 1024
    col_len resd 1

section .text

global _start
_start:
    ; read file into memory
    call3 read_file, raw_data, filename, 32768
    mov r14, raw_data
    add r14, rax                ; store end in r14

    ; add null-terminator
    mov byte [r14], 0

    ; parse integers
    mov r12, raw_data           ; r12 is byte index
    xor r13, r13                ; r13 is line index

.parseLoop:
    ; read next line to buf
    call2 read_line, buf, r12
    add r12, rax                 ; increment r12 by bytes read
    inc r12                      ; +1 to include newline char

    ; read number
    call1 stoi, buf
.readNum:
    mov dword [col1 + r13], eax
    inc r13

    ; check stop condition
    cmp r12, r14
    jge .finish

    ; back to start of loop
    jmp .parseLoop

.finish:

    ; finish
    call1 exit, 0
