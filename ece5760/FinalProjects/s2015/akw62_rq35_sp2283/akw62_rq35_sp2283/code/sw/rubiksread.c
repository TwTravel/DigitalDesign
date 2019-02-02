#include "system.h"
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include "altera_up_avalon_parallel_port.h"
#include "main.h"
#include "rubiksread.h"

void rubiksRead(int * cubeSide)
{
	// x, y - indices of cubies
	// m, n - indices of kernel (in pixels)
	int m, n, x, y;
	
	// keep track of pixel sums
	
	int pixelSum = 0;
	int pixelSumCr = 0;
	int pixelSumCb = 0;
	int pixelSumY = 0;
	
	// size of lowpass filter kernel
	int kernelSize = 15;
	
	// top right corner of first kernel
	int cubeX = 75;
	int cubeY = 40;
	
	// running location of kernel
	int startX = 0;
	int startY = 0;
	
	// distance between kernels
	int deltaX = 80;
	int deltaY = 75;
	
	// color value thresholds
	//Cb is high byte of pixelSum
	int wMaskLCb = 0x74;
	int wMaskHCb = 0x90;
	int wMaskLCr = 0x74;
	int wMaskHCr = 0x90;
	
	int gMaskLCb = 0x50;
	int gMaskHCb = 0x74;
	int gMaskLCr = 0x50;
	int gMaskHCr = 0x74;
	
	int yMaskLCb = 0x3F;
	int yMaskHCb = 0x68;
	int yMaskLCr = 0x77;
	int yMaskHCr = 0x90;
	
	int oMaskLCb = 0x54;
	int oMaskHCb = 0x78;
	int oMaskLCr = 0x9C;
	int oMaskHCr = 0xB8;
	
	int rMaskLCb = 0x70;
	int rMaskHCb = 0x80;
	int rMaskLCr = 0x90;
	int rMaskHCr = 0xB8;
	
	int bMaskLCb = 0x88;
	int bMaskHCb = 0xA8;
	int bMaskLCr = 0x70;
	int bMaskHCr = 0x81;
	
	int xVal = 0;
	int yVal = 0;
	
	int cubeSet; // check if cubie is set
	
	/* Declare volatile pointer to pixel buffer 
	(volatile means that IO load and store instructions will be used to 	
    access these pointer locations, instead of regular memory loads and 	
    stores) */
	// VGA pixel buffer address
  	volatile short * pixel_buffer = (short *) PIXEL_BUFFER_BASE;	
	//while(1) {
	
	int debug;
	// cycle through each cubie
	do{
		startY = cubeY;
		for (y = 0; y < 3; y++) {
			startX = cubeX;
			cubeSet = 0;
			for (x = 0; x < 3; x++) {
				do {
					cubeSet = 0;
					while (cubeSet == 0) {
						/* 16 bit byte-addressable memory with 24 bit YCbCr values, storage will be as follows
				
							16		8		0
							|	Cb	|	Y	| 
							|	-	|	Cr	| 																*/
						
						
						pixelSumCr = 0;
						pixelSumCb = 0;
						pixelSumY = 0;
			
						// store one kernel of CbCr values
						for (n = startY; n < kernelSize + startY; n++){
							for (m = startX; m < kernelSize + startX; m++){
								pixel_buffer = PIXEL_BUFFER_BASE + 1280*n + 4*m;
								pixelSumY  += *pixel_buffer   & 0x000000FF;
								pixelSumCb += *pixel_buffer++ & 0x0000FF00;
								pixelSumCr += *pixel_buffer++ & 0x000000FF;
							}
						}

						// lowpass filter of kernel
						pixelSumCb = ((pixelSumCb / (kernelSize*kernelSize)) & 0x0000FF00) >> 8;
						pixelSumCr = (pixelSumCr / (kernelSize*kernelSize)) & 0x000000FF;
						pixelSumY = (pixelSumY / (kernelSize*kernelSize)) & 0x000000FF;
						
						// hi byte is Cb, lo byte is Cr
						pixelSum = ((pixelSumCb << 8) | pixelSumCr);
						
						// check lowpass filtered value against thresholds to determine color
						
						if (((wMaskLCb < pixelSumCb) && (wMaskHCb > pixelSumCb)) && ((wMaskLCr < pixelSumCr) && (wMaskHCr > pixelSumCr)) && ((pixelSumY < 0x8C) && (pixelSumY > 0x70))) 
						{
							cubeSet = 1;
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, 0x00);
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, pixelSum);
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, pixelSum);
							cubeSide[3*y+x] = W;
						} 
						else if (((yMaskLCb < pixelSumCb) && (yMaskHCb > pixelSumCb)) && ((yMaskLCr < pixelSumCr) && (yMaskHCr > pixelSumCr)) )
						{
							cubeSet = 1;		
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, 0x01);
							cubeSide[3*y+x] = Y;
						}
						else if (((oMaskLCb < pixelSumCb) && (oMaskHCb > pixelSumCb)) && ((oMaskLCr < pixelSumCr) && (oMaskHCr > pixelSumCr)) )
						{				
							cubeSet = 1;
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, 0x02);
							cubeSide[3*y+x] = O;
						}
						else if (((rMaskLCb < pixelSumCb) && (rMaskHCb > pixelSumCb)) && ((rMaskLCr < pixelSumCr) && (rMaskHCr > pixelSumCr)))
						{	
							cubeSet = 1;
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, 0x04);
							cubeSide[3*y+x] = R;
						}
						else if (((gMaskLCb < pixelSumCb) && (gMaskHCb > pixelSumCb)) && ((gMaskLCr < pixelSumCr) && (gMaskHCr > pixelSumCr)))
						{	
							cubeSet = 1;
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, 0x10);
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, pixelSum);
							cubeSide[3*y+x] = G;
						}
						else if (((bMaskLCb < pixelSumCb) && (bMaskHCb > pixelSumCb)) && ((bMaskLCr < pixelSumCr) && (bMaskHCr > pixelSumCr)))
						{
							cubeSet = 1;
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, 0x08);
							//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, pixelSumY);
							cubeSide[3*y+x] = B;
						}
						
						else 
						{
							IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, 0x10000 | pixelSum);
						}
						//IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, /*0x10000 |*/ pixelSumY);
						
						// display location of scanning squares and the color being detected
						for (n = startY; n < kernelSize + startY; n++){
							for (m = startX; m < kernelSize + startX; m++){
								pixel_buffer = PIXEL_BUFFER_BASE+1280*n + 4*m;
								*pixel_buffer++ = (pixelSumCb << 8) | 0x80;
								*pixel_buffer++ = pixelSumCr;
							}
						}
						//cubeSet = 0;
					}
					debug = IORD_ALT_UP_PARALLEL_PORT_DATA(SWITCHES_BASE);
					xVal = ((debug & 0x700) >> 8);
					yVal = ((debug & 0x7000) >> 12);
					
					IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_RED_BASE, pixelSum);
					IOWR_ALT_UP_PARALLEL_PORT_DATA(LED_GREEN_BASE, pixelSumY);
					
					if((debug & 0x8000) > 0 && !((x == xVal) && (y == yVal))){
						cubeSet = 0;
					}
				} while((debug & 0x8000) > 0 && (x == xVal) && (y == yVal));
				startX += deltaX;
			}
			startY += deltaY;
		}
		debug = IORD_ALT_UP_PARALLEL_PORT_DATA(SWITCHES_BASE);
	} while((debug & 0x8000) > 0);
	//}

}
