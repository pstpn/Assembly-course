.686
.model flat, stdcall
option casemap:none

include D:\masm32\include\windows.inc
include D:\masm32\include\user32.inc
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\user32.lib
includelib D:\masm32\lib\kernel32.lib


; Прототип главной функции окна
MainWindow proto :DWORD,:DWORD,:DWORD,:DWORD

.data
; Имя окна
windowName db "Lab_10", 0
; Имя всплывающего окна результата
className db "Sum result", 0
; Класс кнопки
btnName db "button", 0
; Текст на кнопке
btnText db "Get result", 0
; Класс полей ввода цифр
fieldName db "edit", 0
; Форматированное сообщение результата
formatResult db "Sum result: %d", 0

.data?
; Handle программы
hinstance HINSTANCE ?
; Терминал (адрес)
cmd LPSTR ?
; Handler кнопки
btnHandler HWND ?
; Handler первого поля ввода
field1 HWND ?
; Handler второго поля ввода
field2 HWND ?
; Бефер чтения
buf db 2 dup(?)

.const
; ID кнопки получения результата
btnID equ 1

.code
main:
    ; Получение Handlera для программы
    invoke GetModuleHandle, NULL
    mov hinstance, eax 
    ; Получение адреса cmd
    invoke GetCommandLine
    mov cmd, eax
    ; Вызов запуска главного окна
    invoke MainWindow, hinstance, NULL, cmd, SW_SHOWDEFAULT
    ; Завершение программы
    invoke ExitProcess, eax

; Функция главного окна программы
MainWindow proc hinst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:DWORD, CmdShow:DWORD
    ; Структура для регистрации окна (заполнение ниже)
    local wc:WNDCLASSEX
    ; Обработчик сообщений
    local msg:MSG
    ; Хранение Handlera окна
    local hwnd:HWND

    ; Размер структуры wc
    mov wc.cbSize, SIZEOF WNDCLASSEX
    ; Стиль класса
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    ; Указатель на оконную процедуру
    mov wc.lpfnWndProc, offset process
    ; Количество дополнительных байтов, выделяемых
    ; в соответствии со структурой оконного класса
    mov wc.cbClsExtra, NULL
    ; Количество дополнительных байтов, 
    ; выделяемых после экземпляра окна
    mov wc.cbWndExtra, NULL
    push hinst
    ; Дескриптор экземпляра, 
    ; содержащего оконную процедуру для класса
    pop wc.hInstance
    ; Дескриптор фоновой кисти класса
    mov wc.hbrBackground, COLOR_HIGHLIGHTTEXT
    ; Указатель на символьную строку с завершающим нулем, 
    ; которая указывает имя ресурса меню класса
    mov wc.lpszMenuName, NULL
    ; Указатель на строку с завершающим нулем (название окна)
    mov wc.lpszClassName, offset className
    ; Иконка по умолчанию
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    ; Дескриптор маленького значка, связанного с классом окна
    mov wc.hIconSm, eax
    ; Курсор обычного вида
    invoke LoadCursor, NULL, IDC_ARROW
    ; Дескриптор курсора класса
    mov wc.hCursor, eax
    ; Регистрация класса окна
    invoke RegisterClassEx, addr wc

    ; Создание основного окна
    invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr className,\
        addr windowName, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,\
        CW_USEDEFAULT, 320, 300, NULL, NULL, hinst, NULL
    ; Сохранение Handlera окна
    mov hwnd, eax

    ; Показ окна
    invoke ShowWindow, hwnd, SW_SHOWNORMAL
    ; Обновление окна
    invoke UpdateWindow, hwnd

; Обработчик
.WHILE TRUE
    invoke GetMessage, addr msg, NULL, 0, 0
.BREAK .IF(!eax)
    invoke TranslateMessage, addr msg
    invoke DispatchMessage, addr msg
.ENDW
    mov eax, msg.wParam
    ret
MainWindow endp

; Функция получения результата сложения
process proc hwnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

; Если необходимо закрыть окно
.IF uMsg == WM_DESTROY
    invoke PostQuitMessage, NULL
; Если необходимо создать окно
.ELSEIF uMsg == WM_CREATE
    ; Создание первого поля для ввода
    invoke CreateWindowEx,WS_EX_CLIENTEDGE,addr fieldName,\
        NULL, WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
        ES_AUTOHSCROLL, 10, 100, 30, 30, hwnd, 10, hinstance, NULL
    mov field1, eax
    ; Создание второго поля для ввода
    invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr fieldName,\
        NULL, WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
        ES_AUTOHSCROLL, 55, 100, 30, 30, hwnd, 10, hinstance, NULL
    mov field2, eax
    ; Установить первое поле в фокус (с курсором внутри)
    invoke SetFocus, field1
    ; СОздание кнопки получения результата
    invoke CreateWindowEx, NULL, addr btnName, addr btnText,\
        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,
        100, 100, 160, 30, hwnd, btnID, hinstance, NULL
    mov btnHandler, eax

; Если нажали кнопку получения результата
.ELSEIF uMsg == WM_COMMAND
    ; Сохранение комманды (идентификатора)
    mov eax, wParam
    ; Если текущий идентификатор - кнопочный
    .IF ax == btnID
        shr eax, 16
            .IF ax == BN_CLICKED
            push edi
            push ebx

; Получения первой цифры
getFirstNum:
            invoke GetWindowText, field1, addr buf, 2
            xor edi, edi
            xor eax, eax
            xor ebx, ebx
            mov cx, 10
            mov bl, byte ptr buf[edi]
            sub bl, '0'
            mul cx
            add eax, ebx
            push eax

; Получения второй цифры
getSecondNum:
            invoke GetWindowText, field2, addr buf, 2
            xor edi, edi
            xor eax, eax
            xor ebx, ebx
            mov cx, 10
            mov bl, byte ptr buf[edi]
            sub bl, '0'
            mul cx
            add eax, ebx
            pop ebx
            add eax, ebx

; Вывод результата сложения
printResult:
            invoke wsprintf, addr buf, addr formatResult, eax
            invoke MessageBox, hwnd, addr buf, addr className, MB_OK

            pop ebx
            pop edi
            .ENDIF
    .ENDIF

; Обработчка по умолчанию
.ELSE
    invoke DefWindowProc, hwnd, uMsg, wParam, lParam
    ret

.ENDIF
    xor eax, eax
    ret

process endp
END main