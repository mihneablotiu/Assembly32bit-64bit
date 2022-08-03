section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	pop edx ; ret address
	pop eax ; first parameter -> eax = a
	pop ebx ; second parameter -> ebx = b
	push ebx ; putting them back on the stack
	push eax
	push edx

cmmdc:
	xor edx, edx 
	div ebx
	push edx
	pop esi ; esi = eax % ebx

	push ebx ; eax = ebx
	pop eax

	push esi ; ebx = esi
	pop ebx

	cmp ebx, 0 ; euclid's algorithm until ebx is <= 0
	ja cmmdc

	; now we have cmmdc(a, b) = eax
	; formula: a * b = cmmdc(a, b) * cmmmc(a, b)
	; cmmmc(a, b) = a * b / cmmdc(a, b)

	push eax 
	pop edi ; cmmdc = edi

	pop edx ; getting the parameters again for the product
	pop eax ; eax = a
	pop ebx ; ebx = b
	push ebx ; putting them back on the stack
	push eax
	push edx

	mul ebx ; eax = a * b

	div edi ; eax = a * b / cmmdc(a, b)
	
	ret
	
