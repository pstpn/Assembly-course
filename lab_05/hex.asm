PUBLIC get_signed_hex_num
EXTRN read_num: near
EXTRN print_output_hex_msg: near
EXTRN print_crlf: near
EXTRN print_minus: near
EXTRN decimal: word


DSEG SEGMENT PARA PUBLIC 'DATA'
HEX_ALPHABET db "0123456789ABCDEF"
DSEG ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
current_dec dw 0
DSEG ENDS


CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
get_signed_hex_num proc near
    call read_num

    call print_output_hex_msg

    xor DX, DX
    mov CX, 4
    mov AX, decimal
    and AX, 32768
    cmp AX, 32768
    
    je negative_hex
    jmp process_convert

    negative_hex:
        not decimal
        add decimal, 1
    process_convert:
        mov current_dec, 0

        push CX
        mov CL, 100b
        rol decimal, CL
        mov AX, decimal
        and AX, 1111b
        add current_dec, AX
        
        mov DI, OFFSET HEX_ALPHABET
        add DI, current_dec
        mov DL, [DI]
        mov AH, 02h
        int 21h

        pop CX
        loop process_convert

    call print_crlf

    ret
get_signed_hex_num endp
CSEG ENDS

END