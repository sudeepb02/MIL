;File with procedures
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

extern str1,str2,str3,str1len,str2len
global concat,substring

concat :
	mov esi,str1	;set pointer to source
	mov edi,str3	;set pointer to destination
	mov cl,byte[str1len] 	;set counter

	cld		;clear direction flag
	rep movsb	;copy string

	mov esi,str2	;pointer to source 
	mov cl,byte[str2len]
	
	cld
	rep movsb 

	ret

substring :
	ret

