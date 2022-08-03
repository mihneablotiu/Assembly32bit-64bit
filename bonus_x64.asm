section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0

	; taking into consideration the calling convention on 64 bit
	; we have v1 in %rdi, n1 in %rsi, v2 in %rdx, n2 in %rcx, v in %r8

	cmp rsi, rcx
	jge first ; if the first array has more or equal number of elements as the second
	jl second ; else

back:

	leave
	ret

first:
	mov r10d, dword[rdi]
	mov dword[r8], r10d ; we write the first int from v1 in v
	add r8, 4 ; we go to the next address in v
	add rdi, 4 ; we go to the next address in v1

	mov r10d, dword[rdx]
	mov dword[r8], r10d ; we write the first int from v2 to v(next address)
	add r8, 4 ; we go to the next address in v
	add rdx, 4 ; we go to the next address in v1

	sub rsi, 1 ; we put one element from each array to the result
	sub rcx, 1 ; so we have n1 - 1 and n2 - 1 elements to put more 

	cmp rcx, 0
	jg first ; repeat the previous steps until the second array is
			 ; finished as it is the shortest

	cmp rsi, 0
	jnz continue_first ; continue to put just from the first array
					   ; until this one is finished as well
	jmp back

second: ; the same steps as if the first array was longer
		; but we stop when the first array is finished and we continue
		; with the second one
	mov r10d, dword[rdi]
	mov dword[r8], r10d 
	add r8, 4
	add rdi, 4

	mov r10d, dword[rdx]
	mov dword[r8], r10d
	add r8, 4
	add rdx, 4

	sub rsi, 1
	sub rcx, 1

	cmp rsi, 0
	jg second

	cmp rcx, 0
	jnz continue_second


	jmp back


continue_first: ; continue putting elements from the first array
				; if it is longer until we have no more elements to put in v
	mov r10d, dword[rdi]
	mov dword[r8], r10d 
	add r8, 4
	add rdi, 4

	sub rsi, 1
	cmp rsi, 0
	jnz continue_first

	jmp back

continue_second: ; continue putting elements from the second array
				 ; if it is longer until we have no more elements to put in v
	mov r10d, dword[rdx]
	mov dword[r8], r10d 
	add r8, 4
	add rdx, 4

	sub rcx, 1
	cmp rcx, 0
	jnz continue_second

	jmp back

