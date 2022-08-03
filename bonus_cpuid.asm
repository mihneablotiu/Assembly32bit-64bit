section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	push ebx ; we save the used registers as the calling convention rules
	push esi
	push edi

	mov eax, 0x0 ; we call cpuid with 0 in eax
	cpuid

	mov edi, dword[ebp + 8] ; the starting address of the string

	mov dword[edi], ebx ; we write the manufacturer ID in the corect
						; order (ebx, edx, ecx)
	add edi, 4
	mov dword[edi], edx

	add edi, 4
	mov dword[edi], ecx
	
	pop edi ; we restore the registers
	pop esi
	pop ebx
	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0
	push ebx ; we save the used registers as the calling convention rules
	push esi
	push edi

	xor eax, eax 
	add eax, 1 ; we call cpuid with eax = 1
	cpuid

	mov edi, dword[ebp + 8] ; the starting address of where we write the vmx value

	ror ecx, 5 ; we bring the vmx bit to bit 0 (less significant)
	and ecx, 1 ; we keep just the last bit
	mov dword[edi], ecx ; we write it 

	xor eax, eax
	add eax, 1 ; we call cpuid with eax = 1
	cpuid

	mov edi, dword[ebp + 12] ; the starting address of where we write the rdrand value

	rol ecx, 2 ; we bring the rdrand bit to bit 0
	and ecx, 1 ; we keep just the last bit
	mov dword[edi], ecx ; we write it

	xor eax, eax
	add eax, 1 ; we call cpuid with eax = 1
	cpuid

	mov edi, dword[ebp + 16] ; the starting address of where we write the avx value

	rol ecx, 4 ; we bring the avx bit to bit 0
	and ecx, 1 ; we keep just the last bit
	mov dword[edi], ecx ; we write it

	pop edi ; restore the registers saved initally
	pop esi
	pop ebx
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	push ebx ; we save the registers as the calling convention rules
	push esi
	push edi
	
	xor eax, eax
	mov eax, 80000006h ; we call cpuid with eax = 80000006h 
	cpuid
	
	mov edi, dword[ebp + 8] ; the address where the line_size should be written

	xor ebx, ebx
	mov bl, cl ; the line size in the 0-7 bits of ecx
	mov dword[edi], ebx ; we write the result as an int


	xor eax, eax
	mov eax, 80000006h ; we call cpuid with eax = 80000006h
	cpuid
	
	mov edi, dword[ebp + 12] ; the address where the cache_size should be written

	xor ebx, ebx
	rol ecx, 16 ; the cache size is in the 16-31 bits so we bring
				; them in the 0-15 bits in order to access the easily
	mov bx, cx
	mov dword[edi], ebx ; we write them as an int

	pop edi ; we restore the registers
	pop esi
	pop ebx
	leave
	ret
