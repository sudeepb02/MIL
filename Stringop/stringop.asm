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

msg1 db "1.Length",10,"2.Reverse",10,"3.Check Palindrome",10
msg1len equ $-msg1

msg2 db "Enter String : ",10
msg2len equ $-msg2

msg3 db "Enter your choice",10
msg3len equ $-msg3

lenmsg db "Length of String : ",20h
lenmsglen equ $-lenmsg

revmsg db "Reverse string : ",20h
revmsglen equ $-revmsg

errmsg db "Please enter correct choice",10
errmsglen equ $-errmsg

palmsg db "String is Palindrome",10
palmsglen equ $-palmsg

npal db "String is not Palindrome",10
npallen equ $-npal
nline db "",10


section .bss
str1 resb 50
str1len resb 1
str1rev resb 50
choice resb 1
temp resb 1

section .text
global _start
_start:
menu:	fn 4,1,msg2,msg2len
	
	fn 3,0,str1,50
		
	fn 4,1,msg1,msg1len
	fn 4,1,msg3,msg3len
	
	fn 3,0,choice,1		;Read choice
	
	cmp byte[choice],31h
	je strlen
	cmp byte[choice],32h
	je strrev
	cmp byte[choice],33h
	je strpal
	fn 4,1,errmsg,errmsg
	jmp exit	
exit :
	mov eax,1
	mov ebx,0
	int 80h

strlen : 
	fn 4,1,lenmsg,lenmsglen

	call strlenfn
	fn 4,1,temp,1
	fn 4,1,nline,1
		
	jmp exit

strrev :
	call strrevfn
		
	fn 4,1,revmsg,revmsglen
	fn 4,1,str1rev,str1len
	fn 4,1,nline,1
		
	jmp exit

strpal :
	call strpalfn
	jmp exit 

strlenfn :
	push rax
	push rbx
	push rcx
	push rdx

	mov ecx,0
	mov esi,str1
up:	cmp byte[esi],0Ah
	je nxt
	inc cl
	inc esi
	jmp up

nxt :	mov byte[str1len],cl
	cmp cl,09
	jbe add30
	add cl,07
add30:	add cl,30h
	mov byte[temp],cl

	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

strrevfn :
	push rax
	push rbx
	push rcx
	push rdx
	
	mov ecx,0
	mov esi,str1
	mov edi,str1rev
	mov cl,byte[str1len]
	sub cl,1
	add esi,ecx
	add cl,1
loop1:	mov al,byte[esi]
	mov byte[edi],al
	inc edi
	dec esi
	dec cl
	jnz loop1
	
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

strpalfn :
	push rax
	push rbx
	push rcx
	push rdx

	call strlenfn
	mov cl,byte[str1len]
	call strrevfn
	mov esi,str1
	mov edi,str1rev
l1:	mov al,byte[esi]
	cmp al,byte[edi]
	jne l2
	inc esi
	inc edi
	dec cl
	jnz l1

	fn 4,1,palmsg,palmsglen
	jmp l3
l2:
	fn 4,1,npal,npallen
l3:	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

