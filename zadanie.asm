%include "asm_io.inc"

segment .data
    array times 100 db 0
    length db 0
    max_index db 0
    
segment .text
    global  _asm_main

print_int_hex:
    enter 0,0
    push eax

    shr eax, 4h
    add eax, 48
    cmp eax, '9'
    jbe dont_add_to_alpha
    add eax, 7
dont_add_to_alpha:
    call print_char
    pop eax
    and eax, 00001111b
    add eax, 48
    cmp eax, '9'
    jbe dont_add_to_alpha2
    add eax, 7
dont_add_to_alpha2:
    call print_char
    mov eax, 104
    call print_char

    leave
    ret

_asm_main:
    enter    0, 0
    pusha

    call read_char
char_loop:
    mov ebx,10
    sub eax, '0'
    mul ebx
    mov ebx, eax
    call read_char
    sub eax, '0'
    add eax, ebx
    push eax
    inc BYTE[length]
    call read_char
    cmp eax, 10
    je fill_array
    cmp eax, 13
    je fill_array
    cmp eax, 32
    je skip_spaces
    jmp char_loop
skip_spaces:
    call read_char
    cmp eax, 32
    je skip_spaces
    jmp char_loop

fill_array:
    mov ecx, [length]
    mov ebx, array
l1:
    pop eax
    mov [ebx], al
    inc ebx
    loop l1

setup_sort:
    xor eax, eax
    mov al, [length]
    dec al
    mov [max_index], al

initialize_sort:
    xor eax,eax
    xor ecx, ecx
    mov edi,array ; will be indexing left element of bubble, max index value is [length] - 2
    mov esi,array ; will be indexing right element of bubble, value is ecx+1 and max value is [length] - 1 = [max_index]
    inc esi
    xor edx,edx ; will be detecting if swap has occured, if not than array is sorted. 1 if swap was made, otherwise 0
    mov cl, [max_index]
    
sort: ; bubble sort. EDI has to be less than ESI
    xor eax, eax
    xor ebx, ebx
    mov al, [edi]
    mov bl, [esi]
    cmp al, bl
    ja swap_bubble
back:
    inc edi
    inc esi
    loop sort
    cmp edx, 0
    je print_array
    jmp initialize_sort

swap_bubble:
    xor eax, eax
    mov al, [esi]
    push eax
    mov al, [edi]
    push eax
    pop eax
    mov [esi], al
    pop eax
    mov [edi], al
    mov edx, 1h
    jmp back

print_array:
    xor ecx, ecx
    mov cl, [length]
    mov ebx, array
l2:
    xor eax, eax
    mov al, [ebx]
    call print_int_hex
    mov eax, 32
    call print_char
    inc ebx
    loop l2

    
_asm_end:
    
    popa
    mov eax, 0
    
    leave
    ret 
 