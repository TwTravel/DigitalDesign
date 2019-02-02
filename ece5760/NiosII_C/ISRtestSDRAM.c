
//ISR test in C

//system.h has peripheral base addresses, IRQ definitions, and cpu details
#include "system.h"
//Next include has definition of alt_irq_register
#include "sys/alt_irq.h"
//The next two includes are in syslib/DeviceDrivers[sopc_builder]
//They have the macros for setting values in peripherals
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_pio_regs.h"
//I like these:
#define begin {
#define end }  

//LED inversion flag is set by ISR and read by main  
int flag;

//timer ISR which is called by the HAL exception dispatcher
static void timer_isr(void* context, alt_u32 id)
begin
  IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0); //reset TO flag
  flag = flag ^ 0xff;  //toggle inversion flag
end

int main(void)
begin
  volatile int context;
  int sw;
  
  flag = 0xff;
  
  //set up timer
  //one second period, 50e6 counts = 0x2FAF080
  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_0_BASE, 0xf080);
  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_0_BASE, 0x2fa);
  //set RUN, set CONTuous, set ITO
  IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE, 7);
  //register the interrupt (and turn it on)
  alt_irq_register(TIMER_0_IRQ, (void*)&context, timer_isr);
  
  while(1)
  begin
    //read the switches
    sw = IORD_ALTERA_AVALON_PIO_DATA(SWITCH_BASE);
    //flash some LEDs
    IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, sw ^ flag);
    //set up a 32-bit word to act as DDR increment
    //frequency f: DDR_incr = f*2^32/5e6 = f*85.89934 Hz
    IOWR_ALTERA_AVALON_PIO_DATA(WIDEOUT_BASE, sw*85899/1000);   
  end
end
