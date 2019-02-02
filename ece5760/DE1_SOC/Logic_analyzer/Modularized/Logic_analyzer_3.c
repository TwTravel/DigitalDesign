///////////////////////////////////////
// Logic Analyzer test
// 
// compile with
// gcc Logic_analyzer_3.c -o la3  -O3
///////////////////////////////////////
//=======================================================
// Logic analyser
//=======================================================
// check for trigger
// -- if triggered log data to memory
// -- signal HPS
//
// write the controller memory 
// Bus address 0xC0000000
// -- addr 0 -- new data? yes==1
// -- addr 1 -- allow capture to occur -- arm 
// -- addr 2 -- trigger count (after trigger event)
// write trigger mask -- two 32 bit words 
// -- addr 254 dont care mask a "1" means "care"
// -- addr 255 actual bits
// read the controller memory
// -- addr 250 -- data capture complete == 1
// -- addr 251 -- addr_complete (sram addr of trigger sample)
// 
// Read the alanyzer buffer
// Bus address 0xC0001000
// read 1000 words starting at offset "addr_complete"
// and wrapping at 12 bits

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

// ==========================================
// PuTTY serial terminal control codes
// see 
// http://ascii-table.com/ansi-escape-sequences-vt-100.php
// cursor_pos(1,1) sets the cursor to the upper-left corner of the screen
#define cursor_pos(line,column) printf("\x1b[%02d;%02dH",line,column)	
#define clr_right printf("\x1b[K")
#define clrscr() printf( "\x1b[2J")
#define home()   printf( "\x1b[H")
#define pcr()    printf( '\r')
#define crlf     putchar(0x0a); putchar(0x0d);
// from http://www.comptechdoc.org/os/linux/howlinuxworks/linux_hlvt100.html
// and colors from http://www.termsys.demon.co.uk/vtansi.htm
#define green_text printf("\x1b[32m")
#define yellow_text printf("\x1b[33m")
#define red_text printf("\x1b[31m")
#define rev_text printf("\x1b[7m")
#define normal_text printf("\x1b[0m")

// ==========================================
// main bus; scratch RAM at 0xC0000000
//       analyzer buffer at 0xC0001000
// Change THESE if you move the SRAM in Qsys
#define FPGA_SRAM_BASE      0xC0000000
#define FPGA_SRAM_SPAN      0x00002000
#define ANALYZER_OFFSET     0x00001000
// ==========================================

/// lw_bus 
#define HW_REGS_BASE          0xff200000
#define HW_REGS_SPAN          0x00005000 


// the light weight buss base
void *h2p_lw_virtual_base;
// HPS_to_FPGA FIFO status address = 0
//volatile unsigned int * FIFO_write_status_ptr = NULL ;
//volatile unsigned int * FIFO_read_status_ptr = NULL ;

// HPS_to_FPGA FIFO write address
// main bus addess 0x0000_0000
void *h2p_virtual_base;
// RAM FPGA command buffer
volatile unsigned int * control_sram_ptr = NULL ;
volatile unsigned int * analyzer_sram_ptr = NULL ;


// /dev/mem file id
int fd;	

// timer variables
struct timeval t1, t2;
double elapsedTime;
	
