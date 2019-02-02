#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_up_avalon_audio.h"
#include "altera_up_avalon_video_character_buffer_with_dma.h"
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include "altera_up_avalon_ps2.h"
#include "sys/alt_stdio.h"

/* globals */
#define BUF_SIZE 500000			// about 10 seconds of buffer (@ 48K samples/sec)
#define BUF_THRESHOLD 96		// 75% of 128 word buffer

/* function prototypes */
void HEX_PS2(unsigned char, unsigned char, unsigned char);
void check_KEYs( int *, int *, int *, alt_up_audio_dev * );

/********************************************************************************
 * This program demonstrates use of the media ports in the DE1-SoC Computer
 *
 * It performs the following: 
 *  1. records audio for about 10 seconds when KEY[1] is pressed. LEDR[0] is
 * 	   lit while recording
 * 	2. plays the recorded audio when KEY[2] is pressed. LEDR[1] is lit while 
 * 	   playing
 * 	3. Draws a blue box on the VGA display, and places a text string inside
 * 	   the box
 * 	4. Displays the last three bytes of data received from the PS/2 port 
 * 	   on the HEX displays on the board
********************************************************************************/
int main(void)
{
    /* The base addresses of devices are listed in the "BSP/system.h" file*/

	alt_up_ps2_dev *PS2_dev;
	alt_up_audio_dev *audio_dev;
	alt_up_char_buffer_dev *char_buffer_dev;
	alt_up_pixel_buffer_dma_dev *pixel_buffer_dev;

	/* used for audio record/playback */
	int record = 0, play = 0, buffer_index = 0;
	unsigned int l_buf[BUF_SIZE];
	unsigned int r_buf[BUF_SIZE];
	int num_read; int num_written;

	/* used for PS/2 port data */
	unsigned char PS2_data;
	unsigned char byte1 = 0, byte2 = 0, byte3 = 0;

	/* create a message to be displayed on the VGA and LCD displays */
	char text_top_row[40] = "Altera DE1-SoC\0";
	char text_bottom_row[40] = "Computer\0";

	/* output text message in the middle of the VGA monitor */
	char_buffer_dev = alt_up_char_buffer_open_dev ("/dev/VGA_Subsystem_VGA_Char_Buffer_avalon_char_buffer_slave");
	if (char_buffer_dev == NULL)
	{
		alt_printf ("Error: could not open character buffer device\n");
		return -1;
	}
	else
		alt_printf ("Opened character buffer device\n");
	alt_up_char_buffer_string (char_buffer_dev, text_top_row, 35, 29);
	alt_up_char_buffer_string (char_buffer_dev, text_bottom_row, 35, 30);
	
	/* allocate space for the pixel buffer */
	short buffer[512][256];	

	/* open the pixel buffer */
	pixel_buffer_dev = alt_up_pixel_buffer_dma_open_dev ("/dev/VGA_Subsystem_VGA_Pixel_DMA");
	if (pixel_buffer_dev == NULL)
	{
		alt_printf ("Error: could not open pixel buffer device\n");
		return -1;
	}
	else
		alt_printf ("Opened pixel buffer device\n");		

	alt_up_pixel_buffer_dma_clear_screen (pixel_buffer_dev, 0);
	/* draw a medium-blue box in the middle of the screen, using character buffer coordinates.
	 * Use character coord * 4 since characters are 4 x 4 pixel buffer coords (8 x 8 VGA coords) */
	alt_up_pixel_buffer_dma_draw_box (pixel_buffer_dev, 34 * 4, 28 * 4, 50 * 4, 32 * 4, 0x187F, 0);
	
	// open the PS2 port
	PS2_dev = alt_up_ps2_open_dev ("/dev/PS2_Port");
	if (PS2_dev == NULL)
	{
		alt_printf ("Error: could not open PS2 device\n");
		return -1;
	}
	else
		alt_printf ("Opened PS2 device\n");

	audio_dev = alt_up_audio_open_dev ("/dev/Audio_Subsystem_Audio");
	if (audio_dev == NULL)
	{
		alt_printf ("Error: could not open audio device\n");
		return -1;
	}
	else
		alt_printf ("Opened audio device\n");

	/* read and echo audio data */
	record = 0;
	play = 0;

	(void) alt_up_ps2_write_data_byte (PS2_dev, 0xFF);		// reset
	while(1)
	{
		check_KEYs ( &record, &play, &buffer_index, audio_dev );
		if (record)
		{
			IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE , 0x1); // set LEDR[0] on

			// record data until the buffer is full
			if (buffer_index < BUF_SIZE)
			{
				num_read = alt_up_audio_record_r (audio_dev, &(r_buf[buffer_index]), 
					BUF_SIZE - buffer_index);
				/* assume we can read same # words from the left and right */
				(void) alt_up_audio_record_l (audio_dev, &(l_buf[buffer_index]), 
					num_read);
				buffer_index += num_read;

				if (buffer_index == BUF_SIZE)
				{
					// done recording
					record = 0;
					IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE , 0x0); // set LEDR off
				}
			}
		}
		else if (play)
		{
			IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE , 0x2); // set LEDR[1] on

			// output data until the buffer is empty 
			if (buffer_index < BUF_SIZE)
			{
				num_written = alt_up_audio_play_r (audio_dev, &(r_buf[buffer_index]), 
				 	BUF_SIZE - buffer_index);
				/* assume that we can write the same # words to the left and right */
				(void) alt_up_audio_play_l (audio_dev, &(l_buf[buffer_index]), 
					num_written);
				buffer_index += num_written;

				if (buffer_index == BUF_SIZE)
				{
					// done playback
					play = 0;
					IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE , 0x0); // set LEDR off
				}
			}
		}
		/* check for PS/2 data--display on HEX displays */
		if (alt_up_ps2_read_data_byte (PS2_dev, &PS2_data) == 0)
		{
			/* shift the next data byte into the display */
			byte1 = byte2;
			byte2 = byte3;
			byte3 = PS2_data;
			HEX_PS2 (byte1, byte2, byte3);

			if ( (byte2 == (unsigned char) 0xAA) && (byte3 == (unsigned char) 0x00) )
				// mouse inserted; initialize sending of data
				(void) alt_up_ps2_write_data_byte (PS2_dev, 0xF4);
		}
	}
}

