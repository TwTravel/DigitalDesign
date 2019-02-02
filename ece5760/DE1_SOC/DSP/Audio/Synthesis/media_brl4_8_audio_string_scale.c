///////////////////////////////////////
/// Audio
/// compile with
/// gcc media_brl4_8_audio_string_scale.c -o testA -lm -O3
/// string fundamental frequency = Fs*sqrt(rho)/(2*(string_size-2))
/// The factor of 2 is there becuase we want to scale with the round-trip distance
/// of the wave on the string. 
/// Subtracting 2 for the zero end points.
/// Take the sqrt(rho) to make it ~speed of sound
/// For Fs=48kHz, rho=0.04, string_size=20 
/// string fundamental frequency = 250+/-5 Hz
/// see http://math.aalto.fi/~ksalo2/akusem/sem_FDM.pdf
/// eq 12 is Courant stability condition rho<1.0
///////////////////////////////////////
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
#include <netdb.h> 

#include "address_map_arm_brl4.h"

#define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0) 
#define MIN(a,b) ((a)>(b) ? (b):(a))

/* function prototypes */
void VGA_text (int, int, char *);
void VGA_box (int, int, int, int, short);
void VGA_line(int, int, int, int, short) ;

// virtual to real address pointers

volatile unsigned int * red_LED_ptr = NULL ;
//volatile unsigned int * res_reg_ptr = NULL ;
//volatile unsigned int * stat_reg_ptr = NULL ;

// audio stuff
volatile unsigned int * audio_base_ptr = NULL ;
volatile unsigned int * audio_fifo_data_ptr = NULL ; //4bytes
volatile unsigned int * audio_left_data_ptr = NULL ; //8bytes
volatile unsigned int * audio_right_data_ptr = NULL ; //12bytes
// phase accumulator
// drum-specific multiply macros simulated by shifts
#define times0pt5(a) ((a)>>1) 
#define times0pt25(a) ((a)>>2) 
#define times2pt0(a) ((a)<<1) 
#define times4pt0(a) ((a)<<2) 
#define times0pt9998(a) ((a)-((a)>>12)) //>>10
#define times0pt9999(a) ((a)-((a)>>13)) //>>10
#define times0pt99999(a) ((a)-((a)>>16)) //>>10
#define times0pt999(a) ((a)-((a)>>10)) //>>10
#define times_rho(a) (((a)>>4)) //>>2

// fixed pt macros suitable for 32-bit sound
typedef signed int fix28 ;
//multiply two fixed 4:28
#define multfix28(a,b) ((fix28)(((( signed long long)(a))*(( signed long long)(b)))>>28)) 
//#define multfix28(a,b) ((fix28)((( ((short)((a)>>17)) * ((short)((b)>>17)) )))) 
#define float2fix28(a) ((fix28)((a)*268435456.0f)) // 2^28
#define fix2float28(a) ((float)(a)/268435456.0f) 
#define int2fix28(a) ((a)<<28)
#define fix2int28(a) ((a)>>28)
// shift fraction to 32-bit sound
#define fix2audio28(a) (a<<4)

// some fixed point values
#define FOURfix28 0x40000000 
#define SIXTEENTHfix28 0x01000000
#define ONEfix28 0x10000000
#define two32 4294967296

// string size paramenters
#define string_size 40 
#define string_out  10
#define string_pluck 30
// #define string_size 20 
// #define string_out  5
// #define string_pluck 15
// string arrays
int copy_size = string_size*4 ;
fix28 string_n[string_size] ;
// drup amp at last time
fix28 string_n_1[string_size] ;
// drum update
fix28 new_string[string_size] ;
// initial condition
float triangle_n[string_size] ;
// C scale
fix28 rho[8] ;
// musical scale frequencies
//                 C4      D4      E4      F4      G4      A4      B4      C5
float notes[8] = { 261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25 } ;
// octave scaling
float note_scale[6] = {0.0625, 0.125, 0.25, 0.50, 1.00, 2.00};
//

clock_t note_time ;

// the light weight buss base
void *h2p_lw_virtual_base;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
void *vga_pixel_virtual_base;

// character buffer
volatile unsigned int * vga_char_ptr = NULL ;
void *vga_char_virtual_base;

// /dev/mem file descriptor
 int fd;
 
