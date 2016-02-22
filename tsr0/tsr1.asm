;divide by zero TSR
.MODEL TINY
.CODE
ORG 100H
BEGIN:
	JMP INIT		;Jump to the TSR loader modifying the TSR
	OLDINT DD 2
	

START:
	MOV AH,0AH		;Function to display character
	MOV AL,'*'		;To print *
	MOV BH,0
	MOV CX,05
	INT 10H
	
	JMP CS:OLDINT	;Move the original divide by zero int address
	
INIT:
	CLI			;Clear direction file
	MOV AH,35H	;Get interrupt address
	MOV AL,0	;Interrupt no
	INT 21H
	
	MOV WORD PTR OLDINT,BX		;Copy IP of original type 0
	MOV WORD PTR OLDINT+2,ES	;Copy CS
		
	MOV AH,25H			;Modify IVT
	MOV AL,0			;Int. type no 0
	MOV DX,OFFSET START	;Starting address of user ISR
	INT 21H
		
	MOV AH,31H			;Makes program resident in RAM
	MOV DX,OFFSET INIT	;Size of resident code
	INT 21H
	
	STI				;Set interrupt flag
	END BEGIN		;Exit
	
	
	