/****************************************************************************************
 * Subroutine to show a string of HEX data on the HEX displays
 * Note that we are using pointer accesses for the HEX displays parallel port. We could
 * also use the HAL functions for these ports instead.
****************************************************************************************/
void HEX_PS2(unsigned char b1, unsigned char b2, unsigned char b3)
{

	/* SEVEN_SEGMENT_DECODE_TABLE gives the on/off settings for all segments in 
	 * a single 7-seg display in the computer, for the hex digits 0 - F */
	unsigned char	seven_seg_decode_table[] = {	0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 
		  										0x7F, 0x67, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 };
	unsigned char	hex_segs[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
	unsigned int shift_buffer, nibble;
	unsigned char code;
	int i;

	shift_buffer = (b1 << 16) | (b2 << 8) | b3;
	for ( i = 0; i < 6; ++i )
	{
		nibble = shift_buffer & 0x0000000F;		// character is in rightmost nibble
		code = seven_seg_decode_table[nibble];
		hex_segs[i] = code;
		shift_buffer = shift_buffer >> 4;
	}
	/* drive the hex displays */    
    IOWR_ALTERA_AVALON_PIO_DATA(HEX3_HEX0_BASE , *(int *) (hex_segs));
    IOWR_ALTERA_AVALON_PIO_DATA(HEX5_HEX4_BASE , *(int *) (hex_segs+4));
}

/****************************************************************************************
 * Subroutine to read KEYs
****************************************************************************************/
void check_KEYs(int *KEY1, int *KEY2, int *counter, 
	alt_up_audio_dev *audio_dev)
{
	int KEY_value;

	KEY_value = IORD_ALTERA_AVALON_PIO_DATA(PUSHBUTTONS_BASE); // read the pushbutton KEY values
	
	while (IORD_ALTERA_AVALON_PIO_DATA(PUSHBUTTONS_BASE));		// wait for pushbutton KEY release

	if (KEY_value == 0x2)					// check KEY1
	{
		// reset counter to start recording
		*counter = 0;
		// reset audio port
		alt_up_audio_reset_audio_core (audio_dev);

		*KEY1 = 1;
	}
	else if (KEY_value == 0x4)				// check KEY2
	{
		// reset counter to start playback
		*counter = 0;
		// reset audio port
		alt_up_audio_reset_audio_core (audio_dev);

		*KEY2 = 1;
	}
}
