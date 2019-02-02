;define section
define
	LEDs 00

; data section
data 0	; base address
	; name length <value>
	initA	1	0 
	incr 	1	2
	outval 	1 

;code section
code
; label opcode	address

	load	initA	; zero outval
	store	outval
init:	load 	initA
loop:	add 	incr
	jneg 	skip
	jump 	loop
skip:	load 	outval
	add 	incr
	out 	LEDs
	store 	outval
	jump 	init

