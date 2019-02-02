//////////////////////////////////////
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
#include <math.h>

/* function prototypes */
void VGA_text (int, int, char *);
void VGA_text_clear();
void VGA_box (int, int, int, int, short);
void VGA_line(int, int, int, int, short) ;
void VGA_disc (int, int, int, short);
void draw_main_screen();
void draw_instr1();
void draw_instr2();
void draw_instr3();
void draw_play();
//void glider_gu


// the light weight buss base
void *h2p_lw_virtual_base;
void *switch_virtual_base;
void *led_virtual_base;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
volatile unsigned int * switch_address= NULL;
void *vga_pixel_virtual_base;

// character buffer
volatile unsigned int * vga_char_ptr = NULL ;
volatile unsigned int * base_ptr;
volatile unsigned int * switch_ptr;
volatile unsigned int * led_ptr;
void *vga_char_virtual_base;

char text_top_row[40]="Welcome to the Big Red Strings!\0";
char text_bottom_row[40]="Select a song to play:\0";
char text1[40]="Select the melody's instrument:\0";
char text2[40]="Select the harmony's instrument:\0";
char text3[40]="Select the third instrument:\0";
char text4[40]="Push Play to Start the Song!\0";
char song_title[40];
char command[40];
//PIO address offsets

#define THREE_SF .0046875
#define TWO_FHE .00416666666
#define TWO_TT 8388608
#define instr_port 0x00001900
// /dev/mem file id
int fd;

// shared memory 
key_t mem_key=0xf0;
int shared_mem_id; 
int *shared_ptr;
int shared_time;
int shared_note;
char shared_str[64];
char num_string[32],char_string[40];

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
    

	// === get VGA char addr =====================
	// get virtual addr that maps to physical
        vga_pixel_virtual_base = mmap(NULL, FPGA_ONCHIP_SPAN, (PROT_READ|PROT_WRITE), MAP_SHARED, fd, FPGA_ONCHIP_BASE);
	if( vga_pixel_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}


        vga_char_virtual_base = mmap(NULL, FPGA_CHAR_SPAN, (PROT_READ|PROT_WRITE), MAP_SHARED, fd, FPGA_CHAR_BASE);

        vga_char_ptr = (unsigned int *)(vga_char_virtual_base);
 
    // Get the address that maps to the FPGA pixel buffer
	vga_pixel_ptr =(unsigned int *)(vga_pixel_virtual_base);
        led_ptr=(unsigned int *)(h2p_lw_virtual_base);
        unsigned int *instr_ptr=(unsigned int *)(h2p_lw_virtual_base+instr_port);
	// ===========================================

	/* create a message to be displayed on the VGA 
          and LCD displays */
