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
	ori	16	; value loaded into k1
	nop
	nop	
	nop
	nop
	nop
	nand	k2,k1	; makes k2 equal to 0xff
	shiftl	k1,2	; multiply k1 by 4 to get address 64 in k1
	nop
	nop
	nop
	nop
	nop
	store	k2,(k1)	; write k2 to memory
	nop
	nop
	nop
	nop
	load	k3,(k1) ; read it to k3
	nop
	nop
	nop
	nop
	stop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
