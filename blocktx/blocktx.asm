;Block Transfer

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
str1 db "000001234500000"
str1len equ $-str1

msg1 db "1.Non-overlapping",10,"2.Overlapping with positive offset",10,"3.Overlapping with negative offset",10,"4.Exit",10
msg1len equ $-msg1

msg2 db "Enter your choice :",20h
msg2len equ $-msg2

msg3 db "Enter offset : ",20h
msg3len equ $-msg3

msg4 db "String : ",20h
msg4len equ $-msg4

nline db 10

section .bss
choice resb 2
offset resb 2

section .text
global _start:
_start:
	fn 4,1,msg4,msg4len
	fn 4,1,str1,str1len

	fn 4,1,nline,1
	fn 4,1,msg1,msg1len

	fn 3,0,choice,2		;read choice from user

	cmp byte[choice],31h	;jump to appropriate label
	je lno
	cmp byte[choice],32h
	je lop
	cmp byte[choice],33h
	je lon
	cmp byte[choice],34h
	je exit
	jmp _start

lno :
	call nobt

	fn 4,1,str1,str1len

	fn 4,1,nline,1
	jmp _start

lop :
	call getoffset		;get offset from user
	call ptransfer

	fn 4,1,str1,str1len

	fn 4,1,nline,1
	jmp _start

lon :
	call getoffset
	call ntransfer

	fn 4,1,str1,str1len
	
	fn 4,1,nline,1
	jmp _start

exit :
	mov eax,1
	mov ebx,0
	int 80h

getoffset :
	fn 4,1,msg3,msg3len

	fn 3,0,offset,2

	mov al,byte[offset]	;convert offset to decimal
	sub al,30h	
	mov byte[offset],al	;store final offset

	ret

nobt :
	mov esi,str1		;set pointer to source
	add esi,5		;move to reqd location
	mov edi,esi		;set pointer ot destination
	add edi,5		;move to reqd position

	mov ecx,5
	cld 			;copy string in auto-incr
	rep movsb
	
	ret

ptransfer :

	mov esi,str1		;set pointer ot source
	mov edi,str1		;set pointer to destination

	add esi,9	
	add edi,9
	mov ebx,0
	mov bl,byte[offset]
	add edi,ebx		;move to required offset location

	mov ecx,5

	std			;set direction flag for auto-decr
	rep movsb

	ret

ntransfer :
	mov esi,str1		;set pointer to source
	mov edi,str1		;set pointer to destination

	add esi,5
	add edi,5
	mov ebx,0
	mov bl,byte[offset]
	sub edi,ebx		;move to reqd offset location

	mov ecx,5

	cld			;clear direction flag
	rep movsb		;copy string
	ret


