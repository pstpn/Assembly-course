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

; Матрица - прямоугольная цифровая

; Задание - если значение какого-либо элемента не
; превышает количества элементов в строке,
; заменить его значением элемента, чей индекс в
; строке равен старому значению

StackSEG SEGMENT PARA STACK 'STACK'
    db 100 dup(0)
StackSEG ENDS

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

DSEG SEGMENT PARA PUBLIC 'DATA'
n db '$'
m db '$'
matrix db 9 dup(9 dup(0))
DSEG ENDS

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
    mov BX, 0
    mov CL, n
    sub CL, 30h
read_matrix_rows:
    push CX
    
    mov SI, 0
    mov CL, m
    sub CL, 30h

    read_matrix_value:
        mov AH, 1h
        int 21h
        mov matrix[BX][SI], AL
        sub matrix[BX][SI], 30h

        mov AH, 2h
        mov DX, 20h
        int 21h
        
        inc SI

        loop read_matrix_value

    add BL, MAX_N_M_VALUES

    pop CX

    mov DX, 0Dh
    int 21h

    mov DX, 0Ah
    int 21h

    loop read_matrix_rows
print_output_matrix_msg:
    mov AH, 9h
    mov DX, OFFSET OUTPUT_MSG
    int 21h
print_matrix:
    mov AH, 2h
    mov BX, 0
    mov CL, n
    sub CL, 30h
print_matrix_rows:
    push CX

    mov DX, 0Dh
    int 21h
    mov DX, 0Ah
    int 21h
    
    mov SI, 0
    mov CL, m
    sub CL, 30h

    print_matrix_value:
        mov DL, matrix[BX][SI]
        add DL, 30h
        int 21h

        mov DX, 20h
        int 21h
        
        inc SI

        loop print_matrix_value

    add BL, MAX_N_M_VALUES

    pop CX

    loop print_matrix_rows
finish_program:
    mov AH, 4Ch
    int 21h
CSEG ENDS

END main