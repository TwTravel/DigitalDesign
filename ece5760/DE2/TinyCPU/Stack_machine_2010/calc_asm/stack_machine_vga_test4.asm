; animate 1800 particles on VGA
; using 36-bit random number generator
; ==================================

`define ; named constants
	; ports
 	switches 0 ; in port 0
	keys 1; in port 1
	redLEDs 3 ; out port 3
	gpio 3 ;
	vga_addr 0
	vga_data 1
	vga_we 2
	;
	forever 1 ; endless loop
	; 
	N 1800 ; number of particles
	scale 7 ; scale rand to 0.5 pixels per step

; ==================================

`data 256 ;decimal start of data in memory
	temp 1 ; scratch location 
	tempPC 1
	x 1800
	y 1800
	count 1
	rand  1
	rand2 1
	frame_toggle 1
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

; load an fix value to the stack
`macro pushi_fix 1 ; value
; compute the fixed value
   pushi %1
   pushi 8
   shl
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
    `calc count N lt
`do
    ; store the 10.8 pos
    ;st_imm_fix_a 240 y count
    `calc 240 8 shl =y[count]
    ;st_imm_fix_a 450 x count
    `calc 400 8 shl =x[count]

    ; index inc
    inc count
`endwhile

; clear write enable bit
pushi 0
out vga_we

in switches ; seed random number gen
dup
pop rand 
out redLEDs

; main drawing loop

`while
    pushi forever ; never exit
`do
    ; frame rate monitor
    `calc frame_toggle bnot dup =frame_toggle
    ; dup makes one copy to store and another to output
    out gpio

    ; update all particles
    st_imm 0 count
    `while
       `calc count N lt
    `do
    	 ; erase point
	 make_vga_addr x y count
	 out vga_addr
	 pushi 0
	 out vga_data
	 toggle_we 
	
	 ;update x positions
	 call rand_bit
	`calc scale shl x[count] add =x[count]

	;update y positions
	 call rand_bit
	`calc scale shl y[count] add =y[count]

      ; screen boundary checks for x
	`if 
	    `calc x[count] 480 8 shl gt
	`then
	    ; and put back inside the box
	    `calc 478 8 shl =x[count]
	`endif

	`if 
	    `calc x[count] 5 8 shl le
	`then
	    `calc 7 8 shl =x[count]
	`endif

	; screen boundary check for y
	`if 
	    ld_a y count
	    pushi_fix 480
 	    gt
	`then
	    st_imm_fix_a 478 y count
	`endif

	`if 
	    ld_a y count
	    pushi_fix 5
 	    le
	`then
	    ;st_imm_fix_a 7 y count
	`endif


	; write new point	
	 make_vga_addr x y count
	 out vga_addr
	 pushi 1
	 out vga_data
	 toggle_we 

	 inc count
   `endwhile ; particle update loop
								
`endwhile ; end of main loop

;===============================
; random number generator
;===============================
; from "Art of Electronics" page 657
; entry: uses nothing on stack
; exit: +1 or -1 on stack
; 36-bit shift reg:
; shift left one bit
; bits 36 and 25 XORed (2nd reg bit 17 and 6)
; and stored to bit 0
rand_bit: pop tempPC ; save PC
    push rand2 
    dup ; copy for xor
    pushi 11 ; shift left to align bits 17 and 6
    shl
    bxor ; bitwise xor
    pushi 17
    shr ; move bit 17 to bit 0
    pop temp ; save xor bit for later

    push rand ; modify rand2
    pushi 17
    shr ; put high bit in low position
    push rand2
    pushi 1
    shl
    bor ; shift bit into high order SR
    pop rand2 ; and store it

    push rand ; modify rand
    pushi 1 ; shift to open up 0 bit 
    shl 
    push temp ; get the stored xor bit
    bor ; form new final rand
    dup
    pop rand 

    pushi 1 ; construct +/-1 output
    band ; isolate bit 0
    pushi 1 ; mult by 2 and subtract 1
    shl     ; so that final output is +1 or -1
    pushi 1
    sub
    push tempPC ; get PC
    return

;===end of code ============================
;
