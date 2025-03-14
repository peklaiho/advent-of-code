%include "macro.asm"

extern exit, prints, read_two_ints, read_line, read_file

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
    mov r12, raw_data           ; r12 is raw data buffer

    ; read file into memory
    call3 read_file, r12, filename, 32768
    mov r13, r12
    add r13, rax                ; r13 is end of raw data

    ; add null-terminator
    mov byte [r13], 0

    mov r14, col1               ; r14 is index of col1
    mov r15, col2               ; r15 is index of col2

.parse:
    ; read next line into buf
    call2 read_line, buf, r12
    add r12, rax                ; increment r12 by bytes read
    inc r12                     ; +1 to include newline char

    ; read numbers into col1, col2
    call1 read_two_ints, buf
    mov dword [r14], eax        ; write first number to col1
    shr rax, 32                 ; shift right
    mov dword [r15], eax        ; write second number to col2

    ; increment registers
    add r14, 4
    add r15, 4

    cmp r12, r13
    jl .parse                   ; continue if r12 < r13

    ; qty of numbers: (r14 - col1) / 4
    ; save it to col_len
    mov rax, r14
    sub rax, col1
    xor rdx, rdx
    mov rdi, 4
    div rdi
    mov dword [col_len], eax

.finish:
    call1 exit, 0
