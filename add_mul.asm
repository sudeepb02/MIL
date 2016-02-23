%macro fn 4
	push rax
	push rbx
	push rcx
	push rdx
	mov eax,%1
	mov ebx,%2
	mov ecx,%3
	mov edx,%4
	int 80h
	pop rdx
	pop rcx
	pop rbx
	pop rax
%endmacro

section .data

msg1 db "Enter the two numbers : ",20h
msg1len equ $-msg1

section .bss
no1 resb 5
no1len resb 1
no2 resb 5
no2len resb 1
sum resd 1
result resb 11
num1 resd 1
num2 resd 2

section .text
global _start
_start:
	fn 4,1,msg1,msg1len

	mov eax,3
	mov ebx,0
	mov ecx,no1
	mov edx,5
	int 80h

	mov [no1len],al
	
	mov eax,3
	mov ebx,0
	mov ecx,no2
	mov edx,5
	int 80h

	mov [no2len],al
	
	mov ecx,0
	mov cl,[no1len]
	mov eax,0
	mov esi,no1
l1:	rol eax,4
	mov dl,byte[esi]
	sub dl,30h
	add al,dl
	inc esi
	dec cl
	jnz l1

	mov dword[num1],eax


exit :
	mov eax,1
	mov ebx,0
	int 80h

