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
msg1 db "Enter a BCD number : "
msg1len equ $-msg1
nline db 10
msg2 db "Equivalent hexadecimal number : "
msg2len equ $-msg2

section .bss
no_bcd resb 0Bh
no_hex resd 1
temp resd 1
result resb 8

section .text
global _start
_start:	
	fn 4,1,msg1,msg1len
	fn 4,1,nline,1
	
	fn 3,0,no_bcd,0Bh		;Read the number
	
	mov eax,0	;To store hex equivalent
	mov esi,no_bcd	;Pointer
	mov ebx,0Ah
	mov cl,8

mloop:	cmp byte[esi],0Ah	;check end of line
	je next			;jump if equal to next
	cmp byte[esi],30h	;check invalid 
	jb exit			;jump to exit

	cmp byte[esi],39h	;conversion
	jbe l1
	jmp next
l1:
	sub byte[esi],30h
	mul ebx
	add al,byte[esi]
	inc esi
	dec cl
	jnz mloop

next:	mov edi,no_hex		;set pointer
	mov [edi],eax		;Store the number
	
	fn 4,1,msg2,msg2len
	call display		;call display function
	fn 4,1,nline,1		;New line
	
		

exit:	mov eax,1
	mov ebx,0
	int 80h

display:
	mov cl,8		;set counter
	mov esi,result		;set pointer
r1:
	rol eax,4		;rotate left 4 bits
	mov [temp],eax		;store in temp
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
	
	
		
	
