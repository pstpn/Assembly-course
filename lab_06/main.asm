.model tiny
.186

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:CSEG
    org 100h
main:
    jmp INIT

    OLD_INTER dd 0
    SPEED db 01Fh
    UNINSTALL_FLAG db 31h
INTER:
    pusha

    mov AL, 0F3h
    out 60h, AL
    mov AL, SPEED
    out 60h, AL
    dec SPEED
    int 21h

    cmp SPEED, 0h
    je reset
    jmp exit

    reset:
        mov SPEED, 01Fh
    exit:
        popa

        jmp CS:OLD_INTER
INIT:
    mov AX, 3508h
    int 21h

    cmp ES:UNINSTALL_FLAG, 31h
    je UNINSTALL
    jmp INSTALL
INSTALL:
    mov word ptr OLD_INTER, BX
    mov word ptr OLD_INTER + 2, ES

    mov AX, 2508h
    mov DX, OFFSET INTER
    int 21h

    mov DX, OFFSET INIT
    int 27h
UNINSTALL:
    pusha

    mov DX, word ptr ES:OLD_INTER
	mov DS, word ptr ES:OLD_INTER + 2

    mov AX, 2508h
    int 21h

    mov AL, 0F3h
    out 60h, AL
    mov AL, 0h
    out 60h, AL

    popa

    mov AH, 49h
    int 21h

    mov AH, 4Ch
    int 21h
CSEG ENDS
END main