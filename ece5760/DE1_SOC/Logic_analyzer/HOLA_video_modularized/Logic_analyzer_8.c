//////////////////////////////////////////////
// Logic Analyzer test
// Test with video and DDS
// And with modularized drawing and printing
// compile with:
//   gcc Logic_analyzer_8.c -o la8  -O3
//////////////////////////////////////////////

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <sys/time.h> 
#include <math.h> 

#include "address_map_arm_brl4.h"

//=======================================================
// Logic analyser interface
//=======================================================
// check for trigger
// -- if triggered log data to memory
// -- signal HPS
//
// write the controller memory 
// Bus address 0xC0000000
// -- addr 0 -- new data? yes==1
// -- addr 1 -- allow capture to occur -- arm 
// -- addr 2 -- trigger count (after trigger event)
// write trigger mask -- two 32 bit words 
// -- addr 254 dont care mask a "1" means "care"
// -- addr 255 actual bits
// read the controller memory
// -- addr 250 -- data capture complete == 1
// -- addr 251 -- addr_complete (sram addr of trigger sample)
// 
// trigger_count is the numbr of samples AFTER the trigger
// -- 100 < trigger_count < 900
// trigger_mask are the bits that matter to the application
// -- For example, 0h0000ffff, will only look at the lowr 16 bits
// trigger_value is the exact bit patttern in the trigger word to match
// -- For example, with the mask above, 0h0f001000 will cause a trigger 
// -- when the trigger word equals 0hxxxx1000, where x means "don't care"
	
// Read the alanyzer buffer
// Bus address 0xC0001000
// read 1000 words starting at offset "addr_complete"
// and wrapping at 10 bits
// h2f_axi_master; scratch RAM at 0xC0000000
// analyzer buffer at 0xC0001000
// analyzer control at 0xC0000000
// Change THESE if you move the SRAM in Qsys
#define FPGA_SRAM_BASE      0xC8000000
#define FPGA_SRAM_SPAN      0x00002000
#define ANALYZER_OFFSET     0x00000000
#define CONTROL_OFFSET      0x00001000
// the start_HOLA routine:
// -- takes input: trigger_mask, trigger_value
// -- arms the trigger
// -- waits for the FPGA to return logic_data array
// -- logic_data is 1000 values with the trigger point at 499
// start_HOLA(trigger_mask, trigger_value)
void start_HOLA(unsigned int, unsigned int) ;
unsigned int logic_data[1024] ;
unsigned int trigger_mask, trigger_value ;
// the end_HOLA routine:
// -- signals the FPGA that the HPS is done processing current data
void end_HOLA(void) ;

// ==========================================
/// lw_bus 
#define HW_REGS_BASE          0xff200000
#define HW_REGS_SPAN          0x00005000 

//=======================================================
// drawing/printing interface
//=======================================================
// all print/draw routine:
// -- use ranges are relative to trigger point
// -- use a contigious range of bits from data logger
// -- specified by the low-order bit and a mask value
// -- specify signed/unsigned display

// draw routines:
// -- specify vertical position on screen
// -- vertical scaling factor (number of bits to shift-right)
// -- the waveform color
// -- draw occures on VGA
// draw_wave_HOLA(low_bit, bit_mask, un/sign, v_pos, v_scale, h_scale, color)
void draw_wave_HOLA( int, int, char, int, int, int, char);

// print routines
// -- specify format e.g. %2d %06x or binary
// -- print occurs on system concole
// -- column titles are "sample" and "title"
// print_HOLA(begin, end, low_bit, bit_mask, un/sign, *format, *title)
void print_HOLA(int, int, int, int, char, char *, char *);
// 'begin' will be a negative number indicating before trigger
// 'format' 
//
// print_binary_HOLA(begin, end, low_bit, bit_mask, *title)
void print_binary_HOLA(int, int, int, int, char *);

//=======================================================



