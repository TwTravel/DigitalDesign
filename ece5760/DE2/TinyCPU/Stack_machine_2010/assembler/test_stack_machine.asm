define
 	sw0 1
 	sw1 2
	pattern 85 ; 0d85=0x55
;
data 128 ;decimal start of data
 	temp 1 ; for stack DUP function
	test 1 ; location to push test data
; 
code
	pushi 0
loop0: pushi 1
	add ;one to the counter
	
	; code DUP function (copy stack top)
	pop temp
	push temp 	
	push temp 
	
	;output one copy, leave one on stack for next loop
	out	
	
	;slow it down with an inner loop counter
	pushi 0
loop1: pushi 1
	add 
	
	;code DUP function
	pop temp 
	push temp 	
	push temp 	

	;jump back to inner loop1 unless overflow
	jnz loop1 ; go until equal 
	pop temp ; dump copy of inner counter if we fall thru jnz
	
	;pushpc and halt if sw[0] is on
	in ;switchs
	pushi sw0 ; detect botton bit set
	eq ;means (next==top -> top)
	jnz pushtest
	
	; ST/LD test and halt if sw[1] is on
	in ;switch
	pushi sw1 ; detect second bit set
	eq ;means (next==top -> top)
	jnz STtest
	
	; back to beginning using a pc manipulation to check "poppc" 
	; equivalent to jmp loop0
	pushi loop0
	poppc  ; puts value into PC
	
	; test pushpc
pushtest: pushpc 
	; now halt to read value
halt: jmp halt ; qtop SHOULD contain 0x1A
	
	; test ST/LD
STtest: pushi test
	pushi pattern 
	st 
	pushi test
	ld
halt2: jmp halt2 -- qtop SHOULD contain 0x55
;
;