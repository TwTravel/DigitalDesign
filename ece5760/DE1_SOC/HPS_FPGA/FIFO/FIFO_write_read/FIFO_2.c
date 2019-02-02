///////////////////////////////////////
// FIFO test
// 256 32-bit words read and write
// compile with
// gcc FIFO_2.c -o fifo2  -O3
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
#include <math.h> 

// FIFO functions
// void read_delay(void);
// int  read_empty(void);
// int  write_full(void)
// int  try_read(void) ;
// int  try_write(int) ;
// void read(void);
// void write(void);

// main bus; scratch RAM
// used only for testing
#define FPGA_ONCHIP_BASE      0xC8000000
#define FPGA_ONCHIP_SPAN      0x00001000

// main bus; FIFO write address
#define FIFO_BASE            0xC0000000
#define FIFO_SPAN            0x00001000
// the read and write ports for the FIFOs
// you need to query the status ports before these operations
// PUSH the write FIFO
// POP the read FIFO
#define FIFO_WRITE		     (*(FIFO_write_ptr))
#define FIFO_READ            (*(FIFO_read_ptr))

/// lw_bus; FIFO status address
#define HW_REGS_BASE          0xff200000
#define HW_REGS_SPAN          0x00005000 
// WAIT looks nicer than just braces
#define WAIT {}
// FIFO status registers
// base address is current fifo fill-level
// base+1 address is status: 
// --bit0 signals "full"
// --bit1 signals "empty"
#define WRITE_FIFO_FILL_LEVEL (*FIFO_write_status_ptr)
#define READ_FIFO_FILL_LEVEL  (*FIFO_read_status_ptr)
#define WRITE_FIFO_FULL		  ((*(FIFO_write_status_ptr+1))& 1 ) 
#define WRITE_FIFO_EMPTY	  ((*(FIFO_write_status_ptr+1))& 2 ) 
#define READ_FIFO_FULL		  ((*(FIFO_read_status_ptr+1)) & 1 )
#define READ_FIFO_EMPTY	      ((*(FIFO_read_status_ptr+1)) & 2 )
// arg a is data to be written
#define FIFO_WRITE_BLOCK(a)	  {while (WRITE_FIFO_FULL){WAIT};FIFO_WRITE=a;}
// arg a is data to be written, arg b is success/fail of write: b==1 means success
#define FIFO_WRITE_NOBLOCK(a,b) {b=!WRITE_FIFO_FULL; if(!WRITE_FIFO_FULL)FIFO_WRITE=a; }
// arg a is data read
#define FIFO_READ_BLOCK(a)	  {while (READ_FIFO_EMPTY){WAIT};a=FIFO_READ;}
// arg a is data read, arg b is success/fail of read: b==1 means success
#define FIFO_READ_NOBLOCK(a,b) {b=!READ_FIFO_EMPTY; if(!READ_FIFO_EMPTY)a=FIFO_READ;}


// the light weight buss base
void *h2p_lw_virtual_base;
// HPS_to_FPGA FIFO status address = 0
volatile unsigned int * FIFO_write_status_ptr = NULL ;
volatile unsigned int * FIFO_read_status_ptr = NULL ;

// RAM FPGA command buffer
// main bus addess 0x0800_0000
volatile unsigned int * sram_ptr = NULL ;
void *sram_virtual_base;

// HPS_to_FPGA FIFO write address
// main bus addess 0x0000_0000
void *h2p_virtual_base;
volatile unsigned int * FIFO_write_ptr = NULL ;
volatile unsigned int * FIFO_read_ptr = NULL ;

// /dev/mem file id
int fd;	

// timer variables
struct timeval t1, t2;
double elapsedTime;
	
int main(void)
{

	// Declare volatile pointers to I/O registers (volatile 	
	// means that IO load and store instructions will be used 	
	// to access these pointer locations, 
	// instead of regular memory loads and stores)  
  
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
	// the two status registers
	FIFO_write_status_ptr = (unsigned int *)(h2p_lw_virtual_base);
	// From Qsys, second FIFO is 0x20
	FIFO_read_status_ptr = (unsigned int *)(h2p_lw_virtual_base + 0x20); //0x20
	
	//============================================
	
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
    // Get the address that maps to the FIFO read/write ports
	FIFO_write_ptr =(unsigned int *)(h2p_virtual_base);
	FIFO_read_ptr = (unsigned int *)(h2p_virtual_base + 0x10); //0x10
	
	//============================================
	int N ;
	int data[1024] ;
	int i ;
	int temp1, temp2;
	
	while(1) 
	{
		printf("\n\r enter N=");
		scanf("%d", &N);
		if (N>500) N = 1 ;
		if (N<1) N = 1 ;
		
		// generate a sequence
		for (i=0; i<N; i++){
			data[i] = i + 1 ;
		}
		
		// print fill levels
		printf("=====================\n\r");
		printf("fill levels before interleaved write\n\r");
		printf("write=%d read=%d\n\r", WRITE_FIFO_FILL_LEVEL, READ_FIFO_FILL_LEVEL);
		
		// start the timer
		//gettimeofday(&t1, NULL);
		
		// ====================================
		// send array to FIFO and read every time
		// ====================================
		for (i=0; i<N; i++){
			int r;
			// wait for a slot then
			// do the actual FIFO write
			FIFO_WRITE_BLOCK(data[i]);
			// now read it back
			while (!READ_FIFO_EMPTY) {
				printf("return=%d %d %d\n\r", FIFO_READ, WRITE_FIFO_FILL_LEVEL, READ_FIFO_FILL_LEVEL) ; 
			}	
		}
		if(!READ_FIFO_EMPTY) printf("delayed last read\n\r");
		// and one last read because
		// for this example occasionally there is one left on the loopback
		while (!READ_FIFO_EMPTY) {
			printf("return=%d %d %d\n\r", FIFO_READ, WRITE_FIFO_FILL_LEVEL, READ_FIFO_FILL_LEVEL) ;
		}
		
		// finish timing the transfer
		// gettimeofday(&t2, NULL);
		// elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		// elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		// printf("T=%8.0f uSec  \n\r", elapsedTime);
		
		// ======================================
		// send array to FIFO and read entire block
		// ======================================
		// print fill levels
		printf("=====================\n\r");
		printf("fill levels before block write\n\r");
		printf("write=%d read=%d\n\r", WRITE_FIFO_FILL_LEVEL, READ_FIFO_FILL_LEVEL);
		
		// send array to FIFO and read block
		for (i=0; i<N; i++){
			// wait for a slot
			// do the FIFO write
			FIFO_WRITE_BLOCK(data[i]);
		}
		
		printf("fill levels before block read\n\r");
		printf("write=%d read=%d\n\r", WRITE_FIFO_FILL_LEVEL, READ_FIFO_FILL_LEVEL);
		
		// get array from FIFO while there is data in the FIFO
		while (!READ_FIFO_EMPTY) {
			// print array from FIFO read port
			printf("return=%d %d %d\n\r", FIFO_READ, WRITE_FIFO_FILL_LEVEL, READ_FIFO_FILL_LEVEL) ; 
		}
		
		// FIFO fill levels
		printf("fill levels after block read\n\r");
		printf("write=%d read=%d\n\r", WRITE_FIFO_FILL_LEVEL, READ_FIFO_FILL_LEVEL);
		printf("=====================\n\r");
	} // end while(1)
} // end main

//////////////////////////////////////////////////////////////////
/// end /////////////////////////////////////