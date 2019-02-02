///////////////////////////////////////
/// 640x480 version!
/// test VGA with hardware video input copy to VGA
// compile with
// gcc FP_DDA_2nd_order_heun.c -o fp1 -lm -O3
///////////////////////////////////////
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

/* function prototypes */
void VGA_text (int, int, char *);
void VGA_text_clear();
void VGA_box (int, int, int, int, short);
void VGA_line(int, int, int, int, short) ;
void VGA_disc (int, int, int, short);
int  VGA_read_pixel(int, int) ;
int  video_in_read_pixel(int, int);
void draw_delay(void) ;
// FP
unsigned int floatToReg27(float) ;
float reg27ToFloat(unsigned int) ;

// the light weight buss base
void *h2p_lw_virtual_base;

// RAM FPGA command buffer
volatile unsigned int * sram_ptr = NULL ;
void *sram_virtual_base;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
void *vga_pixel_virtual_base;

// character buffer
volatile unsigned int * vga_char_ptr = NULL ;
void *vga_char_virtual_base;

// /dev/mem file id
int fd;

// pixel macro
// #define VGA_PIXEL(x,y,color) do{\
	// char  *pixel_ptr ;\
	// pixel_ptr = (char *)vga_pixel_ptr + ((y)<<10) + (x) ;\
	// *(char *)pixel_ptr = (color);\
// } while(0)
	
// pixel macro
#define VGA_PIXEL(x,y,color) do{\
	char  *pixel_ptr ;\
	pixel_ptr = (char *)vga_pixel_ptr + ((y)<<10) + (x) ;\
	*(char *)pixel_ptr = (color);\
} while(0)
	

// measure time
struct timeval t1, t2;
double elapsedTime;
struct timespec delay_time ;
	
