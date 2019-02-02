/*
 * File: string_synth.c
 * Authors: Erissa Irani (eli8)
 *			Albert Xu (awx2)
 *			Sophia Yan (sjy33)
 * Date: May 1, 2017
 * Description: This program runs on the ARM core of the DE1-SoC. 
 *				It reads in music from an input file and interfaces 
 *				with the FPGA to synthesize the notes on a plucked 
 *				string.
 */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <math.h>
#include <sys/types.h>
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <sys/mman.h>
#include <sys/time.h> 
#include "address_map_arm_brl4.h"
#include <pthread.h>

// the light weight buss base
void *h2p_lw_virtual_base;
void *switch_virtual_base;
void *led_virtual_base;

// pixel buffer
volatile unsigned int * vga_pixel_ptr = NULL ;
volatile unsigned int * switch_address= NULL;
void *vga_pixel_virtual_base;

/* function prototypes */
void VGA_text (int, int, char *);
void VGA_text_clear();
void VGA_box (int, int, int, int, short);
void VGA_disc (int, int, int, short);
void draw_main_screen();

// character buffer
volatile unsigned int * vga_char_ptr = NULL ;
volatile unsigned int * base_ptr;
volatile unsigned int * switch_ptr;
volatile unsigned int * led_ptr;
void *vga_char_virtual_base;

// /dev/mem file id
int fd;

// shared memory 
key_t mem_key=0xf0;
int shared_mem_id; 
int *shared_ptr;
int shared_time;
int shared_note;
char shared_str[64];

char text_top_row[40]="Welcome to the Big Red Strings!\0";
char text_bottom_row[40]="Select a song to play:\0";
char text1[40]="Select the melody's instrument:\0";
char text2[40]="Select the harmony's instrument:\0";
char text3[40]="Select the third instrument:\0";

#define PLUCK_PORT1 0x00001000
#define S12_PORT 0x00001100
#define S34_PORT 0x00001200
#define PLUCK_PORT2 0x00001300
#define S12_PORT2 0x00001400
#define S34_PORT2 0x00001500
#define PLUCK_PORT3 0x00001600
#define S12_PORT3 0x00001700
#define S34_PORT3 0x00001800

double note_to_frequency(char note[3]) {

	double frequency;

	// because case statements don't work on strings in C ;_;

	// part of 2nd octave
//        if (note[0] == 'E' && note[1] == '_' && note[2] == '2')
//		frequency = 82.4; 
//        else if (note[0] == 'F' && note[1] == '_' && note[2] == '2')
//		frequency = 87.3 ; 
//        else if (note[0] == 'F' && note[1] == '#' && note[2] == '2')
//		frequency = 92.5; 
        if (note[0] == 'G' && note[1] == '_' && note[2] == '2')
		frequency = 98.0; 
        else if (note[0] == 'G' && note[1] == '#' && note[2] == '2')
		frequency = 103.8;
	else if (note[0] == 'A' && note[1] == '_' && note[2] == '2')
		frequency = 110.0;
	else if (note[0] == 'B' && note[1] == 'b' && note[2] == '2')
		frequency = 116.5;
	else if (note[0] == 'B' && note[1] == '_' && note[2] == '2')
		frequency = 123.5;
        // 3rd octave
	else if (note[0] == 'C' && note[1] == '_' && note[2] == '3')
		frequency = 130.8;
	else if (note[0] == 'C' && note[1] == '#' && note[2] == '3')
		frequency = 138.6;
	else if (note[0] == 'D' && note[1] == '_' && note[2] == '3')
		frequency = 146.8;
	else if (note[0] == 'E' && note[1] == 'b' && note[2] == '3')
		frequency = 155.6;
	else if (note[0] == 'E' && note[1] == '_' && note[2] == '3')
		frequency = 164.8;
	else if (note[0] == 'F' && note[1] == '_' && note[2] == '3')
		frequency = 174.6;
	else if (note[0] == 'F' && note[1] == '#' && note[2] == '3')
		frequency = 185.0;
	else if (note[0] == 'G' && note[1] == '_' && note[2] == '3')
		frequency = 196.0;
	else if (note[0] == 'G' && note[1] == '#' && note[2] == '3')
		frequency = 207.7;
	else if (note[0] == 'A' && note[1] == '_' && note[2] == '3')
		frequency = 220.0;
	else if (note[0] == 'B' && note[1] == 'b' && note[2] == '3')
		frequency = 233.1;
	else if (note[0] == 'B' && note[1] == '_' && note[2] == '3')
		frequency = 246.9;

	// 4th octave
	else if (note[0] == 'C' && note[1] == '_' && note[2] == '4')
		frequency = 261.6;
	else if (note[0] == 'C' && note[1] == '#' && note[2] == '4')
		frequency = 277.2;
	else if (note[0] == 'D' && note[1] == '_' && note[2] == '4')
		frequency = 293.7;
	else if (note[0] == 'E' && note[1] == 'b' && note[2] == '4')
		frequency = 311.1;
	else if (note[0] == 'E' && note[1] == '_' && note[2] == '4')
		frequency = 329.6;
	else if (note[0] == 'F' && note[1] == '_' && note[2] == '4')
		frequency = 349.2;
	else if (note[0] == 'F' && note[1] == '#' && note[2] == '4')
		frequency = 370.0;
	else if (note[0] == 'G' && note[1] == '_' && note[2] == '4')
		frequency = 392.0;
	else if (note[0] == 'G' && note[1] == '#' && note[2] == '4')
		frequency = 415.3;
	else if (note[0] == 'A' && note[1] == '_' && note[2] == '4')
		frequency = 440.0;
	else if (note[0] == 'B' && note[1] == 'b' && note[2] == '4')
		frequency = 466.2;
	else if (note[0] == 'B' && note[1] == '_' && note[2] == '4')
		frequency = 493.9;

	// 5th octave
	else if (note[0] == 'C' && note[1] == '_' && note[2] == '5')
		frequency = 523.3;
	else if (note[0] == 'C' && note[1] == '#' && note[2] == '5')
		frequency = 554.4;
	else if (note[0] == 'D' && note[1] == '_' && note[2] == '5')
		frequency = 587.3;
	else if (note[0] == 'E' && note[1] == 'b' && note[2] == '5')
		frequency = 622.3;
	else if (note[0] == 'E' && note[1] == '_' && note[2] == '5')
		frequency = 659.3;
	else if (note[0] == 'F' && note[1] == '_' && note[2] == '5')
		frequency = 698.5;
	else if (note[0] == 'F' && note[1] == '#' && note[2] == '5')
		frequency = 740.0;
	else if (note[0] == 'G' && note[1] == '_' && note[2] == '5')
		frequency = 784.0;
	else if (note[0] == 'G' && note[1] == '#' && note[2] == '5')
		frequency = 830.6;
	else if (note[0] == 'A' && note[1] == '_' && note[2] == '5')
		frequency = 880.0;
	else if (note[0] == 'B' && note[1] == 'b' && note[2] == '5')
		frequency = 932.3;
	else if (note[0] == 'B' && note[1] == '_' && note[2] == '5')
		frequency = 987.8;

        // 6th octave 
	else if (note[0] == 'C' && note[1] == '_' && note[2] == '6')
		frequency = 1046.5;
	else if (note[0] == 'C' && note[1] == '#' && note[2] == '6')
		frequency = 1109;

	else
		frequency = 0;

	return frequency;
}