// ==========================================
// PuTTY serial terminal control codes
// ==========================================
// see 
// http://ascii-table.com/ansi-escape-sequences-vt-100.php
// cursor_pos(1,1) sets the cursor to the upper-left corner of the screen
#define cursor_pos(line,column) printf("\x1b[%02d;%02dH",line,column)	
#define clr_right printf("\x1b[K")
#define clrscr() printf( "\x1b[2J")
#define home()   printf( "\x1b[H")
#define pcr()    printf( '\r')
#define crlf     putchar(0x0a); putchar(0x0d);
// from http://www.comptechdoc.org/os/linux/howlinuxworks/linux_hlvt100.html
// and colors from http://www.termsys.demon.co.uk/vtansi.htm
#define green_text printf("\x1b[32m")
#define yellow_text printf("\x1b[33m")
#define red_text printf("\x1b[31m")
#define rev_text printf("\x1b[7m")
#define normal_text printf("\x1b[0m")

// ==========================================
// graphics support
// ==========================================
// pixel macro
#define VGA_PIXEL(x,y,color) do{\
	char  *pixel_ptr ;\
	pixel_ptr = (char *)vga_pixel_ptr + ((y)<<10) + (x) ;\
	*(char *)pixel_ptr = (color);\
} while(0)
	
/* function prototypes */
void VGA_text (int, int, char *);
void VGA_text_clear();
void VGA_box (int, int, int, int, short);
void VGA_line(int, int, int, int, short) ;
void VGA_disc (int, int, int, short);
int  VGA_read_pixel(int, int) ;
int  video_in_read_pixel(int, int);
void draw_delay(void) ;

// 8-bit primary colors
#define red 0xe0
#define dark_red 0x60
#define green 0x1c
#define dark_green 0x0c
#define blue 0x03
#define dark_blue 0x01
#define yellow 0xfc
#define cyan 0x1f
#define magenta 0xe3
#define black 0x00
#define gray (0x60 | 0x0c | 0x01)
#define white 0xff

// ==========================================
// real-to-virtual memory variables
// ==========================================
	
// the light weight buss base
void *h2p_lw_virtual_base;
// HPS_to_FPGA FIFO status address = 0
//volatile unsigned int * FIFO_write_status_ptr = NULL ;
//volatile unsigned int * FIFO_read_status_ptr = NULL ;

// HPS_to_FPGA FIFO write address
// main bus addess 0x0000_0000
void *h2p_virtual_base;
// RAM FPGA command buffer
volatile unsigned int * control_sram_ptr = NULL ;
volatile unsigned int * analyzer_sram_ptr = NULL ;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
void *vga_pixel_virtual_base;

// character buffer
volatile unsigned int * vga_char_ptr = NULL ;
void *vga_char_virtual_base;

// /dev/mem file id
int fd;	

// ==========================================
// binary print conversion
// ==========================================
// The hexidecimal digits 0-f (0-15)
// are mapped to the decimal equivalent of the
// binary value, which prints correctly using %04d	
// array LUT for hex digit to binary
int hex2bin[16] = {0, 1, 10, 11, 100, 101, 110, 111, 
			       1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111};

