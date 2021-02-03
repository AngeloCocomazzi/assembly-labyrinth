title labirintov4;

exit_gioco macro

	mov al,02
	mov ah,00h
	int 10h				;clear schermo


	stampa msg_orainizio	
	stampa ora_inizio
	
	
	stampa msg_orafine
	stampa ora_fine
	
	
	stampa msg_numero_mosse	
	stampa n_mosse

fine_m:
	mov ah,04ch
	int 21h
		
endm



; svuota_vett macro

	; push  ax bx cx dx di 
	
	; mov cx,8
	; mov di,0
	; lea bx,ora_fine
	
; svuota:	mov al,32
		; mov [bx+di],al
		; inc di
		; loop svuota
		
	; pop di dx cx bx ax

; endm



copia_vett macro  ;Sull’8086 solo i registri bx,si,di,bp permettono l’accesso indiretto[].

	push  ax bx cx dx di 
	
	mov cx,8
	mov di,0
	
	;lea dx,ora_fine
	
riempi:	push cx
		lea bx,ora_fine
		mov bx,[bx+di]
		
		mov cx,bx
		
		lea bx,ora_inizio
		mov [bx+di],cx
		
		inc di
		
		pop cx
		loop riempi
	inc prima_mossa	
	pop di dx cx bx ax

endm


dividi_s macro   ;divide in 2 cifre separate i valori sopra il 9 (es. 10 viene inserito nel vettore come 1 e 0)

	pop di
	pop cx
	pop bx

	lea bx,ora_fine
	mov ah,0
	mov al,cl
	;mov dl,0
	mov dh,10
	div dh				

	mov dl,al
	add dl,30h
	mov [bx+di],dl
	inc di

	mov dl,ah
	add dl,30h
	mov [bx+di],dl
	inc di

	push di

endm

verifica_car macro

mov dh,riga
mov dl,colonna
mov bh,02
mov ah,02
int 10h            ;verifica carattere
mov ah,08h
int 10h

endm

canc_car macro

push ax
		
	mov bh,02
	mov ah,02h
	int 10h
		
	mov al,' '
       
    mov cx,1     
    mov ah,09h
    int 10h

pop ax

endm


acapo macro

mov dl,0dh
mov ah,02
int 21h

endm

stampa macro msg

lea dx,msg
mov ah,09
int 21h

endm

set_video macro
        
	mov al,02 ;set page number
	mov ah,05h
	int 10h

	;mov al,02 ;set video mode
	;mov ah,00h
	;int 10h
	
	mov cx,2607h;set invisible cursor
	mov ah,01
	int 10h

endm


print_pedina macro
	;pop dx
		;mov bh,02  ;BH = Page Number
		mov ah,02h ;ah=02 Set cursor position
		int 10h

		mov bl,100b ; BL = Color,
		mov al,254d ;AL = Character


		mov cx,1 ;CX = Number of times to print character
		mov ah,09h
		int 10h
	;push dx
endm


riga_colonna macro ;stampa pedina ad una determinata riga/colonna

	mov dh,riga
	mov dl,colonna
	
	mov ah,02
	int 10h
	
	mov bh,02h
	mov bl,100b
	mov al,254d
	
	mov cx,1
	mov ah,09h
	int 10h
	
endm


scroll_down macro
	
	mov cx,24
	

scroll:
		push cx
			call delay
			mov al,1  ;AL indica il numero di righe su cui è effettuato lo scrolling dal basso verso l'alto all'interno della finestra; se AL=0 viene cancellata l'intera area, qualunque sia la sua dimensione.
			mov ch,0  ;CH, CL indicano le coordinate di riga, colonna del suo angolo in alto a sinistra
			mov cl,0  ;DH, DL indicano le coordinate di riga, colonna del suo angolo in basso a destra
			mov dl,80
			mov dh,24
			
			mov ah,06h
			int 10h

		pop cx
	loop scroll
endm



data segment

numero_maggiore DB "Il numero di mosse sono piu' di 999 $"

