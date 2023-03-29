; Задание:
; 
; из двух модулей, в которых объявить по сегменту кода, которые
; должны объединяться в единый. В одном осуществить ввод
; последней цифры числа от 10 до 15, в другом - вывод на экран
; этого числа в 16-ричной с/с.


EXTRN PrintHexNumber: near
PUBLIC second_number

DSEG SEGMENT PARA PUBLIC 'DATA'
INPUT_MSG db 13
    db 10
    db "Input number (10 - 15): $"
first_number db ?
second_number db ?
DSEG ENDS

STK SEGMENT PARA STACK 'STACK'
	db 20 dup(0)
STK ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG, SS:STK
main:
    mov AX, DSEG
    mov DS, AX
print_input_msg:
    mov AH, 9h
    mov DX, OFFSET INPUT_MSG
    int 21h
read_data:
    mov AH, 1h
    int 21h
    mov first_number, AL

    int 21h
    mov second_number, AL
print_result:
    call PrintHexNumber

    mov AH, 4Ch
    int 21h
CSEG ENDS

END main