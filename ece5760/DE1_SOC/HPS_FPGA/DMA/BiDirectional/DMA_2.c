///////////////////////////////////////
// DMA test
// Send data from HPS on-chip memory
// to FPGA SRAM
// compile with
// gcc DMA_2.c -o dma  -O3
//
// based on a design from
// https://github.com/robertofem/CycloneVSoC-examples/blob/master/Linux-applications/DMA_transfer_FPGA_DMAC/README.md
//
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

// ======================================
#define H2F_AXI_MASTER_BASE   0xC0000000
// main bus; scratch RAM
#define FPGA_ONCHIP_BASE      0xC8000000
#define FPGA_ONCHIP_SPAN      0x00010000
// h2f bus
// RAM FPGA port s2
// main bus addess 0x0800_0000
volatile unsigned int * sram_ptr = NULL ;
void *sram_virtual_base;

// ======================================
// lw_bus; DMA  addresses
#define HW_REGS_BASE        0xff200000
#define HW_REGS_SPAN        0x00005000 
#define DMA					0xff200000

// from datasheet
// https://www.altera.com/en_US/pdfs/literature/ug/ug_embedded_ip.pdf
#define DMA1_STATUS_OFFSET		0x00 
#define DMA1_READ_ADD_OFFSET	0x01 
#define DMA1_WRT_ADD_OFFSET		0x02	
#define DMA1_LENGTH_OFFSET		0x03
#define DMA1_CNTL_OFFSET		0x06	

// second DMA is at offset 0x20 in Qsys
// but these offsets are in WORDS 
// 0x20 bytes = 32 bytes = 8 words
#define DMA2_STATUS_OFFSET		8+0
#define DMA2_READ_ADD_OFFSET	8+1 
#define DMA2_WRT_ADD_OFFSET		8+2	
#define DMA2_LENGTH_OFFSET		8+3
#define DMA2_CNTL_OFFSET		8+6	

#define LENGTH_ZERO_MASK		0x010
// the h2f light weight bus base
void *h2p_lw_virtual_base;
// HPS_to_FPGA DMA address = 0
volatile unsigned int * DMA_base_ptr = NULL ;	

// ======================================
// HPS onchip memory base/span
// 2^16 bytes at the top of memory
#define HPS_ONCHIP_BASE		0xffff0000
#define HPS_ONCHIP_SPAN		0x00010000
// HPS onchip memory (HPS side!)
volatile unsigned int * hps_onchip_ptr = NULL ;
//volatile unsigned int * hps_onchip_ptr = NULL ;
void *hps_onchip_virtual_base;
// ======================================
// HPS linux MMU memory
//int test_array[];
int data[16384] ;
// ======================================
		  
