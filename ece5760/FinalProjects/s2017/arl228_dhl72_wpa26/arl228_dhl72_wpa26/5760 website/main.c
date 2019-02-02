///////////////////////////////////////
/// 640x480 version!
/// test VGA with hardware video input copy to VGA
// compile with
// gcc fp_test_1.c -o fp1 -lm
///////////////////////////////////////
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <sys/time.h> 
#include <math.h> 
#include "filter.c"
#include "footstep.c"
#include <arpa/inet.h>
#include <sys/socket.h>
#include <linux/input.h>
#include <signal.h>

// main bus; scratch RAM
#define FPGA_ONCHIP_BASE      0xC8000000
#define FPGA_ONCHIP_SPAN      0x00080000

// main bus; FIFO write address
#define FIFO_BASE            0xC4000000
#define FIFO_SPAN            0x00001000

/// lw_bus; FIFO status address
#define HW_REGS_BASE          0xff200000
#define HW_REGS_SPAN          0x00005000
//#define HW_REGS_SPAN          0x00000020

// main bus; left FIFO write address
#define LEFT_FIFO_BASE        0x00000040

// lw_bus; FIFO status address
#define LEFT_STATUS_BASE     0x00000040

// main bus; right FIFO write address
#define RIGHT_FIFO_BASE      0x00000080

// lw_bus; FIFO status address
#define RIGHT_STATUS_BASE    0x00000080

#define FILTER_LENGTH			200
#define SOUND_LENGTH			52801

//VGA
#define FPGA_CHAR_BASE        0xC9000000 
#define FPGA_CHAR_END         0xC9001FFF
#define FPGA_CHAR_SPAN        0x00002000
#define SERVER "10.253.17.15"
#define BUFLEN 512  //Max length of buffer
#define PORT 8889   //The port on which to send data
 
void die(char *s)
{
    perror(s);
    exit(1);
}
void INThandler(){
        exit(0);
}

void controller_choice();
void read_NES_controller(int device);
void read_PS3_controller(int device);


/* function prototypes */
void VGA_text (int, int, char *);
void VGA_text_clear();
void VGA_box (int, int, int, int, short);
void VGA_line(int, int, int, int, short) ;
void VGA_disc (int, int, int, short);


// the light weight buss base
void *h2p_lw_virtual_base;
// HPS_to_FPGA FIFO status address = 0
volatile unsigned int * FIFO_status_ptr = NULL ;
volatile unsigned int * left_FIFO_status_ptr = NULL ;
volatile unsigned int * right_FIFO_status_ptr = NULL ;

// RAM FPGA command buffer
// main bus addess 0x0800_0000
volatile unsigned int * sram_ptr = NULL ;
void *sram_virtual_base;

// HPS_to_FPGA FIFO write address
// main bus addess 0x0000_0000
void *h2p_virtual_base;
volatile unsigned int * FIFO_write_ptr = NULL ;
volatile unsigned int * left_FIFO_write_ptr = NULL ;
volatile unsigned int * right_FIFO_write_ptr = NULL ;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
void *vga_pixel_virtual_base;

// character buffer
volatile unsigned int * vga_char_ptr = NULL ;
void *vga_char_virtual_base;

char background = 0x00;
char player = 0x0f;
char enemy = 0xe0;

int distance = 5;
long distance_sq = 25;
int dir_index = 63;

int pos_x;// = 320;
int pos_y;// = 120;
int last_pos_x = 320;
int last_pos_y = 120;
int last_vga_x = 320;
int last_vga_y = 120;

int enemy_pos_x = 320;
int enemy_pos_y = 240;
int last_enemy_vga_x = 320;
int last_enemy_vga_y = 240;

int debounce_counter = 0;
char it_text[40] = "You're it!\0";
char not_it_text[40] = "Run away!\0";

int it;

//controller variables
int turning=0, forward=0, hitting=0;
struct input_event ev;
char devname[] = "/dev/input/event0";
int choice;        
// /dev/mem file id
int fd;	

