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
