PUBLIC output

EXTRN MAX_N_M_VALUES: byte
EXTRN matrix: byte
EXTRN n: byte
EXTRN m: byte

; Создание сегмента данных (констант)
DSEG SEGMENT PARA PUBLIC 'DATA'
OUTPUT_MSG db 0Ah
    db 0Dh
    db "Result matrix: "
    db 0Ah
    db 0Dh
    db '$'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
output proc near
    print_output_matrix_msg:
        mov AH, 9h
        mov DX, OFFSET OUTPUT_MSG
        int 21h
    print_matrix:
        ; Инициализация счетчика для цикла по строкам
        mov AH, 2h
        mov BX, 0
        mov CL, n
        sub CL, 30h
        
        ; Вывод строк результирующей матрицы
        print_matrix_rows:
            push CX
            
            ; Инициализация счетчика для цикла по столбцам
            mov SI, 0
            mov CL, m
            sub CL, 30h

            ; Вывод конкретной цифры строки
            print_matrix_num:
                mov DL, matrix[BX][SI]
                add DL, 30h
                int 21h

                mov DX, 20h
                int 21h
                
                inc SI

                loop print_matrix_num

            add BL, MAX_N_M_VALUES

            pop CX

            mov DX, 0Dh
            int 21h
            mov DX, 0Ah
            int 21h

            loop print_matrix_rows
    ret
output endp
CSEG ENDS

END