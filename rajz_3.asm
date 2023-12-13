Code	Segment
	assume CS:Code, DS:Data, SS:Stack

Start:
	mov	ax, Code
	mov	DS, AX
	;kezdő pont:
	mov bx, 320 ; oszlop 
	mov dx, 240 ;sor
	push bx
	push dx
	
	mov ah, 00h
	mov al, 12h ;grafikus mode 640*480
	int 10h
	
Rajz:
	mov ah, 0ch ;pixel rajz
	mov al, 0dh ;szín
	;dx a sor, cx az oszlop szám
	pop dx ;sor ki
	pop cx ;oszlop ki
	push cx ;oszlop vissza
	push dx ;sor vissza
	
	mov bh, 0 ;page 0
	int 10h

Var:
	xor ah, ah
	int 16h
	
	cmp al, 27
	jz Program_Vege
	
	cmp ah, 75
	jz Balra
	
	cmp ah, 77
	jz Jobbra
	
	cmp ah, 72
	jz Felfele
	
	cmp ah, 80
	jz Lefele
	jmp Var

Balra:
	pop dx ;sor
	pop bx ;oszlop
	dec bx
	cmp bx, 1
	jnc Tarol
	inc bx
	jmp Tarol
Jobbra:
	pop dx
	pop bx
	inc bx
	cmp bx, 640
	jc Tarol
	dec bx
	jmp Tarol
Felfele:
	pop dx
	pop bx
	dec dx
	cmp dx, 1
	jnc Tarol
	inc dx
	jmp Tarol
Lefele:
	pop dx
	pop bx
	inc dx
	cmp dx, 480
	jc Tarol
	dec dx
	jmp Tarol
Tarol:
	push bx
	push dx
	
	jmp Rajz

Program_Vege:

	mov ax, 03h ;cls
    int 10h

	pop dx
	pop bx
	
	mov	ax, 4c00h
	int	21h

Code	Ends

Data	Segment
Data	Ends

Stack	Segment
Stack	Ends
	End	Start

