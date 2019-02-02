///////////////////////////////////////////////////////////////////
// Audio fpga interface gets data via shared array from udp thread
// shared array is mutex protected
// RIGHT channel only!! FPGA loads left channel
// compile with
// gcc thread_udp.c -o aud -pthread
//
// bruce.land@cornell.edu -- June 2016
////////////////////////////////////////////////////////////////////

// needed for CPU_SET, which is needed to
// force threads onto one processor
#define _GNU_SOURCE 

// the usual stuff
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

// threads
#include <pthread.h>

// fpga addresses
#include "address_map_arm_brl4.h"

// udp buffer
int shared_buffer[65000];
// access to udp buffer
pthread_mutex_t shared_buffer_lock = PTHREAD_MUTEX_INITIALIZER;

// audio fpga interface stuff
volatile unsigned int * audio_base_ptr = NULL ;
volatile unsigned int * audio_fifo_data_ptr = NULL ; //4bytes
volatile unsigned int * audio_left_data_ptr = NULL ; //8bytes
volatile unsigned int * audio_right_data_ptr = NULL ; //12bytes

// the light weight bus base
void *h2p_lw_virtual_base;

// /dev/mem file descriptor
int fd;

///////////////////////////////////////////////////////////////
// THREAD -- read UDP data on port 9090
///////////////////////////////////////////////////////////////
void * read_udp() {
	int i;
	// start over command
	char st; 
	char sync_buffer[] = "8\n"; // actual string is ingored by matlab
	// ======================================================
	// UDP stuff from
	// ======================================================
	// http://www.linuxhowtos.org/C_C++/socket.htm
	// source code: server_udp.c
	int sock, n, flags;
	unsigned int length;
	struct sockaddr_in server, from;
	struct hostent *hp;
	char udp_buffer[512]; //256
	int audio_sample[12];
	
	// open socket and associate with remote IP address
	sock = socket(AF_INET, SOCK_DGRAM, 0);
	if (sock < 0) printf("socket\n\r");
	
	// setup address
	length = sizeof(server);
	server.sin_family = AF_INET;
	server.sin_addr.s_addr=INADDR_ANY;
	// set IP port number
	server.sin_port = htons(9090);
	// associate remote IP address with socket
	if (bind(sock,(struct sockaddr *)&server,length)<0) printf("binding");
	length=sizeof(struct sockaddr_in);
	
	// init the sample count
	// The ZERO index is the sample COUNT
	// The FIRST sample is in index=1
	pthread_mutex_lock(&shared_buffer_lock);
	shared_buffer[0] = 1;
	pthread_mutex_unlock(&shared_buffer_lock);
	
	while(1){	
	
		// get sample from socket
		n = recvfrom(sock,udp_buffer,512,0,(struct sockaddr *)&from, &length);
		//load st with the first character in the rec string
		st = udp_buffer[0];
		udp_buffer[n]=0; // zero terminate the string
		//printf("%s %d\n", buffer, *shared_ptr_fpga);
		
		// check for a start command which is an "s"
		// sent from the PC
		if (st=='s'){
			pthread_mutex_lock(&shared_buffer_lock);
			shared_buffer[0] = 1;
			pthread_mutex_unlock(&shared_buffer_lock);
			printf("udp reset\n");
			st = 0;
		} // end if(st=='s')
		
		else if (shared_buffer[0]<65000) {
			sscanf(udp_buffer, "%d %d %d %d %d %d %d %d", 
				&audio_sample[0], &audio_sample[1], &audio_sample[2], &audio_sample[3],
				&audio_sample[4], &audio_sample[5], &audio_sample[6], &audio_sample[7]);
			
			pthread_mutex_lock(&shared_buffer_lock);
			// move samples to buffer
			for(i=0; i<8; i++){
				// shared_buffer[0] is the NUMBER of received samples			
				shared_buffer[shared_buffer[0]+i] = audio_sample[i] ; //<<23
			} // end for(i=)
			pthread_mutex_unlock(&shared_buffer_lock);
			// jump the offset over the 8 samples just loaded
			shared_buffer[0] = shared_buffer[0] + 8;
		} // end else if
		
	} // end while(1)
}

