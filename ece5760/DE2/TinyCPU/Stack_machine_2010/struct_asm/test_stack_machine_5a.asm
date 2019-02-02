; This program demos structured programming
; with LED output and switch/button input

; macros are defined for some common operations
;
; ==================================

`define ; named constants
 	sw0mask 1
 	sw1mask 2
	switches 0 
	key3mask 8
	key2mask 4
	keys 1  ; port 1
	keymask 15 ; 0x0f
	pattern 85 ; 0d85=0x55
	pattern2 255 ; 0xff
	pattern3 15 ; 0x0f
	redLEDs 0 ; port 0
	greenLEDs 1 ; port 1
	forever 1 ; endless loop

; ==================================

`data 128 ;decimal start of data in memory
 	temp 1 ; for stack DUP function
	pctemp 1 ; for subroutine link
	test 1 ; location to push test data
   counter1 1 ; outer loop counter
   counter2 1 ; inner loop counter
; 
; ==================================
 
`macro dup 0 ; dup the top-of-stack
   pop temp
   push temp
   push temp
`endmacro
;
`macro drop 0 ; drop the top-of-stack
   pop temp
`endmacro
;
`macro addi 1 ; add immediate (one parameter)
   pushi %1 ; argument 1
   add
`endmacro
;
`macro dup? 0 ; dup the top if it is not zero
   pop temp
   push temp
   jz m1
   push temp
 m1: push temp
`endmacro
;
`macro call 1 ; subroutine call (one parameter)
   pushpc
   jmp %1
`endmacro
;
`macro return 0 ; subroutine return
   pushi 1
   add ; jump over subroutine link
   poppc
`endmacro

; ================================

`code ; this section contains the actual program

	pushi 0 ; reset the green LEDs
	out greenLEDs 
	pushi 0 ; reset outer counter
	pop counter1

`while
	pushi forever ; never exit
`do
	push counter1 ; get the counter
	call inc ; add one to the outer counter 
	dup ; copy stack top (macro)
	out redLEDs ;output one copy, one on stack 
	pop counter1  ; save the counter

	;slow it down with an inner loop counter
	pushi 1 ; reset inner counter
	pop counter2 ; and store it
	`while 
		push counter2
		push 0 ; compare stack top to zero
		ne ; returns a TRUE if next != top
	`do
		push counter2 ; get the coutner
		call inc ; increment the inner counter
		pop counter2 ; save the counter
	`endwhile	;end of inner loop	

	; detect some button presses
	`if ; is KEY[3] pressed?
		in keys ;KEY[3:0]
		bnot ; invert so key-down==1
		pushi keymask
		band ; use only lower 4 bits
		pushi key3mask ; detect 4th bit set
		eq ;means (next==top -> top)
	`then ; key 3 is pressed
		pushi pattern2
		out greenLEDs   
	`else ; key 3 is not pressed
		pushi pattern3
		out greenLEDs 
		
		; detect some switch inputs
		`if  ; is sw0 on?
			in switches  ;switchs on DE2
			pushi sw0mask ; detect botton bit set
			eq ;means (next==top -> top)
		`then ;pushpc and output 
			pushpc 
			out greenLEDs  ; LEDs should contain this address
		`endif

		`if  ; is sw1 on?
			in switches  ;switchs on DE2
			pushi sw1mask ; detect botton bit set
			eq ;means (next==top -> top)
		`then ;test ld/st SHOULD contain 0x55
			pushi test
			pushi pattern 
			st 
			pushi test
			ld
			out greenLEDs 
		`endif
	`endif
	
`endwhile ; end of outer loop

;=== increment subroutine ===
;
inc: pop pctemp ; pc to temp
	addi 1 ; to the current loop counter
	push pctemp ; restack pc
	return
;
;===end of code ============================