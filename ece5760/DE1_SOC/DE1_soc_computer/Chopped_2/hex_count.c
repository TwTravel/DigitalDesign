#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

// === FPGA side ===
// #define HW_REGS_BASE ( 0xff200000 )
// #define HW_REGS_SPAN ( 0x00200000 )
// #define HW_REGS_MASK ( HW_REGS_SPAN - 1 )
// #define LED_PIO_BASE 0x00
// #define HEX_PIO_BASE 0x10

#include "address_map_arm_brl4.h"

//int hex_lut[]={0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78,
 //              0x00, 0x10, 0x08, 0x03, 0x46, 0x21, 0x06, 0x0e};
// === HPS side ===
//#define GPIO1_BASE 0xFF709000
//#define GPIO1_EXT_OFFSET 0x14

// the bit position of the switch
#define bit_25 0x02000000
// ===============

int main(void)
{
    // === FPGA ===
    volatile unsigned int *h2p_lw_led_addr=NULL;
    volatile unsigned int *h2p_lw_hex_addr=NULL;
    void *h2p_lw_virtual_base;
    int fd;
    // === HPS switch ===
    volatile unsigned int *led_addr=NULL;
    void *virtual_base_gpio;
    int fd1 ;
    // ================= 
     volatile int i;
    
    // === get FPGA addresses ===
    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
    
    // get virtual addr that maps to physical
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA LED control 
	h2p_lw_led_addr=(unsigned int *)(h2p_lw_virtual_base + (( LEDR_BASE ) ));
    
    // get address for hex display offset 0x10
    h2p_lw_hex_addr=(volatile unsigned int *)(h2p_lw_virtual_base + HEX3_HEX0_BASE);

    // === get HPS GPIO1 address ===
    // Open /dev/mem
        if( ( fd1 = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
                printf( "ERROR: could not open \"/dev/mem\"...\n" );
                return( 1 );
        }

    // get virtual addr that maps to physical
        virtual_base_gpio = mmap( NULL, 0x1000, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd1, HPS_GPIO1_BASE );
        if( virtual_base_gpio == MAP_FAILED ) {
                printf( "ERROR: mmap() failed...\n" );
                close( fd1);
                return(1);
        }

    //Get the address that maps to the GPIO base
    led_addr=(volatile unsigned int *)(virtual_base_gpio);

    // =============================
    // On HPS side:
    //   read the GPIO input register at led_addr+0x14
    //   led_addr happens to be at offset zero from GPIO base address
    // On FPGA side:
    //   output to two FPGA PIO ports to control
    //   red LEDs and 4 hex digits
    int step;
    while(1){
	printf(">");
	scanf("%d", &step);
    	*h2p_lw_led_addr = step ;
		// 4-bits per hex digit output
		// decoded in the FPGA side
        *h2p_lw_hex_addr = step ;
		// test HPS button mapping
        printf("HPS button=%x\n",((int)*(led_addr+0x14)& bit_25)>>25);
    }	

   // close( fd1);
   return 0;
}
