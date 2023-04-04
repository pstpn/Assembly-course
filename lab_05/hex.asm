PUBLIC get_signed_hex_num
EXTRN read_num: near
EXTRN print_output_hex_msg: near
EXTRN print_crlf: near
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

    mov DI, 2
    mov CX, 1
    mov AX, decimal
    and AX, 32768
    cmp AX, 32768

    je convert_to_negative
    jmp process_convert

    convert_to_negative:
        mov AX, decimal
        not AX
        inc AX
        mov decimal, AX
    process_convert:
        push CX
        mov CX, 3
        mov BX, decimal
        mov current_dec, 0

        get_hex_num:
            rol BX, 1
            mov AX, BX
            and AX, 01h
            push CX
            dec CX
            
            accum_multi:
                mul DI
                loop accum_multi

            add current_dec, AX
            pop CX
            loop get_hex_num
        
        rol BX, 1
        mov AX, BX
        and AX, 01h
        add current_dec, AX
        add current_dec, 40

        ; push DI
        ; mov DI, OFFSET HEX_ALPHABET
        ; mov DX, [DI+1]
        ; mov AH, 02h
        ; int 21h

        mov DX, OFFSET current_dec
        mov AH, 02h
        int 21h

        pop DI
        pop CX
        loop process_convert

    ret
get_signed_hex_num endp
CSEG ENDS

END