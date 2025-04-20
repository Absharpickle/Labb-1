;
; Labb1.asm
;
; Created: 2025-04-17 11:12:02
; Author : joeeb477
;


; Replace with your application code

;
; Labb1.asm
;
; Created: 2025-04-13 18:38:48
; Author : joeeb477
;


; Replace with your application code

;	r16 used for reading

	.equ	T = 10

	ldi		r16,HIGH(RAMEND)
	out		SPH,r16
	ldi		r16,LOW(RAMEND)
	out		SPL,r16
	ldi		r16,0b11111110
	out		DDRA,r16
	ldi		r16,0b10001111
	out		DDRB,r16
	clr		r16
SIFFRA_LOOP:
	call	SIFFRA
	jmp		SIFFRA_LOOP

	;;;;;;;;;;;;;;;;;;;;;;;;;;; DELAY(r16=length)
DELAY:
	push	r17
	sbi		PORTB,7
DELAY_OUTER_LOOP:
	ldi		r17,$1F
DELAY_INNER_LOOP:
	dec		r17
	brne	DELAY_INNER_LOOP
	dec		r16
	brne	DELAY_OUTER_LOOP
	cbi		PORTB,7
	pop		r17
	ret

	;;;;;;;;;;;;;;;;;;;;;;;;;; STARTBIT()
STARTBIT:
	call	READ_A0
	breq	STARTBIT	; om 0, läs igen
	ldi		r16,T/2		; checkbit
	call	DELAY
	in		r16,PINA
	andi	r16,$01
	breq	STARTBIT	; om 0, läs igen

STARTBIT_EXIT:
	ret

	;;;;;;;;;;;;;;;;;;;;;;;; READ
READ_A0:
	in		r16,PINA
	andi	r16,$01
	
READ_A0_EXIT:
	ret
	
	;;;;;;;;;;;;;;;;;;;; DATA
DATA:
	ldi		r17,4

DATA_LOOP:
	push	r16
	ldi		r16,T
	call	DELAY
	pop		r16
	sbic	PINA,0
	ori		r16,$10
	lsr		r16
	dec		r17
	brne	DATA_LOOP

DATA_EXIT:
	ret

	;;;;;;;;;;;;;;;;;;;; SKRIV UT

SKRIV_UT:
	andi	r16,$0F
	out		PORTB,r16
	ret

	;;;;;;;;;;;;;;;;;;;; SIFFRA

SIFFRA:
	call	STARTBIT
	call	DATA
	call	SKRIV_UT
	push	r16
	ldi		r16,T
	call	DELAY
	pop		r16

SIFFRA_EXIT:
	ret