//	char text_top_row[40] = "DE1-SoC ARM/FPGA\0";
//	char text_bottom_row[40] = "Cornell ece5760\0";
//	char num_string[20], time_string[40] ;

	
	// clear the screen and initialize all pointers to entire screen
       // VGA_box (0, 0, 639, 479, 0x00);
        float xinit, yinit, xend,yend,delta_x,delta_y, y_diff;
        float xinit_prev, yinit_prev, xend_prev, yend_prev;
        float tot_delta_x, tot_delta_y;
        int max_count;
        //initialize mouse stuff
        int mouse_fd, mouse_bytes;
        unsigned char mouse_data[3];
        unsigned char *pDevice= "/dev/input/mice";
        mouse_fd=open(pDevice,O_RDWR);
        if (mouse_fd==-1){
                printf("Error opening %s\n",pDevice);
                return -1;
        }
        
        int left, right,screen, prev_screen;
        signed char x,y;
        int flags=fcntl(mouse_fd,F_GETFL,0);
        fcntl(mouse_fd,F_SETFL,flags | O_NONBLOCK);
        int mouse_x=0, mouse_y=0;
        
        //Initialize switches
        int SW_value;
        int instruments;
        //Initialize to full screen
        screen=0;
        prev_screen=5;
        VGA_box (0, 0, 679,479, 0x00);
        VGA_text_clear();
        while(1){
               if (screen==0){
                        if (prev_screen==5){
                                VGA_box(0,0,679,479,0x00);
                                VGA_text_clear();
                                prev_screen=0;
                        }
                        draw_main_screen();
                } 
                else if (screen==1){
                        if (prev_screen==0){
                                VGA_box(0,0,679,479,0x00);
                                VGA_text_clear();
                                prev_screen=1;
                        }
                        draw_instr1();
                }
                else if (screen==2){
                        if (prev_screen==1){
                                VGA_box(0,0,679,479,0x00);
                                VGA_text_clear();
                                prev_screen=2;
                        }
                        draw_instr2();
                }
                else if (screen==3){
                        if (prev_screen==2){
                                VGA_box(0,0,679,479,0x00);
                                VGA_text_clear();
                                prev_screen=3;
                        }
                        draw_instr3();
                }
                else if (screen==4){
                        if (prev_screen==3){
                                VGA_box(0,0,679,479,0x00);
                                VGA_text_clear();
                                prev_screen=4;
                        }
                        draw_play();
                }
               // printf("Time = %6.3f\n", elapsedTime);               
 
                mouse_bytes=read(mouse_fd,mouse_data,sizeof(mouse_data));
                if (mouse_bytes>0){
                       // VGA_erase_mouse(mouse_x,mouse_y);
                        VGA_PIXEL(mouse_x,mouse_y,0x00);
                        left=mouse_data[0]&0x1;
                        right=mouse_data[0]&0x2;
                        x=mouse_data[1];
                        y=mouse_data[2];
                        mouse_x+=x/2;
                        mouse_y-=y/2;
                        if (mouse_x<0){
                                mouse_x = 0;
                        }
                        if (mouse_x>639){
                                mouse_x=639;
                        }

                        if (mouse_y<0){
                                mouse_y = 0;
                        }
                        if (mouse_y>479){
                                mouse_y=479;
                        }
                        if (left==1){
                                if (screen==0){
                                        if (mouse_x>=100 && mouse_x<=500){
                                                if (mouse_y>=100 && mouse_y<=125){
                                                        strcpy(song_title,"All of Me\0");
                                                        strcpy(command,"./string_synth5 ./music/allofme_lh.txt ./music/allofme_rh.txt ./music/test.txt");
                                                }
                                                else if (mouse_y>=126 && mouse_y<151){
                                                        strcpy(song_title,"Colors of the Wind\0");
                                                        strcpy(command,"./string_synth5 ./music/colors.txt ./music/colors.txt ./music/colors.txt");
                                                }       
                                                else if (mouse_y>=152 && mouse_y<177){
                                                        strcpy(song_title,"Far Above Cayuga's Waters\0");
                                                        strcpy(command,"./string_synth5 ./music/almamater_lh.txt ./music/almamater_rh.txt ./music/almamater_hh.txt");
                                                }       
                                                else if (mouse_y>=178 && mouse_y<203){
                                                        strcpy(song_title,"Kaze ni Naru\0");
                                                        strcpy(command,"./string_synth5 ./music/kazeninaruMid.txt ./music/kazeninaruUpper.txt ./music/kazeninaruUpper.txt");
                                                }       
                                
                                       } 
                                screen=1;
                                prev_screen=0;      
                                }
                                else if (screen==1){
                                        if (mouse_x>=100 && mouse_x<=500){
                                                if (mouse_y>=100 && mouse_y<=125){
                                                        instruments=instruments+0;
                                                }
                                                else if (mouse_y>=126 && mouse_y<151){
                                                        instruments=instruments+16;
                                                }       
                                                else if (mouse_y>=152 && mouse_y<177){
                                                        instruments=instruments+32;
                                                }       
                                
                                       } 
                                screen=2;
                                prev_screen=1;      
                                }
                                else if (screen==2){
                                        if (mouse_x>=100 && mouse_x<=500){
                                                if (mouse_y>=100 && mouse_y<=125){
                                                        instruments=instruments+0;
                                                }
                                                else if (mouse_y>=126 && mouse_y<151){
                                                        instruments=instruments+4;
                                                }       
                                                else if (mouse_y>=152 && mouse_y<177){
                                                        instruments=instruments+8;
                                                }       
                                
                                       } 
                                screen=3;
                                prev_screen=2;      
                                }
                                else if (screen==3){
                                        if (mouse_x>=100 && mouse_x<=500){
                                                if (mouse_y>=100 && mouse_y<=125){
                                                        instruments=instruments+0;
                                                }
                                                else if (mouse_y>=126 && mouse_y<151){
                                                        instruments=instruments+1;
                                                }       
                                                else if (mouse_y>=152 && mouse_y<177){
                                                        instruments=instruments+2;
                                                }       
                                
                                       } 
                                screen=4;
                                prev_screen=3;
                                *instr_ptr=instruments;      
                                }
                                else if (screen==4){
                                        if (mouse_x>=200 && mouse_x<=500){
                                                if (mouse_y>=100 && mouse_y<=175){
                                                        system(command);
                                                }
                                
                                       } 
                                screen=0;
                                prev_screen=5;      
                                }
                        }/*else if (right==2){
                        } */


            
                
                VGA_PIXEL(mouse_x,mouse_y,0xff);
                }


                }
		
} // end main

