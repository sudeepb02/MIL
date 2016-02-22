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
msg1 db "Enter a Hex number : "
msg1len equ $-msg1
nline db 10
msg2 db "Equivalent BCD number : "
msg2len equ $-msg2

section .bss
no_asc resb 09h
no_hex resd 1
temp resd 1
result resb 8

section .text
global _start
_start:	
	fn 4,1,msg1,msg1len
	fn 4,1,nline,1
	
	fn 3,0,no_asc,09h		;Read the number
	
	mov eax,0	;To store hex equivalent
	mov esi,no_asc	;Pointer
	;mov ebx,0Ah
	mov cl,8

mloop:	cmp byte[esi],0Ah
	je next
	cmp byte[esi],39h
	jbe l1
	sub byte[esi],07h
l1:
	sub byte[esi],30h
	rol eax,4
	add al,byte[esi]
	inc esi
	dec cl
	jnz mloop

	mov esi,result
next:	mov edi,no_hex
	mov eax,[edi]		;Store the number
	mov ebx,0Ah
divid:	div ebx
	mov byte[esi],dl
	inc esi
	cmp eax,00
	jnz divid

	fn 4,1,msg2,msg2len
	call display
	fn 4,1,nline,1
	
		

exit:	mov eax,1
	mov ebx,0
	int 80h

display:
	mov cl,8
	;mov eax,no_hex
	mov esi,result
r1:
	rol eax,4
	mov [temp],eax
	and al,0fh
	cmp al,09
	jbe r2
	add al,07h
r2:	add al,30h
	mov byte[esi],al
	add esi,1
	mov eax,[temp]
	dec cl
	jnz r1
	
	fn 4,1,result,8
	ret
	
	
		
	