msg1  DB  "||||||||   ||BUILD BY ANGELO COCOMAZZI RELAESE V.4|LEVEL 1|||||||||||||        | $"
msg2  DB  "||||||||||   ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| $"
msg3  DB  "||||||||                                                                    |||| $"
msg4  DB  "|||||||| |||||||||  |||||||||||  |||||||||||||||||  |||||||||||||||||||||| ||||| $"
msg5  DB  "|||||||| |||||||||  |||||||||||  |||||||||||||||||  |||||||||||||||||||||| ||||| $"
msg6  DB  "||||     |||||||||   ||||||||||  ||||||||                             |||| ||||| $"
msg7  DB  "|||| || ||||||||||||                           ||| |||||||||  |||||||  ||| ||||| $"
msg8  DB  "||   | ||||||       ||||||||||| | |||||| ||||||||| ||||   ||  |||||    ||| ||||| $"
msg9  DB  "|| |  ||||||| ||||       |||||| |   ||||                | ||  |||  ||| ||| ||||| $"
msg10 DB  "|| || ||||||| ||||  ||||  ||||| ||| ||||||||||||||||||||| ||  ||| |||  ||| ||||| $"
msg11 DB  "|| || |||||||  |||   |||      |                               |||      ||| ||||| $"
msg12 DB  "||| || |||||| |||| | ||||| |||||||||||||||||||| ||||||||||||  |||||||| ||| ||||| $"
msg13 DB  "||  || |||||  |||| | ||||| |||| ||||||| ||||||| |||||||||     |||||||| ||| ||||| $"
msg14 DB  "|| ||| |||||   ||| ||  |||  |||              |  ||||||||  |||     |||   || ||||| $"
msg15 DB  "|| ||| |       |||               ||| ||||||| || ||||||||| ||||||  ||||  || ||||| $"
msg16 DB  "|| |||   | ||| |||||||||||| |||| |||  |||       |||||||| |||||||   |||  || ||||| $"
msg17 DB  "||   || || ||| |||||||      |||| |||| ||| |||||||||||||| ||||||||  ||||  | ||||| $"
msg18 DB  "|||| || || |   ||||||| ||||||||| |||  |   ||||      |||    |||||| |||||| | ||||| $"
msg19 DB  "|||| || ||   | |          |||||| ||| ||||      ||||     ||| ||||| |||||| |     | $"
msg20 DB  "|||| || ||||||   |||||||  |||||| |||  |||| ||| |    ||||||| |||||  ||||| ||||| | $"
msg21 DB  "|||||   |||||||||||||||||||||||| |||| |||| ||||| |||||||||| ||||||  |||||   || | $"
msg22 DB  "||||| |                          !       |   |                            ||!  | $"
msg23 DB  "|||||  |||||||||||||||||||||||||||||||||| |||||||||||||||||||||||||| |||     ||| $"
msg24 DB  "|||||| |||||||||||||||||||||||||||||||||  |||||||||||||||||||||||||||   |||||    $"



msg26 DB  "||||||  ||||||||BUILD BY ANGELO COCOMAZZI RELAESE V.4||LEVEL 2 ||||||||        | $"
msg27 DB  "|||||||         |||||||||||||||||||||||||||||||||||||||||||||||    ||||||||||||| $"
msg28 DB  "||||||||  ||| | |                                               ||   ||||||||||| $"
msg29 DB  "|||||||| ||||||     |||||||||||  |||||||||||||||||  ||||||||||||||||    |||||||| $"
msg30 DB  "|||||||| ||||||||||     |||||||  |||||||||||||||||!!||||||||||||||||||| |||||||| $"
msg31 DB  "|||||||  |||||||||  ||| |||||||| ||||||||                             |  ||||||| $"
msg32 DB  "||||||| ||||||||||||                           ||||||||||| |  |||||||  |     ||| $"
msg33 DB  "|||||| ||||||       ||||||||||| |||||||||||||||||||    ||| |  |||||    |||||  || $"
msg34 DB  "||||| ||||||| ||||       ||||||                     || ||| |  |||    |||||||| || $"
msg35 DB  "||||| ||||||| ||||  ||||  ||||| |||||||||||||||||||||| ||| |  ||| |||  ||     || $"
msg36 DB  "|||||| ||||||  ||||  |||      |                            |  |||      || |||||| $"
msg37 DB  "|||||| |||||| |||||| ||||| |||| ||||||||||||||| ||||||||||||  ||||| || || |||||| $"
msg38 DB  "|||||| |||||  |||||| ||||| |||| ||||||| ||||||| |   |||||     ||||| || || |||||| $"
msg39 DB  "|||||| |||||   |||||   |||  ||||            |   | | ||||  |||     |     | |||||| $"
msg40 DB  "|||||| |   |   |||||||           ||| ||||||| || | | ||||| ||||||  ||||  | |||||| $"
msg41 DB  "||||||   | ||| |||||||||||| |||| |||  |||      |  | |||| |||||||   |||  | |||||| $"
msg42 DB  "||||||| || ||| |||||||      |||| |||| ||| |||||| || |||| ||||||||  ||||   |||||| $"
msg43 DB  "||||||| || |   ||||||| ||||||||| |||  |   |||    || |||    |||||| ||  || ||||||| $"
msg44 DB  "||||||| ||   | |          |||||| ||| |||||||  |||||     ||| ||||| ||  || ||||||| $"
msg45 DB  "||||||| ||||||   |||||||  |||||| |||  |||||| ||||   ||||||| |||||  |||||  |||||| $"
msg46 DB  "|||||   |||||||||||||||||||||||| |||| |||||| ||| |||||||||| ||||||| |||||   |||| $"
msg47 DB  "||||| |                          |                                        |||||| $"
msg48 DB  "|||||  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| |||  |||||| $"
msg49 DB  "||||||  |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||   |||||    $"

