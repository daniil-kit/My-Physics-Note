bits 64

section .data
matrix_info:    ; Здесь будут размеры матрицы и сами данные
db 3, 4          ; Всего 12 ячеек

    align 8

matrix_data:

        dq 1, 2, 3, 4    ; Строка 1 (4 элемента)

        dq 5, 6, 7, 8    ; Строка 2 (4 элемента)

        dq 9, 0, 1, 2    ; Строка 3 (4 элемента) окей идем дальше

section .bss
    sum: resq 255 ; Здесь зарезервируем место под суммы столбцов
	

section .text
    global _start

_start:
    ; Основной код лабы
	movzx r8, [matrix_info]; R - cтроки
	movzx r9, [matrix_info + 1]; C - столбцы
	xor rcx, rcx
column_loop:
	cmp rcx,r9; compare сравнение
	jge >= start_sort; идем к сорт
	jge start_sort
	xor r10,r10
	xor rsi,rsi
	
row_loop:
	cmp rsi,r8; сompare cтроки внетренний цикл
	jge end_row_loop;
вычисляем номер элемента матрицы и адрес(умножаем на *8)
	mov rax, rsi
	imul rax, r9
	add rax, rcx; i*R + j проходим и в rax

	add r10, [matrix_data + rax*8]
	inc rsi; i++
	jmp row_loop;
end_row_loop:
	mov [sum + rcx*8], r10

	inc rcx
	jmp column_loop
; Sort
init_sort:
	mov r15,1; flag
	test r15,r15 ; check flag
	jz exit
main_sort_loop:
	xor r15,r15
	mov rcx, 1;
	call sort_step
	xor rcx, rcx; rcx = 0
	call sort_step
	jmp main_sort_loop
sort_step:
.loop:
    mov rdx, rcx
    inc rdx         ; rdx = j + 1
    cmp rdx, r9     ; Проверка границы
    jge .done

    mov rax, [col_sums + rcx*8] ; сумма j
    mov rbx, [col_sums + rdx*8] ; сумма j+1

    ; Логика сравнения (Вариант 94)
    movzx r14, byte [order]
    test r14, r14
    jnz .descending

    cmp rax, rbx    ; Возрастание
    jle .next
    jmp .swap
.descending:
    cmp rax, rbx    ; Убывание
    jge .next

.swap:
    mov r15, 1      ; Ставим флаг изменений
    ; Меняем суммы местами
    mov [col_sums + rcx*8], rbx
    mov [col_sums + rdx*8], rax
    ; Меняем столбцы в матрице
    call swap_columns

.next:
    add rcx, 2
    jmp .loop
.done:
    ret

; --- Подпрограмма перестановки столбцов ---
swap_columns:
    ; Вход: rcx = j, rdx = j+1
    xor rsi, rsi    ; i = 0
.loop:
    cmp rsi, r8
    jge .done
    
    ; Элемент [i][j]
    mov rdi, rsi
    imul rdi, r9
    add rdi, rcx
    
    ; Элемент [i][j+1]
    mov rbp, rsi
    imul rbp, r9
    add rbp, rdx

    ; Swap 64-bit values
    mov r11, [matrix_data + rdi*8]
    mov r12, [matrix_data + rbp*8]
    mov [matrix_data + rdi*8], r12
    mov [matrix_data + rbp*8], r11

    inc rsi
    jmp .loop
.done:
    ret

exit:	
    ; Выход из программы
    mov rax, 60
    xor rdi, rdi
    syscall

       


