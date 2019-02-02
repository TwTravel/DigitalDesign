/////// Cheesy musical scale with LCD ///////
///////BRL4@cornell.edu : July 2006 /////////
/////////////////////////////////////////////
// system.h has peripheral base addresses, IRQ definitions, and cpu details
#include "system.h"
#include <stdio.h>
// This include has definition of alt_irq_register
#include "sys/alt_irq.h"
//The next two includes are in syslib/DeviceDrivers[sopc_builder]
//They have the macros for setting values in peripherals
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_pio_regs.h"

//I like these:
#define begin {
#define end }  

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

///// timer ISR ////////////////////////////////////////////////////////
//timer ISR which is called by the HAL exception dispatcher
static void timer_isr(void* context, alt_u32 id)
begin
  //recast ISR context variable to pointer to int
  volatile int* flag_ptr = (volatile int*) context;
  IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0); //reset TO flag
  *flag_ptr = *flag_ptr + 1 ;                       //note counter
  if (*flag_ptr==9) *flag_ptr = 0 ;            // cycle after 9 notes
end

///// main ///////////////////////////////////////////////////////////////
int main(void)
begin
  volatile int flag; //LED note counter
  unsigned int sw;   //switch inputs
  
  // Middle C and up one octave
  // the 0 at the end is a rest
  unsigned int notes[9]={262, 294, 330, 349, 392, 440, 494, 523, 0};
  
  flag = 0;          //init the note counter 
  
  //set up timer
  //1/2 second period, 25e6 counts = 0h17D7840
  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_0_BASE, 0x7840);
  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_0_BASE, 0x17d);
  //set RUN, set CONTuous, set ITO
  IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE, 7);
  //register the interrupt (and turn it on)
  alt_irq_register(TIMER_0_IRQ, (void*)&flag, timer_isr);
  
  //open the lcd --- device name from system.h
  lcd_fd = fopen("/dev/lcd", "w");
  if(lcd_fd == NULL) printf("Unable to open lcd display\n");  
  
  //make a scale and print freq on LCD
  while(1)
  begin
    //read the switches
    sw = IORD_ALTERA_AVALON_PIO_DATA(IN0_BASE);
    
    //display note index on LEDs
    IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, flag);
    
    //set up a 32-bit word to act as DDR increment
    //frequency f: DDR_incr = f*2^32/5e6 = f*85.89934 Hz
    // Select an octave with only ONE sw ON
    // so we mult the freq by the sw setting 
    // we can get from middle C up to over a MHz.
    IOWR_ALTERA_AVALON_PIO_DATA(OUT0_BASE, notes[flag]*859*sw/10);
    
    // print the frequency on the LCD
    fprintf(lcd_fd, "%c%sfreq= %d   \n", esc, ESC_BOTTOM_LEFT, notes[flag]*sw);
  end
end
