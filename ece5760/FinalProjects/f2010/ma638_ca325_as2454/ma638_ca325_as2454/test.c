//ISR test in C

//system.h has peripheral base addresses, IRQ definitions, and cpu details
#include "system.h"
//Next include has definition of alt_irq_register
#include "sys/alt_irq.h"
#include <math.h>
#include <stdio.h>
//The next two includes are in syslib/DeviceDrivers[sopc_builder]
//They have the macros for setting values in peripherals
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_pio_regs.h"


#define begin {
#define end }
#define pid_o 0x60		//The data to control the heaters uding PWM
#define pid_i 0x70		//The input from the ADC
#define HON 0x90		//Control signals to show the heater on or off on the VGA
#define VAL 0xa0		//The control to show the progress bar on the VGA

float out1=0,diff1=0,inte1=0,ref=0;//The output,differential, integral terms for PID1
								   //The reference from the user
float out2=0,diff2=0,inte2=0;	   //The output,differential, integral terms for PID2

int main(void)
begin
  IOWR_ALTERA_AVALON_PIO_DATA(HON,0);
  IOWR_ALTERA_AVALON_PIO_DATA(VAL,0);
  //reset the heater on/off and the progress bar values to the VGA
  float p1,i1,d1;
  float p2,i2,d2;
  float kp1=101;
  float ki1=4;
  float kd1=2;
  float kp2=101;
  float ki2=4;
  float kd2=2;
  //the controller coefficients

  float start1=0,start2=0;
  //the start values of temperature

  int adc1=0,adc2=0;
  //input from ADCs

  int adc_prev_1=0,adc_prev_2=0;
  //To store previous values of temperature to activate the PID only when there is a change

  int sw=0;
  //Switch to take in reference input

  int temp;

  unsigned long int out=0;

  temp=IORD_ALTERA_AVALON_PIO_DATA(pid_i);
  adc1=temp/256;
  adc2=temp%256;

  while(1)
  begin
  sw = IORD_ALTERA_AVALON_PIO_DATA(SWITCH_BASE);//To check if new reference is to be given
												//or to continue with previous value.
  if(sw==0X01)
  begin
	  start1=0;start2=0;
      printf("Enter reference value: ");
	  scanf("%f",&ref);
	  printf("The reference value: %f\n",ref);
	  while(start1==0||start2==0)
      begin
		  temp=IORD_ALTERA_AVALON_PIO_DATA(pid_i);
		  start1=temp/256;
		  start2=temp%256;
	  end
	  //This is done because the CPU clock(50 MHz) is much faster than the read/enable clock(2.4Hz).
	  //Hence there will be zeros in the input from the ADC which must be ignored.
  end
  while((ref>adc1&&(ref-adc1)>=1)&&(ref>adc2&&(ref-adc2)>=1))//The PID controller loop. Quit if even
															 //one of the sensors reach the set temp.
      begin
     	  temp=IORD_ALTERA_AVALON_PIO_DATA(pid_i);
          adc1=temp/256;
          adc2=temp%256;
		  if((adc1!=adc_prev_1||adc2!=adc_prev_2)&&adc1!=0&&adc2!=0)
		//Again this is done because the CPU clock is much faster than the read/enable clock.
	    //We could instead integrate everything using the read clock.
		  begin
			  out2=((adc2)*2-1);
			  p2=kp2*(ref-out2);
			  inte2+=(ref-out2);
			  i2=ki2*inte2;
			  d2=kd2*(diff2-(ref-out2));
			  diff2=(ref-out2);
			  out2=p2+i2+d2;
			  out1=((adc1)*2-1);
			  p1=kp1*(ref-out1);
			  inte1+=(ref-out1);
			  i1=ki1*inte1;
			  d1=kd1*(diff1-(ref-out1));
			  diff1=(ref-out1);
			  out1=p1+i1+d1;
			  IOWR_ALTERA_AVALON_PIO_DATA(HON,3);
			  //Heater output
			  IOWR_ALTERA_AVALON_PIO_DATA(VAL,(int)(((float)(out2-start2)/(float)(ref-start2))*80));
			  //Progress bar output based on only one sensor.
			  if(out2>1023)
				  out2=1023;
			  if(out1>1023)
				  out1=1023;
			  out=((int)(out1))+(1024*((int)(out2)));
			  //saturation conditions because this is the max output from the PWM counter(10 bits)
			  IOWR_ALTERA_AVALON_PIO_DATA(pid_o,(out));
			  printf("Output from Nios is: %f\n",out1);
			  printf("Output from Nios is: %f\n",out2);
			  printf("Output from Nios is: %d\n",out);
			  printf("Input from adc1 is: %d\n",((adc1)*2-1));
			  printf("Input from adc2 is: %d\n",((adc2)*2-1));
			  adc_prev_1=adc1;
			  adc_prev_2=adc2;
          end
      end
      p1=0;i1=0;d1=0;inte1=0;diff1=0;out1=0;
      p2=0;i2=0;d2=0;inte2=0;diff2=0;out2=0;
      //Reset the PID
      IOWR_ALTERA_AVALON_PIO_DATA(HON,0);//Switch off heaters once the reference temperature is attained
    end
end
			  printf("Output from Nios is: %f\n",out2);
			  printf("Output from Nios is: %d\n",out);
			  printf("Input from adc1 is: %d\n",((adc1)*2-1));
			  printf("Input from adc2 is: %d\n",((adc2)*2-1));
			  adc_prev_1=adc1;
			  adc_prev_2=adc2;
          end
      end
      p1=0;i1=0;d1=0;inte1=0;diff1=0;out1=0;
      p2=0;i2=0;d2=0;inte2=0;diff2=0;out2