%include "macro.asm"

extern exit, memcmp, memcpy, memset, itos, stoi, sort, read_two_ints, read_line

section .data
    number_array dd 4, 3, 1, 6, 2, 5
    lines db `opq\nrst\n\0`
    two_numbers db `123  456\n\0`
    num1 db "12345", 0
    num2 db "-98765", 0
    word1 db "abc", 0
    word2 db "acd", 0
    empty db 0

section .bss
    buf resb 256

section .text

global _start
_start:
    call test_memcmp
    call test_memcpy
    call test_memset
    call test_itos
    call test_stoi
    call test_sort
    call test_read_two_ints
    call test_read_line
    call1 exit, 0

test_memcmp:
    call3 memcmp, word1, word2, 3
    cmp rax, -1
    jne .error
    call3 memcmp, word2, word1, 3
    cmp rax, 1
    jne .error
    call3 memcmp, word1, word1, 3
    cmp rax, 0
    jne .error
    jmp .finish
.error:
    call1 exit, 1
.finish:
    ret

test_memcpy:
    call3 memcpy, buf, word2, 3
    mov al, [buf]
    cmp al, 'a'
    jne .error
    mov al, [buf + 1]
    cmp al, 'c'
    jne .error
    mov al, [buf + 2]
    cmp al, 'd'
    jne .error
    jmp .finish
.error:
    call1 exit, 2
.finish:
    ret

test_memset:
    call3 memset, buf, 5, 3
    mov al, [buf]
    cmp al, 5
    jne .error
    mov al, [buf + 1]
    cmp al, 5
    jne .error
    mov al, [buf + 2]
    cmp al, 5
    jne .error
    jmp .finish
.error:
    call1 exit, 3
.finish:
    ret

test_itos:
    call2 itos, buf, 45
    mov al, [buf]
    cmp al, '4'
    jne .error
    mov al, [buf + 1]
    cmp al, '5'
    jne .error
    mov al, [buf + 2]
    cmp al, 0               ; check null-terminator
    jne .error
    jmp .finish
.error:
    call1 exit, 4
.finish:
    ret

test_stoi:
    call1 stoi, num1
    cmp rax, 12345
    jne .error
    call1 stoi, num2
    cmp rax, -98765
    jne .error
    jmp .finish
.error:
    call1 exit, 5
.finish:
    ret

test_sort:
    call2 sort, number_array, 6
    mov rax, number_array
    cmp dword [rax], 1
    jne .error
    cmp dword [rax + 4], 2
    jne .error
    cmp dword [rax + 8], 3
    jne .error
    cmp dword [rax + 12], 4
    jne .error
    cmp dword [rax + 16], 5
    jne .error
    cmp dword [rax + 20], 6
    jne .error
    jmp .finish
.error:
    call1 exit, 6
.finish:
    ret

test_read_two_ints:
    call1 read_two_ints, two_numbers
    mov edi, eax
    cmp rdi, 123
    jne .error
    shr rax, 32
    cmp rax, 456
    jne .error
    jmp .finish
.error:
    call1 exit, 7
.finish:
    ret

test_read_line:
    ; testcase 1
    call2 read_line, buf, lines
    cmp rax, 3              ; check length
    jne .error
    mov al, [buf]
    cmp al, 'o'
    jne .error
    mov al, [buf + 1]
    cmp al, 'p'
    jne .error
    mov al, [buf + 2]
    cmp al, 'q'
    jne .error
    mov al, [buf + 3]
    cmp al, 0
    jne .error
    ; testcase 2: empty string
    call2 read_line, buf, empty
    cmp rax, 0
    jne .error
    mov al, [buf]
    cmp al, 0
    jne .error
    jmp .finish
.error:
    call1 exit, 8
.finish:
    ret