ora_inizio DB  "        $";DUP(?)
ora_fine DB "        $"
n_mosse DB "   $"

msg_orainizio  DB  "Ora di inizio : $"
msg_orafine    DB  " Ora di fine : $"
msg_numero_mosse DB " Numero di mosse : $"


centinaia DB 0
decine DB 0
unita DB 0

ora DB 0
minuti DB 0
secondi DB 0

tasto DB 0

riga DB 0
colonna DB 9

uscita DB 0

prima_mossa DW 0

data ends

code segment

assume CS:code, DS:data

inizio: mov ax,data
        mov ds,ax
labi1:		
	set_video
		
	stampa msg1

	acapo
	stampa msg2

	acapo
	stampa msg3

	acapo
	stampa msg4

	acapo
	stampa msg5

	acapo
	stampa msg6

	acapo
	stampa msg7

	acapo
	stampa msg8

	acapo
	stampa msg9

	acapo
	stampa msg10

	acapo
	stampa msg11

	acapo
	stampa msg12

	acapo
	stampa msg13

	acapo
	stampa msg14

	acapo
	stampa msg15

	acapo
	stampa msg16

	acapo
	stampa msg17

	acapo
	stampa msg18

	acapo
	stampa msg19

	acapo
	stampa msg20

	acapo
	stampa msg21

	acapo
	stampa msg22

	acapo
	stampa msg23

	acapo
    stampa msg24
	
	call numero_mosse

	
	jmp ciclo

	
labi2:
	inc uscita
	
	scroll_down
	
	 mov al,02 ;set video mode
	 mov ah,00h
	 int 10h
	
	call delay
	
	set_video
		
	stampa msg26

	acapo
	stampa msg27

	acapo
	stampa msg28

	acapo
	stampa msg29

	acapo
	stampa msg30

	acapo
	stampa msg31

	acapo
	stampa msg32

	acapo
	stampa msg33

	acapo
	stampa msg34

	acapo
	stampa msg35

	acapo
	stampa msg36

	acapo
	stampa msg37

	acapo
	stampa msg38

	acapo
	stampa msg39

	acapo
	stampa msg40

	acapo
	stampa msg41

	acapo
	stampa msg42

	acapo
	stampa msg43

	acapo
	stampa msg44

	acapo
	stampa msg45

	acapo
	stampa msg46
	
	acapo
	stampa msg47

	acapo
	stampa msg48

	acapo
    stampa msg49
	;push dx
	;push dx
	call numero_mosse
	
	jmp ciclo


jmp_labi2: jmp labi2	

	
	mov cx,1000h;numero di mosse massime 
	
ciclo:
		push cx
		;mov tasto,0
		
	waiting:	
		;mov ah,0	
		mov AL,55H  ; ZF is still zero
		sub AL,55H  ; result is 0
				    ; ZF is set (ZF = 1)
		
		mov ah,01   ;check for keystroke in the keyboard buffer.
					;ZF = 1 if keystroke is not available.
					;ZF = 0 if keystroke available.
					;AH = BIOS scan code.
					;AL = ASCII character.
					;(if a keystroke is present, it is not removed from the keyboard buffer).
		int 16h
	
		jnz pressione
		
		call chiamata_ora
				
		call delay
		
	jmp waiting
		
pressione :	cmp al,0
			je waiting
			
			cmp al,3			;controllo se viene premuto ctrl+c
			je jmp_fine
			
			cmp prima_mossa,0
			je prima_mossa_orario

			cmp al,119
			je sopra1

			cmp al,97
			je sinistra1

			cmp al,100
			je  destra1

			cmp al,115
			je sotto1
			
			;call delay
			
			call clearkeyboardbuffer
			
			jmp waiting

