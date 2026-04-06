bits    64
;       res=(a*b*c - c*d*e) / (a/b + c/d)
section .data
res:
        dq      0
a:
        dq      0xFFFFFFFFFFFFFFFF
b:
        dd      50
c:
        dd      40
d:
        db      10
e:
        dw      1

section .text
global  _start
_start:;
        ; считаем произведение b и c
        mov eax, [b]
        mov ebx, [c]
        mul ebx
        jc err_ovf         ; Проверка переполнения при b * c

        ; сохраняем младшую часть результата
        mov r8d, eax
        shl rdx, 32
        or r8, rdx

        ; умножаем на a
        mov rax, [a]
        mul r8
        jc err_ovf         ; Проверка переполнения при (b*c) * a
        mov r8, rax

        ; считаем d и e
        movzx eax, byte [d]
        movzx ebx, word [e]
        xor rdx, rdx
        mul ebx
        jc err_ovf         ; Проверка переполнения при d * e

        ; сохраняем результат
        mov r9d, eax
        shl rdx, 32
        or r9, rdx

        ; умножаем на c
        mov eax, [c]
        xor rdx, rdx
        mov ebx, r9d
        mul ebx
        jc err_ovf         ; Проверка переполнения при (d*e) * c

        ; сохраняем вторую часть числителя
        mov r10d, eax
        shl rdx, 32
        or r10, rdx

        ; вычитание
        sub r8, r10
        jc err_ovf         ; Если c*d*e больше, чем a*b*c (для беззнаковых это перенос/заем)

        ; первая часть знаменателя a / b
        mov rax, [a]
        mov rdx, 0
        
        ;
        mov rbx, 0         ; Сначала обнуляем весь 64-битный регистр
        mov ebx, [b]       ; Теперь кладем туда 32-битное 'b'
        ;

        test ebx, ebx      ; проверка деления на ноль
        jz err             ; если 0, переход в ошибку

        div rbx
        mov r9, rax

        ; вторая часть c / d
        mov eax, [c]
        mov edx, 0
        movzx ebx, byte[d]

        test ebx, ebx      ; снова проверка делителя
        jz err

        div ebx
        mov r11d, eax

        ; складываем знаменатель
        add r9, r11
        jc err_ovf         ; Проверка переполнения при сложении знаменателей

        ; проверка перед финальным делением
        test r9, r9
        jz err

        ; итоговое деление
        mov rax, r8        ; числитель
        xor rdx, rdx       ; очистка перед div
        div r9             ; деление

        mov [res], rax     ; сохраняем результат

        ; завершение программы (всё ок)
        mov eax, 60
        xor edi, edi
        syscall
        
err:
    ; Ошибка деления на ноль
    mov eax, 60
    mov edi, 1         ; edi = 1
    syscall

err_ovf:
    ; Ошибка переполнения
    mov eax, 60
    mov edi, 2         ; edi = 2
    syscall