// array LUT for hex digit to binary
int hex2bin[16] = {0, 1, 10, 11, 100, 101, 110, 111, 
			       1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111};

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
	
	//============================================
	
	//  RAM FPGA parameter/analyzer addrs 
	h2p_virtual_base = mmap( NULL, FPGA_SRAM_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_SRAM_BASE); 	
	
	if( h2p_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    // Get the address that maps to the RAM buffers
	control_sram_ptr =(unsigned int *)(h2p_virtual_base);
	analyzer_sram_ptr =(unsigned int *)(h2p_virtual_base + ANALYZER_OFFSET);
	
	// ===========================================

	int logic_data[1024] ;
	int logic_arm, trigger_count=500, trigger_mask, trigger_value ;
	int initial_addr ;
	int i, j, jj, fmt, lower_limit, upper_limit;
	unsigned int data_word;

	trigger_count = 500 ;
	// trigger_count is the numbr of samples AFTER the trigger
	// -- 100 < trigger_count < 900
	// trigger_mask are the bits that matter to the application
	// -- For example, 0h0000ffff, will only look at the lowr 16 bits
	// trigger_value is the exact bit patttern in the trigger word to match
	// -- For example, with the mask above, 0h0f001000 will cause a trigger 
	// -- when the trigger word equals 0hxxxx1000, where x means "don't care"
	
	// print limits realative to tirgger
	lower_limit = -10 ;
	upper_limit = 11 ;
	fmt = 2;
	while(1) 
	{
		// slow it down for testing
		normal_text;
		printf("\n\r enter trigger mask, trigger value\n\r");
		scanf("%x %x", &trigger_mask, &trigger_value ); 
		
		// === setup ===
		// set arm command
		logic_arm = 1;
		*(control_sram_ptr+1) = logic_arm;
		
		// set trigger position (100-900)
		*(control_sram_ptr+2) = trigger_count;
		
		// set trigger mask
		*(control_sram_ptr+254) = trigger_mask;
		// set tirgger vaule
		*(control_sram_ptr+255) = trigger_value;
		
		// set data ready flag
		// data is actually read by the FPGA when this flag is set
		*(control_sram_ptr) = 1 ;
		// FPGA clears flag when done reading
		// wait for FPGA read done
		while (*(control_sram_ptr)==1) ;
		
		// === analyzer response ===
		// wait for analyzer data capture done
		while (*(control_sram_ptr+250)==0) ;
		
		// read back the address in buffer memory at
		// which the trigger occured 
		// (trigger actually occurs at  initial_address-1)
		initial_addr = *(control_sram_ptr+251);
		
		// print a few data values around the trigger point
		// trigger point is initial_addr-1
		clrscr();
		cursor_pos(1,10);
		green_text;
		printf("--trig_mask=%x -- trig_value=%x \n\r", trigger_mask, trigger_value);
		printf("count                                 state\n\r");
		normal_text;
		
		if (fmt==1){ // hex format
			for (i=lower_limit; i<upper_limit; i++) {
				printf("%x %d ", 
					*(analyzer_sram_ptr+initial_addr-1+i) & 0x0fffffff,
					*(analyzer_sram_ptr+initial_addr-1+i)>>28);
				if (i==0) printf("-- trigger sample\n\r");
				else printf("\n\r");
			}
		}
		else if (fmt==2){
			for (i=lower_limit; i<upper_limit; i++) {
				data_word = *(analyzer_sram_ptr+initial_addr-1+i) & 0x0fffffff ;
				printf("%07x ", data_word);
				// convert to binary
				jj = 0;
				for(j=24; j>=0; j=j-4){
					if(jj==0){ normal_text; jj=1;}
					else {yellow_text; jj=0;}
					printf("%04d", hex2bin[(data_word>>j) & 0x0f]);
				}
				normal_text;
				printf("  %d", *(analyzer_sram_ptr+initial_addr-1+i)>>28);
				if (i==0) printf(" <-- trigger sample\n\r");
				else printf("\n\r");
			}	
		}
		
		// Clear the done flag which signals the FPGA to start
		// logging data again.
		*(control_sram_ptr+250) = 0;
	
		// start the timer
		// gettimeofday(&t1, NULL);
		// // finish timing the transfer
		 // gettimeofday(&t2, NULL);
		// elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000000.0;      // sec to us
		// elapsedTime += (t2.tv_usec - t1.tv_usec) ;   // us to 
		 // printf("T=%8.0f uSec  \n\r", elapsedTime); 
		
	} // end while(1)
} // end main

//////////////////////////////////////////////////////////////////
/// end /////////////////////////////////////