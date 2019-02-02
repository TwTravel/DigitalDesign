///////////////////////////////////////////////////////////////////////
// Mouse test from 
// http://stackoverflow.com/questions/11451618/how-do-you-read-the-mouse-button-state-from-dev-input-mice
//
// Native ARM GCC Compile: gcc mouse_test.c -o mouse
//
///////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <sys/time.h> 
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <pthread.h>


//#include "address_map_arm_brl4.h"

// video display
#define SDRAM_BASE            0xC0000000
#define SDRAM_END             0xC3FFFFFF
#define SDRAM_SPAN			  0x04000000
// characters
#define FPGA_CHAR_BASE        0xC9000000 
#define FPGA_CHAR_END         0xC9001FFF
#define FPGA_CHAR_SPAN        0x00002000
/* Cyclone V FPGA devices */
#define HW_REGS_BASE          0xff200000
//#define HW_REGS_SPAN        0x00200000 
#define HW_REGS_SPAN          0x00005000 

#define HW_REGS_BASE 0xff200000
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )
#define XCOORD_BASE	0x00
#define YCOORD_BASE	0x10
#define DIR_BASE	0x20
#define LEFT_CLICK_BASE	0x30
#define RIGHT_CLICK_BASE	0x40

int main(int argc, char** argv)
{
	
	
	
    volatile unsigned int *h2p_lw_x_coord_addr=NULL;
    volatile unsigned int *h2p_lw_y_coord_addr=NULL;
    volatile unsigned int *h2p_lw_dir_addr=NULL;
    volatile unsigned int *h2p_lw_left_click_addr=NULL;
    volatile unsigned int *h2p_lw_right_click_addr=NULL;
   

    void *h2p_lw_virtual_base;
    int fd;
    // === HPS switch ===
    volatile unsigned int *led_addr=NULL;
    void *virtual_base_gpio;
    // ================= 
    //volatile int i;
    
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
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}


   //set pointers to the corresponding pio ports for initial conditions, constants, hw clk and reset, and outputs
	h2p_lw_x_coord_addr = (volatile unsigned int *)(h2p_lw_virtual_base + XCOORD_BASE);
	//printf("actual location: %x\n", (unsigned int) h2p_lw_ix1_addr);
	h2p_lw_y_coord_addr = (volatile unsigned int *)(h2p_lw_virtual_base + YCOORD_BASE);
	h2p_lw_dir_addr = (volatile unsigned int *)(h2p_lw_virtual_base + DIR_BASE);
	h2p_lw_left_click_addr = (volatile unsigned int *)(h2p_lw_virtual_base + LEFT_CLICK_BASE);
	h2p_lw_right_click_addr = (volatile unsigned int *)(h2p_lw_virtual_base + RIGHT_CLICK_BASE);
	
	int current_x = 320;
	int current_y = 240;

	int bytes;
    //int fd, bytes;
    unsigned char data[3];

    const char *pDevice = "/dev/input/mice";

    // Open Mouse
    fd = open(pDevice, O_RDWR);
    if(fd == -1)
    {
        printf("ERROR Opening %s\n", pDevice);
        return -1;
    }
	//needed for nonblocking read()
	int flags = fcntl(fd, F_GETFL, 0);
	fcntl(fd, F_SETFL, flags | O_NONBLOCK); 
	
    int left, middle, right;
    signed char x, y;
	int curr_x_velocity, curr_y_velocity, prev_x_velocity, prev_y_velocity;
	
	//initialize previous velocities to zero
	prev_x_velocity = 0;
	prev_y_velocity = 0;
	int direction;
	int count = 0;
    while(1)
    {
        // Read Mouse     
        bytes = read(fd, data, sizeof(data));

        if(bytes > 0)
        {
            left = data[0] & 0x1;
            right = data[0] & 0x2;
            middle = data[0] & 0x4;

            x = data[1];
            y = data[2];
			
			if( (current_x + (int) x)<640 && (current_x + (int) x) >= 0 ){
				current_x += (int) x;
				//curr_x_velocity = (int) x;
				curr_x_velocity = current_x;
			}
			if( (current_y - (int) y)<480 && (current_y - (int) y) >= 0 ){
				current_y -= (int) y;
				//curr_y_velocity = (int) y * -1;
				curr_y_velocity = current_y;
			}
			//update every 3 reads to smooth out motion
			if (count == 3){
			//get direction depending on change in velocity for each frame
				prev_x_velocity = curr_x_velocity;
				prev_y_velocity = curr_y_velocity;
				
				count = 0;
			}
			count++;
			
			//decode direction to send to FPGA
			if( curr_x_velocity > prev_x_velocity && curr_y_velocity > prev_y_velocity ) direction = 6;
			else if( curr_x_velocity == prev_x_velocity && curr_y_velocity > prev_y_velocity ) direction = 4;
			else if( curr_x_velocity < prev_x_velocity && curr_y_velocity > prev_y_velocity ) direction = 8;
			else if( curr_x_velocity < prev_x_velocity && curr_y_velocity == prev_y_velocity ) direction = 2;
			else if( curr_x_velocity < prev_x_velocity && curr_y_velocity < prev_y_velocity ) direction = 5;
			else if( curr_x_velocity == prev_x_velocity && curr_y_velocity < prev_y_velocity ) direction = 3;
			else if( curr_x_velocity > prev_x_velocity && curr_y_velocity < prev_y_velocity ) direction = 7;
			else if( curr_x_velocity > prev_x_velocity && curr_y_velocity == prev_y_velocity ) direction = 1;
			
			//write to PIO ports
			*h2p_lw_x_coord_addr = current_x;
			*h2p_lw_y_coord_addr = current_y;
			*h2p_lw_dir_addr = direction;
			*h2p_lw_left_click_addr =  left;
			*h2p_lw_right_click_addr = right>>1;
			
			
			printf("direction = %d, current x=%d, current y=%d, left=%d\n", direction, current_x, current_y, left);

        }   
    }
    return 0; 
}
	