;TSR for screensaver

PUSHREG MACRO		;macro for push to stack
PUSH AX
PUSH BX
PUSH CX
PUSH DX
ENDM

POPREG MACRO		;macro for pop
POP DX
POP CX
POP BX
POP AX
ENDM

.MODEL TINY
.CODE
ORG 100H

BEGIN:
        	JMP INIT
                KEYB DD 1
                TIMR DD 1
		CNT DB 1
		SAVE DW 1
		MSG DB "SCREENSAVER"
		MSGLEN EQU $-MSG
		
SSCREEN:
                PUSHREG         ;push
                MOV AH,05H      ;request active
                MOV AL,0        ;as page no 0
                INT 10H        
                MOV CS:CNT,0  ;reset counter to 0
                POPREG          ;pop
			JMP CS:KEYB
STIMER:
                PUSHREG      	    ;push
                INC CS:CNT			;increment count
                CMP CS:CNT,91H		;Check thime
                JA NEXT          	;if above jump to NEXT
                POPREG           	;pop
			JMP CS:TIMR
NEXT:	
                MOV AH,05H        ;request page active
                MOV AL,1          ;
			INT 10H
	
                MOV AH,13H      ;function to display
                MOV AL,01       
                MOV BH,1        ;page no 1
                MOV BL,07H      
                MOV CS:SAVE,CS  ;move content of CS to mem CS
                MOV ES,CS:SAVE  ;move content of CS to ES
                LEA BP,MSG      ;load effective address
                MOV CX,MSGLEN   
                MOV DH,12       ;row no
                MOV DL,35       ;column no
                INT 10H
                POPREG
		JMP CS:TIMR
INIT:
                CLI              ;clear interrupt flag
                
                MOV AH,35H       ;get interrupt address address
                MOV AL,9H        ;for INT no 9
        		INT 21H
        
	   	MOV WORD PTR KEYB,BX		;save address
	   	MOV WORD PTR KEYB+2,ES


                MOV AH,35H       ;get interrupt addrerss
                MOV AL,8H		;for INT NO 8
				INT 21H
		
		MOV WORD PTR TIMR,BX		;save address
		MOV WORD PTR TIMR+2,ES
		
                MOV AH,25H       ;change IVT
                MOV AL,9H        ;for INT no 9
                MOV DX,OFFSET SSCREEN  ;addresss
				INT 21H
	
				MOV AH,25H				;change IVT
				MOV AL,8H				;for INT no 8
				MOV DX,OFFSET STIMER		;address
				INT 21H
			
				MOV AH,31H			;make resident in ram
				MOV DX,OFFSET INIT	;
				INT 21H

				STI 
		
		END BEGIN 
