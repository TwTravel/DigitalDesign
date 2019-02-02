///////////////////////////////////////
/// 640x480 version!
/// test VGA with hardware video input copy to VGA
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
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
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
void tcp_send(char * datum);

// the light weight buss base
void *h2p_lw_virtual_base;
volatile unsigned int *h2p_lw_video_in_control_addr=NULL;
volatile unsigned int *h2p_lw_video_in_resolution_addr=NULL;
//volatile unsigned int *h2p_lw_video_in_control_addr=NULL;
//volatile unsigned int *h2p_lw_video_in_control_addr=NULL;

volatile unsigned int *h2p_lw_video_edge_control_addr=NULL;

// box coordinate buffer
volatile unsigned int *h2p_lw_x_value = NULL;
volatile unsigned int *h2p_lw_y_value = NULL;
volatile unsigned int *h2p_lw_radius_value = NULL;

// color buffer
volatile unsigned int *h2p_lw_red_min = NULL;
volatile unsigned int *h2p_lw_red_max = NULL;
volatile unsigned int *h2p_lw_blue_min = NULL;
volatile unsigned int *h2p_lw_blue_max = NULL;
volatile unsigned int *h2p_lw_green_min = NULL;
volatile unsigned int *h2p_lw_green_max = NULL;

//coordinate inputs
volatile unsigned int *h2p_lw_x_accum = NULL;
volatile unsigned int *h2p_lw_y_accum = NULL;
volatile unsigned int *h2p_lw_z_accum = NULL;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
void *vga_pixel_virtual_base;

// video input buffer
volatile unsigned int * video_in_ptr = NULL ;
void *video_in_virtual_base;

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

//tcp macros
#define HOSTNAME "169.254.163.56"//"localhost"//"128.253.17.222"
#define PORT 81


// pixel macro
#define VGA_PIXEL(x,y,color) do{\
        char  *pixel_ptr ;\
        pixel_ptr = (char *)vga_pixel_ptr + ((y)<<10) + (x) ;\
        *(char *)pixel_ptr = (color);\
} while(0)

