; animate 800 particles on VGA
; using gravity simulation
; and viscous drag
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
	scale 4 ; scale rand to 50 pixels

; ==================================

`data 512 ;decimal start of data in memory

	x 800 ; 800 particles pos and speed
	y 800
	vx 800
	vy 800
	count 1 ; particle index
	rand  1 ; random number gen
	g 1 ; gravity
	d 1 ; drag
	dd 1 ; drag divider
	temp 1 ; scratch location 
	tempPC 1 ;scratch for prog counter
	; 
; ==================================

; store a value to a variable 
`macro st_imm 2 ; store_immediate const var_name
   pushi %1
   pop %2
`endmacro
 
; store a value to an array
`macro st_imm_a 3 ; store_imm_array const var_name index_name
   ;compute the address
   pushi %2 ;ADDRESS, not value
   push %3
   add
   ; get the value
   pushi %1
   st
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

; seed random number gen
in switches 
dup
pop rand 
out redLEDs
	
; init point position in pixels
; step thru all particles
st_imm 0 count
`while
    push count
    pushi N
    lt
`do
    ; store the 10.8 pos
    st_imm_fix_a 10 y count
    st_imm_fix_a 10 x count
    ; init vel
    st_imm_a 0 vy count
    st_imm_a 500 vx count

    ; dither y pos
    call rand_num ; call a bunch to minimize serial correlation
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    pushi scale
    shr
    ld_a y count
    add
    st_a y count

    ; dither x 
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    drop
    call rand_num
    pushi scale
    shr
    ld_a x count
    add
    st_a x count

    ; index inc
    inc count
`endwhile

; clear write enable bit
pushi 0
out vga_we

; init gravity
st_imm 1 g ; g=2**-8

;==================
; main drawing loop
;==================

`while
    pushi forever ; never exit
`do

    inc dd ; drag divider tracks frame number
    ; and only add in drag every 16 frames
    `if
    	push dd
    	pushi 15
    	band
    `then
	st_imm 0 d
    `else
	st_imm 1 d
    `endif

    ; loop to update all particles
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
	
	;update x vel
	ld_a vx count
	dup
	push d ; drag
	mul
	sub
	st_a vx count

	;update y vel
	ld_a vy count
	dup
	push d ; drag
	mul
	sub
	push g ; gravity
	add
	st_a vy count

	;update x positions
	ld_a vx count
	ld_a x count
	add
	st_a x count

	; screen boundary checks for x
	`if 
	    ld_a x count
	    pushi_fix 480
 	    gt
	`then
	    ld_a vx count  ; negate the speed
	    neg
	    st_a vx count
	    st_imm_fix_a 480 x count ; and put back inside the box
	`endif

	`if 
	    ld_a x count
	    pushi_fix 5
 	    le
	`then
	    ld_a vx count ; negate the speed
	    neg
	    st_a vx count
	    ;st_imm_fix_a 7 x count
	`endif

	;update y positions
	ld_a vy count
	ld_a y count
	add
	st_a y count

	; screen boundary check for y
	`if 
	    ld_a y count
	    pushi_fix 480
 	    gt
	`then
	    ld_a vy count ; negate the speed
	    neg
	    st_a vy count
	    st_imm_fix_a 480 y count
	`endif

	`if 
	    ld_a y count
	    pushi_fix 5
 	    le
	`then
	    ld_a vy count ; negate the speed
	    neg
	    st_a vy count
	    ;st_imm_fix_a 7 y count
	`endif

	; write new point to screen	
	make_vga_addr x y count
	out vga_addr
	pushi 1
	out vga_data
	toggle_we 

	inc count
    `endwhile ; end of particle update
								
`endwhile ; end of main loop

;===================================
; random number generator
; from "Art of Electronics" page 657
; entry: uses nothing on stack
; exit: 18-bit rand on stack
; 18-bit shift reg:
; shift left one bit
; bits 17 and 10 XORed 
; and stored to bit 0
rand_num: pop tempPC ; save PC
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
    dup ; one for store, one for return
    pop rand ; store 18-bit rand
    push tempPC ; get PC
    return

;===end of code ============================
;
