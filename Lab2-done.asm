;
; suskaiciuoti     /   (a+2b)/(a-x)    , kai a-x > 0 
;              y = |   a*a-3b            , kai a-x = 0
;                  \   |c+x|          , kai a-x < 0
; skaiciai su zenklu
; Duomenys a - w, b - b, c - b, x - w, y - w  

stekas  SEGMENT STACK
	DB 256 DUP(0)
stekas  ENDS

duom    SEGMENT 
a	DW  4  ;   10000; perpildymo situacijai 
b	DB 3
c	DB 8
x	DW -1,-2,-4,12,9,45,6
kiek	= ($-x)/2
y	DW kiek dup(0AAh)     
isvb	DB 'x=',6 dup (?), ' y=',6 dup (?), 0Dh, 0Ah, '$'
perp	DB 'Perpildymas', 0Dh, 0Ah, '$'
daln	DB 'Dalyba is nulio', 0Dh, 0Ah, '$'
netb	DB 'Netelpa i baita', 0Dh, 0Ah, '$'
spausk  DB 'Skaiciavimas baigtas, spausk bet kuri klavisa,', 0Dh, 0Ah, '$' 
duom    ENDS

prog    SEGMENT
	assume ss:stekas, ds:duom, cs:prog
pr:	MOV ax, duom
	MOV ds, ax
	XOR si, si      ; (suma mod 2) si = 0
	XOR di, di      ; di = 0
c_pr:   MOV cx, kiek
        JCXZ pab
cikl:
	MOV ax, a
	SUB ax, x[si]
	CMP ax, 0
	JE f2
	JL f3 
f1: MOV ax, 2
    IMUL b
    JO kl1
    ;2*b
    ADD ax, a
        ;XCHG ax, dx
        ;MOV ax, a
        ;ADD dx, ax
    ;a+2*b
    JO kl1
    PUSH ax
    MOV ax, a
    SUB ax, x[si]
    JO kl1
	CMP ax, 0
	JE kl2	; dalyba is 0
	XCHG ax, bx
	POP ax   
	;MOV ax, dx
	CWD 
	IDIV bx	; ax=rez
	JMP re  	
f2:	MOV ax, a
	IMUL a
	JO kl1
	XCHG ax, bx
	;a*a
	MOV ax, 3
	IMUL b
	JO kl1
	;3*b
	SUB bx, ax
	;bx-ax
	JO kl1
	JMP re   
f3:	MOV al, c
	CBW
	CMP bx, 0
	JG mod       ; jei c < 0 keicia zenkla
	NEG bx
mod: ADD ax, x[si]
	JO kl1
re:	
	CMP al, 0
	JGE teigr 
	CMP ah, 0FFh  ; jei neig. rezultatas
	JE  ger
	JMP kl3
teigr:  CMP ah, 0     ;jei teig. rezultatas
        JE ger	
	JMP kl3
ger:	
    MOV y[di], ax
	INC si
	INC si
	INC di
	INC di
	LOOP cikl
pab:	    
;rezultatu isvedimas i ekrana	            
;============================
	XOR si, si
	XOR di, di 
        MOV cx, kiek
        JCXZ is_pab
is_cikl:
	MOV ax, x[si]  ; isvedamas skaicius x yra ax reg. 
	PUSH ax
	MOV bx, offset isvb+2  
	PUSH bx
	CALL binasc
	MOV ax, y[di]
	CBW		; isvedamas skaicius y yra ax reg. 
	PUSH ax
	MOV bx, offset isvb+11 
	PUSH bx
	CALL binasc
	  
	MOV dx, offset isvb
	MOV ah, 9h
	INT 21h 
;============================
	INC si     
	INC si
	INC di
	INC di
	LOOP is_cikl
is_pab:	
;===== PAUZE ===================  
;===== paspausti bet kuri klavisa ===
	LEA dx, spausk
	MOV ah, 9
	INT 21h
	MOV ah, 0 
        INT 16h 
;============================        
        MOV ah, 4Ch   ; programos pabaiga, grizti i OS
	INT 21h
;============================	
	
kl1:	LEA dx, perp
	MOV ah, 9
	INT 21h
	XOR al, al
	JMP ger
kl2:	LEA dx, daln
	MOV ah, 9
	INT 21h
	XOR al, al
	JMP ger
kl3:	LEA dx, netb
	MOV ah, 9
	INT 21h
	XOR al, al
	JMP ger

; skaiciu vercia i desimtaine sist. ir issaugo
; ASCII kode. Parametrai perduodami per steka
; Pirmasis parametras ([bp+6])- verciamas skaicius
; Antrasis parametras ([bp+4])- vieta rezultatui

binasc	PROC NEAR   
	PUSH bp
	MOV bp, sp
; naudojamu registru issaugojimas
	PUSHA  
; rezultato eilute uzpildome tarpais
	MOV cx, 6   
	MOV bx, [bp+4]
tarp:	MOV byte ptr[bx], ' '
	INC bx
	LOOP tarp
; skaicius paruosiamas dalybai is 10   
	MOV ax, [bp+6]
	MOV si, 10
	CMP ax, 0
	JGE val
; verciamas skaicius yra neigiamas
	NEG ax
val:	XOR dx, dx
	DIV si
;  gauta liekana verciame i ASCII koda
	ADD dx, '0'   ; galima--> ADD dx, 30h
;  irasome skaitmeni i eilutes pabaiga
	DEC bx
	MOV [bx], dl
; skaiciuojame pervestu simboliu kieki
	INC cx
; ar dar reikia kartoti dalyba?
	CMP ax, 0
	JNZ val
; gautas rezultatas. Uzrasome zenkla
;	pop ax  
	MOV ax, [bp+6]
	CMP ax,0
	JNS teig
; buvo neigiamas skaicius, uzrasome -
	DEC bx
	MOV byte ptr[bx], '-'
	INC cx
	JMP vepab
; buvo teigiamas skaicius, uzrasau +
teig:	DEC bx
	MOV byte ptr[bx], '+'
	INC cx
vepab: 	
	POPA  
	POP bp
	RET
binasc	ENDP    
prog    ENDS 
        END pr