void * key_read() {
	double velocity_angle;
	double enemy_angle;

	int value, value2;
	char input_buffer[64];
	while(1){
		printf("Enter a command\n");
		scanf("%s %d %d",input_buffer, &value, &value2);
		if(strcmp(input_buffer, "distance") == 0){
			distance = (3 > value) ? 3 : value;
		}
		else if(strcmp(input_buffer, "direction") == 0){
			dir_index = (value % 360)/5;
		}
		else if(strcmp(input_buffer, "move") == 0){
			last_pos_x = pos_x;
			last_pos_y = pos_y;
			pos_x += value;
			pos_y += value2;
		}
		else{
			printf("Enter a valid command\n");
		}
		velocity_angle = atan2(pos_y-last_pos_y,pos_x-last_pos_x);
		enemy_angle = atan2(enemy_pos_y-pos_y,enemy_pos_x-pos_x);
		printf("%f\n", velocity_angle * 57.2957);
		printf("%f\n", enemy_angle * 57.2957);
		velocity_angle = velocity_angle * 57.2957;
		enemy_angle = enemy_angle * 57.2957;
		dir_index = ((int)(-velocity_angle + enemy_angle + 450)%360)/5;
		printf("%d\n", dir_index);
	}

}
void * client() {
	struct sockaddr_in si_other;
    int s, i, slen=sizeof(si_other);
    char buf[BUFLEN];
    char message[BUFLEN];
    pos_y = 100;
    pos_x = 100;
    it = 0;
    VGA_text_clear();
	VGA_text (1, 1, not_it_text);

    if ( (s=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1)
    {
        die("socket");
    }
 
    memset((char *) &si_other, 0, sizeof(si_other));
    si_other.sin_family = AF_INET;
    si_other.sin_port = htons(PORT);
     
    if (inet_aton(SERVER , &si_other.sin_addr) == 0) 
    {
        fprintf(stderr, "inet_aton() failed\n");
        exit(1);
    }
 
    while(1)
    {	

        //printf("Enter message : ");
		//scanf("%s", &message);
		//memset(message,0,sizeof(message));
		sprintf(message,"%0d %0d", pos_x,pos_y);
        //printf("%s\n",message);
        //send the message
        if (sendto(s, message, strlen(message) , 0 , (struct sockaddr *) &si_other, slen)==-1)
        {
            die("sendto()");
        }
         
        //receive a reply and print it
        //clear the buffer by filling null, it might have previously received data
        memset(buf,'\0', BUFLEN);
        //try to receive some data, this is a blocking call
        if (recvfrom(s, buf, BUFLEN, 0, (struct sockaddr *) &si_other, &slen) == -1)
        {
            die("recvfrom()");
        }
        
        //puts(buf);
        sscanf(buf, "%d %d", &enemy_pos_x, &enemy_pos_y);
        distance_sq = (enemy_pos_y-pos_y)*(enemy_pos_y-pos_y) + (enemy_pos_x-pos_x)*(enemy_pos_x-pos_x);
        if(distance_sq <= 100 && debounce_counter ==0){
        	debounce_counter = 10;
        	//sleep(2);
        	//printf("debug\n");

        	it = 1-it;

        	if(it == 0){
        	//pos_x = (enemy_pos_x + 320)%640;
			//pos_y = (enemy_pos_y + 240)%480;
			//pos_y = 300;
    		//pos_x = 400;
			// clear the screen
			VGA_box (0, 0, 639, 479, background);
			// clear the text
			VGA_text_clear();
			VGA_text (1, 1, not_it_text);
			//VGA_text (1, 2, text_bottom_row);

			}
			else{
				//pos_y = 100;
    			//pos_x = 100;
				VGA_text_clear();
				VGA_text (1, 1, it_text);
			}
			
        }
        else if(debounce_counter != 0){
        	debounce_counter--;
        	if(debounce_counter == 0){
        		if(it == 0){
        			pos_x = 100;
        			pos_y = 100;
        		}
        		else{
        			pos_x = 640 - 100;
        			pos_y = 480 - 100;
        		}
        	}
        	//sleep(1);
        }
        //sleep(1);
    }
}
void * server() {
	struct sockaddr_in si_me, si_other;
    
    int s, i, slen = sizeof(si_other) , recv_len;
    char buf[BUFLEN];
    char message[BUFLEN];

    pos_y = 300;
    pos_x = 400;
    it = 1;
    VGA_text_clear();
	VGA_text (1, 1, it_text);
    //create a UDP socket
    if ((s=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1)
    {
        die("socket");
    }
     
    // zero out the structure
    memset((char *) &si_me, 0, sizeof(si_me));
     
    si_me.sin_family = AF_INET;
    si_me.sin_port = htons(PORT);
    si_me.sin_addr.s_addr = htonl(INADDR_ANY);
     
    //bind socket to port
    if( bind(s , (struct sockaddr*)&si_me, sizeof(si_me) ) == -1)
    {
        die("bind");
    }
    
    //keep listening for data
    while(1)
    {
        //printf("Waiting for data...");
        //fflush(stdout);
         fflush(stdout);
        memset(buf, '\0', sizeof(buf));
        //try to receive some data, this is a blocking call
        if ((recv_len = recvfrom(s, buf, BUFLEN, 0, (struct sockaddr *) &si_other, &slen)) == -1)
        {
            die("recvfrom()");
        }
         
        //print details of the client/peer and the data received
        //printf("Received packet from %s:%d\n", inet_ntoa(si_other.sin_addr), ntohs(si_other.sin_port));
        //printf("Data: %s\n" , buf);
        
        sscanf(buf, "%d %d ", &enemy_pos_x, &enemy_pos_y);

        //printf("%s\n", buf);
        //now reply the client with your position
        sprintf(message,"%d %d", pos_x,pos_y);
        if (sendto(s, message, recv_len, 0, (struct sockaddr*) &si_other, slen) == -1)
        {
            die("sendto()");
        }
        distance_sq = (enemy_pos_y-pos_y)*(enemy_pos_y-pos_y) + (enemy_pos_x-pos_x)*(enemy_pos_x-pos_x);
        if(distance_sq <= 100 && debounce_counter == 0){
        	debounce_counter = 10;
        	//sleep(2);
        	//printf("debug\n");

        	it = 1-it;

        	if(it == 0){
        	//pos_x = (enemy_pos_x + 320)%640;
			//pos_y = (enemy_pos_y + 240)%480;
			//pos_y = 300;
    		//pos_x = 400;
			// clear the screen
			VGA_box (0, 0, 639, 479, background);
			// clear the text
			VGA_text_clear();
			VGA_text (1, 1, not_it_text);
			//VGA_text (1, 2, text_bottom_row);

			}
			else{
				//pos_y = 100;
    			//pos_x = 100;
				VGA_text_clear();
				VGA_text (1, 1, it_text);
			}
			
        }
        else if(debounce_counter != 0){
        	debounce_counter--;
        	if(debounce_counter == 0){
        		if(it == 0){
        			pos_x = 100;
        			pos_y = 100;
        		}
        		else{
        			pos_x = 640 - 100;
        			pos_y = 480 - 100;
        		}
        	}
        	//sleep(1);
        }
    }
}

void * fifo_write() {
	int i = 0;
	int j = 0;
	int k = 0;

	while(1) 
	{	
		if(it == 0){
		if( j < FILTER_LENGTH){
			//while(*left_FIFO_status_ptr > 250);
			if(*left_FIFO_status_ptr < 250){
				*(left_FIFO_write_ptr) = filter_left[dir_index][j]/distance;
				j++;
			}
		}
		else{
			j = 0;
		}
		if( k < FILTER_LENGTH){
			//while(*right_FIFO_status_ptr > 250);
			if(*right_FIFO_status_ptr < 250){
				*(right_FIFO_write_ptr) = filter_right[dir_index][j]/distance;
				k++;
			}
		}
		else{
			k = 0;
		}
		if( i < SOUND_LENGTH){
		// send to FIFO
			//while(*FIFO_status_ptr > 250);
			if(*FIFO_status_ptr < 250){
				*(FIFO_write_ptr) =  footstep[i];
				i++;
			}
		}
		else{
			i=0;
		}
	}
	} // end while(1)
}

void * vga_update() {
	double velocity_angle;
	double enemy_angle;


	while(1){
		//erase last position
		//printf("%d %d\n", pos_x,pos_y);
		if(it == 1){
		VGA_disc(last_vga_x, last_vga_y, 10, background);
		VGA_disc(last_enemy_vga_x, last_enemy_vga_y, 10,background);
		
		last_vga_y = pos_y;
		last_vga_x = pos_x;
		last_enemy_vga_y = enemy_pos_y;
		last_enemy_vga_x = enemy_pos_x;
		//write current position
		VGA_disc(pos_x, pos_y, 10, player);
		VGA_disc(enemy_pos_x,enemy_pos_y,10,enemy);
		}
		if(it == 0){
		velocity_angle = atan2(pos_y-last_pos_y,pos_x-last_pos_x);
		enemy_angle = atan2(enemy_pos_y-pos_y,enemy_pos_x-pos_x);
		//printf("%f\n", velocity_angle * 57.2957);
		//printf("%f\n", enemy_angle * 57.2957);
		velocity_angle = velocity_angle * 57.2957;
		enemy_angle = enemy_angle * 57.2957;
		dir_index = ((int)(-velocity_angle + enemy_angle + 450)%360)/5;
		//distance = (abs(enemy_pos_y-pos_y) + abs(enemy_pos_x-pos_x))/4;
		//distance = (distance < 3) ? 3 : distance;
		distance = 4.0 + ((1.0/1200.0)* (double)distance_sq);
		//printf("%d\n", distance);
		}
		//printf("%d\n", dir_index);

		usleep(33333);
		//VGA_box(315, 0, 325, 10, background);
		//VGA_box(315, 0, 325, 10, player);
		//sleep(1);

	}
}

void * controller() {
	int device = open(devname, O_RDONLY);
	//needed for non block

	int flags = fcntl(device, F_GETFL, 0);
	fcntl(device, F_SETFL, flags | O_NONBLOCK);
        

    signal(SIGINT, INThandler);
    
    //controller_choice();
    choice = 1;
    while(1)
    {
		switch(choice){
			case 1:		read_NES_controller(device);
						break;
					
			case 2: 	read_PS3_controller(device);
						break;
			} 
    }
}






int main(void)
{

	// Declare volatile pointers to I/O registers (volatile 	// means that IO load and store instructions will be used 	// to access these pointer locations, 
	// instead of regular memory loads and stores) 
  	
	// === need to mmap: =======================
	// FPGA_CHAR_BASE
	// FPGA_ONCHIP_BASE      
	// HW_REGS_BASE        
  	pthread_t thread_fifo, thread_keyboard, thread_vga, thread_udp, thread_controller;
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
	FIFO_status_ptr = (unsigned int *)(h2p_lw_virtual_base);
	left_FIFO_status_ptr = (unsigned int *)(h2p_lw_virtual_base + LEFT_STATUS_BASE);
	right_FIFO_status_ptr = (unsigned int *)(h2p_lw_virtual_base + RIGHT_STATUS_BASE);

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
	//============================================
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

	
	// scratch RAM FPGA parameter addr 
	sram_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_ONCHIP_BASE); 	
	
	if( sram_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    // Get the address that maps to the RAM buffer
	sram_ptr =(unsigned int *)(sram_virtual_base);
	
	// ===========================================

	// FIFO write addr 
	h2p_virtual_base = mmap( NULL, FIFO_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FIFO_BASE); 	
	
	if( h2p_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    // Get the address that maps to the FIFO
	FIFO_write_ptr =(unsigned int *)(h2p_virtual_base);
	left_FIFO_write_ptr = (unsigned int *)(h2p_virtual_base + LEFT_FIFO_BASE);
	right_FIFO_write_ptr = (unsigned int *)(h2p_virtual_base + RIGHT_FIFO_BASE);
	
	//VGA clear

	// clear the screen
	VGA_box (0, 0, 639, 479, background);
	// clear the text
	VGA_text_clear();
	//VGA_text (1, 1, text_top_row);
	//VGA_text (1, 2, text_bottom_row);

	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
	//============================================
	pthread_create(&thread_fifo,NULL,fifo_write,NULL);
	//pthread_create(&thread_keyboard,NULL,key_read,NULL);
	pthread_create(&thread_vga,NULL,vga_update,NULL);
	//pthread_create(&thread_udp,NULL,client,NULL);
	pthread_create(&thread_udp,NULL,server,NULL);
	pthread_create(&thread_controller,NULL,controller,NULL);



	while(1);

} // end main

/// /// ///////////////////////////////////// 
/// end /////////////////////////////////////
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
			pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + (col) ;
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
				pixel_ptr = (char *)vga_pixel_ptr + (row<<10) + (col) ;
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

void controller_choice(){
	do{
    printf("Choose controller\n");
    printf("1. NES Controller\n");
    printf("2. PS3 Controller\n");
    scanf("%d", &choice);
    
    
    if (choice != 1 && choice !=2)
    {
		printf("Not a valid choice of controller.\n\n");
		}
	}while (choice != 1 && choice !=2);
	
	
	
	}
	
	
void read_PS3_controller (int device){
	read(device,&ev, sizeof(ev));
                
                sleep(.03); 
                
                if ( ev.type == 1  || ev.type == 3){ //gets rid of setup printout
					switch(ev.type){
						case 3:			if(ev.code == 17 && ev.value == -1){
										last_pos_y = pos_y;
										pos_y-=5;
										if(pos_y < 0){
											pos_y = 480;
										}									}
									else if (ev.code == 17 && ev.value == 1) {
										last_pos_y = pos_y;
									pos_y+=5;
									if(pos_y > 480){
											pos_y -= 480;
										}
									}
									else if (ev.code == 16 && ev.value == -1) {last_pos_x = pos_x;
									pos_x-=5;
									if(pos_x < 0){
										pos_x += 640;
									}

								}
									else if (ev.code == 16 && ev.value == 1) {last_pos_x = pos_x;
									pos_x+=5;
									if(pos_x > 640){
										pos_x -= 640;
									}
								}
									break;
									
									
						case 1: 	if (ev.code == 306 && ev.value == 1){printf("Circle pressed\n");hitting++;}
									else if (ev.code == 304 && ev.value == 1) {printf("Square pressed\n");hitting--;}
									else if (ev.code == 313 && ev.value == 1) {printf("start pressed\n");printf("forward: %i \nturning: %i \nhtting: %i\n", forward, turning, hitting);}
									else if (ev.code == 312 && ev.value == 1) {printf("select pressed\n");}
									break;
						
						default:	printf("no functionality for other button types\n");
									printf("event type: %u event number: %u\n",ev.type, ev.code); 	
								}

							}
	}	
void read_NES_controller(int device){
	read(device,&ev, sizeof(ev));
                
                sleep(.03); 
                
                if ( ev.type == 1  || ev.type == 3){ //gets rid of setup printout
					switch(ev.type){
						case 3:		if(ev.code == 1 && ev.value == 0){
										//printf("up pressed\n");
										last_pos_y = pos_y;
										pos_y-=5;
										if(pos_y < 0){
											pos_y = 480;
										}	
									}
									else if (ev.code == 1 && ev.value == 255) {//printf("down pressed\n");
									last_pos_y = pos_y;
									pos_y+=5;
								if(pos_y > 480){
											pos_y -= 480;
										}	}
									else if (ev.code == 0 && ev.value == 0) {//printf("left pressed\n");
									last_pos_x = pos_x;
									pos_x-=5;
								if(pos_x < 0){
										pos_x += 640;
									}}
									else if (ev.code == 0 && ev.value == 255) {//printf("right pressed\n");
									last_pos_x = pos_x;
									pos_x+=5;
								if(pos_x > 640){
										pos_x -= 640;
									}}
									break;
									
									
						case 1: 	if (ev.code == 289 && ev.value == 1){printf("A pressed\n");hitting++;}
									else if (ev.code == 288 && ev.value == 1) {printf("B pressed\n");hitting--;}
									else if (ev.code == 297 && ev.value == 1) {printf("start pressed\n");printf("forward: %i \nturning: %i \nhtting: %i\n", forward, turning, hitting);}
									else if (ev.code == 296 && ev.value == 1) {printf("select pressed\n");}
									break;
						
						default:	printf("no functionality for other button types\n");
									printf("event type: %u event number: %u\n",ev.type, ev.code); 	
								}
							}
							
	}
