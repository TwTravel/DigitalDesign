#include <stdio.h>
#include "rs232.h"
#include "readBMP.h"

Image *image;
int n,m;

int main(int argc, char **argv)
{
	
	int error;
	//the data to send over serial
	int packet[] = {0,0,0,0,
					0,0,0,0,
					0,0,0,0,
					0,0,0,0};
	printf("Serial Communication in C\n");
	
	printf("Opening Comport: COM1\n");
	error = OpenComport(0, 115200);
	if(error) {
		printf("Failed!!! Exiting\n");
		return 0;
	}
	
	//allocate memory for the Image structure
	image = (Image *)malloc(sizeof(Image));
	if(argc == 2) {
		n = ImageLoad(argv[1], image); //load the image if specified via command line
	} else n = ImageLoad("./bball.bmp", image); //otherwise load default image
	
	if(n == 0) { //uh oh an error occured, probably b/c you didn't use a .BMP file that is 24 bit depth
		printf("image load fail\n");
		return 0;
	}
	
	int size = image->sizeX*image->sizeY; //size of image
	int pix_start = 0; //start indice
	int offset = 0;
	
	int rlow = 0; //low byte of x,y coordinate
	int rhigh = 0; //high byte of x,y coordinate
	int rmid = 0; //middle byte of x,y coordinate
	int j = 0;
	int i = 0;
	int r = 0;
	int packet_checksum = 0; //the checksum for current packet
	int jz = 0;
	int iz = 0;
	int zpix_start = 0;
	int red = 0;
	int green = 0;
	int blue = 0;
	int startColorIndex = 0;
	n = image->sizeX;
	m = image->sizeY;
	
	//while there are still pixels to send to the FPGA
	while(pix_start < n*m) {
		j = (int)(pix_start / n);
		i = (int)(pix_start % n);
		//if(m == 640) i = i / 2;
		if(n == 640)
			r = (i*1024 + j)*16;
		else r = (i*512 + j)*64;
		rlow = r % 256;
		rmid = (int)(r >> 8) % 256;
		rhigh = (int)(r >> 16) % 256;
		packet[0] = rhigh;
		packet[1] = rmid;
		packet[2] = rlow;
		
		//send 12 data bytes per package
		for(offset = 0; offset < 12; offset ++) {
			zpix_start = pix_start + offset;
			jz = (int)(zpix_start / n);
			iz = (int)(zpix_start % n);
			
			startColorIndex = (m-1-jz)*n*3 + (iz)*3;
			//convert the 8 bit color values into 3,3,2 for sending to be properly read by the FPGA
			red = (unsigned char)(image->data[startColorIndex]) >> 5;
			green = (unsigned char)(image->data[startColorIndex+1]) >> 5;
			blue = (unsigned char)(image->data[startColorIndex+2]) >> 6;
			
			packet[3+offset] = (red * 32) + (green * 4) + blue;
			
		}
		packet_checksum = computeChecksum(packet);
		packet[15] = packet_checksum;
		//send the 16 bytes to the FPGA
		for(offset = 0; offset < 16; offset ++) {
			error = SendByte(0,(unsigned char)packet[offset]);
			//printf("%i\n",packet[offset]);
		}
		//if (j > 63 && i > 262)
		//	scanf("%d",&r);
		pix_start += 12;
		
	}
		SendByte(0,(unsigned char)128);
	return 0;
}

//function to compute the XOR checksum of a packet
int computeChecksum(int *packet)
{
	int checksum = 0;
	int i = 0;
	for(i = 0; i < 15; i ++)
		checksum ^= packet[i];
	return checksum;
}
