PUBLIC replace

EXTRN MAX_N_M_VALUES: byte
EXTRN matrix: byte
EXTRN n: byte
EXTRN m: byte


; Создание сегмента данных (для работы)
DSEG SEGMENT PARA PUBLIC 'DATA'
temp_matrix db 9 dup(9 dup(0))
DSEG ENDS


CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
init_temp_matrix proc near
    ; Инициализация счетчика для цикла по строкам
    mov BX, 0
    xor CX, CX
    mov CL, n
    sub CL, 30h

    init_matrix_rows:
        push CX
        
        ; Инициализация счетчика для цикла по столбцам
        mov SI, 0
        mov CL, m
        sub CL, 30h

        init_matrix_num:
            mov AL, matrix[BX][SI]
            mov temp_matrix[BX][SI], AL
            inc SI

            loop init_matrix_num

        add BL, MAX_N_M_VALUES

        pop CX

        loop init_matrix_rows

    ret
init_temp_matrix endp
copy_to_matrix proc near
    ; Инициализация счетчика для цикла по строкам
    mov BX, 0
    xor CX, CX
    mov CL, n
    sub CL, 30h

    init_matrix_rows:
        push CX
        
        ; Инициализация счетчика для цикла по столбцам
        mov SI, 0
        mov CL, m
        sub CL, 30h

        init_matrix_num:
            mov AL, temp_matrix[BX][SI]
            mov matrix[BX][SI], AL
            inc SI

            loop init_matrix_num

        add BL, MAX_N_M_VALUES

        pop CX

        loop init_matrix_rows

    ret
copy_to_matrix endp
replace proc near
    call init_temp_matrix

    find_num_and_replace:
        ; Инициализация счетчика для цикла по строкам
        mov BX, 0
        mov CL, n
        sub CL, 30h

        ; Цикл по строкам
        for_i_less_n:
            push CX

            ; Инициализация счетчика для цикла по столбцам
            mov SI, 0
            mov CL, m
            sub CL, 30h

            ; Цикл по столбцам
            for_j_less_m:
                mov AL, matrix[BX][SI]
                mov AH, m
                sub AH, 30h
                cmp AL, AH

                ; Если значение конкретной цифры меньше либо равно
                jle replace_nums
                ; Иначе
                jg skip

                ; Замена цифры на другую с индексом == старому значению
                replace_nums:
                    push SI
                    mov DL, temp_matrix[BX][SI]
                    mov SI, DX
                    dec SI
                    mov AL, matrix[BX][SI]
                    pop SI
                    mov temp_matrix[BX][SI], AL
                skip:
                    inc SI

                loop for_j_less_m

            add BL, MAX_N_M_VALUES

            pop CX

            loop for_i_less_n

    call copy_to_matrix

    ret
replace endp
CSEG ENDS

END