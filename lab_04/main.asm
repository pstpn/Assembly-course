; Требуется составить программу на языке ассемблера, которая обеспечит ввод
; матрицы, преобразование согласно индивидуальному заданию и вывод изменённой
; матрицы.
; В программе должна быть выделена память под матрицу 9х9. Фактический размер
; задаётся пользователем и не превышает 9х9.
; Матрицу считать статической (как если бы в Си она была объявлена char a[9][9]) и
; работать с ней соответствующим образом.
; Тип матрицы “символьная” означает, что элементом матрицы является один символ.
; Тип “цифровая” означает, что элементом является цифра.
; Для решения задачи можно вводить дополнительные переменные, в том числе
; массивы.

; Матрица: прямоугольная цифровая

; Задание: если значение какого-либо элемента не
; превышает количества элементов в строке,
; заменить его значением элемента, чей индекс в
; строке равен старому значению


; Создание сегмента стека
StackSEG SEGMENT PARA STACK 'STACK'
    db 256 dup(0)
StackSEG ENDS

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
OUTPUT_MSG db 0Ah
    db 0Dh
    db "Result matrix: "
    db 0Ah
    db 0Dh
    db '$'
MAX_N_M_VALUES db 9
DSEG ENDS

; Создание сегмента данных (для работы)
DSEG SEGMENT PARA PUBLIC 'DATA'
n db '$'
m db '$'
matrix db 9 dup(9 dup(0))
DSEG ENDS

; Создание сегмента кода
CSEG SEGMENT PARA PUBLIC 'CODE'
    assume DS:DSEG, CS:CSEG, SS:StackSEG
main:
    mov AX, DSEG
    mov DS, AX
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

            ; Если значение конкретной цифры меньше (меньше либо равно (jna)???)
            jnae replace
            ; Иначе
            jnb skip

            ; Замена цифры на другую с индексом == старому значению
            replace:
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
finish_program:
    mov AH, 4Ch
    int 21h
CSEG ENDS

END main