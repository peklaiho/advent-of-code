%include "macro.asm"

extern exit, prints, itos, bubble_sort, read_two_ints, read_line, read_file

section .data
    filename db "day01-input.txt", 0
    result_is db "Result: ", 0
    newline db 10, 0

section .bss
    raw_data resb 32768 ; 32kb
    buf resb 256
    col1 resd 1024
    col2 resd 1024
    len resd 1

section .text

global _start
_start:
    mov r12, raw_data           ; r12: index of raw_data
    xor r13, r13                ; r13: index of numbers

    ; read file into memory
    call3 read_file, r12, filename, 32768

    mov r14, raw_data
    add r14, rax                ; r14: end of data

    mov byte [r14], 0           ; null-terminator

.parse:
    ; read next line into buf
    call2 read_line, buf, r12
    add r12, rax                ; increment r12 by bytes read
    inc r12                     ; +1 to include newline char

    ; read numbers into col1, col2
    call1 read_two_ints, buf
    mov dword [col1 + r13*4], eax ; write first number to col1
    shr rax, 32                 ; shift right
    mov dword [col2 + r13*4], eax ; write second number to col2

    inc r13                     ; increment number index

    cmp r12, r14
    jl .parse                   ; continue if r12 < r13

    ; sort arrays
    call2 bubble_sort, col1, r13
    call2 bubble_sort, col2, r13

    xor r12, r12                ; r12: final result
    xor rcx, rcx                ; rcx: number index

.loop:
    cmp rcx, r13
    jge .finish                 ; finish if rcx >= r13

    mov dword edi, [col1 + rcx*4] ; move first number to rdi
    mov dword esi, [col2 + rcx*4] ; move second number to rsi
    sub rdi, rsi

    cmp rdi, 0
    jge .sum
    neg rdi                     ; take abs value
.sum:
    add r12, rdi
    inc rcx
    jmp .loop

.finish:
    call1 prints, result_is
    call2 itos, buf, r12
    call1 prints, buf
    call1 prints, newline

    call1 exit, 0
