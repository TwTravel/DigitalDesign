
/////// Cheesy musical scale ////////////////
///////BRL4@cornell.edu : July 2006 /////////
/////////////////////////////////////////////
// system.h has peripheral base addresses, IRQ definitions, and cpu details
#include "system.h"
// Next include has definition of alt_irq_register
#include "sys/alt_irq.h"
//The next two includes are in syslib/DeviceDrivers[sopc_builder]
//They have the macros for setting values in peripherals
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_pio_regs.h"
// Next include contains usleep(microseconds)
//#include <unistd.h> //e.g. //usleep(5000000); is 5 seconds

//I like these:
#define begin {
#define end }  

//timer ISR which is called by the HAL exception dispatcher
static void timer_isr(void* context, alt_u32 id)
begin
  //recast ISR context variable to pointer to int
  volatile int* flag_ptr = (volatile int*) context;
  IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0); //reset TO flag
  *flag_ptr = *flag_ptr + 1 ;                       //note counter
  if (*flag_ptr==9) *flag_ptr = 0 ;            // cycle after 9 notes
end

int main(void)
begin
  volatile int flag; //LED inversion flag is set by ISR and read by main
  unsigned int sw;   //switch inputs
  flag = 0;          //init the note counter 
  // Middle C and up one octave
  // the 0 at the end is a rest
  unsigned int notes[9]={262, 294, 330, 349, 392, 440, 494, 523, 0};
  //set up timer
  //1/2 second period, 25e6 counts = 0h17D7840
  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_0_BASE, 0x7840);
  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_0_BASE, 0x17d);
  //set RUN, set CONTuous, set ITO
  IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE, 7);
  //register the interrupt (and turn it on)
  alt_irq_register(TIMER_0_IRQ, (void*)&flag, timer_isr);
  //now just loop and make a scale
  while(1)
  begin
    //read the switches
    sw = IORD_ALTERA_AVALON_PIO_DATA(SWITCH_BASE);
    //display note index on LEDs
    IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, flag);
    //set up a 32-bit word to act as DDR increment
    //frequency f: DDR_incr = f*2^32/5e6 = f*85.89934 Hz
    // Select an octave with only ONE sw ON
    // so we mult the freq by the sw setting and div/4 
    // so we can get 2 octaves below middle C 
    IOWR_ALTERA_AVALON_PIO_DATA(WIDEOUT_BASE, notes[flag]*85899*sw/4000);  
  end
end
