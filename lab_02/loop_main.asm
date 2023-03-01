StkSeg SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg ENDS

DataS SEGMENT WORD 'DATA'
HelloMessage DB 13              ; курсор поместить в нач. строки
    DB 10                       ; перевести курсор на нов. строку
    DB 'Hello, world !'         ; текст сообщения
    DB '$'                      ; ограничитель для функции DOS
DataS ENDS

Code SEGMENT WORD 'CODE'
    ASSUME CS:Code, DS:DataS
PrintMsg:
    mov AX, DataS               ; загрузка в AX адреса сегмента данных
    mov DS, AX                  ; установка DS
    mov DX, OFFSET HelloMessage ; передача адреса строки
    mov AH, 9                   ; АН=09h выдать на дисплей строку
    mov CX, 3                   ; установка счетчика цикла
dispMsg:
    int 21h                     ; вызов функции DOS
    loop dispMsg                ; цикл вывода сообщения
    
    mov AH, 7                   ; АН=07h ввести символ без эха
    int 21h                     ; вызов функции DOS
    mov AH, 4Ch                 ; АН=4Ch завершить процесс
    int 21h                     ; вызов функции DOS
Code ENDS

END PrintMsg