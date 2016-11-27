; Week 2, Test Program 1
; Andrew House, TA, ECE352
;
; This program is heavily populated with nops to aviod data hazards.
; It loads a value from memory, uses it to calculate some other values,
; then loops until one of those derived values is zero.  It then
; writes a result to memory, and reads it back to a different register.
;
; Final result should be:
; k0: 03   k1: 44    k2: 18    k3: 18
;
	ori	16	; value loaded into k1 ;01
	nop ;02
	nop	;03
	nop ;04
	nand	k2,k1	; makes k2 equal to 0xff 05
	nand	k3,k1	; makes k3 equal to 0xff 06
	shiftl	k1,2	; multiply k1 by 4 to get address 64 in k1 7
	nop ;08
	nop	;09
	nop	;0a
	load	k0,(k1)	; load value 252 from address 64 0b
	sub	k1,k1	; clear k1 0c
	nop ;0d
	nop	;0e

	nand	k2,k0	; should leave 0x03 in k2 0f
	nand	k3,k0	; should leave 0x03 in k3 10
	sub	k0,k0	; clear k0 11
	ori	1	; put 1 into k1 12
	nop ;13
	nop;14
	nop ;15

loop	add	k0,k1	; increment k0 ;16
	shiftl	k2,1	; multiply k2 by 2 ;17
	sub	k3,k1	; decrement k3 ;18
	bnz	loop	; loop until k3 = 0 ;19
	nop
	nop
	nop		; 28 instructions so far

	sub	k1,k1	; clear k1
	nop
	nop
	nop
	ori	17
	nop
	nop
	nop
	shiftl	k1,2	; multiply 17 by 4 to get address 68
	nop
	nop
	nop
	store	k2,(k1)	; write k2 to memory
	nop
	nop
	nop
	load	k3,(k1) ; read it to k3
	nop
	nop
	nop
	stop	; 49 instructions?
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	org	64
ldlbl	db	252
	org	68
stlbl	db	1
