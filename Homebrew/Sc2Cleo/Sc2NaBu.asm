; Loads and decompresses a image in 'Graphics Mode II'
; Version 0.3
; By Lars The 18Th
;

	output 0000001.nabu

	defpage 0,#140d
	page 0

	code

vdpio equ #A0		;VDP IO

					jr start
					db "              "
					db "Sc2Cleo for NaBu"
					db "v0.3 (c)2022    "
					db "By CINIC Systems"
					db "Code:           "
					db "Lars The 18Th   "
					db "Graphics:       "
					db "Dustin Ramsey   "


start:

					di
					ld b,setvdpdataend-setvdpdata
					ld c,vdpio+1
					ld hl,setvdpdata					;VDP data to write

setvdpregisters:
					outi
					jp nz,setvdpregisters				;Set all VDP Regiters
	

copytovram:
					ld de,imageend-imagebegin			;Length of Image
					ld hl,imagebegin					;Pointer to Image

nextpixels:
					dec de
					ld a,d								;Check if copying is done
					or e
					jr z,done

					ld a,(hl)							;Read first Pixel
					inc hl
					inc a								;Is it #FF ?
					jr z,multiple						;Yes #FF goto Multiple

single:
					dec a
					out (vdpio),a						;Write to VRAM
					jr nextpixels

multiple:
					ld a,(hl)
					inc hl
					ld b,(hl)
					inc hl
					dec de
					dec de

repeating:
					out (vdpio),a						;Write to VRAM
					nop
					djnz repeating
					jr nextpixels

;---------------------------------
done:
					xor a								;Set ram pointer to #1800
					out (vdpio+1),a						;Set Vram Pointer Low Part
					ld a,#18+64
					out (vdpio+1),a						;Set Vram Pointer Hi Part


					xor a
					ld de,#0300
fill:
					ld b,a
					out (vdpio),a
					ld a,d
					or e
					ld a,b
					jr z,keypressed
					inc a
					inc hl
					dec de
					jr fill
keypressed:
					ld a,#40							;Enable Screen
					out (vdpio+1),a
					ld a,#01+#80						;Set Register #1
					out (vdpio+1),a


					di
					halt
					jr z,keypressed


;---------------------------------
setvdpdata:
					db #02,#80,#20,#81,#06,#82,#ff,#83,#03,#84,#36,#85,#07,#86,#01,#87,#00,#8e,#00,#40
setvdpdataend:

imagebegin:
					incbin cleo3NulOUT.hex				;Compressed image
imageend:


end
