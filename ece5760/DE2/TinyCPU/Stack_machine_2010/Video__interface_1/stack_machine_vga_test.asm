; animate a particle on VGA
; using 18-bit random number generator
; ==================================

`define ; named constants
	; ports
 	switches 0 ; in port 0
	keys 1; in port 1
	redLEDs 3 ; out port 3
	vga_addr 0
	vga_data 1
	vga_we 2
	;
	forever 1 ; endless loop
	; 
	N 800 ; number of particles
	scale 6 ; scale rand to 0.25 pixels

; ==================================

`data 256 ;decimal start of data in memory
	temp 1 ; scratch location 
	x 800
	y 800
	count 1
	rand  1
	; 
; ==================================
 
`macro st_imm 2 ; store_immediate const var_name
   pushi %1
   pop %2
`endmacro

; put an integer constant into an 10.8 fixed array
`macro st_imm_fix_a 3 ; store const var_name index_name
   ;compute the address
   pushi %2 ;ADDRESS, not value
   push %3
   add
   ; compute the fixed value
   pushi %1
   pushi 8
   shl
   st
`endmacro

; store an array value from the stack
`macro st_a 2 ; store var_name index_name
   pop temp ; save the value to store
   ;compute the address
   pushi %1 ;ADDRESS, not value
   push %2
   add
   push temp ; restore the value
   st
`endmacro

; load an array value to the stack
`macro ld_a 2 ; load var_name index_name
   ;compute the address
   pushi %1 ;ADDRESS, not value
   push %2
   add
   ld ; get the value
`endmacro

; combine x and y to construct a vga display address
`macro make_vga_addr 3 ; parameters x y index_name (in 10.8 format)
   ;get x and shift it right then left (for 9 bits of y position)
   pushi %1 ;ADDRESS, not value
   push %3
   add ; x array element address
   ld
   pushi 8 ; truncate low bits 
   shr
   pushi 9
   shl
   ; get y and shift it 8 right
   pushi %2 ;ADDRESS, not value
   push %3
   add ; y array element address
   ld
   pushi 8
   shr
   add
`endmacro

; write enable toggle
`macro toggle_we 0 ; store_immediate const addr
   pushi 1
   out vga_we
   pushi 0
   out vga_we
`endmacro

`macro addi 1 ; add immediate (one parameter)
   pushi %1 ; argument 1
   add
`endmacro

; increment a variable and store it
`macro inc 1 ; increment variable_name
   push %1
   pushi 1
   add
   pop %1
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

`code ; particle animation
	
; init point position in pixels
; step thru all particles
st_imm 0 count
`while
    push count
    pushi N
    lt
`do
    ; store the 10.8 pos
    st_imm_fix_a 240 y count
    st_imm_fix_a 255 x count
    ; index inc
    inc count
`endwhile

; clear write enable bit
pushi 0
out vga_we

in switches ; seed random number gen
pop rand 

; main drawing loop

`while
    pushi forever ; never exit
`do
    
    ; update all particles
    st_imm 0 count
    `while
        push count
        pushi N
        lt
    `do

    	; erase point
	make_vga_addr x y count
	out vga_addr
	pushi 0
	out vga_data
	toggle_we 
	
	;update x positions
	call rand_bit
	pushi scale
	shl
	ld_a x count
	add
	st_a x count

	;update y positions
	call rand_bit
	pushi scale
	shl
	ld_a y count
	add
	st_a y count

	; write new point	
	make_vga_addr x y count
	out vga_addr
	pushi 1
	out vga_data
	toggle_we 

	inc count
    `endwhile
								
`endwhile ; end of main loop

;===============================
; random number generator
; from "Art of Electronics" page 657
; entry: uses nothing on stack
; exit: +1 or -1 on stack
; 18-bit shift reg:
; shift left one bit
; bits 17 and 11 XORed 
; and stored to bit 0
rand_bit: pop temp ; save PC
    push rand 
    dup ; copy for xor
    pushi 7 ; shift left to align bits 17 and 10
    shl
    bxor ; bitwise xor
    pushi 17
    shr ; move bit 17 to bit 0
    push rand
    pushi 1 ; shift to open up 0 bit 
    shl 
    bor ; form new final rand
    dup
    pop rand 
    pushi 1
    band ; isolate bit 0
    pushi 1 ; mult by 2 and subtract 1
    shl     ; so that final output is +1 or -1
    pushi 1
    sub
    push temp ; get PC
    return

;===end of code ============================
;
pushi 1 ; shift left to open up bit 0
    shl