int main(void)
{
	delay_time.tv_nsec = 10 ;
	delay_time.tv_sec = 0 ;

	// Declare volatile pointers to I/O registers (volatile 	// means that IO load and store instructions will be used 	// to access these pointer locations, 
	// instead of regular memory loads and stores) 
  	
	// === need to mmap: =======================
	// FPGA_CHAR_BASE
	// FPGA_ONCHIP_BASE      
	// HW_REGS_BASE        
  
	// === get FPGA addresses ==================
    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
    
    // get virtual addr that maps to physical
	// for light weight bus
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}
	
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
	
	// === get RAM FPGA parameter addr =========
	sram_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_ONCHIP_BASE); //fp	
	
	if( sram_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    // Get the address that maps to the RAM buffer
	sram_ptr =(unsigned int *)(sram_virtual_base);
	
	// ===========================================

	/* create a message to be displayed on the VGA 
          and LCD displays */
	char text_top_row[40] = "DE1-SoC ARM/FPGA\0";
	char text_bottom_row[40] = "Cornell ece5760\0";
	char num_string[20], time_string[50] ;
	char title[80] = "FPGA Parallel, Floating-point, 2nd-order system\0" ;
	char title1[80] ;
	
	// a pixel from the video
	int pixel_color;
	// video input index
	int i,j;
	
	int sample_count=0;
	int vga_x = 0;
	int vga_inc = 100;
	float test ;
	float v1, v2;
	
	// 8-bit primary colors
	// 8-bit color:
	// color = B+(G<<2)+(R<<5);  max values B=3,G=7,R=7
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
	
	// clear the screen
	VGA_box (0, 0, 639, 479, black);
	// clear the text
	VGA_text_clear();
	VGA_text (1, 56, text_top_row);
	VGA_text (1, 57, text_bottom_row);
	VGA_text (10, 1, title);
	
	// get k/m, d/m, stride
	float k_m, d_m ;
	int stride, dt ;
	scanf("%f %f %d %d", &k_m, &d_m, &stride, &dt) ;
	
	*(sram_ptr+1) = floatToReg27(-k_m) ;
	// then wait
	while (*(sram_ptr) != 0) ;
	
	*(sram_ptr+2) = floatToReg27(-d_m)  ;
	// then wait
	while (*(sram_ptr) != 0) ;
	
	*(sram_ptr+3) = stride ;
	// then wait
	while (*(sram_ptr) != 0) ;
	
	*(sram_ptr+4) = dt ;
	// then wait
	while (*(sram_ptr) != 0) ;
	
	sprintf(title1, "k/m=%2.3f, d/m=%2.3f, stride=%4d, dt=2^(-%2d)", k_m, d_m, stride, dt);
	VGA_text (10, 2, title1);
	
	// sram buffer
	// [addr=0]==1 RESET
	// [addr=0]==2 sample
	// [addr=0]==3 set parameters
	
	//printf("start1\n\r");
	// set parameters
	*(sram_ptr) = 3 ;
	// then wait
	while (*(sram_ptr) != 0) ;
	
	// resest computation
	*(sram_ptr) = 1 ;
	// then wait
	while (*(sram_ptr) != 0) ;
	
	// draw the zero-lines
	VGA_line(0, 330, 639, 330, gray);
	VGA_line(0, 150, 639, 150, gray);
	vga_x = 0 ;
	
	//printf("start2\n\r");
	// start the timer for the whole solution
	gettimeofday(&t1, NULL);
	
	while(sample_count<639) 
	{
		// debug print out stuff
		// printf("v1,v2,f2,k_v1,d_v2 %f %f %f %f %f\n\r", 
		// v1, v2, 
		// reg27ToFloat(*(sram_ptr+10)),
		// reg27ToFloat(*(sram_ptr+11)),
		// reg27ToFloat(*(sram_ptr+12)));
		
		// get next sample command to FPGA
		*(sram_ptr) = 2 ;
		
		
		
		// addr=8 float v1 result
		// addr=9 float v2 result
		// read back solution from FPGA  reg27ToFloat
		v1 = reg27ToFloat(*(sram_ptr+8)) ;
		v2 = reg27ToFloat(*(sram_ptr+9)) ;
		
		VGA_PIXEL(vga_x, (int)(-v1*75+150), white);
		VGA_PIXEL(vga_x, (int)(-v2*75+330), white);
		// x-position
		vga_x++ ;
		
		// increment main counter for while loop
		sample_count++;
		// then wait for FPGA ACK
	    while (*(sram_ptr) != 0) ;
		

	} // end while(1)
		
	// // stop the timer and write it
	gettimeofday(&t2, NULL);
	elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
	elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
	sprintf(time_string, "FPGA Heun (white) T=%6.0f uSec ", elapsedTime);
	VGA_text (40, 56, time_string);
	
	///////////////////////////////////////////
	// now do Heun on the ARM /////////////////
	///////////////////////////////////////////
	// http://www.math.ubc.ca/~israel/m215/impeuler/impeuler.html
	//
	int t_limit ;
	float real_dt, v1_temp ;
	t_limit = 639*stride;
	real_dt = pow(2,-dt);
	
	float kv1, kv2, v1t, v2t, mv1, mv2 ;
	/*
    Form the slope for each variable at time=n
    kv1 = f1(v1(n), v2(n))
    kv2 = f2(v1(n), v2(n))
    Estimate one step forward for each variable
    v1t = v1 + dt*kv1
    v2t = v2 + dt*kv2
    Form the slope for each variable at time=n+1
    mv1 = f1(v1t, v2t)
    mv2 = f2(v1t, v2t)
    Average the two estimates to get the new values of V.
    v1(n+1) = v1(n) + dt*(kv1 + mv1)/2
    v2(n+1) = v2(n) + dt*(kv2 + mv2)/2
	*/
	
	// start the timer for the whole solution
	gettimeofday(&t1, NULL);
	v1 = 1.0; v2 = 0; vga_x=0;
	
	for(i=0; i<t_limit; i++){
		kv1 = v2;
		kv2 = -k_m*v1 - d_m*v2 ;
		v1t = v1 + real_dt * kv1;
		v2t = v2 + real_dt * kv2;
		mv1 = v2t;
		mv2 = -k_m*v1t - d_m*v2t ;
		v1 = v1 + real_dt * (kv1 + mv1)/2;
		v2 = v2 + real_dt * (kv2 + mv2)/2;
		
		if (i%stride==0){
			// now draw
			VGA_PIXEL(vga_x, (int)(-v1*75+150), red);
			VGA_PIXEL(vga_x, (int)(-v2*75+330), red);
			// x-position
			vga_x++ ;	
		}
	}
	
	/// stop the timer and write it
	gettimeofday(&t2, NULL);
	elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
	elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
	sprintf(time_string, "HPS Heun (red) T=%6.0f uSec ", elapsedTime);
	VGA_text (40, 57, time_string);
	
	/////////////////////////////////////////////////////
	// exact solution
	// v1 = exp(-(d_m)/2*t) * cos(sqrt(k_m-(d_m/2)^2)*t)
	// from
	// https://physics.ucf.edu/~schellin/teaching/phz3113_2011/lec10-3.pdf
	// third slide
	/////////////////////////////////////////////////////
	float t;
	
	for(i=0; i<639; i++){
		t = i * stride * real_dt ;
		v1 = exp(-d_m/2 * t) * cos(sqrt(k_m - (d_m*d_m)/4) * t);
		VGA_PIXEL(i, (int)(-v1*75+150), green);
	}
	
	// plot the time for 2 complete cycles for k/m
	// 1/sqrt((k_m)-(d_m*d_m))*(2*pi*(1/dt))*(2 cycles)/stride
	int cycles ;
	cycles = 1/sqrt((k_m)-(d_m*d_m)/4) * 2 * 6.283 * (1/real_dt) / stride ;
	VGA_line(cycles, 50, cycles, 240, green);
	sprintf(time_string, "HPS exact soln (green) ");
	VGA_text (40, 58, time_string);
} // end main

