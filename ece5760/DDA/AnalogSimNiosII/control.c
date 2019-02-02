/////// ISR test in C ///////////////////////
///////BRL4@cornell.edu : July 2006 /////////
/////////////////////////////////////////////
// system.h has peripheral base addresses, IRQ definitions, and cpu details
#include "system.h"
#include "stdio.h"
// Next include has definition of alt_irq_register
//#include "sys/alt_irq.h"
//The next two includes are in syslib/DeviceDrivers[sopc_builder]
//They have the macros for setting values in peripherals
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_pio_regs.h"
// Next include contains usleep(microseconds)
#include <unistd.h> //e.g. //usleep(5000000); is 5 seconds

//I like these:
#define begin {
#define end }  
#define Nfreq 100

int main(void)
begin
  int findex; //frequency index
  int freq; //current frequency
  int gain; // current gain
  int newAmp, oldAmp, newPhase, oldPhase;
  
  //assert reset of the DDA subsystem
  //IOWR_ALTERA_AVALON_PIO_DATA(CONTROL_BASE,0);
  
  while(1)
  begin
    freq = 300;
    oldAmp = -1;
    oldPhase = -1;
    for(findex=0; findex<Nfreq; findex++)
    begin
      //assert reset of the DDA subsystem
      IOWR_ALTERA_AVALON_PIO_DATA(CONTROL_BASE,0);
      //set up a 32-bit word to act as DDR increment
      //frequency f: DDR_incr = f*2^32/5e6 = f*85.89934 Hz
      IOWR_ALTERA_AVALON_PIO_DATA(DDS_INCR_BASE, freq*85899/1000);
      //set up the input sine wave gain
      gain = 0x2000 ; // 1/16
      IOWR_ALTERA_AVALON_PIO_DATA(INPUT_GAIN_BASE,gain); //0x2000
      //release reset of the DDA subsystem
      IOWR_ALTERA_AVALON_PIO_DATA(CONTROL_BASE,1);
      //wait 20 cycles
      usleep(1000000/freq*20); //usleep is in microseconds
      newAmp = IORD_ALTERA_AVALON_PIO_DATA(AMPLITUDE_BASE);
      newPhase = IORD_ALTERA_AVALON_PIO_DATA(PHASE_BASE);
      
      //wait for data to settle
      while ((newAmp != oldAmp) | (newPhase != oldPhase))
      begin
      //wait 2 cycles
        usleep(1000000/freq*2); //usleep is in microseconds
        oldAmp = newAmp; //record last reading
        newAmp = IORD_ALTERA_AVALON_PIO_DATA(AMPLITUDE_BASE);
        oldPhase = newPhase;
        newPhase = IORD_ALTERA_AVALON_PIO_DATA(PHASE_BASE);
      end
      //read and print
      
      printf("freq=%d, amp=%f, phase=%d\n", 
            freq, ((float)newAmp)*(((float)gain)/32768.0), 
            (newPhase*360/256));
      freq = (int)((float)freq*1.01); 
    end 
    usleep(100000000);
    printf("\n");
  end
end