#define VIDEO_IN_PIXEL(x,y,color) do{\
        char  *pixel_ptr ;\
        pixel_ptr = (char *)video_in_ptr + ((y)<<9) + (x) ;\
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

        // Declare volatile pointers to I/O registers (volatile   
		// means that IO load and store instructions will be used    
		// to access these pointer locations,
        // instead of regular memory loads and stores)

        // === need to mmap: =======================
        // FPGA_CHAR_BASE
        // FPGA_ONCHIP_BASE
        // HW_REGS_BASE

        // === get FPGA addresses ==================
    // Open /dev/mem
        if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 )    {
                printf( "ERROR: could not open \"/dev/mem\"...\n" );
                return( 1 );
        }

    // get virtual addr that maps to physical
        h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE );
        if( h2p_lw_virtual_base == MAP_FAILED ) {
                printf( "ERROR: mmap1() failed...\n" );
                close( fd );
                return(1);
        }
    h2p_lw_video_in_control_addr=(volatile unsigned int *)(h2p_lw_virtual_base+VIDEO_IN_BASE+0x0c);
        h2p_lw_video_in_resolution_addr=(volatile unsigned int *)(h2p_lw_virtual_base+VIDEO_IN_BASE+0x08);
        *(h2p_lw_video_in_control_addr) = 0x04 ; // turn on video capture
        *(h2p_lw_video_in_resolution_addr) = 0x00f00140 ;  // high 240 low 320
        h2p_lw_video_edge_control_addr=(volatile unsigned int *)(h2p_lw_virtual_base+VIDEO_IN_BASE+0x10);
        *h2p_lw_video_edge_control_addr = 0x01 ; // 1 means edges
        *h2p_lw_video_edge_control_addr = 0x00 ; // 1 means edges

		// box virtual address that maps to physical
		
		h2p_lw_x_value = (volatile unsigned int *)(h2p_lw_virtual_base+X_VALUE);
		h2p_lw_y_value = (volatile unsigned int *)(h2p_lw_virtual_base+Y_VALUE);
		h2p_lw_radius_value = (volatile unsigned int *)(h2p_lw_virtual_base+RADIUS_VALUE);
		
		// color virtual address that maps to physical
		
		h2p_lw_red_min = (volatile unsigned int *)(h2p_lw_virtual_base+RED_MIN);
		h2p_lw_red_max = (volatile unsigned int *)(h2p_lw_virtual_base+RED_MAX);
		h2p_lw_blue_min = (volatile unsigned int *)(h2p_lw_virtual_base+BLUE_MIN);
		h2p_lw_blue_max = (volatile unsigned int *)(h2p_lw_virtual_base+BLUE_MAX);
		h2p_lw_green_min = (volatile unsigned int *)(h2p_lw_virtual_base+GREEN_MIN);
		h2p_lw_green_max = (volatile unsigned int *)(h2p_lw_virtual_base+GREEN_MAX);

		//add base to map accums to physical
		h2p_lw_x_accum = (volatile unsigned int *)(h2p_lw_virtual_base+X_ACCUM_BASE);
		h2p_lw_y_accum = (volatile unsigned int *)(h2p_lw_virtual_base+Y_ACCUM_BASE);
		h2p_lw_z_accum = (volatile unsigned int *)(h2p_lw_virtual_base+Z_ACCUM_BASE);
		
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

        // ===========================================

        /* create a message to be displayed on the VGA
          and LCD displays */
        char text_top_row[40] = "DE1-SoC ARM/FPGA\0";
        char text_bottom_row[40] = "Cornell ece5760\0";
        char num_string[20], time_string[50] ;

        // a pixel from the video
        int pixel_color;
        // video input index
        int i,j;

        // clear the screen
        VGA_box (0, 0, 639, 479, 0x00);
        // clear the text
        VGA_text_clear();
        VGA_text (1, 56, text_top_row);
        VGA_text (1, 57, text_bottom_row);

        // start timer
    //gettimeofday(&t1, NULL);

	// COMMAND TERMINAL INTERFACE
	
	    int input_x_value;
        int input_y_value;
        int input_radius_value;
		int input_red_min;
		int input_red_max;
		int input_blue_min;
		int input_blue_max;
		int input_green_min;
		int input_green_max;

	int output_x_accum;
	int output_y_accum;
	int output_z_accum;

        printf("x_value: \n");
        printf(">");
        scanf("%d", &input_x_value);
        printf("%d \n",input_x_value);
        *h2p_lw_x_value = input_x_value;

        printf("y_value: \n");
        printf(">");
        scanf("%d", &input_y_value);
        printf("%d \n",input_y_value);
        *h2p_lw_y_value = input_y_value;

        printf("radius_value: \n");
        printf(">");
        scanf("%d", &input_radius_value);
        printf("%d \n",input_radius_value);
        *h2p_lw_radius_value = input_radius_value;
		
		printf("red min value: \n");
        printf(">");
        scanf("%d", &input_red_min);
        printf("%d \n",input_red_min);
        *h2p_lw_red_min = input_red_min;
		
		printf("red max value: \n");
        printf(">");
        scanf("%d", &input_red_max);
        printf("%d \n",input_red_max);
        *h2p_lw_red_max = input_red_max;
		
		printf("green min value: \n");
        printf(">");
        scanf("%d", &input_green_min);
        printf("%d \n",input_green_min);
        *h2p_lw_green_min = input_green_min;
		
		printf("green max value: \n");
        printf(">");
        scanf("%d", &input_green_max);
        printf("%d \n",input_green_max);
        *h2p_lw_green_max = input_green_max; 
		
		printf("blue min value: \n");
        printf(">");
        scanf("%d", &input_blue_min);
        printf("%d \n",input_blue_min);
        *h2p_lw_blue_min = input_blue_min;
		
		printf("blue max value: \n");
        printf(">");
        scanf("%d", &input_blue_max);
        printf("%d \n",input_blue_max);
        *h2p_lw_blue_max = input_blue_max;
		


        while(1)
        {
                gettimeofday(&t1, NULL);

                // note that this version of VGA_disk
                // has THROTTLED pixel write
                //VGA_disc((rand()&0x3ff), (rand()&0x1ff), rand()&0x3f, rand()&0xff) ;

                // software copy test.
                // in production, hardware does the copy
                // put a few  pixel in input buffer
                 //VIDEO_IN_PIXEL(160,120,0xff);
                 //VIDEO_IN_PIXEL(0,0,0xff);
                 //VIDEO_IN_PIXEL(319,239,0xff);
                 //VIDEO_IN_PIXEL(300,200,0xff);

                // read/write video input -- copy to VGA display
                // for (i=0; i<320; i++) {
                        // for (j=0; j<240; j++) {
                                // pixel_color = video_in_read_pixel(i,j);
                                // VGA_PIXEL(i+100,j+50,pixel_color);
                        // }
                // }

                // stop timer
		output_x_accum = *h2p_lw_x_accum;
		output_y_accum = *h2p_lw_y_accum;
		output_z_accum = *h2p_lw_z_accum;
		if(output_z_accum>0 && output_x_accum>output_z_accum){		
			*h2p_lw_x_value = output_x_accum/output_z_accum;
			*h2p_lw_y_value = output_y_accum/output_z_accum;
		}
		if(output_z_accum>125){		
			*h2p_lw_radius_value = output_z_accum/125;
		}
		printf("X Accum: %d \n",*h2p_lw_x_value);
		printf("Y Accum: %d \n",*h2p_lw_y_value);
		printf("Z Accum: %d \n",*h2p_lw_radius_value);
		char outStr[12];
		sprintf(outStr,"%d;%d;%d",*h2p_lw_x_value,*h2p_lw_y_value,output_z_accum);
		printf("Sending data\n");
		/*tcp_send("20;40;60"); //testing tcp 
                tcp_send("30;50;70");
		tcp_send("50;60;90");*/
		tcp_send(outStr);
		printf("Sent\n");

                 gettimeofday(&t2, NULL);
                 elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
                // elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms
                 pixel_color = VGA_read_pixel(160,120);
                 sprintf(time_string, "T=%3.0fmS  color=%x    ", elapsedTime, pixel_color);
                // VGA_text (10, 3, num_string);
                 VGA_text (1, 58, time_string);

        } // end while(1)
} // end main

