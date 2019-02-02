/*********************************************************************************************************
Claire Chen and Mark Zhao
ECE 5760, Spring 2017

Attribution: Modified from Bruce Land's HPS example code

Description: Main code for HPS system
*********************************************************************************************************/

#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <sys/time.h> 
#include "address_map.h"
#include "graphics.h"
#include "vision.h"

/************************* POINTERS FOR BUS ADDRESSES**************************************/
// the light weight bus base
void *h2p_lw_virtual_base;
unsigned int *h2p_lw_video_in_control_addr=NULL;
unsigned int *h2p_lw_video_in_resolution_addr=NULL;
//volatile unsigned int *h2p_lw_video_in_control_addr=NULL;
//volatile unsigned int *h2p_lw_video_in_control_addr=NULL;

unsigned int *h2p_lw_video_edge_control_addr=NULL;

// pixel buffer
unsigned int * vga_pixel_ptr = NULL ;
void *vga_pixel_virtual_base;

// video input buffer
unsigned int * video_in_ptr = NULL ;
void *video_in_virtual_base;

// character buffer
unsigned int * vga_char_ptr = NULL ;
void *vga_char_virtual_base;

//Pushbutton address
unsigned int * pushbutton_addr = NULL;

//PIO Ports
unsigned int* PIO_red_low_addr = NULL;
unsigned int* PIO_red_high_addr = NULL;
unsigned int* PIO_green_low_addr = NULL;
unsigned int* PIO_green_high_addr = NULL;
unsigned int* PIO_orange_low_addr = NULL;
unsigned int* PIO_orange_high_addr = NULL;
unsigned int* PIO_purple_low_addr = NULL;
unsigned int* PIO_purple_high_addr = NULL;
unsigned int* PIO_yellow_low_addr = NULL;
unsigned int* PIO_yellow_high_addr = NULL;

unsigned int* PWM_timer_addr = NULL;
/**************************************************************************************/


/************************************File Descriptors and Other Pointers***************/
// /dev/mem file id
int fd;

// shared memory 
key_t mem_key=0xf0;
int shared_mem_id; 
int *shared_ptr;
int shared_time;
int shared_note;
char shared_str[64];

/**************************************************************************************/

// measure time
struct timeval t1, t2;
double elapsedTime;
struct timespec delay_time ;

int i,j;
unsigned int current_pixel_color;
//binary matrix of video frame

unsigned int bin_img[ROWS][COLS] = {0};
unsigned int eroded_img[ROWS][COLS] = {0};
unsigned int opened_img[ROWS][COLS] = {0};

char text_num_components[64];
char text_on_screen[64];
char text_num_red[32];
char text_num_green[32];
char text_num_orange[32];
char text_num_purple[32];
char text_num_yellow[32];
char text_total_red[32];
char text_total_green[32];
char text_total_orange[32];
char text_total_purple[32];
char text_total_yellow[32];

unsigned int prev_frame_label[ROWS][COLS] = {0};