/**************************************************************************
 * Mark Eiding mje56                                                      *
 * ECE 5760                                                               *
 * Modified IEEE single precision FP                                      *
 * bit 26:      Sign     (0: pos, 1: neg)                                 *
 * bits[25:18]: Exponent (unsigned)                                       *
 * bits[17:0]:  Fraction (unsigned)                                       *
 *  (-1)^SIGN * 2^(EXP-127) * (1+.FRAC)                                   *
 * (http://en.wikipedia.org/wiki/Single-precision_floating-point_format)  *
 * Adapted from Skyler Schneider ss868                                    *
 *************************************************************************/
// Convert a C floating point into a 27-bit register floating point.
unsigned int floatToReg27(float f) {
    int f_f = (*(int*)&f);
    int f_sign = (f_f >> 31) & 0x1;
    int f_exp = (f_f >> 23) & 0xFF;
    int f_frac = f_f & 0x007FFFFF;
    int r_sign;
    int r_exp;
    int r_frac;
    r_sign = f_sign;
    if((f_exp == 0x00) || (f_exp == 0xFF)) {
        // 0x00 -> 0 or subnormal
        // 0xFF -> infinity or NaN
        r_exp = 0;
        r_frac = 0;
    } else {
        r_exp = (f_exp) & 0xFF;
        r_frac = ((f_frac >> 5)) & 0x0003FFFF;
    }
    return (r_sign << 26) | (r_exp << 18) | r_frac;
}

// Convert a 27-bit register floating point into a C floating point.
inline float reg27ToFloat(unsigned int r) {
	float result;
	int two_30 = 1073741824 ;
    int sign = (r & 0x04000000) >> 26;
    unsigned int exp = (r & 0x03FC0000) >> 18;
    int frac = (r & 0x0003FFFF);
    //float result = pow(2.0, (float) (exp-127.0));
	if (exp>=127)
		result = (float) (2<<(exp-127));
	else 
		result = (float) (two_30>>(127-exp))/two_30;
	
    result = (1.0+(((float)frac) / 262144.0)) * result;
    if(sign) result = result * (-1);
    return result;
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

#define NOP10() asm("nop;nop;nop;nop;nop;nop;nop;nop;nop;nop")

void draw_delay(void){
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10(); //16
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10(); //32
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10(); //48
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10(); //64
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10();
	NOP10(); NOP10(); NOP10(); NOP10(); //68
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10(); //80
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10();
	// NOP10(); NOP10(); NOP10(); NOP10(); //96
}

/// /// ///////////////////////////////////// 
/// end /////////////////////////////////////