// WAIT looks nicer than just braces
#define WAIT {}

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
	// DMA status register
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}
	// the DMA registers
	DMA_base_ptr = (unsigned int *)(h2p_lw_virtual_base);
	
	
	//============================================
	
	//  RAM FPGA parameter addr 
	sram_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_ONCHIP_BASE); 	
	
	if( sram_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    // Get the address that maps to the RAM buffer
	sram_ptr =(unsigned int *)(sram_virtual_base);
	
	// ===========================================

	// HPS onchip ram
	hps_onchip_virtual_base = mmap( NULL, HPS_ONCHIP_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HPS_ONCHIP_BASE); 	
	
	if( hps_onchip_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    // Get the address that maps to the HPS ram
	//hps_onchip_ptr =(unsigned int *)(hps_onchip_virtual_base);
	hps_onchip_ptr =(unsigned int *)(hps_onchip_virtual_base);
	
	//============================================
	int N ;
	//int data[16384] ;
	int i, j ;
	int temp1, temp2;
	
	while(1) 
	{
		printf("\n\r enter N=");
		scanf("%d", &N);
		if (N>16300) N = 16300 ;
		if (N<1) N = 1 ;
		printf("================\n\r");
		
		// === HPS sdram ============================
		// === program r/w
		printf("HPS sdram\n\r");
		// === write local memory
		// start the timer
		gettimeofday(&t1, NULL);
		// generate a sequence
		for (i=0; i<N; i++){
			data[i] = i ;
		}
		// finish timing the write
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("HPS sdram write T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		
		// === read back local memory
		// start the timer
		gettimeofday(&t1, NULL);
		temp1 = 0 ;
		for (i=0; i<N; i++){
			temp1 += data[i] ;
		}
		// finish timing the read
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("HPS sdram read T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		//printf("HPS memory sum=%d \n\r", temp1);
		printf("================\n\r");
		
		// === HPS onchip memory ======================
		// === program r/w
		// to try:
		// 64 bit read/write for speedup
		// dma verion of memcpy?
		
		printf("HPS onchip mmap\n\r");
		// === write local memory
		// start the timer
		gettimeofday(&t1, NULL);
		// generate a sequence
		for (i=0; i<N; i++){
			*(hps_onchip_ptr+i) = i ;
		}
		
		// finish timing the write
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("HPS memory write T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		
		// === read back local memory
		// start the timer
		gettimeofday(&t1, NULL);
		temp1 = 0 ;
		for (i=0; i<N; i++){
			temp1 += *(hps_onchip_ptr+i) ;	
		}
		
		// finish timing the read
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("HPS memory read T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		printf("HPS memory sum=%d \n\r", temp1);
		printf("================\n\r");
		
		// === FPGA sram ==============================
		// === program r/w
		printf("FPGA sram mmap\n\r");
		// === write fpga memory
		// start the timer
		gettimeofday(&t1, NULL);
		// generate a sequence
		for (i=0; i<N; i++){
			*(sram_ptr+i) = i ;
		}
		// finish timing the transfer
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("fpga write T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		
		// === read back fpga memory
		// start the timer
		gettimeofday(&t1, NULL);
		temp1 = 0 ;
		for (i=0; i<N; i++){
			temp1 += *(sram_ptr+i) ;
		}
		// finish timing the transfer
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("fpga read T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		printf("fpga memory sum=%d \n\r", temp1);
		printf("================\n\r");
		
		// === FPGA DMA ==============================
		// program write to local memory
		// DMA write local-to-fpga
		// program read fpga
		printf("HPS onchip DMA to FPGA and back\n\r");
		// clear fpga memory (to make sure the DMA happens)
		for (i=0; i<N; i++){
			*(sram_ptr+i) = 0 ;
		}
		
		// === put data in onchip ram
		// start the timer
		gettimeofday(&t1, NULL);
		// generate a sequence
		for (i=0; i<N; i++){
			*(hps_onchip_ptr+i) = i ;
		}
		// finish timing the write
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("HPS memory write T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		
		// === DMA transfer HPS->FPGA 
		// set up DMA
		// from https://www.altera.com/en_US/pdfs/literature/ug/ug_embedded_ip.pdf
		// section 25.4.3 Tables 224 and 225
		*(DMA_base_ptr + DMA1_STATUS_OFFSET) = 0;
		// read bus-master gets data from HPS addr=0xffff0000
		*(DMA_base_ptr + DMA1_READ_ADD_OFFSET) = 0xffff0000 ;
		// write bus_master for fpga sram is mapped to 0x08000000 
		*(DMA_base_ptr + DMA1_WRT_ADD_OFFSET) = 0x08000000 ;
		// copy 4000 bytes for 1000 ints
		*(DMA_base_ptr + DMA1_LENGTH_OFFSET) = N*4 ;
		// set bit 2 for WORD transfer
		// set bit 3 to start DMA
		// set bit 7 to stop on byte-count
		// start the timer because DMA will start
		gettimeofday(&t1, NULL);
		*(DMA_base_ptr + DMA1_CNTL_OFFSET) = 0b10001100;
		while ((*(DMA_base_ptr + DMA1_STATUS_OFFSET) & LENGTH_ZERO_MASK) == 0) WAIT;
		// finish timing the transfer
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("DMA fpga write T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		
		// check the FPGA SRAM
		temp1 = 0 ;
		for (i=0; i<N; i++){
			//temp1 += data[i]; 
			temp1 += *(sram_ptr+i) ;
		}
		printf("fpga memory sum=%d \n\r", temp1);
		
		// clear onchip memory to make sure transfer back from FPGA works
		for (i=0; i<N; i++){
			*(hps_onchip_ptr+i) = 0 ;
		}
		
		// === DMA FPGA memory -> HPS
		*(DMA_base_ptr + DMA2_STATUS_OFFSET) = 0;
		// read bus-master gets data from FPGA SRAM
		*(DMA_base_ptr + DMA2_READ_ADD_OFFSET) = 0x08000000 ;
		// write bus_master for HPS onchip 
		*(DMA_base_ptr + DMA2_WRT_ADD_OFFSET) = 0xffff0000 ;
		// copy 4000 bytes for 1000 ints
		*(DMA_base_ptr + DMA2_LENGTH_OFFSET) = N*4 ;
		// set bit 2 for WORD transfer
		// set bit 3 to start DMA
		// set bit 7 to stop on byte-count
		// start the timer because DMA will start
		gettimeofday(&t1, NULL);
		*(DMA_base_ptr + DMA2_CNTL_OFFSET) = 0b10001100;
		while ((*(DMA_base_ptr + DMA2_STATUS_OFFSET) & LENGTH_ZERO_MASK) == 0) WAIT;
		// finish timing the transfer
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("DMA fpga read T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		
		// === add onchip to check transfer
		// start the timer
		gettimeofday(&t1, NULL);
		temp1 = 0 ;
		for (i=0; i<N; i++){
			//temp1 += data[i]; 
			temp1 += *(hps_onchip_ptr+i) ;
		}
		// finish timing the transfer
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		printf("HPS memory read T=%.0f uSec  n/sec=%2.3e\n\r", elapsedTime, N*1e6/elapsedTime);
		printf("HPS memory sum=%d \n\r", temp1);
		// time the transaction
		
	} // end while(1)
} // end main
	
//////////////////////////////////////////////////////////////////
/// end /////////////////////////////////////