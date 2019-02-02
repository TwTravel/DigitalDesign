/////////////////////////////////////////////
/// Audio udp receiver and sends data
///  to fpga interface process
///  via shared memory
/// compile with
/// gcc media_brl4_audio_udp_ipc.c -o Audp
//////////////////////////////////////////////
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
//#define float2fix30(a) ((int)((a)*1073741824)) // 2^30

// virtual to real address pointers

//volatile unsigned int * red_LED_ptr = NULL ;
//volatile unsigned int * res_reg_ptr = NULL ;
//volatile unsigned int * stat_reg_ptr = NULL ;

// audio stuff
//volatile unsigned int * audio_base_ptr = NULL ;
//volatile unsigned int * audio_fifo_data_ptr = NULL ; //4bytes
//volatile unsigned int * audio_left_data_ptr = NULL ; //8bytes
//volatile unsigned int * audio_right_data_ptr = NULL ; //12bytes

// the light weight buss base
//void *h2p_lw_virtual_base;

// /dev/mem file descriptor
//int fd;

// shared memory with FPGA audio process
key_t mem_key_fpga=0xf0f1;
size_t mem_size_fpga=262143; //  2^16 ints
int shared_mem_id_fpga; 
volatile int *shared_ptr_fpga;
//int audio_time;
 
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

  	// === shared memory ====================================
	// with fpga audio process
	// shared_ptr_fpga keeps the current sample count
	// samples start at shared_ptr_fpga+1
	shared_mem_id_fpga = shmget(mem_key_fpga, mem_size_fpga, IPC_CREAT | 0666);
	if(shared_mem_id_fpga==-1) printf("shmget failed");
	shared_ptr_fpga = shmat(shared_mem_id_fpga, NULL, 0);

	// =======================================================
	// 
	int i;
	// start over command
	char st; 
	char sync_buffer[] = "8\n"; // actual string is ingored by matlab
	
	// init the sample count
	// The ZERO index is the sample COUNT
	// The FIRST sample is in index=1
	*shared_ptr_fpga = 1;
	
	while(1){	
	
		// get sample from socket
		n = recvfrom(sock,buffer,512,0,(struct sockaddr *)&from, &length);
		//load st with the first character in the rec string
		st = buffer[0];
		buffer[n]=0; // zero terminate the string
		//printf("%s %d\n", buffer, *shared_ptr_fpga);
		
		// check for a start command
		if (st=='s'){
			*shared_ptr_fpga = 1;
			printf("reset\n");
			st = 0;
		} // if
		
		else if (*shared_ptr_fpga<65000) {
			sscanf(buffer, "%d %d %d %d %d %d %d %d", 
				&audio_sample[0], &audio_sample[1], &audio_sample[2], &audio_sample[3],
				&audio_sample[4], &audio_sample[5], &audio_sample[6], &audio_sample[7]);
				
			// move samples to shared memory
			for(i=0; i<8; i++){
				// add the shared address, the VALUE of the zero shared element, and current index
				*(shared_ptr_fpga + *shared_ptr_fpga + i) = audio_sample[i];
			} // for(i=)
			// jump the offset over the 8 samples just loaded
			*shared_ptr_fpga = *shared_ptr_fpga + 8;
		} // else if
		
	} // end while(1)
} // end main

