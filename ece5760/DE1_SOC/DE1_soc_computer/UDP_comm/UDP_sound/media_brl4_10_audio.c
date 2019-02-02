///////////////////////////////////////
/// Audio
/// compile with
/// gcc media_brl4_10_audio.c -o testA -lm
///////////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <math.h>
#include <sys/types.h>
#include <string.h>
// interprocess comm
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <time.h>
// network stuff
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>  /* IP address conversion stuff */
#include <netdb.h> 

#include "address_map_arm_brl4.h"

// fixed point
#define float2fix30(a) ((int)((a)*1073741824)) // 2^30

//#define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0) 

/* function prototypes */
//void VGA_text (int, int, char *);
//void VGA_box (int, int, int, int, short);
//void VGA_line(int, int, int, int, short) ;

// virtual to real address pointers

volatile unsigned int * red_LED_ptr = NULL ;
//volatile unsigned int * res_reg_ptr = NULL ;
//volatile unsigned int * stat_reg_ptr = NULL ;

// audio stuff
volatile unsigned int * audio_base_ptr = NULL ;
volatile unsigned int * audio_fifo_data_ptr = NULL ; //4bytes
volatile unsigned int * audio_left_data_ptr = NULL ; //8bytes
volatile unsigned int * audio_right_data_ptr = NULL ; //12bytes

// the light weight buss base
void *h2p_lw_virtual_base;

// /dev/mem file descriptor
int fd;
// shared memory 
key_t mem_key=0xf0;
int shared_mem_id; 
int *shared_ptr;
int audio_time;
 
int main(void)
{
	// ======================================================
	// UDP stuff from
	// http://www.linuxhowtos.org/C_C++/socket.htm
	// source code: server_udp.c
	int sock, n, flags;
	unsigned int length;
	struct sockaddr_in server, from;
	struct hostent *hp;
	char buffer[512]; //256
	int audio_sample[12];
	
	// open socket and associate with remote IP address
	sock = socket(AF_INET, SOCK_DGRAM, 0);
	if (sock < 0) printf("socket\n\r");
	
	// set up socket receive function to noblock option
	//flags = fcntl(sock, F_GETFL);
	//flags |= O_NONBLOCK;
	//fcntl(sock, F_SETFL, flags);
	
	// setup address
	length = sizeof(server);
	server.sin_family = AF_INET;
	server.sin_addr.s_addr=INADDR_ANY;
	// set IP port number
	server.sin_port = htons(9090);
	// associate remote IP address with socket
	if (bind(sock,(struct sockaddr *)&server,length)<0) printf("binding");
	length=sizeof(struct sockaddr_in);
	
	// generally should close socket, but this code does not
	//close(sock);
	// ======================================================
	
	// Declare volatile pointers to I/O registers (volatile 	
	// means that IO load and store instructions will be used 	
	// to access these pointer locations, 
	// instead of regular memory loads and stores) 

  	// === shared memory =======================
	// with video process
	shared_mem_id = shmget(mem_key, 100, IPC_CREAT | 0666);
	shared_ptr = shmat(shared_mem_id, NULL, 0);
	
	// === need to mmap: =======================    
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

	// audio addresses
	// base address is control register
	audio_base_ptr = (unsigned int *)(h2p_lw_virtual_base + AUDIO_BASE);
	audio_fifo_data_ptr  = audio_base_ptr  + 1 ; // word
	audio_left_data_ptr = audio_base_ptr  + 2 ; // words
	audio_right_data_ptr = audio_base_ptr  + 3 ; // words

	// ===========================================
	// 
	int i, audio_sample_scaled;
	char sync_buffer[] = "8\n"; // actual string is ingored by matlab
	while(1){	
	
		// generate approx 8khz audio
		// load the FIFO from UDP packet at 8 kHz sample rate
		// so dup it 6 times 6x8=48 kHz
		int ii,jj;
		while (((*audio_fifo_data_ptr>>24) & 0xff) > 49) {
			// share audio time with video
			*shared_ptr = audio_time/48000 ;
			// get sample from socket
			n = recvfrom(sock,buffer,512,0,(struct sockaddr *)&from, &length);
			sscanf(buffer, "%d %d %d %d %d %d %d %d", 
				&audio_sample[0], &audio_sample[1], &audio_sample[2], &audio_sample[3],
				&audio_sample[4], &audio_sample[5], &audio_sample[6], &audio_sample[7]);
				
			// send sync back to the source of the input buffer
			// not used with Matlab pgm, becuase matlab receive is SLOW
			//n=sendto(sock, sync_buffer, strlen(sync_buffer),0,(const struct sockaddr *)&from, length);
			
			// move samples to audio FIFO
			for(ii=0; ii<8; ii++){
				audio_sample_scaled = audio_sample[ii];
				for(jj=0; jj<6; jj++){
					*audio_left_data_ptr = audio_sample_scaled;
					*audio_right_data_ptr = audio_sample_scaled;
					// update audio sample time 
					audio_time++ ;	
				} // for(jj=)	
			} // for(ii=)
		} // end while (((*audio		
	} // end while(1)
} // end main