int main(void)
{
	// Declare volatile pointers to I/O registers (volatile 	// means that IO load and store instructions will be used 	// to access these pointer locations, 
	// instead of regular memory loads and stores) 

	// === need to mmap: =======================
	// FPGA_CHAR_BASE
	// FPGA_ONCHIP_BASE      
	// HW_REGS_BASE        
  
	// === get FPGA addresses ==================
    // Open /dev/mem
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
    
    // get virtual addr that maps to physical
	h2p_lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );	
	if( h2p_lw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap1() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA LED control 
	red_LED_ptr =(unsigned int *)(h2p_lw_virtual_base +  	 			LEDR_BASE);

	// address to resolution register
	//res_reg_ptr =(unsigned int *)(h2p_lw_virtual_base +  	 	//		resOffset);

	 //addr to vga status
	//stat_reg_ptr = (unsigned int *)(h2p_lw_virtual_base +  	 	//		statusOffset);

	// audio addresses
	// base address is control register
	audio_base_ptr = (unsigned int *)(h2p_lw_virtual_base +  	 			AUDIO_BASE);
	audio_fifo_data_ptr  = audio_base_ptr  + 1 ; // word
	audio_left_data_ptr = audio_base_ptr  + 2 ; // words
	audio_right_data_ptr = audio_base_ptr  + 3 ; // words

	// === get VGA char addr =====================
	// get virtual addr that maps to physical
	vga_char_virtual_base = mmap( NULL, FPGA_CHAR_SPAN, ( 	PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_CHAR_BASE );	
	if( vga_char_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap2() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA LED control 
	vga_char_ptr =(unsigned int *)(vga_char_virtual_base);

	// === get VGA pixel addr ====================
	// get virtual addr that maps to physical
	vga_pixel_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( 	PROT_READ | PROT_WRITE ), MAP_SHARED, fd, 			FPGA_ONCHIP_BASE);	
	if( vga_pixel_virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap3() failed...\n" );
		close( fd );
		return(1);
	}
    
    // Get the address that maps to the FPGA pixel buffer
	vga_pixel_ptr =(unsigned int *)(vga_pixel_virtual_base);

	// ===========================================
	// drum index
	int i, j, dist2, octave, junk;
	fix28 new_string_temp, temp;
	float famp, fsd ;
	// sample rate
	float drive_freq, Fs = 48000 ; //	
	
	// read the LINUX clock (microSec)
	// and set the time so that a not plays soon
	note_time = clock() ;
	printf("Enter octave(0-4), pluck amp,StD\n\r");
	junk = scanf("%d %f %f", &octave, &famp, &fsd);
	if (octave<0) octave = 0;
	if (octave>4) octave = 4;
	// compute the rhos for the scale
	for (i=0; i<8; i++){
		// for each note: compute rho = (2*(length-2)*f/Fs)**2
		rho[i] = float2fix28(pow(2.0*(string_size-2)*note_scale[octave]*notes[i]/Fs, 2.0));
	}
	j = 0; 
	
	while(1){	

		// generate a drum simulation
		// load the FIFO until it is full
		while (((*audio_fifo_data_ptr>>24)& 0xff) > 1) {
			// do drum time sample
			// equation 2.18 
			// from http://people.ece.cornell.edu/land/courses/ece5760/LABS/s2018/WaveFDsoln.pdf
			for (i=1; i<string_size-2; i++){  
				temp = string_n[i-1] + string_n[i+1] - times2pt0(string_n[i]);
				new_string_temp = multfix28(rho[j], temp);
				new_string[i] = times0pt9999(new_string_temp + times2pt0(string_n[i]) - times0pt9999(string_n_1[i])) ;       
			}
			
			// free end
			//new_string[string_size-1] = new_string[string_size-2];
			// update arrays for next step
			memcpy(string_n_1, string_n, copy_size);
			memcpy(string_n, new_string, copy_size);
			
			
			// send time sample to the audio FiFOs
			*audio_left_data_ptr =  fix2audio28(new_string[string_out]);
			*audio_right_data_ptr = fix2audio28(new_string[string_out]);
			
		} // end while (((*audio	
		
		if (clock()- note_time > 700000) {
			j++; 
			if(j>7) j=0;
			// pluck the string
			// this is a set up for zerro initial displacment with
			// the strike as a velocity
			for (i=1; i<string_size-2; i++){
				// noise
				//string_n[i] = (fix28)((rand() & 0xfffffff) - 0x4ffffff);
				// Triangle puck
				triangle_n[i] = (i<=string_pluck)? ((float)i/(float)string_pluck) :
					(1-(((float)i-string_pluck)/(float)(string_size-string_pluck))) ;
				// Gaussian pluck
				string_n[i] = float2fix28(triangle_n[i]*famp*exp(-(float)(i-string_pluck)*(i-string_pluck)/(fsd*fsd)));
				string_n_1[i] = string_n[i] ;      	
			}
			string_n[0] = 0;
			string_n_1[0] = 0;
			string_n[string_size-1] = 0;
			string_n_1[string_size-1] = 0;
			
			// read LINUX time for the next drum strike
			note_time = clock();
			
		};

	} // end while(1)
} // end main