///////////////////////////////////////////////////////////////
// THREAD -- write the data to the audio FIFO
///////////////////////////////////////////////////////////////
void * write_fpga() {	

	int i, audio_sample_scaled;
	int sample_num_shared, sample_num_out;
	// playing: state=1
	int state = 0; 
	
	while(1){
		// Play once for every sound download
		// -- detect download by changing sample number in shared memory
		// -- set state to "playing"
		
		// wait for # of samples in shared memory to be greater than 128
		// --and reset the output sample counter to 1
		// --start reading the shared memory at the first sample
		
		// --load FIFO buffer until sample number in shared memory 
		// is the same as the one just loaded
		// set state to "not playing" 
		
		// if not_playing then check for start conditions
		if (state==0){
			pthread_mutex_lock(&shared_buffer_lock);
			// wait for enough samples to fill the audio FIFO the first time
			if(shared_buffer[0]>128 ) {
				state = 1;
				sample_num_out = 1;
				//sample_num_shared = 0;
				printf("play start \n");
			} // end if(shared_buffer[0]>128 )
			pthread_mutex_unlock(&shared_buffer_lock);
		} // end if(state==0)
		
		// if playing the load the FIFO and check for end of samples
		else if(state==1){	
			// generate approx 8khz audio
			// load the audio FIFO from shared memory
			// and dup it 6 times 6x8=48 kHz
			int jj;
			while (((*audio_fifo_data_ptr>>16) & 0xff) > 6) {
				pthread_mutex_lock(&shared_buffer_lock);
				if (sample_num_out < shared_buffer[0]){
					audio_sample_scaled = shared_buffer[sample_num_out];				
					sample_num_out++;
					// share audio time with video
					//*shared_ptr = audio_time/48000 ;
					// move samples to audio FIFO
					for(jj=0; jj<6; jj++){
						//*audio_left_data_ptr = audio_sample_scaled;
						*audio_right_data_ptr = audio_sample_scaled;
						// update audio sample time 
						//audio_time++ ;	
					} // for(jj=)	
				} // if (sample_num_out < *shared_ptr_fpga)
				// If we are out of samples, get out!
				else break; // the inner while loop
				pthread_mutex_unlock(&shared_buffer_lock);
			} // end while (((*audio
			
			// and reset the state machine if out of samples
			pthread_mutex_lock(&shared_buffer_lock);
			if (sample_num_out>=shared_buffer[0]) {
				state = 0; // turn it off
				shared_buffer[0] = 1;
			} // else if (sample_num_out>=*shared_ptr_fpga)	
			pthread_mutex_unlock(&shared_buffer_lock);
		} // else if(state==1){      
	} // while(1)
}

///////////////////////////////////////////////////////////////
// set up the addresses and threads
///////////////////////////////////////////////////////////////
int main() {	
	// ======================================================
	// FPGA register setup
	// ======================================================
	// Declare volatile pointers to I/O registers (volatile 	
	// means that IO load and store instructions will be used 	
	// to access these pointer locations, 
	// instead of regular memory loads and stores) 
	
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
	
	// ======================================================
	// Thread stuff
	// ======================================================
	// from 
	// http://man7.org/linux/man-pages/man3/pthread_setaffinity_np.3.html
	// see also
	// http://man7.org/linux/man-pages/man3/CPU_SET.3.html
	// The cpu_set_t structure is opaque and must be manipulated with
	// the following macros
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);  
	// put just one processsor into the list
	CPU_SET(0, &cpuset);
	
	// the thread identifiers
	pthread_t thread_read, thread_write ;
	
	// the semaphore inits
	// read is not ready becuase nothing has been input yet
	//sem_init(&enter_cond, 0, 0);
	// print is ready at init time
	//sem_init(&print_cond, 0, 1); 
	
	//For portability, explicitly create threads in a joinable state 
	// thread attribute used here to allow JOIN
	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
	
	// now the threads
	pthread_create(&thread_read,NULL,read_udp,NULL);
	pthread_create(&thread_write,NULL,write_fpga,NULL);
	
	// for efficiency, force  threads onto processor ZERO
	pthread_setaffinity_np(thread_read, sizeof(cpu_set_t), &cpuset);
	pthread_setaffinity_np(thread_write, sizeof(cpu_set_t), &cpuset);
	
	// In this case the thread never exit
	pthread_join(thread_read,NULL);
	pthread_join(thread_write,NULL);
	return 0;
}
///////////////////////////////////////////////////////////////