PUBLIC get_unsigned_bin_num
EXTRN read_num: near
EXTRN print_output_bin_msg: near
EXTRN print_crlf: near
EXTRN decimal: word


CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG
get_unsigned_bin_num proc near
    call read_num

    call print_output_bin_msg

    mov BX, decimal
    mov AH, 02h
    xor DX, DX
    xor CX, CX
    mov CL, 10h

    while_shift:
        rol BX, 01h
        mov DX, BX
        xor DH, DH
        and DX, 01h
        add DL, 30h
        int 21h

        loop while_shift

	call print_crlf

    ret
get_unsigned_bin_num endp
CSEG ENDS

END