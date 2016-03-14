;File with main
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

extern concat,substring
global str1,str2,str3,str1len,str2len,str3len

section .data
msg1 db "1. Concat",10,"2.Substring",10,"Enter your choice : ",20h
msg1len equ $-msg1

msg2 db "Please enter string 1 : ",20h
msg2len equ $-msg2

msg3 db "Please enter string 2 : ",20h
msg3len equ $-msg3

msg4 db "Please enter the substring : ",20h
msg4len equ $-msg4

errmsg db "Please enter correct choice ",10
errmsglen equ $-errmsg

nline db "",10		;For new line

section .bss
str1 resb 16
str2 resb 16
str3 resb 32

str1len resb 1
str2len resb 1
str3len resb 1
choice resb 2


section .text
global _start
_start:
	fn 4,1,msg1,msg1len
	
	fn 3,0,choice,2		;Read choice from user
	cmp byte[choice],31h
	je l_concat
	cmp byte[choice],32h
	je l_substr
	
	fn 4,1,errmsg,errmsglen	;Invalid choice
	jmp exit		;Exit

l_concat:
	fn 4,1,msg2,msg2len

	mov eax,3
	mov ebx,0
	mov ecx,str1
	mov edx,40
	int 80h
	mov byte[str1len],al

	fn 4,1,msg4,msg4len

	mov eax,3
	mov ebx,0
	mov ecx,str2
	mov edx,20
	int 80h
	mov byte[str2len],al

	call concat

	mov bl,byte[str1len]
	mov cl,byte[str2len]
	add bl,cl
	mov byte[str3len],bl

	fn 4,1,str3,str3len
	jmp exit

l_substr:
	fn 4,1,msg2,msg2len

	mov eax,3
	mov ebx,0
	mov ecx,str1
	mov edx,40
	int 80h
	mov byte[str1len],al
	
	fn 4,1,msg4,msg4len

	mov eax,3
	mov ebx,0
	mov ecx,str2
	mov edx,20
	int 80h
	mov byte[str2len],al

	call substring
		
	jmp exit

exit:
	mov eax,1
	mov ebx,2
	int 80h
