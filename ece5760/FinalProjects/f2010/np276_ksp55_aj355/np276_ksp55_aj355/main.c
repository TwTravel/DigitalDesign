#define	oFFTAddress_addr	0x01001020
#define	oFFTStart_addr		0x01001030
#define	iFFTComplete_addr	0x01001040
#define	iFFTCoeff_addr		0x01001050
#define	iFFTLevel_addr		0x01001060
#define	iSwitches_addr		0x01001070
#define	iKeys_addr	 		0x01001080
#define	oLEDR_addr	 		0x01001090
#define	oLEDG_addr	 		0x010010a0
#define oLCD_addr			0x010010b0
#define lc_addr			    0x010010c0

#define LEDR(val)   	IOWR_ALTERA_AVALON_PIO_DATA(oLEDR_addr, val)
#define LEDG(val)  	 	IOWR_ALTERA_AVALON_PIO_DATA(oLEDG_addr, val)
#define KEY      		IORD_ALTERA_AVALON_PIO_DATA(iKeys_addr)
#define SWITCH      	IORD_ALTERA_AVALON_PIO_DATA(iSwitches_addr)
#define FFTLEVEL      	IORD_ALTERA_AVALON_PIO_DATA(iFFTLevel_addr)
#define FFTCOEFF      	IORD_ALTERA_AVALON_PIO_DATA(iFFTCoeff_addr)
#define FFTCOMPLETE    	IORD_ALTERA_AVALON_PIO_DATA(iFFTComplete_addr)
#define FFTSTART(val)   IOWR_ALTERA_AVALON_PIO_DATA(oFFTStart_addr, val)
#define FFTADDRESS(val) IOWR_ALTERA_AVALON_PIO_DATA(oFFTAddress_addr, val)
#define LCD(val)   		IOWR_ALTERA_AVALON_PIO_DATA(oLCD_addr, val)
#define LC         		IORD_ALTERA_AVALON_PIO_DATA(lc_addr)

#include <math.h>
#include "system.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

#include <stdio.h>


#define SAMPLE_SIZE 256
#define NUM_SAMPLES 32
float mel[12];
float mfcc[12];
float fc[] = {0,132.83,290.87,478.9,702.61,968.77,1285.4,1662.2,2110.5,2643.8,3278.3,4033.2,4931.4,6000};
float fftcoeff[SAMPLE_SIZE*NUM_SAMPLES];
#define PI 3.141592653589793

void dct(float in[], float out[], int n);
double melH(int f, int i);
void melcepstrum_conversion(float in[], int n, float mel[], int m, float fs);


int main()
{

  int i=0,j=0,level=0;
  FFTSTART(0);
  for (i = 0; i < 100000; i++);
  while(1)
  {
      FFTSTART(1);
      while (!FFTCOMPLETE);  // Wait until FFT operation to finish
      FFTSTART(0);

	  //Read the level signal to determine start of the command
      level = FFTLEVEL;
	  //Clear the led outputs
	  LEDR(0);
	  //Check if something is being Spoken
      if (level >60)
      {
		//Glow a LED to indicate start of voice
    	  LEDR(2);
		//Save the fft of next 32 samples
		  for(i=0;i<NUM_SAMPLES;i++)
		  {
		      FFTSTART(1);
		      while(!FFTCOMPLETE)  // Wait until FFT operation to finish
		      FFTSTART(0);

			//Save the fftoutput from the fft memory into the array
			  for (j = 0; j < SAMPLE_SIZE; j++)
			  {
				  FFTADDRESS(j);
				  fftcoeff[i*SAMPLE_SIZE+j] = (float)(short)FFTCOEFF;
			  }
		  }
		  //1 sec sample stored
		  LEDR(4);
		  // shift the spectrum into the mel scale
		  melcepstrum_conversion(fftcoeff, SAMPLE_SIZE*NUM_SAMPLES, mel, 12, 8000);
		  LEDR(8);
		  // compute the dct of the mel spectrum
		  dct(mel, mfcc, 12);
		  float sum_mel;
		  //Take the sum of first two coefficients of the dct output
		  //The first two coefficients contains the maximum information
		  sum_mel = (mfcc[0] + fabs(mfcc[1]));
		  LEDG(0);		//Clear the output LEDs
			if(SWITCH & 1){
		          if(sum_mel > 59) {
		  			  printf("\nYou said Yes");
		  			  printf("\t %f",sum_mel);
		  			  LEDG(128);
		  		  }
		  		  else if(sum_mel> 50 && sum_mel<58) {
		  			  printf("\nYou said No");
		  			  printf("\t %f",sum_mel);
		  			  LEDG(1);
		  		  }
		  		  else if(sum_mel < 60 && sum_mel > 58){
		  			  printf("\nPlease be loud and clear!!");
		  			  printf("\t %f",sum_mel);
		  		  }
		  		  else if(sum_mel < 51 && sum_mel > 45){
		  			  printf("\nPlease be loud and clear");
		  			  printf("\t %f",sum_mel);
		  		  }
		  		  else {
		  		     printf("\nPlease be loud and clear");
		  		     printf("\t %f",sum_mel);
		  		  }
		  }//switch end
		  printf("\n");
	  }
      else
      {
	  //this represent silence
		  LEDG(0);
		  LEDR(1);
      }
  }
}


// shift the n point spectrum in into the mel frequency m point spectrum mel
void melcepstrum_conversion(float in[], int n, float mel[], int m, float fs)
{
    int i, j;

    float deltaf = fs / n;
    for (i = 0; i < m; i++) {
        mel[i] = 0.0;
        for (j = 0; j < n; j++) {
            mel[i] += in[j]*melH(j*deltaf, i+1);
        }
        mel[i] = log10(mel[i]);
    }
}

// compute the value of the mel triangle filter bank i at frequency f
double melH(int f, int i)
{
    if (f < fc[i-1] || f >= fc[i+1]) return 0;
    if (f < fc[i]) return (f-fc[i-1])/(fc[i]-fc[i-1]);
    else           return (f-fc[i+1])/(fc[i]-fc[i+1]);
}

// O(n2) dct - simple but slow (use for small vectors only)
void dct(float in[], float out[], int n)
{
    int i,j;

    double pn = PI / n;
    for (i = 0; i < n; i++) {
        out[i] = 0.0;
        for (j = 0; j < n; j++) {
            out[i] += in[j]*cos(i*pn*(j+0.5));
        }
    }
}