/****************************************************************************************
 * Subroutine to send a string of text to the VGA monitor 
****************************************************************************************/
void draw_main_screen(){
        VGA_text(22,5,text_top_row);
        VGA_text(27,10, text_bottom_row);
        VGA_box(100,100,500,125,0xE9);
        VGA_text(22,14,"All of Me\0");
        VGA_box(100,126,500,151,0xF9);
        VGA_text(22,17,"Colors of the Wind\0");
        VGA_box(100,152,500,177,0x31);
        VGA_text(22,20,"Far Above Cayuga's Waters\0");
        VGA_box(100,178,500,203,0x16);
        VGA_text(22,23,"Kaze ni Naru\0");
}
void draw_instr1(){
        VGA_text(27,10, text1);
        VGA_box(100,100,500,125,0xE9);
        VGA_text(22,14,"Instrument 1\0");
        VGA_box(100,126,500,151,0xF9);
        VGA_text(22,17,"Instrument 2\0");
        VGA_box(100,152,500,177,0x16);
        VGA_text(22,20,"Instrument 3\0");
}
void draw_instr2(){
        VGA_text(27,10, text2);
        VGA_box(100,100,500,125,0xE9);
        VGA_text(22,14,"Instrument 1\0");
        VGA_box(100,126,500,151,0xF9);
        VGA_text(22,17,"Instrument 2\0");
        VGA_box(100,152,500,177,0x16);
        VGA_text(22,20,"Instrument 3\0");
}
void draw_instr3(){
        VGA_text(27,10, text3);
        VGA_box(100,100,500,125,0xE9);
        VGA_text(22,14,"Instrument 1\0");
        VGA_box(100,126,500,151,0xF9);
        VGA_text(22,17,"Instrument 2\0");
        VGA_box(100,152,500,177,0x16);
        VGA_text(22,20,"Instrument 3\0");
}
void draw_play(){
        VGA_text(27,10, text4);
        VGA_box(200,100,500,175,0xE9);
        VGA_text(30,17,"Play\0");
}


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
        //check bound
        if(x<1) {
               x = 2; 
        }
        if(x>602) {
               x = 601;
        }
        if(y<1) {
               y = 2;
        }
        if (y>470) {
               y=469;
        }
	
        //draw glider
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

        //draw slider glider gun
	VGA_PIXEL(xd+x+xs*1,yd+y+ys*5,0xff);
	VGA_PIXEL(xd+x+xs*1,yd+y+ys*6,0xff);
	VGA_PIXEL(xd+x+xs*2,yd+y+ys*5,0xff);
	VGA_PIXEL(xd+x+xs*2,yd+y+ys*6,0xff);
	VGA_PIXEL(xd+x+xs*11,yd+y+ys*5,0xff);
	VGA_PIXEL(xd+x+xs*11,yd+y+ys*6,0xff);
	VGA_PIXEL(xd+x+xs*11,yd+y+ys*7,0xff);
	VGA_PIXEL(xd+x+xs*12,yd+y+ys*4,0xff);
	VGA_PIXEL(xd+x+xs*12,yd+y+ys*8,0xff);
	VGA_PIXEL(xd+x+xs*13,yd+y+ys*3,0xff);
	VGA_PIXEL(xd+x+xs*13,yd+y+ys*9,0xff);
	VGA_PIXEL(xd+x+xs*14,yd+y+ys*3,0xff);
	VGA_PIXEL(xd+x+xs*14,yd+y+ys*9,0xff);
	VGA_PIXEL(xd+x+xs*15,yd+y+ys*6,0xff);
	VGA_PIXEL(xd+x+xs*16,yd+y+ys*4,0xff);
	VGA_PIXEL(xd+x+xs*16,yd+y+ys*8,0xff);
	VGA_PIXEL(xd+x+xs*17,yd+y+ys*5,0xff);
	VGA_PIXEL(xd+x+xs*17,yd+y+ys*6,0xff);
	VGA_PIXEL(xd+x+xs*17,yd+y+ys*7,0xff);
	VGA_PIXEL(xd+x+xs*18,yd+y+ys*6,0xff);
	
}

