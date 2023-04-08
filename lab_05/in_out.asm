PUBLIC print_menu
PUBLIC read_action
PUBLIC read_num
PUBLIC crlf
PUBLIC print_minus
EXTRN decimal: word


; Создание сегмента данных (сообщений и констант)
DSEG SEGMENT PARA PUBLIC 'DATA'
MENU_MSG db 0Ah, 0Dh, 0Dh,
    "Menu: ", 0Ah, 0Dh, 0Dh,
    "1) Get unsigned binary number", 0Ah, 0Dh,
    "2) Get signed hex number", 0Ah, 0Dh,
    "0) Exit", 0Ah, 0Dh,
    ": $"
INPUT_NUM_MSG db 0Ah
    db 0Dh
    db "Input unsigned decimal number: $"
OUTPUT_BIN_MSG db "Converted binary number: $"
OUTPUT_HEX_MSG db "Converted hex number: $"
crlf db 0Dh, 0Ah, '$'
DSEG ENDS

; Создание сегмента данных (для работы)
DSEG SEGMENT PARA PUBLIC 'DATA'
string_num db 6
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
print_crlf proc near
	mov AH, 09h		
    mov DX, offset crlf
	int 21h

    ret
print_crlf endp
print_menu proc near
    mov AH, 09h
    mov DX, OFFSET MENU_MSG
    int 21h

    ret
print_menu endp
print_input_msg proc near
	call print_crlf
    mov DX, OFFSET INPUT_NUM_MSG
    int 21h

    ret
print_input_msg endp
print_output_bin_msg proc near
    mov AH, 09h
    mov DX, OFFSET OUTPUT_BIN_MSG
    int 21h

    ret
print_output_bin_msg endp
print_output_hex_msg proc near
    mov AH, 09h
    mov DX, OFFSET OUTPUT_HEX_MSG
    int 21h

    ret
print_output_hex_msg endp
print_minus proc near
    mov AH, 02h
    mov DX, '-'
    int 21h

    ret
print_minus endp
read_action proc near
    xor SI, SI
    mov AH, 01h
    int 21h

    xor AH, AH
    sub AL, 30h
    mov CL, 02h
    mul CL
    mov SI, AX
    
    ret
read_action endp
read_string_num proc near
    mov AH, 0Ah
    mov DX, OFFSET string_num
    int 21h

	call print_crlf

    mov DI, offset string_num
	mov BX, [DI+1]
	mov byte ptr [DI+BX+2], '$'

	call print_crlf

    ret
read_string_num endp
string_num_to_word proc near
    xor AX, AX
    xor BX, BX
    xor SI, SI
    xor CX, CX
    mov DI, offset string_num
	mov CL, [DI+1]
    mov DX, OFFSET string_num
    add DX, 02h
    mov SI, DX
    mov DI, 10
    
    while_cx:
        mov BL, [SI]
        inc SI
        sub BL, 30h

        mov AX, decimal
        mul DI
        xor BH, BH
        add AX, BX
        mov decimal, AX

        loop while_cx

    ret
string_num_to_word endp
read_num proc near
    call print_input_msg

    call read_string_num

    call string_num_to_word

    ret
read_num endp
CSEG ENDS

END