jmp_help: loop ciclo
jmp_fine: jmp fine			


			sopra1: 	
					push ax bx cx dx
					call sopra
					pop dx cx bx ax
					jmp pressione_c

			sotto1 : 
					push ax bx cx dx
					call sotto
					pop dx cx bx ax
					
					cmp uscita,1
					je jmp_labi2
					
					cmp uscita,3
					je risultati_finali
					
					jmp pressione_c

			destra1 : 
					push ax bx cx dx
					call destra
					pop dx cx bx ax
					jmp pressione_c

			sinistra1 :
					push ax bx cx dx
					call sinistra
					pop dx cx bx ax
					jmp pressione_c
	
			prima_mossa_orario:
				
					copia_vett
				
					jmp pressione
					
			risultati_finali :
					exit_gioco
	
	pressione_c:
			call clearkeyboardbuffer

	continua:pop cx
		
jmp jmp_help

fine:
	;exit_gioco	
	
	mov ah,04ch
	int 21h

sopra proc

	mov dh,riga
	mov dl,colonna
	
	push dx

	dec riga
	verifica_car

	pop dx

	cmp riga,0
	jbe incre_riga

	cmp al,124
	jae incre_riga

    canc_car
	
	inc prima_mossa
	call numero_mosse
	
	jmp fine_psop
	
incre_riga: inc riga
			
		mov dh,riga
        mov dl,colonna
		
		print_pedina
		

fine_psop:
	
	ret
endp



sotto proc
	;push ax bx cx dx
	mov dh,riga
	mov dl,colonna
	
	push dx

	inc riga
	verifica_car

	pop dx

	cmp al,124
	je decre_riga

	cmp riga,24
	jae fine_gioco

    canc_car
	
	inc prima_mossa
	call numero_mosse
	
	jmp fine_pst

decre_riga: 
		dec riga

		mov dh,riga
        mov dl,colonna
		
		print_pedina
		
		jmp fine_pst

			
fine_gioco:
			mov riga,0
			mov colonna,6		

			inc uscita
			
			jmp fine_pst

fine_pst:	
	;pop dx cx bx ax
	ret
endp




destra proc
		;push ax bx cx dx

		mov dh,riga
		mov dl,colonna
		
		push dx
		
		inc colonna
        verifica_car
	
		pop dx

		cmp al,124
		je decre_col
		
		canc_car
		
		inc prima_mossa
		call numero_mosse

		jmp fine_pdx
		
decre_col:
		dec colonna
		mov dh,riga
        mov dl,colonna
		
		print_pedina

fine_pdx:
	;pop dx cx bx ax
	ret
endp




sinistra proc
	;push ax bx cx dx

	mov dh,riga
	mov dl,colonna
	
	push dx

	dec colonna
	verifica_car
	
	pop dx

	cmp al,124
	je incre_col
	
	canc_car
	
	call numero_mosse
	inc prima_mossa

	jmp fine_psx
	
incre_col:
		inc colonna  
		mov dh,riga
        mov dl,colonna
		
		print_pedina
		
fine_psx:
	;pop dx cx bx ax 
	ret
endp


clearkeyboardbuffer proc
	push		ax
	push		es
	mov		ax, 0000h
	mov		es, ax
	mov		es:[041ah], 041eh
	mov		es:[041ch], 041eh				; Clears keyboard buffer
	pop		es
	pop		ax
	ret
clearkeyboardbuffer		endp



ora_t proc        ;procedura per trasformare l'orario in una stringa 
	
	push ax bx cx dx
	
	mov di,0
	mov ch,0
	mov cl,ora

	cmp ora,9
	ja funzione

	lea bx,ora_fine

	mov dl,30h
	mov [bx+di],dl
	inc di

	mov dl,ora
	add dl,30h
	mov [bx+di],dl
	inc di
minuti_set:
	;mov dl,ora
	;lea cx,msg1
	mov cl,58
	mov [bx+di],cl
	inc di
	
	mov ch,0
	mov cl,minuti

	cmp minuti,9
	ja funzione

	mov dl,30h
	mov [bx+di],dl
	inc di

	mov dl,minuti
	add dl,30h
	mov [bx+di],dl
	inc di

secondi_set:
	;lea cx,msg1
	mov cl,58
	mov [bx+di],cl
	inc di
	mov ch,0
	mov cl,secondi

	cmp secondi,9
	ja funzione

	mov dl,30h
	mov [bx+di],dl
	inc di

	mov dl,secondi
	add dl,30h
	mov [bx+di],dl
	inc di

	jmp fine_proc