// ==========================================				   
int main(void)
{

	// Declare volatile pointers to I/O registers (volatile 	
	// means that IO load and store instructions will be used 	
	// to access these pointer locations, 
	// instead of regular memory loads and stores)  
  
	// === get FPGA addresses ==================
    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
    
	//============================================
    // get virtual addr that maps to physical
	// for light weight bus
	// FIFO status registers
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}
	
	//============================================
	
	//  RAM FPGA parameter/analyzer addrs 
	h2p_virtual_base = mmap( NULL, FPGA_SRAM_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_SRAM_BASE); 	
	
	if( h2p_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    // Get the address that maps to the RAM buffers
	control_sram_ptr =(unsigned int *)(h2p_virtual_base + CONTROL_OFFSET);
	analyzer_sram_ptr =(unsigned int *)(h2p_virtual_base + ANALYZER_OFFSET);
	
	// ===========================================
	// === get VGA char addr =====================
	// get virtual addr that maps to physical
	vga_char_virtual_base = mmap( NULL, FPGA_CHAR_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_CHAR_BASE );	
	if( vga_char_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap2() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the character 
	vga_char_ptr =(unsigned int *)(vga_char_virtual_base);

	// === get VGA pixel addr ====================
	// get virtual addr that maps to physical
	// SDRAM
	vga_pixel_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, SDRAM_BASE); //SDRAM_BASE	
	
	if( vga_pixel_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    // Get the address that maps to the FPGA pixel buffer
	vga_pixel_ptr =(unsigned int *)(vga_pixel_virtual_base);
	
	
	//===========================================
	/* create a message to be displayed on the VGA 
          and LCD displays */
	char text_top_row[40] = "HOLA: DE1-SoC ARM/FPGA\0";
	char text_bottom_row[40] = "Cornell ece5760\0";
	char num_string[20], time_string[50], HOLA_string[50] ;
	
	// a pixel from the video
	int pixel_color;
	
	// clear the screen
	VGA_box (0, 0, 639, 479, dark_blue);
	// clear the text
	VGA_text_clear();
	VGA_text (1, 56, text_top_row);
	VGA_text (1, 57, text_bottom_row);
	
	int h_scale = 1;
	// ===========================================
	
	while(1) 
	{
		// ask for trigger data
		printf("\n\r enter trigger mask, trigger value, h_zoom(0,1,2,3,4)\n\r");
		scanf("%x %x %x", &trigger_mask, &trigger_value, &h_scale ); 
		
		// clear the VGA screen
		VGA_box (0, 0, 639, 479, dark_blue);
		//  display the trigger point
		VGA_line(320, 0, 320, 400, green) ;
		sprintf(HOLA_string, "trig_mask=%08x  trig_value=%08x zoom=%1d", 
				trigger_mask, trigger_value, h_scale) ;
		VGA_text(25, 57, HOLA_string) ;
		
		// Arm HOLA and wait for data in the array
		// 'logic_data'
		start_HOLA(trigger_mask, trigger_value);
		
		// draw phase
		// draw_wave_HOLA(begin, end, low_bit, bit_mask, sign, v_pos, v_scale, h_scale, color)
		draw_wave_HOLA(0, 0xff, 'u', 100, 2, h_scale, white);
		
		// draw one bit per wave
		draw_wave_HOLA(7, 0x01, 'u', 120, -2, h_scale, red);
		draw_wave_HOLA(6, 0x01, 'u', 140, -2, h_scale, red);
		draw_wave_HOLA(5, 0x01, 'u', 160, -2, h_scale, red);
		draw_wave_HOLA(4, 0x01, 'u', 180, -2, h_scale, red);
		draw_wave_HOLA(3, 0x01, 'u', 200, -2, h_scale, red);
		draw_wave_HOLA(2, 0x01, 'u', 220, -2, h_scale, red);
		draw_wave_HOLA(1, 0x01, 'u', 240, -2, h_scale, red);
		draw_wave_HOLA(0, 0x01, 'u', 260, -2, h_scale, red);
		
		// draw sine
		draw_wave_HOLA(8, 0xffff, 's',  350, 9, h_scale, white);
		
		// print the phase
		// print_HOLA(begin, end, low_bit, bit_mask, un/sign, *format, *title) ;
		// format for sample number AND vector to print; 
		char title[]="All data" ;
		print_binary_HOLA(-5, 5, 0, 0xffffffff, title) ;
		
		// print__binary_HOLA(begin, end, low_bit, bit_mask, *title)
		char title_s[]="Phase" ;
		print_binary_HOLA(-5, 5, 0, 0xff, title_s);

		// Clear the done flag which signals the FPGA to start
		// logging data again.
		end_HOLA();
		
	} // end while(1)
} // end main

/****************************************************************************************
 * start_HOLA(trigger_mask, trigger_value)
****************************************************************************************/
void start_HOLA(unsigned int trigger_mask, unsigned int trigger_value){
	int logic_arm, trigger_count=500 ;
	int initial_addr ;
	int i, i_wrap, j, lower_limit, upper_limit;
	//unsigned int data_word;
	
	// set arm command
	logic_arm = 1;
	*(control_sram_ptr+1) = logic_arm;
	
	// set trigger position (100-900)
	*(control_sram_ptr+2) = trigger_count;
	
	// set trigger mask
	*(control_sram_ptr+254) = trigger_mask;
	// set tirgger vaule
	*(control_sram_ptr+255) = trigger_value;
	
	// set data ready flag
	// data is actually read by the FPGA when this flag is set
	*(control_sram_ptr) = 1 ;
	// FPGA clears flag when done reading
	// wait for FPGA read done
	while (*(control_sram_ptr)==1) ;
	
	// === analyzer response ===
	// wait for analyzer data capture done
	while (*(control_sram_ptr+250)==0) ;
	
	// read back the address in buffer memory at
	// which the trigger occured 
	// (trigger actually occurs at  initial_address-1)
	initial_addr = *(control_sram_ptr+251);
	
	// initial_addr contains the offset into the data memory
	//     at the trigger sample + 1
	// address range is 0-1023 and WRAPS in hardware
	lower_limit = -500 ; // relative to trigger point
	upper_limit = 500 ;  // relative to trigger point
	j = 0;
	for (i=lower_limit; i<upper_limit; i++) {
		// wrap the memory block address
		i_wrap = (initial_addr + i) & 0x3ff ; 
		// put the trigger point in position j=499
		logic_data[j] = *(analyzer_sram_ptr + i_wrap) ;
		j++;
	}
}

/****************************************************************************************
 * end_HOLA(trigger_mask, trigger value)
****************************************************************************************/
void end_HOLA(void){
	// Clear the done flag which signals the FPGA to start
	// logging data again.
	*(control_sram_ptr+250) = 0;	
}

/****************************************************************************************
 * draw_wave_HOLA(begin, end, low_bit, bit_mask, sign, v_pos, v_scale, color)
****************************************************************************************/
// Input:
// base position of the desired field in the 32-bit word from the FPGA
// width of the desired field, expressed as a bit-mask, e.g. 8-bits is 0xff
// signed/unsigned 'u' implies unsigned, 's' implies signed
// vertical position on the screen
// vertical scale represented as powers of two:
//     a value of 2 means right-shift 2 bits
//     a value of -1 means left-shift 1 bit
// pixels/sample clock (hoizontal scale) can be 0,1,2,3
//     a value of 3 means 8 pixels/clock cycle
// color -- 8-bit colors defined above
void draw_wave_HOLA( int low_bit, int bit_mask, char s, 
                    int v_pos, int v_scale, int h_scale, char color){
	int lower_draw, upper_draw, i, j ;
	int isolate_bits, negative_mask ;
	int draw_data[640] ; 
	#define m1 0xffffffff // minus one
	// strip out data and populate the 
	// lower 640 locations of the arrays for VGA display
	// limits -500 and +500 from trigger position 499
	// Center trigger point on screen at 320
	lower_draw = -(320>>h_scale) + 499; //>>h_scale
	upper_draw =  (320>>h_scale) + 499 ;
	j = 0 ;
	int h_scale_n = 1<<h_scale;
	int count_scale;
	// get samples centered around trigger
	for (i=lower_draw; i<upper_draw; i++) {
		// isolate the bits 
		// unsigned?
		for (count_scale=0; count_scale<h_scale_n; count_scale++){
		if (s=='u')
			if (v_scale >= 0)
				draw_data[j] = v_pos - (((logic_data[i]>>low_bit) & bit_mask) >> v_scale) ;
			else 
				draw_data[j] = v_pos - (((logic_data[i]>>low_bit) & bit_mask) << -v_scale) ;
			
		// must be signed
		else {
				isolate_bits = ((logic_data[i]>>low_bit) & bit_mask);
				// if negative, zero the bits in the mask that overlap the actual bits
				// (bit_mask^(bit_mask>>1) isolates the high order bit of the mask
				if(isolate_bits & (bit_mask^(bit_mask>>1))) negative_mask = m1 ^ bit_mask ; 
				else negative_mask = 0;
				if (v_scale >= 0)
					draw_data[j] = v_pos - ((signed int)(isolate_bits | negative_mask) >> v_scale) ;
				else
					draw_data[j] = v_pos - ((signed int)(isolate_bits | negative_mask) << -v_scale) ;
			}
		j++;
		}
	}
	
	// draw the vector
	// VGA_PIXEL(x,y,color)
	// the array index is now screen coordinate
	
	for (i=0; i<640; i++) {		
		VGA_PIXEL(i, draw_data[i], color) ;	
	}		
}


/****************************************************************************************
print_HOLA(begin, end, low_bit, bit_mask, un/sign, *format, *title)
****************************************************************************************/
// Input:
// Number of samples before the trigger, expressed as a negative integer
// Number of samples after the trigger, expressed as  positive integer
// base position of the desired field in the 32-bit word from the FPGA
// width of the desired field, expressed as a bit-mask, e.g. 8-bits is 0xff
// signed/unsigned 'u' implies unsigned, 's' implies signed
// a printf format string, e.g. 
//     char fmt_s[]="%03d %d "  
//     where the %03d formats the clock tick number 
//     and %d is the desired format for the data vector
// title of the data vector column, e.g.
//     char title_s[]="sine" ;
void print_HOLA(int begin, int end, int low_bit, int bit_mask, char s, 
                char * fmt, char * title){
	int isolate_bits, i; 
	int negative_mask;
	#define m1 0xffffffff // minus one
	
	printf("\n\rclk  %s \n\r", title) ;
	for (i=begin+499; i<end+499; i++) {
		isolate_bits = ((logic_data[i]>>low_bit) & bit_mask);
		if (s=='u'){
			printf(fmt, i, isolate_bits);
		}
		// signed
		else {
			if(isolate_bits & (bit_mask^(bit_mask>>1))) negative_mask = m1 ^ bit_mask ; 
			else negative_mask = 0;
			printf(fmt, i, (signed int)(isolate_bits | negative_mask));
		}
		if (i==499) printf(" <-- trigger point");
		printf("\n\r");
	}
	
}

/****************************************************************************************
print_binary_HOLA(begin, end, low_bit, bit_mask, *title)
****************************************************************************************/
void print_binary_HOLA(int begin, int end, int low_bit, int bit_mask, char * title){
	int isolate_bits, j, jj;
	int n_bits=0 ;
	
	// the title
	printf("\n\rclk  %s \n\r", title) ;
	
	// get number of nonzero bits from mask
	unsigned int i = bit_mask;
	while (i!=0){
		n_bits++;
		i = i >> 1 ;
	}
	// round up to 4-bit multiple
	if(n_bits%4 != 0) n_bits += n_bits%4 ;
	// and trim off one shift
	n_bits -= 4;
	//printf("bits=%d/n/r", n_bits);
	
	// convert to binary
	for (i=begin+499; i<end+499; i++) {
		isolate_bits = ((logic_data[i]>>low_bit) & bit_mask) ;
		printf("%03d ", i);
		printf("%08x ", isolate_bits);
		// binary
		jj = 0;
		for(j=n_bits; j>=0; j=j-4){
			if(jj==0){ normal_text; jj=1;}
			else {yellow_text; jj=0;}
			printf("%04d", hex2bin[(isolate_bits>>j) & 0x0f]);
		}
		normal_text;
		if (i==499) printf(" <-- trigger sample\n\r");
		else printf("\n\r");
	}	
	
}
/****************************************************************************************
 * Subroutine to read a pixel from the video input 
****************************************************************************************/
// int  video_in_read_pixel(int x, int y){
	// char  *pixel_ptr ;
	// pixel_ptr = (char *)video_in_ptr + ((y)<<9) + (x) ;
	// return *pixel_ptr ;
// }

/****************************************************************************************
 * Subroutine to read a pixel from the VGA monitor 
****************************************************************************************/
int  VGA_read_pixel(int x, int y){
	char  *pixel_ptr ;
	pixel_ptr = (char *)vga_pixel_ptr + ((y)<<10) + (x) ;
	return *pixel_ptr ;
}

/****************************************************************************************
 * Subroutine to send a string of text to the VGA monitor 
****************************************************************************************/
void VGA_text(int x, int y, char * text_ptr)
{
  	volatile char * character_buffer = (char *) vga_char_ptr ;	// VGA character buffer
	int offset;
	/* assume that the text string fits on one line */
	offset = (y << 7) + x;
	while ( *(text_ptr) )
	{
		// write to the character buffer
		*(character_buffer + offset) = *(text_ptr);	
		++text_ptr;
		++offset;
	}
}

/****************************************************************************************
 * Subroutine to clear text to the VGA monitor 
****************************************************************************************/
void VGA_text_clear()
{
  	volatile char * character_buffer = (char *) vga_char_ptr ;	// VGA character buffer
	int offset, x, y;
	for (x=0; x<79; x++){
		for (y=0; y<59; y++){
	/* assume that the text string fits on one line */
			offset = (y << 7) + x;
			// write to the character buffer
			*(character_buffer + offset) = ' ';		
		}
	}
}

/****************************************************************************************
 * Draw a filled rectangle on the VGA monitor 
****************************************************************************************/
#define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0) 

void VGA_box(int x1, int y1, int x2, int y2, short pixel_color)
{
	char  *pixel_ptr ; 
	int row, col;

	/* check and fix box coordinates to be valid */
	if (x1>639) x1 = 639;
	if (y1>479) y1 = 479;
	if (x2>639) x2 = 639;
	if (y2>479) y2 = 479;
	if (x1<0) x1 = 0;
	if (y1<0) y1 = 0;
	if (x2<0) x2 = 0;
	if (y2<0) y2 = 0;
	if (x1>x2) SWAP(x1,x2);
	if (y1>y2) SWAP(y1,y2);
	for (row = y1; row <= y2; row++)
		for (col = x1; col <= x2; ++col)
		{
			//640x480
			pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
			// set pixel color
			*(char *)pixel_ptr = pixel_color;		
		}
}

/****************************************************************************************
 * Draw a filled circle on the VGA monitor 
****************************************************************************************/

void VGA_disc(int x, int y, int r, short pixel_color)
{
	char  *pixel_ptr ; 
	int row, col, rsqr, xc, yc;
	
	rsqr = r*r;
	
	for (yc = -r; yc <= r; yc++)
		for (xc = -r; xc <= r; xc++)
		{
			col = xc;
			row = yc;
			// add the r to make the edge smoother
			if(col*col+row*row <= rsqr+r){
				col += x; // add the center point
				row += y; // add the center point
				//check for valid 640x480
				if (col>639) col = 639;
				if (row>479) row = 479;
				if (col<0) col = 0;
				if (row<0) row = 0;
				pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + col ;
				// set pixel color
				//nanosleep(&delay_time, NULL);
				//draw_delay();
				*(char *)pixel_ptr = pixel_color;
			}
					
		}
}

// =============================================
// === Draw a line
// =============================================
//plot a line 
//at x1,y1 to x2,y2 with color 
//Code is from David Rodgers,
//"Procedural Elements of Computer Graphics",1985
void VGA_line(int x1, int y1, int x2, int y2, short c) {
	int e;
	signed int dx,dy,j, temp;
	signed int s1,s2, xchange;
     signed int x,y;
	char *pixel_ptr ;
	
	/* check and fix line coordinates to be valid */
	if (x1>639) x1 = 639;
	if (y1>479) y1 = 479;
	if (x2>639) x2 = 639;
	if (y2>479) y2 = 479;
	if (x1<0) x1 = 0;
	if (y1<0) y1 = 0;
	if (x2<0) x2 = 0;
	if (y2<0) y2 = 0;
        
	x = x1;
	y = y1;
	
	//take absolute value
	if (x2 < x1) {
		dx = x1 - x2;
		s1 = -1;
	}

	else if (x2 == x1) {
		dx = 0;
		s1 = 0;
	}

	else {
		dx = x2 - x1;
		s1 = 1;
	}

	if (y2 < y1) {
		dy = y1 - y2;
		s2 = -1;
	}

	else if (y2 == y1) {
		dy = 0;
		s2 = 0;
	}

	else {
		dy = y2 - y1;
		s2 = 1;
	}

	xchange = 0;   

	if (dy>dx) {
		temp = dx;
		dx = dy;
		dy = temp;
		xchange = 1;
	} 

	e = ((int)dy<<1) - dx;  
	 
	for (j=0; j<=dx; j++) {
		//video_pt(x,y,c); //640x480
		pixel_ptr = (char *)vga_pixel_ptr + (y<<10)+ x; 
		// set pixel color
		*(char *)pixel_ptr = c;	
		 
		if (e>=0) {
			if (xchange==1) x = x + s1;
			else y = y + s2;
			e = e - ((int)dx<<1);
		}

		if (xchange==1) y = y + s2;
		else x = x + s1;

		e = e + ((int)dy<<1);
	}
}

/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
/// end /////////////////////////////////////