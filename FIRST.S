;Student: Lillian Ma
;Professor: Terrance Mok
;Class: COMP 2655-002
start:			; TO DO: fill in your code and inline doc. here
CR	equ	13	; constant CR = carriage return character
LF	equ	10	; constant LF = line feed character


input:	clr.w	d0	;clears garbage bits out of d0
	jsr	read_char	;read first char into d0
	move.w	d0,d1		;moves char ascii value into d1
	move.w	#CR,d0	;carriage return and line feed
	jsr	write_char
	move.w	#LF,d0
	jsr	write_char


	clr.l	d0
	jsr	read_char	;reads second char into d0
	move.l	d0,d2		;moves char ascii value into d2
	move.w	#CR,d0
	jsr	write_char
	move.w	#LF,d0
	jsr	write_char

	clr.l	d0
	jsr	read_char	;reads third char into d0
	move.l	d0,d3		;moves char ascii value into d3
	move.w	#CR,d0
	jsr	write_char
	move.w	#LF,d0
	jsr	write_char

math:	sub.w	#'0',d1	;converts ascii value to int for math
	sub.l	#'0',d2
	sub.l	#'0',d3

	mulu.w	#10,d1	;(a * 10) d1 is L now
	add.l	d2,d1	;(a * 10) + b
	mulu.w	#10,d1	;((a * 10) + b)
	add.l	d3,d1	;d1 = x = ((a * 10) + b)10 + c

	move.l	d1,d4	;d4 = x
	mulu.w	d1,d4	;d4 = x^2
	move.l	d4,d5	;d5 = x^2

	lsl.l	#8,d4	;d4 = 256x^2
	lsl.l	#5,d5	;d5 = 32x^2
	add.l	d5,d4	;d4 = 288x^2

	move.l	d1,d5	;d5 = x
	mulu.w	#3171,d5	;d5 = 3171x
	divu.w	#73,d5	;d5 = 3171x/73
	and.l	#$0000FFFF,d5	;clearing remainder out of top word of d5 for addition
	sub.l	d5,d4	;d4 = 288x^2 - 3171x/73
	add.l	#5286,d4	;d4 = 288x^2 - 3171x/73 + 5286


	divu.w	#10000,d4	;d4 = (288x^2 - (3171x/73) + 5287) / 10000 need to swap the word to get remainder
	swap	d4	;d4 = (288x^2 - (3171x/73) + 5287) % 10000
	and.l	#$0000FFFF,d4	;clearing out higher word to prep for division
	divu.w	#10,d4	;d4 = y = ((288x^2 - (3171x/73) + 5287) % 10000) / 10
	and.l	#$0000FFFF,d4	;clearing out higher word to get rid of remainder

output:	move.l	d4,d0	;copy to d0 for output
	divu.w	#100,d0	;isolating 100s digit
	and.l	#$0000FFFF,d0	
	add.l	#'0',d0
	jsr	write_char	;write hundreds digit

	move.l	d4,d0	;copy to d0 for output
	divu.w	#10,d0	;y / 10
	and.l	#$0000FFFF,d0
	divu.w	#10,d0	;(y / 10) / 10
	swap	d0	;(y / 10) % 10
	and.l	#$0000FFFF,d0	;clear upper word out for output
	add.l	#'0',d0
	jsr	write_char

	move.l	d4,d0	;copy to d0 for output
	divu.w	#10,d0	;
	swap	d0	;y % 10
	and.l	#$0000FFFF,d0	;clear upper word out for output
	add.l	#'0',d0
	jsr	write_char	
	
	move.l	#CR,d0	
	jsr	write_char
	move.l	#LF,d0
	jsr	write_char
	
	
		
	
		
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
