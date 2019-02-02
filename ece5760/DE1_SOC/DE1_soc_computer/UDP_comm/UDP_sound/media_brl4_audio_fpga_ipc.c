////////////////////////////////////////////////
/// Audio fpga interface gets data via ipc
/// from udp receiver
/// compile with
/// gcc media_brl4_audio_fpga_ipc.c -o Audf
////////////////////////////////////////////////
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

// virtual to real address pointers

//volatile unsigned int * red_LED_ptr = NULL ;
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
// shared memory for video process
key_t mem_key=0xf0;
int shared_mem_id; 
int *shared_ptr;
int audio_time;

// shared memory with UDP audio process
key_t mem_key_fpga=0xf0f1;
size_t mem_size_fpga=262143; //  2^16 ints
int shared_mem_id_fpga; 
volatile int *shared_ptr_fpga;
 
int main(void)
{
	// ======================================================
	
	// Declare volatile pointers to I/O registers (volatile 	
	// means that IO load and store instructions will be used 	
	// to access these pointer locations, 
	// instead of regular memory loads and stores) 

  	// === shared memory ====================================
	// with video process
	shared_mem_id = shmget(mem_key, 100, IPC_CREAT | 0666);
	shared_ptr = shmat(shared_mem_id, NULL, 0);
	
	// === shared memory ====================================
	// with fpga audio process
	// shared_ptr_fpga keeps the current sample count
	// samples start at shared_ptr_fpga+1
	shared_mem_id_fpga = shmget(mem_key_fpga, mem_size_fpga, IPC_CREAT | 0666);
	shared_ptr_fpga = shmat(shared_mem_id_fpga, NULL, 0);
	
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
	int sample_num_shared, sample_num_out;
	// playing: state=1
	int state = 0; 
	
	while(1){	
		// Play once for every sound download
		// -- detect download by changing sample number in shared memory
		// -- set state to "playing"
		
		// wait for # of samples in shared memory to be greater than 10
		// --and reset the output sample counter to 1
		// --start reading the shared memory at the first sample
		
		// --load FIFO buffer until sample number in shared memory 
		// is the same as the one just loaded
		// set state to "not playing" 
		
		if (state==0){
			if(*shared_ptr_fpga>10 ) {
				state=1;
				sample_num_out = 1;
				//sample_num_shared = 0;
				printf("start\n");
			}
		}
		
		else if(state==1){	
			// generate approx 8khz audio
			// load the audio FIFO from shared memory
			// and dup it 6 times 6x8=48 kHz
			int jj;
			while (((*audio_fifo_data_ptr>>24) & 0xff) > 6) {
				if (sample_num_out < *shared_ptr_fpga){
					audio_sample_scaled = *(shared_ptr_fpga + sample_num_out);
					sample_num_out++;
					// share audio time with video
					*shared_ptr = audio_time/48000 ;
					// move samples to audio FIFO
					for(jj=0; jj<6; jj++){
						*audio_left_data_ptr = audio_sample_scaled;
						*audio_right_data_ptr = audio_sample_scaled;
						// update audio sample time 
						audio_time++ ;	
					} // for(jj=)	
				} // if (sample_num_out < *shared_ptr_fpga)
				// If we are out of samples, get out!
				else break;
			} // end while (((*audio
			
			// and reset the state machine if out of samples
			if (sample_num_out>=*shared_ptr_fpga) {
				state = 0; // turn it off
				*shared_ptr_fpga = 1;
			} // else if (sample_num_out>=*shared_ptr_fpga)	
		} // else if(state==1){
	} // end while(1)
} // end main