/*******************************************************************************
*********
 * Subroutine to read a pixel from the video input
********************************************************************************
********/
int  video_in_read_pixel(int x, int y){
        char  *pixel_ptr ;
        pixel_ptr = (char *)video_in_ptr + ((y)<<9) + (x) ;
        return *pixel_ptr ;
}

/*******************************************************************************
*********
 * Subroutine to read a pixel from the VGA monitor
********************************************************************************
********/
int  VGA_read_pixel(int x, int y){
        char  *pixel_ptr ;
        pixel_ptr = (char *)vga_pixel_ptr + ((y)<<10) + (x) ;
        return *pixel_ptr ;
}

/*******************************************************************************
*********
 * Subroutine to send a string of text to the VGA monitor
********************************************************************************
********/
void VGA_text(int x, int y, char * text_ptr)
{
        volatile char * character_buffer = (char *) vga_char_ptr ;      // VGA character buffer
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

/*******************************************************************************
*********
 * Subroutine to clear text to the VGA monitor
********************************************************************************
********/
void VGA_text_clear()
{
        volatile char * character_buffer = (char *) vga_char_ptr ;      // VGA character buffer
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

/*******************************************************************************
*********
 * Draw a filled rectangle on the VGA monitor
********************************************************************************
********/
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

void tcp_send(char * datum) 
{
    int sockfd, portno, n;
    struct sockaddr_in serv_addr;
    struct hostent *server;

    char buffer[256];
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    server = gethostbyname(HOSTNAME);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host\n");
        exit(0);
    }
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(PORT);
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) 
        error("ERROR connecting");
    bzero(buffer,256);
    strcpy(buffer, datum);
    printf("buf = %s\n\r", buffer);
    n = write(sockfd,buffer,strlen(buffer));
    if (n < 0) 
         error("ERROR writing to socket");
    bzero(buffer,256);
    n = read(sockfd,buffer,255);
    if (n < 0) 
         error("ERROR reading from socket");
    printf("%s\n",buffer);
    close(sockfd);
}



