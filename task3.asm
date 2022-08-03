global get_words
global compare_func
global sort

section .text
    extern strtok
    extern strncpy
    extern qsort
    extern strlen
    extern strncmp
    extern printf

section .data
    delim db " ,.", 0xA, 0x0

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    push ebx ; saving the registers as the calling convention rules
    push esi
    push edi

    mov esi, dword[ebp + 8] ; the pointer to the array of words
    mov ecx, dword[ebp + 12] ; the number of words
    mov edx, dword[ebp + 16] ; the size of the elements to be sorted

    push compare_func
    push edx
    push ecx
    push esi
    call qsort ; calling qsort with the parameters needed
    add esp, 16

    pop edi ; restoring the values of the registers
    pop esi
    pop ebx
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    push ebx ; saving the register as the calling convetion rules
    push esi
    push edi

    mov edi, dword[ebp + 8] ; the start of the string
    mov esi, dword[ebp + 12]; pointer to the frist array of the words
    mov ecx, dword[ebp + 16]; the number of words

    push delim ; calling strtok for the first word
    push edi
    call strtok
    add esp, 8

    ; now in EAX we have the first word after the split

splitting:

    push 100
    push eax
    push dword[esi]
    call strncpy ; we put the current word in the current array
    add esp, 12

    add esi, 4 ; pointer to the next array

    push delim
    push 0
    call strtok
    add esp, 8 ; separate the next word

    cmp eax, 0 ; separate untill eax = NULL
    jne splitting ; we separate and write in the array until the last word is null

    pop edi ; restoring the old registers
    pop esi
    pop ebx
    leave
    ret

compare_func: ; compare_func for qsort parameter
    enter 0, 0
    push ebx ; saving the register as the calling convetion rules
    push esi
    push edi

    mov ebx, dword[ebp + 8] ; the void address of the first string
 
    push dword[ebx]
    call strlen ; now we have in eax the length of the first string
    add esp, 4

    mov ecx, eax ; ecx = strlen(s1)
    push ecx

    mov edx, dword[ebp + 12] ; the void address of the second string

    push dword[edx]
    call strlen
    add esp, 4 ; eax = strlen(s2)

    pop ecx

    cmp ecx, eax ; compare the length of the strings
    jg correct_order ; if the first one is longer than the second
    jl inverse_order ; if the first one is shorter than the second

    ; if they are equal we compare lexicographically
    mov ebx, dword[ebp + 8] ; s1
    mov edx, dword[ebp + 12] ; s2

    push 100
    push dword[edx]
    push dword[ebx]
    call strncmp ; automatically puts the result in eax
    add esp, 12

back:
    pop edi ; restoring the old registers
    pop esi
    pop ebx
    leave
    ret

correct_order:
    mov eax, 1
    jmp back

inverse_order:
    mov eax, -1
    jmp back