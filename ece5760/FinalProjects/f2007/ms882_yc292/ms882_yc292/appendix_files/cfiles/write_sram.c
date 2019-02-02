#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include <sys/alt_irq.h>
#include "write_sram.h"


// function to write data
void write_data(int x ,int z )
{

    while (!IORD_ALTERA_AVALON_PIO_DATA(ACCEPT_BASE));
    IOWR_ALTERA_AVALON_PIO_DATA(DATA_BASE, x);
    IOWR_ALTERA_AVALON_PIO_DATA(ADDRESS_BASE, z);
    IOWR_ALTERA_AVALON_PIO_DATA(VALID_BASE, 1);

    while (!IORD_ALTERA_AVALON_PIO_DATA(FDONE_BASE));
    IOWR_ALTERA_AVALON_PIO_DATA(VALID_BASE, 0);

    return;
}



int main  ()
{

int temp_1 = 0;
int temp_2 = 0;
int i,j;
int x_addr = 0;
int y_addr = 0;
int temp_3=0;

int count=0;
j=0;


//writing 640 X 480 Image
for (i=0; i < (640*480); i++)
  {


//accumulating data to be of 16 bit so that to send it to the hardware
	temp_1 = (a[i]<<8)+a[i+1];
	temp_3 = (y_addr<<9)+ x_addr;

//calling the write_data function
	write_data(temp_1,temp_3);
	i++;
    j++;
	x_addr++;

//incrementing y on every 320th value of x
	if (x_addr == 320){
		x_addr = 0;
		y_addr++;
	}






     }//for


printf (" Writing Done, %d\t%d", j,y_addr);
}


