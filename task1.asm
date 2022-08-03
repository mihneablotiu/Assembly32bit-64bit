section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	mov edx, 1 ; the number we search for
	mov ecx, dword[ebp + 8] ; the number of numbers
	mov edi, dword[ebp + 12]; the address of the first value
	mov ebx, dword[edi]; the first value

sorting:

	cmp ebx, 1 ; searching for the first number as we have to return its address
	je first

	add edi, 8 ; the address of the next value
	mov ebx, dword[edi] ; the next value

	loopnz sorting


not_first:
	cmp ebx, edx ; is the current value the value we are searching for?
	je search

	add edi, 8 ; the address of the next value
	mov ebx, dword[edi] ; the next value

	loopnz not_first

done:
	leave
	ret

first:
	mov eax, edi ; the return adress
	lea esi, [edi + 4] ; the next of the first value

	add edx, 1 ; the next number to search for
	mov ecx, dword[ebp + 8] ; the number of numbers
	mov edi, dword[ebp + 12]; the address of the first value
	mov ebx, dword[edi]; the first value
	jmp not_first

search:
	mov dword[esi], edi ; we are writing the next field of the previous element
	lea esi, [edi + 4] ; the next of the current value

	add edx, 1 ; the next number to search for
	mov ecx, dword[ebp + 8] ; the number of numbers
	mov edi, dword[ebp + 12]; the address of the first value
	mov ebx, dword[edi]; the first value

	cmp edx, ecx ; we arrived at the last element?
	jg done

	jmp not_first