typedef struct{
        FILE *file;
        unsigned int *ptr1;
        unsigned int *ptr2;
        unsigned int *pluck_ptr;
}Data;

void* file_parse(void* arg){
        Data* data;
        data=(Data*)arg;
        FILE *file;
        file=data->file;
        unsigned int *ptr1;
        ptr1=data->ptr1;
        unsigned int *ptr2;
        ptr2=data->ptr2;
        unsigned int *pluck_ptr;
        pluck_ptr=data->pluck_ptr;
        char line[30];
        char note1[3];
        char note2[3];
        char note3[3];
        char note4[3];
        char note_len[4];
        int parse_time[4];
        int wait_time;
        int pluck;
        unsigned int str12;
        unsigned int str34;
        double freq1;
        double freq2;
        double freq3;
        double freq4;
        unsigned int l1;
        unsigned int l2;
        unsigned int l3;
        unsigned int l4;
        while (fgets(line, sizeof(line), file)) {
                strncpy(note1, line, 3);
                strncpy(note2, line+4,3);
                strncpy(note3, line+8,3);
                strncpy(note4, line+12,3);
                strncpy(note_len, line+16, 4);
                wait_time = 0;
                wait_time += (note_len[0] - '0') * 1000;
                wait_time += (note_len[1] - '0') * 100;
                wait_time += (note_len[2] - '0') * 10;
                wait_time += (note_len[3] - '0');

                printf("%c%c%c,%c%c%c,%c%c%c,%c%c%c, %d\n", note1[0], note1[1], note1[2],note2[0],note2[1],note2[2],note3[0],note3[1],note3[2],note4[0],note4[1],note4[2], wait_time);

                freq1 =note_to_frequency(note1);
                freq2= note_to_frequency(note2);
                freq3= note_to_frequency(note3);
                freq4= note_to_frequency(note4);
                if (freq1==0){
                        l1=0;
                }
                else{
                        l1=(unsigned int)(48000./freq1);
                        pluck=pluck+1;
                }

                if (freq2==0){
                        l2=0;
                }
                else{
                        l2=(unsigned int)(48000./freq2);
                       pluck=pluck+2;
                }

                if (freq3==0){
                        l3=0;
                }
                else{
                        l3=(unsigned int)(48000./freq3);
                        pluck=pluck+4;
                }

                if (freq4==0){
                        l4=0;
                }
                else{
                        l4=(unsigned int)(48000./freq4);
                        pluck=pluck+8;
                }
                str12=(unsigned int)((l1<<10)|l2);
                str34=(unsigned int)((l3<<10)|l4);
//                printf("%f\n,%f\n,%f\n,%f\n", freq1, freq2, freq3,freq4);
  //              printf("%u,%u\n",str12,str34);
                *pluck_ptr=pluck;
                *ptr1=str12;
                *ptr2=str34;
                usleep(10000);
                *pluck_ptr=0;
                pluck=0;       
                usleep(wait_time*1000);
        }
        free(data);
        return NULL;
}

