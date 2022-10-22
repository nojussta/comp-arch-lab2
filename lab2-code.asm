;
; suskaiciuoti     /   (a+2b)/(a-x)    , kai a-x > 0 
;              y = |   a*a-3b            , kai a-x = b
;                  \   |c+x|          , kai a-x < 0
; skaiciai su zenklu
; Duomenys a - w, b - b, c - b, x - w, y - w  

; (a+2b)/(a-x)
f1:	MOV al, c
    CBW
	IMUL c	; dx:ax=c^2
	JO kl1  ; sandauga netilpo i ax 
	XCHG ax, dx
	MOV al, b
	CBW    
	ADD dx, ax	; c^2+b  
	JO kl1
	MOV bx, x[si]
	SUB bx, ax	; x-b
	JO kl1
	CMP bx, 0
	JE kl2	; dalyba is 0   
	MOV ax, dx
	CWD 
	IDIV bx	; ax=rez
	JMP re  

f1: MOV ax, 2
    IMUL b
    JO kl1
    ;2*b
    XCHG ax, dx
    MOV ax, a
    ADD dx, ax
    ;a+2*b
    JO kl1
    MOV bx, x[si]
    SUB ax, bx
    JO kl1
	CMP bx, 0
	JE kl2	; dalyba is 0   
	MOV ax, dx
	CWD 
	IDIV bx	; ax=rez
	JMP re 

; a*a-3b 
f2:	MOV ax, 7
	IMUL a
	JO kl1  ; sandauga netilpo i ax 
	SUB ax, x[si] ;7a-x
	JO kl1
	JMP re 

f2:	MOV ax, a
	IMUL a
	JO kl1
	;a*a
	MOV ax, dx
	MOV ax, 3
	IMUL b
	JO kl1
	;3*b
	SUB dx, ax
	;dx-ax
	JO kl1
	JMP re

; |c+x|
f3:	MOV ax, 2
	IMUL a
	JO kl1  ; sandauga netilpo i ax 
	MOV al, c
	CBW
	CMP bx, 0
	JG mod       ; jei c < 0 keicia zenkla
	NEG bx

f3:	MOV ax, c
	ADD x
	JG mod       ; jei c < 0 keicia zenkla
	NEG bx

;a-x
cikl:
	MOV al, b
	CBW   
	CMP x[si], ax
	JE f2
	JL f3

cikl:
	MOV al, a
	SUB al, x
	CMP x[si], ax
	JE f2
	JL f3