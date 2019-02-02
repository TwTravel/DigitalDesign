.include "nios_macros.s"

#///// parallel ports ////////////////////////////
#define parallel i/o addresses (from SOPC builder)
.equ Switches, 0x00001820
.equ LEDs, 0x00001830

#///// hardware timer ////////////////////////////
#Timer description from http://altera.com/literature/hb/nios2/n2cpu_nii51008.pdf
#NOTE--these are 16 bit registers, BUT offsets in the manual are in 32-bit chunks
#Status --  bit1=RUN bit0=TO
.equ Timer_status, 0x00001800 
#Control -- bit3=STOP bit2=START bit1=CONT bit0=ITO 
.equ Timer_control, 0x00001804
#Period -- timer autoreloads these at count==zero  
.equ Timer_periodl, 0x00001808 
.equ Timer_periodh, 0x0000180c
#Snap -- current time count
#writing any data to this address will cause the
#current count to be copied here    
.equ Timer_snapl, 0x00001810	 
.equ Timer_snaph, 0x00001814  
#Timer behavior:
#TO bit is set when count==0
#uses ISR bit 1 (see configuration data in SOPC builder)
#On interrupt, you must Clear the TO bit of the status register
#RUN bit is read-only and is one when running
#ITO bit enables the count==0 interrupt
#START bit starts the timer when written with a 1
#STOP bit stops the timer when written with a 1
#CONT bit causes a periodic interrupt when 1, and one-shot interrupt when zero 
#for a 1 second period, 50e6 counts = 0x2FAF080

#///// macros /////////////////////////////////////////
#push and pop macros 
#NOTE: You MUST set up a stack pointer before using these macros!
.equ top_of_memory, 0x1000	#4Kbyte: from SOPC settings (double click memory)
# push
.macro push reg
subi	r27, r27, 4
stw	\reg, 0(r27)
.endm
# pop
.macro pop reg
ldw	\reg, 0(r27)
addi	r27, r27, 4
.endm

#//// reset vector is address zero ////////////////////
BR main		# Jump to entry routine
NOP		# skip using NOPs to 0x0020
NOP
NOP
NOP
NOP
NOP
NOP
isr_entry: 
# This location defaults to 0xh0020 in SOPC builder (see: more Nios settings)
BR interrupt_handler 	
NOP

#////// main /////////////////////////////////////////
main:
# set up stack pointer in the standard place: r27
movia	r27, top_of_memory

# set up parallel i/o pointers
movia 	r2, Switches 		# movelong to r2 (sw address)
movia	r3, LEDs		# movelong to r3 (LED address)

# timer period low 16 bits		
movia	r7, Timer_periodl	# set low word of interval for 1 second: 0xF080
movui	r5, 0xf080
sthio	r5, 0(r7)

# timer period high 16 bits
movia	r7, Timer_periodh	# set high word of interval for 1 second: 0x2FA
movui	r5, 0x2fa 
sthio	r5, 0(r7)

# timer control reg
movia	r7, Timer_control	# START timer, set CONT=1, and enable timer ITO bit
movi	r5, 0b111		
stbio	r5, 0(r7)

# cpu IRQ control
movi	r5, 2			# timer ISR uses bit 1 of interrupt enable reg 
wrctl	ienable, r5		# (see SOPC configuration)
movi	r5, 1			# turn on master interrupt bit
wrctl	status, r5

# initialize r5 for invert blink flag
# This reg is modified by the ISR and is used by main		
movi	r5, 0xff		

# endless main loop
loop: 
    ldbio	r4, 0(r2)	# byteread switches (bypass cache)
    xor		r4, r4, r5	# xor with r5 flag from ISR to cause blinking
    stbio	r4, 0(r3)	# bytewrite leds (bypass cache)
br loop

#////// timer ISR /////////////////////////////////////
# ISR entered every time the hardware timer count==0
interrupt_handler:
push 	r2			# save register context
movia	r2, Timer_status	# must clear TO in Timer_status manually
stbio	r0, 0(r2)		# zero to TO bit
xori	r5, r5, 0xff; 		# invert r5 led flag to cause blinking
pop	r2			# restore reg context
#For following: see NiosII Processor Handbook, page 3-13 "Returning from an exception"		
subi	r29, r29, 4		# subtract 4 from ea (exception return addr register)
eret				# return from the ISR

#///// end ////////////////////////////////////////////


