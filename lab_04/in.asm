PUBLIC input

EXTRN MAX_N_M_VALUES: byte
EXTRN matrix: byte
EXTRN n: byte
EXTRN m: byte

; Создание сегмента данных (констант)
DSEG SEGMENT PARA PUBLIC 'DATA'
INPUT_N_MSG db 0Ah
    db 0Dh
    db "Input n value: $"
INPUT_M_MSG db 0Ah
    db 0Dh
    db "Input m value: $"
INPUT_MATRIX_MSG db 0Ah
    db 0Dh
    db "Input matrix elements: "
    db 0Ah
    db 0Dh
    db '$'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
input proc near
    print_input_n_msg:
        mov AH, 9h
        mov DX, OFFSET INPUT_N_MSG
        int 21h
    read_n_value:
        mov AH, 1h
        int 21h
        mov n, AL
    print_input_m_msg:
        mov AH, 9h
        mov DX, OFFSET INPUT_M_MSG
        int 21h
    read_m_value:
        mov AH, 1h
        int 21h
        mov m, AL    
    print_input_matrix_msg:
        mov AH, 9h
        mov DX, OFFSET INPUT_MATRIX_MSG
        int 21h
    read_matrix:
        ; Инициализация счетчика для цикла по строкам
        mov BX, 0
        mov CL, n
        sub CL, 30h

        ; Ввод строк матрицы
        read_matrix_rows:
            push CX
            
            ; Инициализация счетчика для цикла по столбцам
            mov SI, 0
            mov CL, m
            sub CL, 30h

            ; Ввод конкретной цифры
            read_matrix_num:
                mov AH, 1h
                int 21h
                mov matrix[BX][SI], AL
                sub matrix[BX][SI], 30h

                mov AH, 2h
                mov DX, 20h
                int 21h
                
                inc SI

                loop read_matrix_num

            add BL, MAX_N_M_VALUES

            pop CX

            mov DX, 0Dh
            int 21h
            mov DX, 0Ah
            int 21h

            loop read_matrix_rows
    ret
input endp
CSEG ENDS

END