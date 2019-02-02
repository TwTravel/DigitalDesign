; Input 10.8 number on switches
; mult by a constant
; output to LEDs
;
; ==================================

`define ; named constants
 	switches 0 ; in port 0
	keys 1; in port 1
	redLEDs 0 ; out port 0
	greenLEDs 1 ; out port 1
	forever 1 ; endless loop
	keymask 15
	key3mask 8
	key2mask 4

; ==================================

`data 128 ;decimal start of data in memory
	temp 1 ; scratch location for swap
	temp2 1 ; scratch location for swap
	factor 1
	debounce3 1
	debounce2 1
	; 
; ==================================
 
`macro store_imm 2 ; store_immediate const addr
   pushi %1
   pop %2
`endmacro
;
; ================================

`code ; this section contains the actual program

	store_imm 1 factor

`while
	pushi forever ; never exit
`do
	push factor ;
	pushi 8
	shl
	in switches
	mul
	out redLEDs ;output one copy, one on stack 
	
	push factor
	out	greenLEDs

	; detect inc factor
	`if ; is KEY[3] pressed?
		in keys ;KEY[3:0]
		bnot ; invert so key-down==1
		pushi keymask
		band ; use only lower 4 bits
		pushi key3mask ; detect 4th bit set
		eq ;means (next==top -> top)
	`then ; key 3 is pressed
		`if
			push debounce3
		`then
			push factor
			pushi 1
			add
			pop factor
			store_imm 0 debounce3
		`endif
	`else
		store_imm 1 debounce3
	`endif
	
	; detect dec factor
	`if ; is KEY[2] pressed?
		in keys ;KEY[3:0]
		bnot ; invert so key-down==1
		pushi keymask
		band ; use only lower 4 bits
		pushi key2mask ; detect 3rd bit set
		eq ;means (next==top -> top)
	`then ; key 2 is pressed
		`if
			push debounce2
		`then
			push factor
			pushi 1
			sub
			pop factor
			store_imm 0 debounce2
		`endif
	`else
		store_imm 1 debounce2
	`endif
							
`endwhile ; end of outer loop

;===end of code ============================
;
