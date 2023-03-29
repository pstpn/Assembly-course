EXTRN second_number: byte
PUBLIC PrintHexNumber

DSEG SEGMENT PARA PUBLIC 'DATA'
OUTPUT_MSG db 13
    db 10
    db "Converted to HEX: $"
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
PrintHexNumber proc near
    mov AX, DSEG
    mov DS, AX

    mov AL, second_number
    add AL, 11h

    mov AH, 9h
    mov DX, OFFSET OUTPUT_MSG
    int 21h

    mov AH, 2h
    mov DL, AL
    int 21h

    mov DX, 10
    int 21h

    mov DX, 13
    int 21h

    ret
PrintHexNumber endp
CSEG ENDS
END