/****************************************************************************************
 * Draw pi shape 
****************************************************************************************/
void pi(int mouse_x, int mouse_y){
        //check bound
        if(mouse_x<1) {
                mouse_x = 2; 
        }
        if(mouse_x>638) {
                mouse_x = 637;
        }
        if(mouse_y<1) {
                mouse_y = 2;
        }
        if (mouse_y>478) {
                mouse_y=477;
        }
        
        //update life with pi
        life[mouse_x][mouse_y-1]=1;
        life[mouse_x-1][mouse_y-1]=1;
        life[mouse_x+1][mouse_y-1]=1;
        life[mouse_x-1][mouse_y]=1;
        life[mouse_x-1][mouse_y+1]=1;
        life[mouse_x+1][mouse_y]=1;
        life[mouse_x+1][mouse_y+1]=1;

        //draw pi
        VGA_PIXEL(mouse_x,mouse_y-1,0xff);
        VGA_PIXEL(mouse_x-1,mouse_y-1,0xff);
        VGA_PIXEL(mouse_x+1,mouse_y-1,0xff);
        VGA_PIXEL(mouse_x-1,mouse_y,0xff);
        VGA_PIXEL(mouse_x-1,mouse_y+1,0xff);
        VGA_PIXEL(mouse_x+1,mouse_y,0xff);
        VGA_PIXEL(mouse_x+1,mouse_y+1,0xff);
} 


/****************************************************************************************
 * Draw Mouse Cursor 
****************************************************************************************/
void VGA_draw_mouse(int mouse_x, int mouse_y){
        

	//VGA_PIXEL(mouse_x,mouse_y,0xff);
	if(!life[mouse_x-1][mouse_y]){
                VGA_PIXEL(mouse_x-1,mouse_y,0xff);
        }
	if(!life[mouse_x+1][mouse_y]){
                VGA_PIXEL(mouse_x+1,mouse_y,0xff);
	}
        if(!life[mouse_x][mouse_y-1]){
                VGA_PIXEL(mouse_x,mouse_y-1,0xff);
        }
        if(!life[mouse_x][mouse_y+1]){
                VGA_PIXEL(mouse_x,mouse_y+1,0xff);
        }

}


/****************************************************************************************
 * Erase Mouse Cursor 
****************************************************************************************/
void VGA_erase_mouse(int mouse_x, int mouse_y){
        
	//VGA_PIXEL(mouse_x,mouse_y,0x00);
	if (!life[mouse_x-1][mouse_y]){
                VGA_PIXEL(mouse_x-1,mouse_y,0x00);
        }
        if (!life[mouse_x+1][mouse_y]){
	        VGA_PIXEL(mouse_x+1,mouse_y,0x00);
        }
        if (!life[mouse_x][mouse_y-1]){
	        VGA_PIXEL(mouse_x,mouse_y-1,0x00);
        }
        if (!life[mouse_x][mouse_y+1]){
	        VGA_PIXEL(mouse_x,mouse_y+1,0x00);
        }
}



///////////////////////////////////////
/// 640x480 version!
/// This code will segfault the original
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
