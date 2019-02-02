///////////////////////////////////////
// Logic Analyzer test
// Test with video
// compile with
// 
///////////////////////////////////////
//=======================================================
// Logic analyser
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
// Read the alanyzer buffer
// Bus address 0xC0001000
// read 1000 words starting at offset "addr_complete"
// and wrapping at 12 bits

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

// ==========================================
// PuTTY serial terminal control codes
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
// h2f_axi_master; scratch RAM at 0xC0000000
// analyzer buffer at 0xC0001000
// analyzer control at 0xC0000000
// Change THESE if you move the SRAM in Qsys
#define FPGA_SRAM_BASE      0xC8000000
#define FPGA_SRAM_SPAN      0x00002000
#define ANALYZER_OFFSET     0x00000000
#define CONTROL_OFFSET      0x00001000
// ==========================================
/// lw_bus 
#define HW_REGS_BASE          0xff200000
#define HW_REGS_SPAN          0x00005000 

// === graphics =============================
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

// timer variables
struct timeval t1, t2;
double elapsedTime;
	
// array LUT for hex digit to binary
int hex2bin[16] = {0, 1, 10, 11, 100, 101, 110, 111, 
			       1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111};

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
	char text_top_row[40] = "DE1-SoC ARM/FPGA\0";
	char text_bottom_row[40] = "Cornell ece5760\0";
	char num_string[20], time_string[50] ;
	
	// a pixel from the video
	int pixel_color;
	
	// clear the screen
	VGA_box (0, 0, 639, 479, dark_blue);
	// clear the text
	VGA_text_clear();
	VGA_text (1, 56, text_top_row);
	VGA_text (1, 57, text_bottom_row);
	
	//VGA_line(0, 10, 639, 470, green) ;
	// ===========================================
	unsigned int logic_data[1024] ;
	int logic_arm, trigger_count=500, trigger_mask, trigger_value ;
	int initial_addr ;
	int i, i_wrap, j, jj, fmt, lower_limit, upper_limit;
	unsigned int data_word;

	trigger_count = 512 ;
	// trigger_count is the numbr of samples AFTER the trigger
	// -- 100 < trigger_count < 900
	// trigger_mask are the bits that matter to the application
	// -- For example, 0h0000ffff, will only look at the lowr 16 bits
	// trigger_value is the exact bit patttern in the trigger word to match
	// -- For example, with the mask above, 0h0f001000 will cause a trigger 
	// -- when the trigger word equals 0hxxxx1000, where x means "don't care"
	
	// print limits realative to tirgger
	lower_limit = -500 ;
	upper_limit = 500 ;
	fmt = 2;
	while(1) 
	{
		// slow it down for testing
		normal_text;
		printf("\n\r enter trigger mask, trigger value\n\r");
		scanf("%x %x", &trigger_mask, &trigger_value ); 
		
		// === setup ===
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
		
		// print a few data values around the trigger point
		// trigger point is initial_addr-1
		clrscr();
		cursor_pos(1,5);
		green_text;
		printf("--trig_mask=%x -- trig_value=%x \n\r", trigger_mask, trigger_value);
		printf("count                                 state\n\r");
		normal_text;
		j = 0;
		
		// initial_addr contains the offset into the data memory
		// at the trigger sample + 1
		// range is 0-1023
		// --To read the data after the trigger:
		// read from initial_addr up for 500 samples, 
		//    if addr>1023 and more to read, then read from zero
		// -- To read the data before the trigger
		
		for (i=lower_limit; i<upper_limit; i++) {
			//if (intial_addr + i > 1023) i_wrap = i - 1023;
			//else i_wrap = i ;
			i_wrap = (initial_addr + i) & 0x3ff ; 
			logic_data[j] = *(analyzer_sram_ptr + i_wrap) ;
			j++;
		}
		
		// now print the array
		// for (i=0; i<1000; i++){
			// printf(" %08x ", logic_data[i]);
			// if (i==499) printf(" <-- trigger sample\n\r");
			// else printf("\n\r");	
		// }
		
		
		if (fmt==1){ // hex format
			for (i=0; i<100; i++) {
				printf("%x %d ", 
					*(analyzer_sram_ptr+initial_addr-1+i) & 0x0fffffff,
					*(analyzer_sram_ptr+initial_addr-1+i)>>28);
				if (i==499) printf("-- trigger sample\n\r");
				else printf("\n\r");
			}
		}
		else if (fmt==2){
			for (i=0; i<1000; i++) {
				data_word = logic_data[i] & 0x0fffffff ;
				printf("%07x ", data_word);
				// convert to binary
				jj = 0;
				for(j=24; j>=0; j=j-4){
					if(jj==0){ normal_text; jj=1;}
					else {yellow_text; jj=0;}
					printf("%04d", hex2bin[(data_word>>j) & 0x0f]);
				}
				normal_text;
				printf("  %d", logic_data[i]>>28);
				if (i==499) printf(" <-- trigger sample\n\r");
				else printf("\n\r");
			}	
		}
		
		
		// Clear the done flag which signals the FPGA to start
		// logging data again.
		*(control_sram_ptr+250) = 0;
		
	} // end while(1)
} // end main

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