int main(int argc, char* argv[]) {
        if (argc < 3) {
                printf("Invalid number of arguments\n");
                return 1;
        }

        shared_mem_id = shmget(mem_key, 100, IPC_CREAT | 0666);
        shared_ptr = shmat(shared_mem_id, NULL, 0);

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
        led_ptr=(unsigned int *)(h2p_lw_virtual_base);
        switch_ptr= (unsigned int *)(h2p_lw_virtual_base+SW_BASE);
        unsigned int *pluck_ptr1=(unsigned int *)(h2p_lw_virtual_base+PLUCK_PORT1);
        unsigned int *s12_ptr1=(unsigned int *)(h2p_lw_virtual_base+S12_PORT);
        unsigned int *s34_ptr1=(unsigned int *)(h2p_lw_virtual_base+S34_PORT);
        unsigned int *pluck_ptr2=(unsigned int *)(h2p_lw_virtual_base+PLUCK_PORT2);
        unsigned int *s12_ptr2=(unsigned int *)(h2p_lw_virtual_base+S12_PORT2);
        unsigned int *s34_ptr2=(unsigned int *)(h2p_lw_virtual_base+S34_PORT2);
        unsigned int *pluck_ptr3=(unsigned int *)(h2p_lw_virtual_base+PLUCK_PORT3);
        unsigned int *s12_ptr3=(unsigned int *)(h2p_lw_virtual_base+S12_PORT3);
        unsigned int *s34_ptr3=(unsigned int *)(h2p_lw_virtual_base+S34_PORT3);
        // Initialize mouse stuff
        int mouse_fd, mouse_bytes;
        unsigned char mouse_data[3];
        unsigned char *pDevice = "/dev/input/mice";
        mouse_fd = open(pDevice, O_RDWR);
        if (mouse_fd == -1) {
                printf("Error opening %s\n", pDevice);
                return -1;
        }
        int left, right;
        signed char x, y;
        int flags = fcntl(mouse_fd, F_GETFL, 0);
        fcntl(mouse_fd, F_SETFL, flags | O_NONBLOCK);
        int mouse_x=320, mouse_y=240;


        int file_name_len = strlen(argv[1]);
        int file_name_len2=strlen(argv[2]);
        int file_name_len3=strlen(argv[3]);
        char* file_name = malloc(sizeof(char)*file_name_len);
        char* file_name2= malloc(sizeof(char)*file_name_len2);
        char* file_name3= malloc(sizeof(char)*file_name_len3);
        strncpy(file_name, argv[1], file_name_len);
        strncpy(file_name2,argv[2],file_name_len2);
        strncpy(file_name3,argv[3],file_name_len3);

        FILE *f_in;
        FILE *f_in2;
        FILE *f_in3;
        f_in = fopen(file_name, "r");
        f_in2= fopen(file_name2, "r");
        f_in3= fopen(file_name3, "r");
        
        Data* data=(Data*)malloc(sizeof(Data));
        Data* data2=(Data*)malloc(sizeof(Data));
        Data* data3=(Data*)malloc(sizeof(Data));
        data->file=f_in;
        data->ptr1=s12_ptr1;
        data->ptr2=s34_ptr1;
        data->pluck_ptr=pluck_ptr1;
        data2->file=f_in2;
        data2->ptr1=s12_ptr2;
        data2->ptr2=s34_ptr2;
        data2->pluck_ptr=pluck_ptr2;
        data3->file=f_in3;
        data3->ptr1=s12_ptr3;
        data3->ptr2=s34_ptr3;
        data3->pluck_ptr=pluck_ptr3;
        
        // read input line by line
        pthread_t thread1,thread2,thread3;

        pthread_create(&thread1,NULL,file_parse,data);
        pthread_create(&thread2,NULL,file_parse,data2);
        pthread_create(&thread3,NULL,file_parse,data3);

        pthread_join(thread1,NULL);
        pthread_join(thread2,NULL);
        pthread_join(thread3,NULL);

        fclose(f_in);
        fclose(f_in2);
        fclose(f_in3);
        free(file_name);
        free(file_name2);
        free(file_name3);

        return 0;

}
