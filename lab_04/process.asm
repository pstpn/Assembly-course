PUBLIC replace

EXTRN MAX_N_M_VALUES: byte
EXTRN matrix: byte
EXTRN n: byte
EXTRN m: byte

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG
replace proc near
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

                ; Если значение конкретной цифры меньше (меньше либо равно (jle)???)
                jl replace_nums
                ; Иначе (больше (jg)???)
                jge skip

                ; Замена цифры на другую с индексом == старому значению
                replace_nums:
                    push SI
                    mov DL, matrix[BX][SI]
                    mov SI, DX
                    mov AL, matrix[BX][SI]
                    pop SI
                    mov matrix[BX][SI], AL
                skip:
                    inc SI

                loop for_j_less_m

            add BL, MAX_N_M_VALUES

            pop CX

            loop for_i_less_n
    ret
replace endp
CSEG ENDS

END