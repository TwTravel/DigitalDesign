///////////////////////////////////////
/// 640x480 version!
/// This code will segfault the original
/// DE1 computer
/// compile with
/// gcc life_video_2.c -o life -O2
/// -- no optimization yields ??? execution time
/// -- opt -O1 yields ??? mS execution time
/// -- opt -O2 yields ??? mS execution time
/// -- opt -O3 yields ??? mS execution time
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
#include "address_map_arm_brl4.h"

/* function prototypes */
void VGA_text (int, int, char *);
void VGA_text_clear();
void VGA_box (int, int, int, int, short);
void VGA_line(int, int, int, int, short) ;
void VGA_disc (int, int, int, short);
int  VGA_read_pixel(int, int) ;
void glider_gun(int, int, int, int);

// the light weight buss base
void *h2p_lw_virtual_base;
volatile unsigned int *h2p_lw_video_in_control_addr=NULL;
volatile unsigned int *h2p_lw_video_edge_control_addr=NULL;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
void *vga_pixel_virtual_base;

// character buffer
volatile unsigned int * vga_char_ptr = NULL ;
void *vga_char_virtual_base;

// /dev/mem file id
int fd;

// shared memory 
key_t mem_key=0xf0;
int shared_mem_id; 
int *shared_ptr;
int shared_time;
int shared_note;
char shared_str[64];

// pixel macro
#define VGA_PIXEL(x,y,color) do{\
	char  *pixel_ptr ;\
	pixel_ptr = (char *)vga_pixel_ptr + ((y)<<10) + (x) ;\
	*(char *)pixel_ptr = (color);\
} while(0)
	

// game of life array
// bottom bit is current state
// next bit is next state
char life[640][480] ; //char life[640][480] ;
char life_new[640][480] ;
int i, j, count, total_count;
int sum ;

// measure time
struct timeval t1, t2;
double elapsedTime;
	
