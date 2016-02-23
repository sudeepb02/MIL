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

section .data


section .text
global_main
_main:
	
exit:
	mov eax,1
	mov ebx,0
	int 80h


