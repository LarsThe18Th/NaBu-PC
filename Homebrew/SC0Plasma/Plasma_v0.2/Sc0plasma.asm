; Sc0Plasma v0.2
; Plasma Effect with ASCII in TXT Mode 0
; Ported to the NaBu-PC by Lars The 18Th
;
; Original idea and code example by
; nick: goblinish (Krapivin Dmitry)


	output 000001.nabu

	defpage 0,#140d
	page 0

	code
	
sinpl	equ #7F00			; Sinus Destination in RAM
charpl	equ sinpl+256		; Plasma Destination in RAM
vdpram	equ #A0				; VDP RAM
vdpio	equ #A1				; VDP IO


					nop
					nop
					nop
					di

; Set color 15,1
					ld a,#f1							; TXT color 15, Back color 1
					out (vdpio),a
					
					ld a,#87
					out (vdpio),a


; Put all 5 Chars in VRAM

					ld b,5
					ld c,vdpio
					ld hl,charset
add_chars:
					push bc
					outi								; Set adress Low byte
					outi								; Set adress High byte

						ld b,8
						ld c,vdpram
setvdpregisters:
						outi
						jp nz,setvdpregisters			; Write to VRAM

					pop bc
					djnz add_chars

					
;copy chars to RAM
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

;draw plasma
plas_lp:
					;keep params
					push de
					push bc
					exx
					ld hl,pltxt
					push hl
					exx

					db #DD						; #DD, 2E -> Undocumented instruction !
					ld l,24						; ld ixl,n

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

					db #dd						; #DD,#2D -> Undocumented instruction !
					dec l						; dec ixl 
					jp nz,ply

;copy to screen
					pop hl ; ld hl,pltxt
					xor a
					out (vdpio),a
					
					or #48
					out (vdpio),a
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

charset:
char_star:
; Recreate the '*' charakter
					db #50,#01+64						;VRAM adress 0150
					db %00100000
					db %10101000
					db %01110000
					db %00100000
					db %01110000
					db %10101000
					db %00100000
					db %00000000

char_dot
; Recreate the '.' charakter
					db #70,#01+64						;VRAM adress 0170
					db %00000000
					db %00000000
					db %00000000
					db %00000000
					db %00000000
					db %01100000
					db %01100000
					db %00000000

char_zero:
; Recreate the 'O' charakter
					db #80,#01+64						;VRAM adress 0180
					db %01110000
					db %10001000
					db %10011000
					db %10101000
					db %11001000
					db %10001000
					db %01110000
					db %00000000
					
char_o_up:
; Recreate the 'O' charakter
					db #78,#02+64						;VRAM adress 0278
					db %01110000
					db %10001000
					db %10001000
					db %10001000
					db %10001000
					db %10001000
					db %01110000
					db %00000000
					
char_o_low:
; Recreate the 'o' charakter
					db #78,#03+64						;VRAM adress 0378
					db %00000000
					db %00000000
					db %01110000
					db %10001000
					db %10001000
					db %10001000
					db %01110000
					db %00000000