int main(void)
{
	//int x1, y1, x2, y2;

	// Declare volatile pointers to I/O registers (volatile 	// means that IO load and store instructions will be used 	// to access these pointer locations, 
	// instead of regular memory loads and stores) 

	// === shared memory =======================
	// with video process
	shared_mem_id = shmget(mem_key, 100, IPC_CREAT | 0666);
 	//shared_mem_id = shmget(mem_key, 100, 0666);
	shared_ptr = shmat(shared_mem_id, NULL, 0);

  	
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
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}
    h2p_lw_video_in_control_addr=(volatile unsigned int *)(h2p_lw_virtual_base+VIDEO_IN_BASE+0x0c);
	*(h2p_lw_video_in_control_addr) = 0x04 ; // turn on video capture
	h2p_lw_video_edge_control_addr=(volatile unsigned int *)(h2p_lw_virtual_base+VIDEO_IN_BASE+0x10);
	*h2p_lw_video_edge_control_addr = 0x01 ; // 1 means edges
	*h2p_lw_video_edge_control_addr = 0x00 ; // 1 means edges
	
	// === get VGA char addr =====================
	// get virtual addr that maps to physical
	vga_char_virtual_base = mmap( NULL, FPGA_CHAR_SPAN, ( 	PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_CHAR_BASE );	
	if( vga_char_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap2() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA LED control 
	vga_char_ptr =(unsigned int *)(vga_char_virtual_base);

	// === get VGA pixel addr ====================
	// get virtual addr that maps to physical
	vga_pixel_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( 	PROT_READ | PROT_WRITE ), MAP_SHARED, fd, 			FPGA_ONCHIP_BASE);	
	if( vga_pixel_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA pixel buffer
	vga_pixel_ptr =(unsigned int *)(vga_pixel_virtual_base);

	// ===========================================

	/* create a message to be displayed on the VGA 
          and LCD displays */
	char text_top_row[40] = "DE1-SoC ARM/FPGA\0";
	char text_bottom_row[40] = "Cornell ece5760\0";
	char num_string[20], time_string[50] ;
	
	// a pixel from the video
	int pixel_color;
	
	// clear the screen
	VGA_box (0, 0, 639, 479, 0x00);
	// clear the text
	VGA_text_clear();
	VGA_text (1, 1, text_top_row);
	VGA_text (1, 2, text_bottom_row);
	
	// start timer
    //gettimeofday(&t1, NULL);
	
	// zero global counter
	total_count = 0 ;
	
	// init a small pattern "PI"
	// life[320][240] = 1;
	// life[319][240] = 1;
	// life[321][240] = 1;
	// life[319][241] = 1;
	// life[319][242] = 1;
	// life[321][241] = 1;
	// life[321][242] = 1;
	
	// initialize a "gun". 
	glider_gun(150,100, 1, 1);
	glider_gun(400,100, -1, 1);
	glider_gun(150,400, 1, -1);
	glider_gun(400,400, -1, -1);
	//glider_gun(200,200, 1, 1); // no symmetry
	//glider_gun(300,400, -1, -1); // no symmetry
	
	// these 3 make a 2:1 rate divider and absrob the beam
	//glider_gun(200,200, 1, 1); // no symmetry
	//glider_gun(150,400, 1, -1);
	//glider_gun(400,400, -1, -1);
	
	// rand seed from time of day
	//gettimeofday(&t1,NULL);
     // microsecond has 1 000 000
     // Assuming you did not need quite that accuracy
     // Also do not assume the system clock has that accuracy.
    // srand((t1.tv_sec * 1000) + (t1.tv_usec / 1000));
	// init the main state array
	// for (i=50; i<589; i++) {
		// for (j=50; j<459; j++) {
			// life[i][j] = (rand() & 0xb11) == 1 ;
			// if (i==320) life[i][j] = 1;
			// if (j==240) life[i][j] = 1;
		// }
	// }
	count = 0;
	// draw the initial pattern
	for (i=1; i<639; i++) {
		for (j=1; j<479; j++) {
			//if (i==320) life[i][j] = 1;
			VGA_PIXEL(i,j,0xff*life[i][j]);		
		}
	}
	
	while(1) 
	{
		 gettimeofday(&t1, NULL);
		//leave the edges at zero for all time 
		for (i=1; i<639; i++) {
			for (j=1; j<479; j++) {
				sum = life[i-1][j-1] + life[i][j-1] + life[i+1][j-1] +
				      life[i-1][j]                  + life[i+1][j] +
					  life[i-1][j+1] + life[i][j+1] + life[i+1][j+1] ;
				if (sum == 3) {
					life_new[i][j] = 1;
					if(life[i][j]==0) VGA_PIXEL(i,j,0xff);
				}
				else if (sum == 2) {
					life_new[i][j] = life[i][j] ;
				}
				else {
					life_new[i][j] = 0;
					if(life[i][j]==1) VGA_PIXEL(i,j,0x00);
				}
			}
		}
		
		// update the main state array
		// for (i=1; i<639; i++) {
			// for (j=1; j<479; j++) {
				// life[i][j] = life_new[i][j] ;
			// }
		// }
		memcpy(life, life_new, sizeof(life));
		count++;
		//VGA_text (10, 1, text_top_row);
	    //VGA_text (10, 2, text_bottom_row);
		
		// stop timer
		 gettimeofday(&t2, NULL);
		 elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
		 elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms
		 pixel_color = VGA_read_pixel(160,120);
		// sprintf(num_string, "# = %d     ", total_count);
		 sprintf(time_string, "T=%3.0fmS gen=%d  color=%x ", elapsedTime, count, pixel_color);
		// VGA_text (10, 3, num_string);
		 VGA_text (1, 58, time_string);
		
	} // end while(1)
} // end main

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
	for (x=0; x<70; x++){
		for (y=0; y<40; y++){
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

//////////////////////////////////////////////////////////
// glider gun
//////////////////////////////////////////////////////////
// x, y is the base postion
// x_orient and y_orient must be 1 or -1
// the -1 flips the orientation
void glider_gun(int x, int y, int x_orient, int y_orient){
	int xd=0, yd=0, xs=1, ys=1;
	if (x_orient==-1) {
		xd = 37;
		xs = -1;
	}
	if (y_orient==-1) {
		yd = 9;
		ys = -1;
	}
	life[xd+x+xs*1][yd+y+ys*5]=1;
	life[xd+x+xs*1][yd+y+ys*6]=1;
	life[xd+x+xs*2][yd+y+ys*5]=1;
	life[xd+x+xs*2][yd+y+ys*6]=1;
	life[xd+x+xs*11][yd+y+ys*5]=1;
	life[xd+x+xs*11][yd+y+ys*6]=1;
	life[xd+x+xs*11][yd+y+ys*7]=1;
	life[xd+x+xs*12][yd+y+ys*4]=1;
	life[xd+x+xs*12][yd+y+ys*8]=1;
	life[xd+x+xs*13][yd+y+ys*3]=1;
	life[xd+x+xs*13][yd+y+ys*9]=1;
	life[xd+x+xs*14][yd+y+ys*3]=1;
	life[xd+x+xs*14][yd+y+ys*9]=1;
	life[xd+x+xs*15][yd+y+ys*6]=1;
	life[xd+x+xs*16][yd+y+ys*4]=1;
	life[xd+x+xs*16][yd+y+ys*8]=1;
	life[xd+x+xs*17][yd+y+ys*5]=1;
	life[xd+x+xs*17][yd+y+ys*6]=1;
	life[xd+x+xs*17][yd+y+ys*7]=1;
	life[xd+x+xs*18][yd+y+ys*6]=1;
	life[xd+x+xs*21][yd+y+ys*3]=1;
	life[xd+x+xs*21][yd+y+ys*4]=1;
	life[xd+x+xs*21][yd+y+ys*5]=1;
	life[xd+x+xs*22][yd+y+ys*3]=1;
	life[xd+x+xs*22][yd+y+ys*4]=1;
	life[xd+x+xs*22][yd+y+ys*5]=1;
	life[xd+x+xs*23][yd+y+ys*2]=1;
	life[xd+x+xs*23][yd+y+ys*6]=1;
	life[xd+x+xs*25][yd+y+ys*1]=1;
	life[xd+x+xs*25][yd+y+ys*2]=1;
	life[xd+x+xs*25][yd+y+ys*6]=1;
	life[xd+x+xs*25][yd+y+ys*7]=1;
	life[xd+x+xs*35][yd+y+ys*3]=1;
	life[xd+x+xs*35][yd+y+ys*4]=1;
	life[xd+x+xs*36][yd+y+ys*3]=1;
	life[xd+x+xs*36][yd+y+ys*4]=1;	
	
}