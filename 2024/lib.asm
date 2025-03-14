; File descriptors
STDIN equ 0
STDOUT equ 1
STDERR equ 2

; Syscall numbers
SYS_READ equ 0
SYS_WRITE equ 1
SYS_OPEN equ 2
SYS_CLOSE equ 3
SYS_EXIT equ 60

; Misc
NEWLINE equ 10

section .text

;; Exported functions
global exit, prints, memcmp, memcpy, memset, itos, stoi, strcpy, strlen, read_two_ints, read_line, read_file

;; Exit the program
;; Inputs: RDI = exit code

exit:
    mov rax, SYS_EXIT
    syscall                     ; rdi is passed on unchanged
    ret

;; Print null-terminated string to stdout
;; Inputs: RDI

prints:
    mov rsi, rdi                ; arg2: string (strlen does not modify rsi)
    call strlen                 ; length into rax
    mov rdi, STDOUT             ; arg1: stdout
    mov rdx, rax                ; arg3: length
    mov rax, SYS_WRITE          ; syscall id
    syscall
    ret

;; Compare two memory locations
;; Inputs: RDI, RSI, RDX = length
;; Output: RAX = 0, 1, -1

memcmp:
    mov rcx, rdx
    cld
    repe cmpsb                  ; repeat until equal or rcx=0
    jz .equal
    jns .negres
    mov rax, 1
    ret
.negres:
    mov rax, -1
    ret
.equal:
    mov rax, 0
    ret

;; Copy bytes from source to destination
;; Inputs: RDI = destination, RSI = source, RDX = length

memcpy:
    mov rcx, rdx
    cld
    rep movsb                   ; copy RCX bytes from RSI to RDI
    ret

;; Set bytes to specified value
;; Inputs: RDI = destination, RSI = value to set, RDX = length

memset:
    mov rax, rsi
    mov rcx, rdx
    cld
    rep stosb
    ret

;; Convert integer to null-terminated string
;; Inputs: RDI = string, RSI = integer

itos:
    cld
    xor rcx, rcx
    mov rax, rsi
    mov rsi, 10                 ; divisor
    xor r8, r8                  ; r8 marks negative
    cmp rax, 0
    jge .loopPush               ; jump if value >= 0
    mov r8, 1
    neg rax
.loopPush:
    mov rdx, 0                  ; rdx is used by div so make sure it is zero
    div rsi                     ; divide by 10, remainder is stored in rdx
    add rdx, '0'
    push rdx                    ; push the digit to stack
    inc rcx
    test rax, rax
    jnz .loopPush               ; continue if we have more digits
    test r8, r8
    jz .loopPop
    mov rax, '-'
    stosb
.loopPop:
    pop rax
    stosb
    dec rcx
    test rcx, rcx
    jnz .loopPop                ; continue if we have more digits
    xor rax, rax
    stosb                       ; null-terminator
    ret

;; Convert string to integer
;; Inputs: RDI
;; Output: RAX

stoi:
    xor rax, rax
    xor rcx, rcx
    mov rsi, 10                 ; multiplier
    xor r8, r8                  ; r8 marks negative
    mov cl, [rdi]
    cmp cl, '-'
    jne .loop
    mov r8, 1
    inc rdi
.loop:
    mov cl, [rdi]
    cmp cl, '0'
    jb .finish                  ; jump to exit if char is < '0'
    cmp cl, '9'
    ja .finish                  ; jump to exit if char is > '9'
    mul rsi                     ; multiply previous value
    sub cl, '0'
    add rax, rcx                ; add value to rax
    inc rdi
    jmp .loop                   ; start over
.finish:
    test r8, r8
    jz .finish2
    neg rax                     ; make negative
.finish2:
    ret

;; Copy null-terminated string
;; Inputs: RDI = destination, RSI = source

strcpy:
    cld
.loop:
    lodsb
    stosb
    test al, al
    jnz .loop
    ret

;; Calculate length of null-terminated string
;; Inputs: RDI

strlen:
    xor rax, rax
    mov rcx, -1
    cld
    repne scasb                 ; loop until [rdi] != rax
    mov rax, rcx
    add rax, 2
    neg rax
    ret

;; Skip over spaces
;; Inputs: RDI
;; Output: RDI

skip_spaces:
    mov al, [rdi]
    cmp al, ' '
    jne .finish
    inc rdi
    jmp skip_spaces
.finish:
    ret

;; Read two 32-bit integers from a null-terminated string
;; Skip over any space characters
;; Inputs: RDI = string
;; Output: RAX = 2 x 32bit numbers (bit-shifted)

read_two_ints:
    call skip_spaces
    call stoi
    mov r9, rax                 ; store first num in r9
    call skip_spaces
    call stoi
    shl rax, 32                 ; shift left 32 bits
    or rax, r9                  ; bitwise or
    ret

;; Read line to buffer (until newline or null-terminator)
;; The newline character itself is not included
;; Inputs: RDI = destination, RSI = source
;; Output: RAX = number of bytes read

read_line:
    cld
    xor rcx, rcx
.loop:
    lodsb                       ; read char
    cmp al, 0
    je .finish                  ; finish if null-terminator
    cmp al, NEWLINE
    je .finish                  ; finish if \n
    stosb                       ; write char
    inc rcx
    jmp .loop
.finish:
    xor rax, rax
    stosb                       ; null-terminator
    mov rax, rcx
    ret

;; Read file contents into memory
;; Inputs: RDI = buffer, RSI = filename, RDX = length
;; Output: RAX = number of bytes read

read_file:
    push rdx                    ; store len
    push rdi                    ; store buf

    ; open file
    mov rdi, rsi                ; arg1: filename
    mov rsi, 0                  ; arg2: flags, 0 = O_RDONLY
    mov rdx, 0                  ; arg3: mode
    mov rax, SYS_OPEN
    syscall

    ; read file
    mov rdi, rax                ; arg1: file-pointer
    pop rsi                     ; arg2: buffer
    pop rdx                     ; arg3: length
    mov rax, SYS_READ
    push rdi                    ; store file-pointer
    syscall

    ; close file
    pop rdi                     ; arg1: file-pointer
    push rax                    ; store bytes read
    mov rax, SYS_CLOSE
    syscall

    pop rax                     ; return bytes read
    ret
