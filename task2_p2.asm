section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	pop esi ; ret address
	pop ecx ; str_length
	pop ebx ; the address of the first characther of the string
	push ebx ; putting the parameters back on the stack
	push ecx
	push esi

	xor esi, esi ; the number of parantheses opened/closed

parantheses:
	xor eax, eax
	or al, byte[ebx] ; the current par as ascii value

	cmp eax, 40 ; if the current par is open
	je open_par

	cmp eax, 41 ; if the current par is closed
	je closed_par

continue:

	add ebx, 1 ; the next address
	loopnz parantheses

	cmp esi, 0 ; after the string is finished we check
	je balanced ; if the counter is 0, the par are balanced
	jmp finish ; else they are not

balanced:
	xor eax, eax
	add eax, 1 ; if they are balanced we return 1
	ret

open_par:
	add esi, 1 ; we add one to the counter and we continue
	jmp continue

closed_par:
	sub esi, 1 ; we substract one from the counter

	cmp esi, 0 ; if we are on the negative number the par are not balanced
	jl finish

	jmp continue ; else we continue

finish:
	xor eax, eax ; not balanced so we return 0
	ret




