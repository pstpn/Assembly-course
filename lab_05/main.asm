; Требуется составить программу, которая будет осуществлять ввод 16-разрядного числа
; и вывод его в знаковом и беззнаковом представлении. Взаимодействие с
; пользователем должно строиться на основе меню. Программа должна содержать не
; менее 4-х модулей. Главный модуль должен обеспечивать вывод меню, а также
; содержать массив указателей на подпрограммы, выполняющие действия,
; соответствующие пунктам меню. Обработчики действий должны быть оформлены в
; виде подпрограмм, находящихся каждая в отдельном модуле. Вызов необходимой
; функции требуется осуществлять с помощью адресации по массиву индексом
; выбранного пункта меню.

; Вводимое число: беззнаковое в 10 с/с
; 1-е выводимое число: беззнаковое в 2 с/с
; 2-е выводимое число: знаковое в 16 с/с


PUBLIC decimal
EXTRN read_action: near
EXTRN read_num: near
EXTRN print_menu: near
EXTRN get_unsigned_bin_num: near
EXTRN get_signed_hex_num: near


; Создание сегмента стека
StackSEG SEGMENT PARA STACK 'STACK'
    db 500 dup(0)
StackSEG ENDS

; Создание сегмента данных (константы)
DSEG SEGMENT PARA PUBLIC 'DATA'
ACTIONS dw finish_program, get_unsigned_bin_num, get_signed_hex_num
DSEG ENDS

; Создание сегмента данных (для работы)
DSEG SEGMENT PARA PUBLIC 'DATA'
decimal dw 0
DSEG ENDS

; Создание сегмента кода
CSEG SEGMENT PARA PUBLIC 'CODE'
    assume DS:DSEG, CS:CSEG, SS:StackSEG
finish_program proc near
    mov AH, 4Ch
    int 21h
finish_program endp
main:
    mov AX, DSEG
    mov DS, AX

    while_not_exit:
        mov decimal, 0h

        call print_menu

        call read_action
        
        call ACTIONS[SI]

        jmp while_not_exit
CSEG ENDS

END main