funzione:
	push bx
	push cx
	push di

	dividi_s

	pop di

	cmp di,2
	je minuti_set

	cmp di,5
	je secondi_set

fine_proc:
		pop dx cx bx ax

		;mov ora,0
		;mov minuti,0
		;mov secondi,0

ret
ora_t endp



get_ora proc
	
	push ax bx cx dx
	
	mov ah,2Ch
	int 21h ;get system time;CH = ora (0-23)CL = minuti (0-59) DH = secondi (0-59) DL = 1/100 di secondo (0-99)

	mov ora,ch

	mov minuti,cl

	mov secondi,dh
	
	call ora_t     ;IMPORTA L'ORARIO E LO SETTA CORRETTAMENTE NELLA STRINGA ora_fine
	
	pop dx cx bx ax


ret
get_ora endp


chiamata_ora proc ; procedura per stampare l'orario in altro a destra dello schermo
	
	;mov dl,riga
	;mov dh,colonna
	
	call get_ora   ;SETTA LE VARIABILI ORA,MINUTI, SECONDI e imposta l'orario nella stringa
		;cmp ora,9

	push ax bx cx dx 
	
	
	mov al,02 			;page number
	mov ah,05h
	int 10h
			
	mov dh,0			;posizione puntatore
	mov dl,71			;in alto a destra
	
	mov bh,02			;set puntatore
	mov ah,02h
	int 10h
	
			
	lea dx,ora_fine   ;stampa stringa
	mov ah,9
	int 21h
	
	
	riga_colonna ; riposiziona il cursore dove aveva lasciato
	
	pop dx cx bx ax

ret
chiamata_ora endp


numero_mosse proc

	
	call dividi_mosse
	
	push ax bx cx dx 
	
	
	mov al,02 			;page number
	mov ah,05h
	int 10h
			
	mov dh,23			;posizione puntatore
	mov dl,77			;in alto a destra
	
	mov bh,02			;set puntatore
	mov ah,02h
	int 10h
	
			
	lea dx,n_mosse   ;stampa stringa
	mov ah,9
	int 21h
	
	
	riga_colonna ; riposiziona il cursore dove aveva lasciato
	
	pop dx cx bx ax



ret 
endp


dividi_mosse proc
	
	push ax bx cx dx di bp 
	
	mov di,0
	
	cmp prima_mossa,9
	ja maggiore_di_9
	
	lea bx,n_mosse
	
	mov al,30h
	mov[bx+di],al
	inc di
	mov[bx+di],al
	inc di
	mov ax,prima_mossa
	add al,30h
	mov[bx+di],al

	jmp fine_macro
	
	
maggiore_di_9:
	mov ah,0
	mov ax,prima_mossa
	mov dh,0
	mov dl,10
	div dl
	mov decine,al
	mov unita,ah
	
	cmp decine,9
	ja maggiore_di_99
	
	lea bx,n_mosse
	
	mov al,30h
	mov[bx+di],al
	inc di
	
	mov al,decine
	add al,30h
	mov[bx+di],al
	inc di
	
	mov al,unita
	add al,30h
	mov[bx+di],al

	
	jmp fine_macro
	
maggiore_di_99:
	
	;mov bl,decine
	
	;mov secondi,bl
	mov ah,0
	mov al,decine
	mov dh,0
	mov dl,10
	div dl 

	mov centinaia,al
	mov decine,ah
	
	cmp centinaia,9
	ja maggiore_di_999
	
	lea bx,n_mosse
	
	mov al,centinaia
	add al,30h
	mov[bx+di],al
	inc di
	
	mov al,decine
	add al,30h
	mov[bx+di],al
	inc di
	
	mov al,unita
	add al,30h
	mov[bx+di],al
	inc di
	
	jmp fine_macro


maggiore_di_999:

	lea bx,n_mosse
	
	mov al,39h
	mov[bx+di],al
	inc di
	mov[bx+di],al
	inc di
	mov[bx+di],al
	inc di
	;stampa fisso 999

fine_macro:
pop bp di dx cx bx ax
ret
endp



delay proc  ;procedura per il delay migliorabile
	push cx
	mov cx,2000h
	ciclo11: 
			push cx
			mov cx,7h
		ciclo21:
			nop ;250 nano secondi di delay
			loop ciclo21
		pop cx
	loop ciclo11
	pop cx
ret
delay endp

code ends
end inizio