//Main method	
int main(int argc, char* argv[])
{
	delay_time.tv_nsec = 10 ;
	delay_time.tv_sec = 0 ;



	/*************************Address Mapping*************************************************/

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

    h2p_lw_video_in_control_addr=(unsigned int *)(h2p_lw_virtual_base+VIDEO_IN_BASE+0x0c);
	h2p_lw_video_in_resolution_addr=(unsigned int *)(h2p_lw_virtual_base+VIDEO_IN_BASE+0x08);
	*(h2p_lw_video_in_control_addr) = 0x04 ; // turn on video capture
	*(h2p_lw_video_in_resolution_addr) = 0x00f00140 ;  // high 240 low 320
	h2p_lw_video_edge_control_addr=(unsigned int *)(h2p_lw_virtual_base+VIDEO_IN_BASE+0x10);
	*h2p_lw_video_edge_control_addr = 0x01 ; // 1 means edges
	*h2p_lw_video_edge_control_addr = 0x00 ; // 1 means edges
	
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
	
	
	// === get video input =======================
	// on-chip RAM
	video_in_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_ONCHIP_BASE); 
	if( video_in_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
	// format the pointer
	video_in_ptr =(unsigned int *)(video_in_virtual_base);

	//-==========Push Buttons=======================================
	pushbutton_addr = (unsigned int *)(h2p_lw_virtual_base + (KEY_BASE));


	//===PIO Ports==================================
	PIO_red_high_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_RED_HIGH_BASE));
	PIO_red_low_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_RED_LOW_BASE));
	PIO_green_high_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_GREEN_HIGH_BASE));
	PIO_green_low_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_GREEN_LOW_BASE));
	PIO_yellow_high_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_YELLOW_HIGH_BASE));
	PIO_yellow_low_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_YELLOW_LOW_BASE));
	PIO_purple_high_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_PURPLE_HIGH_BASE));
	PIO_purple_low_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_PURPLE_LOW_BASE));
	PIO_orange_high_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_ORANGE_HIGH_BASE));
	PIO_orange_low_addr = (unsigned int*)(h2p_lw_virtual_base + (PIO_ORANGE_LOW_BASE));

  PWM_timer_addr = (unsigned int*)(h2p_lw_virtual_base + (PWM_TIMER_BASE));	
	/******************************************************************************************/


 //    // a pixel from the video
	unsigned int pixel_color;
	// unsigned int pixel_R;
	// unsigned int pixel_G;
	// unsigned int pixel_B;
	// video input index
	

	VGA_setup_screen(vga_pixel_ptr, vga_char_ptr); //Clear and setup the screen 

	//Test - Ask for calibration constants for RGB values
	color_threshold_t red_thresholds;
	color_threshold_t green_thresholds;
	color_threshold_t orange_thresholds;
	color_threshold_t purple_thresholds;
	color_threshold_t yellow_thresholds;

  char recalibrate[20];
  //Prompt the user if they want to recalibrate
  printf("Do you want to recalibrate your colors (y/n)?: ");
  scanf("%s", recalibrate);

  if(strcmp(recalibrate, "y") == 0){
	  printf("Please center the crosshair on the RED Sprees, then press KEY3.\n");
	  calibrate_color(&red_thresholds, vga_pixel_ptr, video_in_ptr, vga_char_ptr, pushbutton_addr, RED_ID);
	  send_calibration(&red_thresholds, PIO_red_low_addr, PIO_red_high_addr);
	  printf("Please center the crosshair on the GREEN Sprees, then press KEY3.\n");
	  calibrate_color(&green_thresholds, vga_pixel_ptr, video_in_ptr, vga_char_ptr, pushbutton_addr, GREEN_ID);
	  send_calibration(&green_thresholds, PIO_green_low_addr, PIO_green_high_addr);
	  printf("Please center the crosshair on the ORANGE Sprees, then press KEY3.\n");
	  calibrate_color(&orange_thresholds, vga_pixel_ptr, video_in_ptr, vga_char_ptr, pushbutton_addr, ORANGE_ID);
	  send_calibration(&orange_thresholds, PIO_orange_low_addr, PIO_orange_high_addr);
	  printf("Please center the crosshair on the PURPLE Sprees, then press KEY3.\n");
	  calibrate_color(&purple_thresholds, vga_pixel_ptr, video_in_ptr, vga_char_ptr, pushbutton_addr, PURPLE_ID);
	  send_calibration(&purple_thresholds, PIO_purple_low_addr, PIO_purple_high_addr);
	  printf("Please center the crosshair on the YELLOW Sprees, then press KEY3.\n");
	  calibrate_color(&yellow_thresholds, vga_pixel_ptr, video_in_ptr, vga_char_ptr, pushbutton_addr, YELLOW_ID);
	  send_calibration(&yellow_thresholds, PIO_yellow_low_addr, PIO_yellow_high_addr);
  }
  else if(strcmp(recalibrate, "n") == 0){
    //Do nothing
    printf("No recalibration.\n");
  }
  else{
    printf("INVALID COMMAND - No recalibration performed.\n");
  }

	//SERVO CONTROL CALIBRATION AND DRIVING
  int servo_speed = 50;
  printf("Enter a speed for the servo from 0 to 100 (50-no movement, 0-full reverse, 100-full forward):");
  scanf("%d", &servo_speed);
  //Convert to a time
  unsigned int pwm_timer_val = 0;
  pwm_timer_val = 500*servo_speed + 50000;
  //Write the timer value to the FPGA
  *PWM_timer_addr = pwm_timer_val;
   
  




	int SE_delta =3;

	int prev_max_label = 0; //To store the max label of the previous frame
	int curr_max_label = 0;
	unsigned int total_sprees = 0;
	int num_components = 0;
	int num_red = 0;
	int num_green = 0;
	int num_orange = 0;
	int num_yellow = 0;
	int num_purple = 0;
	int total_red = 0;
	int total_green = 0;
	int total_orange = 0;
	int total_yellow = 0;
	int total_purple = 0;
	//Render Loop
	while(1) 
	{
		// read/write video input -- copy to VGA display
		// for (i=0; i<320; i++) {
		// 	for (j=0; j<240; j++) {
		// 		pixel_color = video_in_read_pixel(i,j, video_in_ptr);
		// 		draw_delay();
		// 		VGA_pixel(i+320,j,pixel_color,vga_pixel_ptr);
		// 	}
		// }
		num_red = 0;
		num_green = 0;
		num_orange = 0;
		num_yellow = 0;
		num_purple = 0;

		//Grab one frame of encoded image from VGA and put into bin_img matrix as 0 if black, 1 if color
		for (i=0; i<ROWS; i++) {
			for (j=0; j<COLS; j++){
				current_pixel_color = VGA_read_pixel_16(j+320, i+240, vga_pixel_ptr);
				draw_delay();
				draw_delay();
				if (current_pixel_color == 0x0000){
					bin_img[i][j] = BACKGROUND_LABEL;
				}
				else{
					//printf("color: %x\n", current_pixel_color);
					if(i == 0 && j == 0){
						//Ignore this pixel - overlap with top-left image
						bin_img[i][j] = BACKGROUND_LABEL;
					}
					else{
						//Check what color it is
						if(current_pixel_color == RED_COLOR){
							bin_img[i][j] = RED_LABEL;
						}
						else if(current_pixel_color == GREEN_COLOR){
							bin_img[i][j] = GREEN_LABEL;
						}
						else if(current_pixel_color == ORANGE_COLOR){
							bin_img[i][j] = ORANGE_LABEL;
						}
						else if(current_pixel_color == PURPLE_COLOR){
							bin_img[i][j] = PURPLE_LABEL;
						}
						else if(current_pixel_color == YELLOW_COLOR){
							bin_img[i][j] = YELLOW_LABEL;
						}
						else{
							printf("Unidentified color: %x\n", current_pixel_color);
							bin_img[i][j] = BACKGROUND_LABEL;
						}
					}
				}
				draw_delay();

			}
		}

		//Count how many objects are on the screen

		//printf("Counting number of sprees...\n");
		curr_max_label = count_components(bin_img, prev_frame_label, prev_max_label, 
			&total_sprees, &total_red, &total_green, &total_orange, &total_purple, &total_yellow,
			&num_red, &num_green, &num_orange, &num_purple, &num_yellow,
			vga_pixel_ptr);
		//printf("curr: %d prev:%d", curr_max_label,prev_max_label);
		num_components = curr_max_label - prev_max_label;
		//Update the max label for the next frame
		prev_max_label = curr_max_label;
		//printf("maxlabel:%d\n", curr_max_label);
		printf("Total Number of Sprees On the Screen: %d\n",num_components);
		sprintf(text_num_components,"Total Manufactured: %d  ",total_sprees);
		VGA_text (1, 30, text_num_components, vga_char_ptr);
		draw_delay();
		sprintf(text_on_screen,"Total Sprees on screen: %d  ",num_components);
		VGA_text (1, 32, text_on_screen, vga_char_ptr);
		draw_delay();
		sprintf(text_num_red, "Red Sprees on screen: %d  ",num_red);
		VGA_text(1, 34, text_num_red, vga_char_ptr);
		draw_delay();
		sprintf(text_num_green, "Green Sprees on screen: %d  ",num_green);
		VGA_text(1, 36, text_num_green, vga_char_ptr);
		draw_delay();
		sprintf(text_num_orange, "Orange Sprees on screen: %d  ",num_orange);
		VGA_text(1, 38, text_num_orange, vga_char_ptr);
		draw_delay();
		sprintf(text_num_purple, "Yellow Sprees on screen: %d  ",num_purple);
		VGA_text(1, 40, text_num_purple, vga_char_ptr);
		draw_delay();
		sprintf(text_num_yellow, "Purple Sprees on screen: %d  ",num_yellow);
		VGA_text(1, 42, text_num_yellow, vga_char_ptr);
		draw_delay();
		sprintf(text_total_red, "Red Sprees manufactured: %d  ",total_red);
		VGA_text(1, 44, text_total_red, vga_char_ptr);
		draw_delay();
		sprintf(text_total_green, "Green Sprees manufactured: %d  ",total_green);
		VGA_text(1, 46, text_total_green, vga_char_ptr);
		draw_delay();
		sprintf(text_total_orange, "Orange Sprees manufactured: %d  ",total_orange);
		VGA_text(1, 48, text_total_orange, vga_char_ptr);
		draw_delay();
		sprintf(text_total_purple, "Yellow Sprees manufactured: %d  ",total_purple);
		VGA_text(1, 50, text_total_purple, vga_char_ptr);
		draw_delay();
		sprintf(text_total_yellow, "Purple Sprees manufactured: %d  ",total_yellow);
		VGA_text(1, 52, text_total_yellow, vga_char_ptr);
		
	} // end while(1)
} // end main

