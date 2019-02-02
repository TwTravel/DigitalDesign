/////////////////////////////////////////////////////////////////////////
// Ping-Hong Lu 
// 
// This program runs on the Nios II processor instantiated on an Altera
// DE2 board.  It receives VGA information from the board and calcuates
// the movement and velocity of a light source. 
/////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include "system.h"
#include "math.h"
#include "altera_avalon_pio_regs.h"

// I like these
#define begin {
#define end }
#define position_delta 9
#define CIR_BUFFER_SIZE 10

///// LCD control: //////////////////////////////////////////////////////
// From: http://www.altera.com/support/examples/nios2/exm-micro_mutex.html
// ESC ssequences:
// From: http://www.isthe.com/chongo/tech/comp/ansi_escapes.html
// ESC[#;#H      Moves the cursor to line #, column #
// ESC[2J        Clear screen and home cursor
// ESC[K         Clear to end of line
#define ESC_TOP_LEFT    "[1;0H"
#define ESC_BOTTOM_LEFT "[2;0H"
#define LCD_CLR "[2J"
#define LCD_CLR_LINE "[K"
static unsigned char esc = 0x1b; // Integer ASCII value of the ESC character
//File descriptor for the LCD
FILE * lcd_fd;


int main(void)
begin
  int address, valid, address_y;
  int x_position, y_position, no_change;
  int sw, key, notecount;
  int task3_status; //keeps track of suspend state
  //frequencies in Hz of middle C octave
  unsigned int notes[9]={262, 294, 330, 349, 392, 440, 494, 523, 0};
  unsigned int msg = 0;
  unsigned int freq = 0;
  unsigned int speed = 0;
  unsigned int x_position_history[CIR_BUFFER_SIZE];
  unsigned int y_position_history[CIR_BUFFER_SIZE];
  unsigned int head, tail;
  
  // jtag_uart variables
  FILE *uart_file;
  int freq_val;
  int wave_val;
  
  notecount = 0;
  task3_status = 1;
  
  x_position = 619;
  y_position = 459;
  no_change = 1;
  
  head = 0;
  tail = 0;
  
  //open the lcd --- device name from system.h
  lcd_fd = fopen("/dev/lcd", "w");
  if(lcd_fd == NULL) printf("Unable to open lcd display\n");


  while (1)
  begin
    if (msg == 0) msg = 1;
    else msg = 0;
    IOWR_ALTERA_AVALON_PIO_DATA(OUT0_BASE, msg); 

    // Check the validity of the data
    //valid = IORD_ALTERA_AVALON_PIO_DATA(IN1_BASE); 


    // --------- START OF PING -----------------
    x_position_history[0] = x_position;
    y_position_history[0] = y_position;

    address = IORD_ALTERA_AVALON_PIO_DATA(IN0_BASE);
    address_y = IORD_ALTERA_AVALON_PIO_DATA(IN2_BASE);

    if (!(address > x_position - position_delta &&
          address < x_position + position_delta) || 
        !(address_y > y_position - position_delta &&
          address_y < y_position + position_delta))
    begin
      x_position = address;
      y_position = address_y;
      no_change = 0;

      speed = sqrt((double)(
               abs(x_position_history[0] - x_position) *
               abs(x_position_history[0] - x_position) +
               abs(y_position_history[0] - y_position) *
               abs(y_position_history[0] - y_position)));
      speed = speed / 3.1 * 1000000;


      // commented out because printf takes a loooong time
      // will use LEDR, and HEX0-7 instead
//        printf("x: %d\ny: %d\nspeed: %d\n",
//                address, address_y, speed);

        IOWR_ALTERA_AVALON_PIO_DATA(OUT2_BASE, speed/1000000);
//        IOWR_ALTERA_AVALON_PIO_DATA(OUT3_BASE, address);
//        IOWR_ALTERA_AVALON_PIO_DATA(OUT4_BASE, address_y);
        
        if (speed < 6000000)        // 1 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 1);
        else if (speed < 8500000)  // 2 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 3);
        else if (speed < 11000000)  // 3 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 7);
        else if (speed < 13500000)  // 4 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 15);
        else if (speed < 16000000)  // 5 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 31);
        else if (speed < 18500000)  // 6 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 63);
        else if (speed < 21000000)  // 7 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 127);
        else if (speed < 23500000)  // 8 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 255);
        else if (speed < 2600000)  // 9 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 511);
        else if (speed < 28500000)  // 10 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 1023);
        else if (speed < 31000000)  // 11 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 2047);
        else if (speed < 33500000)  // 12 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 4095);
        else if (speed < 36000000)  // 13 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 8191);
        else if (speed < 38500000)  // 14 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 16383);
        else if (speed < 41000000)  // 15 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 32767);
        else if (speed < 43500000)  // 16 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 65535);
        else if (speed < 46000000)  // 17 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 131071);
        else                   // 18 LED
          IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, 262143);
      end
    else
    begin
      // no change in position
      no_change = 1;
      speed = 0;
    end


    IOWR_ALTERA_AVALON_PIO_DATA(OUT3_BASE, address);
    IOWR_ALTERA_AVALON_PIO_DATA(OUT4_BASE, address_y);
 
 
    if (!no_change)
    begin
      // Also commented out because printing to the LCD device
      // is slow.  See LEDR and HEX0-7 for information.
//      fprintf(lcd_fd, "%c%s%c%sx= %d \ny = %d",esc, LCD_CLR, 
//              esc, ESC_TOP_LEFT, x_position, y_position);
    end
  end
end