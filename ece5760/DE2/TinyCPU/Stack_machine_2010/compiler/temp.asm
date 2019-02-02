 constant
 switches 0
 keys 1
 redLEDs 3
 gpio 3
 vga_addr 0
 vga_data 1
 vga_we 2
 forever 1
 N 1800
 scale 7
 variable
 temp
 x 1800
 y 1800
 count
 rand
 rand2
 frame_toggle
 function
 rand_bit
 program
 main:
 0 =count
 while
 count N lt
 do
 240
; inline int2fix
	8 shl
; end inline int2fix
 =y[count]
 400
; inline int2fix
	8 shl
; end inline int2fix
 =x[count]
 count 1 add =count
 endwhile
 0 out[vga_we]
 in[switches]
 dup =rand out[redLEDs]
 while
 forever
 do
 frame_toggle bnot dup =frame_toggle
 out[gpio]
 0 =count
 while
 count N lt
 do
 y[count] x[count]
; inline make_vga_addr
   8 shr 9 shl =temp
   8 shr
   temp add
; end inline make_vga_addr
 out[vga_addr]
 0 out[vga_data]

; inline toggle_we
	1 out[vga_we] 
    0 out[vga_we]
; end inline toggle_we

 rand_bit
 scale shl x[count] add =x[count]
 rand_bit
 scale shl y[count] add =y[count]
 if x[count] 480
; inline int2fix
	8 shl
; end inline int2fix
 gt
 then
 478
; inline int2fix
	8 shl
; end inline int2fix
 =x[count]
 endif
 if x[count] 5 8 shl le
 then
 7
; inline int2fix
	8 shl
; end inline int2fix
 =x[count]
 endif
 if y[count] 480
; inline int2fix
	8 shl
; end inline int2fix
 gt
 then
 478
; inline int2fix
	8 shl
; end inline int2fix
 =y[count]
 endif
 if y[count] 5
; inline int2fix
	8 shl
; end inline int2fix
 le
 then
 7
; inline int2fix
	8 shl
; end inline int2fix
 y[count]
 endif
 y[count] x[count]
; inline make_vga_addr
   8 shr 9 shl =temp
   8 shr
   temp add
; end inline make_vga_addr
 out[vga_addr]
 1 out[vga_data]

; inline toggle_we
	1 out[vga_we] 
    0 out[vga_we]
; end inline toggle_we

 count 1 add =count
 endwhile
 endwhile
 rand_bit:
 rand2 dup 11 shl bxor 17 shr =temp
 rand 17 shr rand2 1 shl bor =rand2
 rand 1 shl temp bor dup =rand
 1 band 1 shl 1 sub
 return
