Code Segment
	assume CS:Code, DS:Data, SS:Stack
;10-20 közötti szám -> ezzel timer, utána bill -> reakció idő, majd a 3 idő átlaga.
Start:
	xor ax, ax
	mov di, 82h
	mov al, [di]
	
	cmp al, '1'
	jz Keres ;0-9-e a második
	
	cmp al, '2'
	jz Keres ;
	
	jmp Hiba
Keres:
	sub al, 48

	mov cl, 10
	mul cl ;ax-ben (alben) -> 10/20
	
	inc di
	mov bl, [di]

	sub bl, 48
	add al, bl
	
	mov dl, 10 ;10-től 10ig: 11db szám 10-től loopol 20ig..
	mov cx, 11
Keres_loop:
	cmp al, dl
	jz Helyes
	
	inc dl
	loop Keres_loop
	
	jmp Hiba
Helyes:
	push ax ;ax-ben a paraméter
	jmp Init
Hiba:
	xor ax, ax
	push ax
;--------------------------------------
Init:
	mov ax, Code
	mov ds, ax

	mov ax, 3
	int 10h
;--------------------------------------
	pop ax ;üres verem
	cmp ax, 0
	jz Hibas_help
	
	mov di, ax ;param. mentés
	mov si, ax ;hány secig fusson
	
	sub sp, 2
	call Timer_loop ;
	sub sp, 2
	
	mov si, di
	call Timer_loop
	sub sp, 2
	
	mov si, di
	call Timer_loop

	jmp Atlag
;-------------------------------------Timer loop-----------------------
Timer_loop:
	mov ah, 0
	int 1ah ;sys time
	mov bx, dx
	add bx, 18
Timer:
	mov ah, 0
	int 1ah ;sys time
	cmp bx, dx
	jl Sec
	
	jmp Timer
Sec:
	mov bx, dx
	add bx, 18
	
	dec si
	cmp si, 0
	jz Reakcio
	
	jmp Timer
Reakcio:
	mov ah, 0
	int 1ah ;sys time
	mov bx, dx
	
	mov dx, offset reakcstr
	mov ah, 9
	int 21h
Varakozik:
	xor ax, ax
	int 16h
	
	cmp al, ' '
	jnz Varakozik
	
	mov ah, 0
	int 1ah ;sys time
	mov cx, dx ;reakció idő tickben cx-ben
	
	sub cx, bx ;cx-ben a reakcióidő
	;veremteszt....... pipa :) ................:
	add sp, 4
	push cx
	sub sp, 2
	
	mov ax, cx ;teszt jó volt a kiírásra
	call Kiiras ;'012'
	ret
;-------------------------------------Timer loop-----------------------
Hibas_help:
	jmp Hibas
;---------------------------Átlag számolás-----------------
Atlag:
	pop bx
	mov ax, bx
	pop bx
	add ax, bx
	pop bx
	add ax, bx
	;mov ax, 693
	mov cl, 3
	div cl
	;al->kétjegyű szám pl 12 ah nem érdekes
	xor ah, ah
	
	call Kiiras
	jmp Program_Vege
;---------------------------Átlag számolás-----------------	
;-----------------------3 számjegyű szám kiírás-----------------	
Kiiras: ;012
	mov cl, 100
	div cl ;ax/cl = ax:dx ? al:ah?
	
	xor bx, bx
	mov bl, ah
	
	mov dl, al ;szazas
	add dl, 48
	mov ah, 2
	int 21h
	
	mov cl, 10
	mov ax, bx
	
	div cl
	mov bl, ah
	
	mov dl, al ;tizes
	add dl, 48
	mov ah, 2
	int 21h
	
	mov dl, bl ;egyes
	add dl, 48
	mov ah, 2
	int 21h	
	
	mov dl, 10 	;NL
	mov ah, 02h
	int 21h
	ret ;!!!
;-----------------------3 számjegyű szám kiírás-----------------
	jmp Program_Vege
Hibas:
	mov dx, offset hibastr
	mov ah, 9
	int 21h
;--------------------------------------
Program_Vege:
	mov ax, 4c00h
    int 21h

reakcstr db "Nyomd meg a space-t! Reakcio ido: $"
hibastr db "Rossz parameter LUL$"
	
Code Ends
Data Segment
Data Ends
Stack Segment
Stack Ends
	End Start

