; Sc0Plasma v0.1
; Plasma Effect with ASCII in TXT Mode 0
; Ported to the NaBu-PC by Lars The 18Th
;
; Original idea and code example by
; nick: goblinish (Krapivin Dmitry)


	output 000001.nabu

	defpage 0,#140d
	page 0

	code
	
sinpl equ #7F00
charpl equ sinpl+256
vdpio equ #A0		;VDP IO


					nop
					nop
					nop
					di

; Set color 15,1
					ld a,#f1							; TXT color 15, Back color 1
					out (vdpio+1),a
					
					ld a,#87
					out (vdpio+1),a


; Put 'o' Char in VRAM
					ld a,#78							; Set adress 0378
					out (vdpio+1),a
					
					ld a,#03+64
					out (vdpio+1),a

					ld b,8
					ld c,vdpio
					ld hl,charo
setvdpregisters:
					outi
					jp nz,setvdpregisters				; Write to VRAM

					
; copy chars to place
					ld de,charpl
copch1:
					ld hl,plchar
copch2:
					ld a,(hl)
					inc hl
					or a
					jr z,copch1
					ld (de),a
					inc e
					jr nz,copch2


				;generate sinus
					ld bc,sinpl
					ld h,c
					ld l,c
					ld e,c
					ld d,c
genlp:
					add hl,de
					ld a,h
					ld (bc),a
					push bc

					ld a,b
					sub c
					ld c,a

					ld a,b
					sub h
					ld (bc),a
					pop bc

					ld a,e
					add a,8
					ld e,a
					jr nc,noincd
					inc d
noincd:
					inc c
					bit 6,c
					jr z,genlp

					ld d,b
					ld e,#80
					ld c,b
neglp:
					ld a,(bc)
					sra a
					ld (bc),a
					ld (de),a
					inc e
					dec c
					jr nz,neglp

				;;;;;;;;;;;;;;;;;;;;;;;;;;draw plasma
plas_lp:
					; No need for slowdown
					;ei		
					;halt
					;di

				;keep params
					push de
					push bc
					exx
					ld hl,pltxt
					push hl
					exx

					db #DD
					ld l,24

ply:
					ld a,40

					push de

plx:
					ex af,af'
					ld h,sinpl/256
					ld l,e
					ld a,(hl)
					ld l,d
					add a,(hl)
					ld l,c
					add a,(hl)
					ld l,b
					add a,(hl)

					ld l,a
					inc h
					ld a,(hl)

					exx
					ld (hl),a
					inc hl
					exx

					inc d	
					inc e
					inc e
					inc e

					ex af,af'
					dec a
					jp nz,plx

					pop de

					inc e
					inc e
					dec d
					dec d
					dec d

					ld a,b
					add a,1
					ld b,a

					ld a,c
					add a,3
					ld c,a

					db #dd
					dec l
					jp nz,ply

				;copy to screen
					pop hl ; ld hl,pltxt
					xor a
					out (vdpio+1),a
					
					or #48
					out (vdpio+1),a
					ld a,4
olp:
					ld bc,#a0
					otir
					dec a
					jr nz,olp

					pop bc
					inc c
					inc b
					inc b
					pop de

					inc e
					inc d
					inc d

					jp plas_lp

					ret

plchar:
	db "..oo**OO00OO**oo.." ; .o*O0O*o. 
	db 0
pltxt:

charo:
; Recreate the 'o' charakter
					db %00000000
					db %00000000
					db %01110000
					db %10001000
					db %10001000
					db %10001000
					db %01110000
					db %00000000
