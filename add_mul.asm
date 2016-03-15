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

nline db 10

section .bss
no1 resb 8
no2 resb 8
result resb 8
num1 resd 1
num2 resd 1
rdec resd 1 
temp resd 1


section .text
global _start
_start:
	fn 4,1,msg1,msg1len

	fn 3,0,no1,8	;Read number 1

	fn 3,0,no2,8	;Read number 2
		
	mov eax,0
	mov esi,no1
conv1:
	mov bl,byte[esi]
	cmp bl,0Ah
	je l1
	cmp bl,39h
	jbe sub30
	sub bl,07h
sub30:	sub bl,30h
	
	rol eax,4
	add al,bl

	inc esi
	cmp byte[esi],0Ah
	jne conv1

l1:	mov dword[num1],eax
	mov eax,0
	mov esi,no2

	mov bl,byte[esi]
	cmp bl,0Ah
	je lmul



lmul:	call multiply
	fn 4,1,nline,1

	call display
	fn 4,1,result,8

	fn 4,1,nline,1
	jmp exit

exit :
	mov eax,1
	mov ebx,0
	int 80h

multiply:
	mov eax,dword[num1]
	mov ecx,dword[num2]

	mov edi,00

la1:	add edi,eax
	dec ecx
	jnz la1

	mov [rdec],edi
	ret

display:
	mov eax,[rdec]
	mov cl,8
	mov esi,result

la2:	rol eax,4
	mov dword[temp],eax
	and al,0fh
	cmp al,09h
	jbe next
	add al,07h
next:	add al,30h
	mov byte[esi],al
	mov eax,dword[temp]
	inc esi
	dec cl
	jnz la2

	ret
