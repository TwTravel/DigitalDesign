#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

#define GPIO1_BASE 0xFF709000
#define GPIO1_EXT_OFFSET 0x50

#define RST_BASE 0xFFD05000
#define RST_IO_OFFSET 0x14

// the position of the green led
#define bit_24 0x01000000
// the postion of the gpio1 reset bit
#define bit_26 0x04000000

int main(void)
{
        volatile unsigned int *led_addr=NULL;
        volatile unsigned int *led_ddr=NULL;
        volatile unsigned int *in_reg=NULL;
        volatile unsigned int *rst_reg=NULL;
        volatile int i; // a counter
        void *virtual_base_gpio;
        void *virtual_base_rst;
        int fd;
        printf( "blink green LED\n");

    //=== get the reset address ===============
    // Open /dev/mem
        if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
                printf( "ERROR: could not open \"/dev/mem\"...\n" );
                return( 1 );
        }

    // get virtual addr that maps to physical
        virtual_base_rst = mmap( NULL, 0x1000, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, RST_BASE );
        if( virtual_base_rst == MAP_FAILED ) {
                printf( "ERROR: mmap() failed...\n" );
                close( fd );
                return(1);
        }

    //===  Get the address that maps to the rset reg =====s
        rst_reg=(volatile unsigned int *)(virtual_base_rst+RST_IO_OFFSET);
        printf("reset initial=%x %x\n",(int)rst_reg, (int)*rst_reg);
        // clear the reset condition
        *rst_reg = 0; //*rst_reg ^ bit_26 ;
        printf("reset reg=%x\n", *rst_reg);

        if( munmap( virtual_base_rst, 0x1000 ) != 0 ) {
                printf( "ERROR: munmap() failed...\n" );
                close( fd );
                return( 1 );
        }
        close( fd );

    //=== get the gpio address ===============
    // Open /dev/mem
        if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
                printf( "ERROR: could not open \"/dev/mem\"...\n" );
                return( 1 );
        }

    // get virtual addr that maps to physical
        virtual_base_gpio = mmap( NULL, 0x1000, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, GPIO1_BASE );
        if( virtual_base_gpio == MAP_FAILED ) {
                printf( "ERROR: mmap() failed...\n" );
                close( fd );
                return(1);
        }

    //Get the address that maps to the LED =====s
        led_addr=(volatile unsigned int *)(virtual_base_gpio);
        // set the data direction to output
        led_ddr = led_addr + 1 ;
        *led_ddr =  bit_24;
        printf("set DDR=%x %x\n",(int)led_ddr, (int)*led_ddr);

        *led_addr = *led_addr ^ bit_24;
        printf("data reg=%x %x\n",(int)led_addr, *led_addr);

        printf("in reg=%x, %x\n",(int)(led_addr+0x14),(int) *(led_addr+0x14));

//      while(1);

   // now just write
        while(1){
                // Toggle  to the PIO register
                *led_addr = bit_24 ;
                for(i=0;i<10000;i++);
                *led_addr = 0 ;
                for(i=0;i<10000;i++);
        }

        if( munmap( virtual_base_gpio, 0x1000 ) != 0 ) {
                printf( "ERROR: munmap() failed...\n" );
                close( fd );
                return( 1 );
        }
        close( fd );

        return 0;
}