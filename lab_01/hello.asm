.MODEL TINY
.DOSSEG
.DATA
    MSG DB "Hello, World!", 0Dh, 0Ah, '$' ; Инициализация выходного сообщения
.CODE
.STARTUP
    MOV AH, 09h                           ; АН=09h выдать на дисплей строку
    MOV DX, OFFSET MSG                    ; передача адреса строки
    INT 21h                               ; вызов функции DOS
    MOV AH, 4Ch                           ; АН=4Ch завершить процесс
    INT 21h                               ; вызов функции DOS
END