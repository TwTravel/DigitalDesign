;define section
define
	AudioOut 0
	AudioIn  0

; data section
data 128; base address
	; name length <value>
; Filter: cutoff=0.100000 
; Filter: cutoff=0.200000 
; data section 
	scale	1	2 
	sum 	1 	0 
	b1 	1 	149 
	b2 	1 	0 
	b3 	1 	3FD6E 
	b4 	1 	0 
	b5 	1 	149 
	a2 	1 	CD98 
	a3 	1 	2F54E 
	a4 	1 	A42E 
	a5 	1 	3D6F5 
	x2 	1 	0 
	x3 	1 	0 
	x4 	1 	0 
	x5 	1 	0 
	y2 	1 	0 
	y3 	1 	0 
	y4 	1 	0 
	y5 	1 	0 
; end data section 

;code section
code

;wait for new sample then do MACs
reset:	in 	AudioIn ;get sample and form x1*b1
	mult	b1
	store	sum
	load	x2	;form x1*b1 + sum
	mult	b2
	add	sum
	store	sum
	load	x3	;form x3*b3 + sum
	mult	b3
	add	sum
	store	sum
	load	x4	;form x4*b4 + sum
	mult	b4
	add	sum
	store	sum
	load	x5	;form x5*b5 + sum
	mult	b5
	add	sum
	store	sum
	load	y2	;form y2*a2 + sum
	mult	a2
	add	sum
	store	sum
	load	y3	;form y3*a3 + sum
	mult	a3
	add	sum
	store	sum
	load	y4	;form y4*a4 + sum
	mult	a4
	add	sum
	store	sum
	load	y5	;form y5*a5 + sum
	mult	a5
	add	sum
	store	sum
	; scale output
	shl	scale
	out	AudioOut
	store	sum
	; update output state variables
	load	y4
	store	y5
	load	y3
	store	y4
	load 	y2
	store	y3
	load	sum
	store	y2 
	; update input state variables
	load	x4
	store	x5
	load	x3
	store	x4
	load 	x2
	store	x3
	in	AudioIn
	store	x2 
	; wait for next reset from audio controller	
halt:	jump halt

