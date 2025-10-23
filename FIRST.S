;Student: Lillian Ma
;Professor: Terrance Mok
;Class: COMP 2655-002

start:			; TO DO: fill in your code and inline doc. here
CR	equ	13	; constant CR = carriage return character
LF	equ	10	; constant LF = line feed character


input:	and.b	#%00000000,d0	;clears garbage bits out the lowest byte of d0
	jsr	read_char	;read first char into d0
	move.b	d0,d1		;moves char ascii value into d1 lower byte


	and.b	#%00000000,d0	;clears garbage bits out the lowest byte of d0
	jsr	read_char	;reads second char into d0
	move.b	d0,d2		;moves char ascii value into d2 lower byte

	and.b	#%00000000,d0	;clears garbage bits out the lowest byte of d0
	jsr	read_char	;reads third char into d0
	move.b	d0,d3		;moves char ascii value into d3 lower byte
				;comment

xcalc:	sub.b	#'0',d1	;converts ascii value to int for math
	sub.b	#'0',d2
	sub.b	#'0',d3

	ext.w	d1	;extending d1 to a word
	and.w	#$00FF,d1	;clearing garbage bits out of upper byte of d1 word

	ext.w	d2
	and.w	#$00FF,d2

	ext.w	d3
	and.w	#$00FF,d3

	mulu.w	#10,d1	;(a * 10)
	add.w	d2,d1	;(a * 10) + b
	mulu.w	#10,d1	;((a * 10) + b)
	add.w	d3,d1	;((a * 10) + b) + c = x

math:	
	
		
	jsr	exit





;----- SUBROUTINE: read_char -----
;
; PURPOSE: waits for and reads a single keystroke from the keyboard.
;
; CALLER OUTPUT: returns the ASCII value of the key in the low byte
;                of D0.
;
; IMPORTANT: NOTE THAT THE HIGHER_ORDER BYTES OF D0 ARE UNDEFINED.
;            DON'T ASSUME THEY ARE ZEROED OUT!
;
; E.G. CALL:	jsr	read_char
;		... now use D0.b ...

read_char:	movem.l	d1-d2/a0-a2,-(sp)
		move.w	#1,-(sp)
		trap	#1
		addq.l	#2,sp	
		movem.l	(sp)+,d1-d2/a0-a2
		rts


;----- SUBROUTINE: write_char -----
;
; PURPOSE: writes a single character to the screen.
;
; CALLER INPUT: takes the ASCII value of the character in the low byte
;               of D0.
;
; E.G. CALL:	move.b	#'a',d0
;		jsr	write_char

write_char:	movem.l	d0-d2/a0-a2,-(sp)
		and.w	#$00FF,d0
		move.w	d0,-(sp)
		move.w	#2,-(sp)
		trap	#1
		addq.l	#4,sp
		movem.l	(sp)+,d0-d2/a0-a2
		rts


;----- SUBROUTINE: exit -----
;
; PURPOSE: terminates the program.  This routine never returns.

exit:		clr.w	-(sp)
		trap	#1
