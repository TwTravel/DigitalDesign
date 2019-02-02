#include <stdio.h>
#include "rs232.h"
#include "readBMP.h"

Image *image;
int n,m;

int main(int argc, char **argv)
{
	
	int error;
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
	
	image = (Image *)malloc(sizeof(Image));
	if(argc == 2) {
		n = ImageLoad(argv[1], image);
	} else n = ImageLoad("./bball.bmp", image);
	
	if(n == 0) {
		printf("image load fail\n");
		return 0;
	}
	
	int size = image->sizeX*image->sizeY;
	int pix_start = 0;
	int offset = 0;
	
	int rlow = 0;
	int rhigh = 0;
	int rmid = 0;
	int j = 0;
	int i = 0;
	int r = 0;
	int packet_checksum = 0;
	int jz = 0;
	int iz = 0;
	int zpix_start = 0;
	int red = 0;
	int green = 0;
	int blue = 0;
	int startColorIndex = 0;
	int gray = 0;
	n = image->sizeX;
	m = image->sizeY;
	int holdj = 0;
	unsigned char result = 0;
	
	gray = 1;
	while(gray == 1)
		gray = PollComport(0,&result,1); //to flush out initial data
	
	printf("beginning, done flushing receive buffer\n");
	
	
	while(pix_start < n*m) {
		j = (int)(pix_start / n);
		holdj = j;
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
		//printf("(%i,%i)\n",r >> 15, (r << 9) >> 6); 
		//printf("(%i,%i); r = %i; rlow = %i, rmid = %i, rhigh = %i\n",i,j,r,rlow,rmid,rhigh);
		for(offset = 0; offset < 12; offset ++) {
			packet[3+offset] = 0;
			for(j = 0; j < 8; j ++){
				zpix_start = pix_start + offset*8+j;
				jz = (int)(zpix_start / n);
				iz = (int)(zpix_start % n);
				
				startColorIndex = (m-1-jz)*n*3 + (iz)*3;
				if(startColorIndex < m*n*3-3) {
					red = (unsigned char)(image->data[startColorIndex] >> 2);
					green = (unsigned char)(image->data[startColorIndex+1] >> 1);
					blue = (unsigned char)(image->data[startColorIndex+2] >> 3);
					
					
					gray = red + green + blue;
					if(gray > 255) gray = 255;
					
					if(gray > 128) gray = 1;
					else gray = 0;
				}
				else gray = 0;
				packet[3+offset] = (packet[3+offset])*2 + gray;
				
			}	
			
		}
		
		packet_checksum = computeChecksum(packet);
		packet[15] = packet_checksum;
		
		for(offset = 0; offset < 16; offset ++) {
			error = SendByte(0,(unsigned char)packet[offset]);
			
		}
		//check for an error transmitted from the FPGA back to us
		PollComport(0,&result,1);
		
		if(result != 0) {
			pix_start += 96;
			iz = (int)(pix_start % n);
			if(iz < 96) pix_start -= iz;
		} else printf("failed\n");
		
	}
		//SendByte(0,(unsigned char)128);
	return 0;
}
//function to compute the checksum
int computeChecksum(int *packet)
{
	int checksum = 0;
	int i = 0;
	for(i = 0; i < 15; i ++)
		checksum ^= packet[i];
	return checksum;
}
