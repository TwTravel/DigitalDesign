#include <math.h>
#include "system.h"
#include <stdio.h>
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

// LCD Stuff
#define ESC_TOP_LEFT    "[1;0H"
#define ESC_BOTTOM_LEFT "[2;0H"
#define LCD_CLR "[2J"
#define LCD_CLR_LINE "[K"
//static unsigned char esc = 0x1b; // Integer ASCII value of the ESC character
unsigned char line[4] = {0x1b, '[', '2', 'J'};

// File descriptor for the LCD
FILE * lcd_fd;

// Just for kicks
#define TRUE  1
#define FALSE 0

// Debugging
#define NNTRAIN_DEBUG 1
#define CEPSTRAL_DEBUG 2
#define NNVOWEL_DEBUG 3
#define NNCLASSIFICATION_DEBUG 4
#define DEBUG 0

// Helpful Altera Defines
#define FFT_DONE IORD_ALTERA_AVALON_PIO_DATA(FFTDONE_BASE)
#define FFT_POW  IORD_ALTERA_AVALON_PIO_DATA(FFTPOWER_BASE)
#define FFT_EXP  IORD_ALTERA_AVALON_PIO_DATA(FFTEXP_BASE)
#define VOWEL    IORD_ALTERA_AVALON_PIO_DATA(VOWELID_BASE)
#define TRAIN    IORD_ALTERA_AVALON_PIO_DATA(TRAIN_BASE)
#define APP      IORD_ALTERA_AVALON_PIO_DATA(APPSWITCHES_BASE)

// MACROS
#define SET_RED_LED(val)   IOWR_ALTERA_AVALON_PIO_DATA(REDLED_BASE, val)
#define SET_GREEN_LED(val) IOWR_ALTERA_AVALON_PIO_DATA(GREENLED_BASE, val)
#define INVALID_FB()       {\
                                SET_RED_LED(1);\
                                SET_GREEN_LED(0);\
                           }
#define VALID_FB()         {\
                                SET_RED_LED(0);\
                                SET_GREEN_LED(1);\
                           }
#define REC_FB_OFF()       {\
                                SET_RED_LED(0);\
                                SET_GREEN_LED(0);\
                           }
#define SET_VOWEL_FB(val)  IOWR_ALTERA_AVALON_PIO_DATA(VOWELLEDS_BASE, val)
#define FFT_START(val)     IOWR_ALTERA_AVALON_PIO_DATA(FFTSTART_BASE, val)
#define FFT_ADDR(val)      IOWR_ALTERA_AVALON_PIO_DATA(FFTADDR_BASE, val)
#define ABS(val) (((signed short)val) > 0 ? ((signed short)val) : (-((signed short)val)))
#define ABSF(val) (((float)val) > 0 ? ((float)val) : (-((float)val)))
#define SWAP(a,b) tempr=(a);(a)=(b);(b)=tempr

// Possible applications
#define APP_VOWEL_RECOGNITION 0
#define APP_VOWEL_IDENTIFICATION 1
#define APP_SPEAKER_VERIFICATION 2
#define APP_VERIFY_COMBO 3

// KNN
#define POPULATION_SIZE  4
#define TRAINING_SAMPLES 1000
#define CEPSTRAL_COEFFS  12
float cepstrumdbase[POPULATION_SIZE][TRAINING_SAMPLES][CEPSTRAL_COEFFS];
float cepstrumsum[CEPSTRAL_COEFFS];
float cepstrumsumsq[CEPSTRAL_COEFFS];
int   trainindex[POPULATION_SIZE];
int   dbasesize;

// Perceptron
#define ETA (0.1)
#define NUM_WEIGHTS (CEPSTRAL_COEFFS)
float w[NUM_WEIGHTS];

// FFT values
float power[512];

// MFCC stuff
#define PI 3.141592653589793
#define WALPHA 0.54
#define WBETA  0.46
float fc[] = {0,132.83,290.87,478.9,702.61,968.77,1285.4,1662.2,2110.5,2643.8,3278.3,4033.2,4931.4,6000};
float xm[12];
float cc[12];

// Array if scaled input MFCCs
float tempcc[12];

// Neural net for vowels
float normC[12] = {0.1256,0.2387,0.3103,0.4629,0.7097,0.7513,0.7551,0.9407,1.0806,1.6268,1.7445,1.8445};
float mins[12] = {35.2227,-3.5023,-2.5545,-3.4447,-1.7989,-1.6293,-1.2367,-1.4114,-1.0041,-0.6698,-0.6260,-0.5228};
float inputWeights[5][12] = {
{ -1.2089,  0.2943,  0.7391,  1.6160, -2.1935, -0.7240, -1.3857, -2.3402, -1.9270, -0.9871, -1.2068,  0.4986},
{  1.7209,  0.7152,  2.4952, -3.2453,  0.0210, -1.6449,  0.9243,  0.8289,  1.4265,  0.3174, -0.7964,  0.0300},
{  0.2512,  0.2612,  0.4827,  0.1527,  0.4246,  0.1010,  0.3902,  2.6627,  0.1643, -0.9129,  1.3745, -0.7828},
{ -1.3447,  0.2917, -3.1331, -2.6909,  1.1394,  0.3363,  1.7668, -0.8060,  1.5766, -0.6394,  0.7125, -0.5882},
{ -1.7162, -1.0673, -0.9907,  1.6492,  0.4469,  1.5707, -0.6763, -3.7785,  0.7869, -0.3750, -0.2600, -0.2563}
};
float layerWeights[5] = {1.1872,-1.8493,-0.4447,1.7714,-2.0585};
float layerBias[5] = {1.7583,1.6819,-1.2861,1.9129,1.1419};
float outputBias = -1.2987;
float outputs[5];

// Neural net for verification (2 layer network, 20 input nodes, 1 output node)
float normC2[12] = { 0.1111, 0.2864, 0.3138, 0.4321, 0.4089, 0.5940, 0.8157, 0.7546, 1.0784, 1.1271, 1.2148, 1.5602};
float mins2[12] = { 31.8608,-1.7785,-3.9666,-3.5837,-3.6057,-1.9164,-1.5185,-1.8338,-1.2547,-1.0079,-1.0161,-0.6993};
float inputWeights2[20][12] = {
{ -0.7526, 0.4288,-0.4882,-1.3992, 0.3468, 1.6403, 0.0536, 0.2692,-1.9052,-0.7899,-0.4174, 0.9512},
{ -2.4543, 0.5014, 0.3943, 1.6109, 0.7841,-1.3805,-0.3385, 0.1604, 2.7870, 0.8548,-1.0384, 0.8302},
{ -0.4268,-0.0416, 1.0595, 0.5244, 0.2416,-0.9700,-1.2861, 0.7993,-0.7730, 0.4486,-0.8534, 0.1769},
{  1.4332,-1.3129,-2.1724, 0.9689,-0.4139, 0.2017, 0.5963, 2.5860, 1.4730,-0.3187,-0.1881,-0.5114},
{ -0.0862,-0.6416, 0.7505, 0.7027, 0.1335,-1.3470, 1.0661,-0.4483, 0.1176, 1.1444, 0.2731,-0.1028},
{  1.8872,-1.0276, 1.8398,-1.6880, 0.3150, 0.1477, 0.8880,-0.1398, 0.6836, 1.8576,-0.7553,-0.9342},
{ -0.9216, 0.6352, 0.7301,-0.3109,-0.2257,-0.4336, 1.1039, 0.5359, 0.7242, 0.7082,-1.0292, 1.2419},
{ -0.4453,-1.2779,-1.6460, 0.2163,-1.4386, 0.7433,-0.7834, 0.3025,-0.2256,-0.4309, 0.4253, 1.8680},
{  0.1236,-2.5354, 0.4105,-0.9713,-0.7253,-1.0976,-0.9437,-0.9861,-1.2965, 0.3741,-1.8046, 0.6564},
{ -0.6594,-2.2827, 1.1421, 1.4527, 0.2529, 0.5253,-0.5925,-1.1238,-0.1844,-1.1727, 0.9060,-1.2109},
{  0.4207,-1.3578,-0.8224, 0.1839,-2.6818,-0.6341, 1.1097, 2.8541,-0.2094, 3.0292,-1.4645,-1.2377},
{  0.4295, 1.0299,-1.5659, 0.2940,-0.6917,-1.0349, 1.0695, 0.2867,-2.2725, 1.8007, 1.7328,-1.4786},
{ -1.1575,-0.2113,-0.1655,-0.0400, 0.7032,-0.3078, 0.3254,-0.9211, 2.5576, 0.0611, 2.9928,-0.0013},
{ -0.1518,-0.3270, 1.1073, 0.4715,-0.8868, 0.3812,-0.2471,-0.9095,-0.8270,-0.1252, 1.6829, 0.6401},
{  0.5530,-0.3549,-0.4217, 0.9172, 1.5877,-0.0034,-0.7609, 0.3707,-1.3530,-1.3026, 1.0384, 0.1577},
{ -2.1922, 1.5180, 0.9797, 0.8251, 0.6398, 0.1715, 0.6412, 3.0613, 0.0815, 1.1072, 1.8286, 0.0065},
{ -1.2666,-1.1772, 1.1917,-0.1739,-0.9549, 0.8335,-0.5706, 1.0262, 0.1206,-1.4301,-0.5439, 2.6319},
{ -0.4765, 0.3235,-0.4655, 1.2807, 0.0106,-0.0949,-0.7238, 2.2040, 1.3202, 1.5410,-1.0232, 0.0781},
{  0.6639, 0.0960,-0.2031, 0.8317,-0.3008,-0.6373,-0.5143, 0.5518,-0.1179,-0.3721, 0.8707, 0.3580},
{ -0.9843, 0.2230, 0.8193,-1.2243, 0.1191,-0.4784,-0.9186, 0.5795,-0.7898,-0.4291,-0.4353,-1.0045}
};
float layerWeights2[20] = {-1.8151,-2.9834,-1.9503,-2.5326,-1.2862,-2.1438, 0.5390, 1.7446, 2.5479,-2.7056, 3.2107,-3.1836, 3.0553,-2.1323, 1.7749, 2.3216,-2.9436,-2.2102,-0.2598, 1.7208};
float layerBias2[20] = {-1.7852, 2.7261, 1.9236,-2.0655,-0.8399,-1.7943, 0.0652, 0.2180, 1.1294,-0.7624, 0.5999, 0.9947,-0.9433, 0.9724,-0.1905,-1.4673,-1.6549,-1.3535, 1.5971,-2.2682};
float outputBias2 = -1.0170;
float outputs2[20];

// Utility prototypes
void print_array(float data[], int n);

// MFCC prototypes
void dct(float x[], float y[], int n);
double melH(int f, int i);
void melshift(float x[], int n, float xm[], int m, float fs);
//void hamming(float x[], int n);
//void mfcc(float x[], int n, float cc[], float m, float fs);

// KNN Prototypes
void initdbase();
void addtrain(int speakeridx, float coeffs[]);
int nearestneighbor(float coeffs[], unsigned char euclidean);

// Good FFT check (vowel using neural net)
unsigned char vowelCheck(float cc[], int n);

// Perceptron of first three cepstrals
unsigned char classify(float cc[], int n);

// Fundamental method prototypes
int findFundamental(float power[]);

int main(void)
{
    int temp,i;
    short exp;
    
    // Lets just initialize the feedback to off to be sure
    SET_VOWEL_FB(0);
    REC_FB_OFF();
    
    // Make sure start is zero for a while
    FFT_START(0);
    for (i = 0; i < 1000000; i++);
    
    //open the lcd --- device name from system.h
    lcd_fd = fopen("/dev/lcd_0", "w");
    if(lcd_fd == NULL) printf("Unable to open lcd display\n");
    
    // Initialize the KNN database
    initdbase();
    
    while(TRUE) {
        FFT_START(1);
        while(!FFT_DONE);  // Wait for the FFT to finish
        FFT_START(0);      // Deassert start
        exp = FFT_EXP;
        if (exp < 62)
        {
            for (i = 0; i < 512; i++) {
                FFT_ADDR(i);
                power[i] = (float)(short)FFT_POW;
            }
                           
            // shift the spectrum into the mel scale
            melshift(power, 512, xm, 12, 32000);
        
            // compute the dct of the mel spectrum
            dct(xm, cc, 12);
           
#if (DEBUG == NNVOWEL_DEBUG)
            if (vowelCheck(cc,12))
            {
                printf("VOWEL\n");
            }
            else
            {
                printf("NOT VOWEL\n");
            }
#endif
#if (DEBUG == NNTRAIN_DEBUG)
            if (vowelCheck(cc,12))
            {
                print_array(cc,12);
            }
#endif      
            // Do the selected application
            switch (APP)
            {
                // Vowel checking, light green if vowel, red if not
                case APP_VOWEL_RECOGNITION:
                    // Make sure vowel id feedback is off
                    SET_VOWEL_FB(0);
                    
                    // Check for a value, display LED feedback
                    if (vowelCheck(cc,12))
                    {
                        VALID_FB();
                    }
                    else
                    {
                        INVALID_FB();
                    }
                    break;
                // Vowel identification, light the nearest neighbor trained vowel
                case APP_VOWEL_IDENTIFICATION:
                    // Make sure verification feedback is off
                    REC_FB_OFF();
                
                    // If we have a vowel, depending on training button state, train or classify, show feedback
                    if (vowelCheck(cc,12))
                    {
                        if (TRAIN)
                        {
                            if (VOWEL & 0x08)
                            {
                                addtrain(3, cc);
                            }
                            else if (VOWEL & 0x04)
                            {
                                addtrain(2, cc);
                            }
                            else if (VOWEL & 0x02)
                            {
                                addtrain(1, cc);
                            }
                            else if (VOWEL & 0x01)
                            {
                                addtrain(0, cc);
                            }
                        }
                        else
                        {
                            temp = nearestneighbor(cc, FALSE);
                            SET_VOWEL_FB(1 << temp);
                        }
                    }
                    break;
                case APP_SPEAKER_VERIFICATION:
                    // Make sure vowel id feedback is off
                    SET_VOWEL_FB(0);
                    
                    // If we have a vowel, try to verify speaker is Parker
                    if (vowelCheck(cc,12))
                    {
                        if (classify(cc,12))
                        {
                            VALID_FB();
                            printf("PARKER\n");
                        }
                        else
                        {
                            INVALID_FB();
                            printf("NOT PARKER\n");
                        }
                    }
                    break;
                case APP_VERIFY_COMBO:
                    // Just set all LED feedback to off
                    //SET_VOWEL_FB(0);
                    //REC_FB_OFF();
                    // Make sure verification feedback is off
                    REC_FB_OFF();
                
                    // If we have a vowel, depending on training button state, train or classify, show feedback
                    if (vowelCheck(cc,12))
                    {
                        if (TRAIN)
                        {
                            if (VOWEL & 0x08)
                            {
                                addtrain(3, cc);
                            }
                            else if (VOWEL & 0x04)
                            {
                                addtrain(2, cc);
                            }
                            else if (VOWEL & 0x02)
                            {
                                addtrain(1, cc);
                            }
                            else if (VOWEL & 0x01)
                            {
                                addtrain(0, cc);
                            }
                        }
                        else
                        {
                            if (classify(cc,12) && nearestneighbor(cc, TRUE) == 0)
                            {
                                VALID_FB();
                                printf("PARKER\n");
                            }
                            else
                            {
                                INVALID_FB();
                                printf("NOT PARKER\n");
                            }
                        }
                    }
                    break;
            }
        }
        else
        {
            // No significant sound is coming in, just turn all feedback off
            SET_VOWEL_FB(0);
            REC_FB_OFF();
        }
    }
}

// Check if this spectrum is a vowel (not noise)
unsigned char vowelCheck(float cc[], int n)
{
    int i,j;
    float out;
    
    // Normalize the ccs
    for (i = 0; i < 12; i++)
    {
        tempcc[i] = (cc[i]-mins[i])*normC[i] - 1.0;
    }
    
    // Initialize the output (with the bias we will add)
    out = outputBias;
    
    // Get the network outputs
    for (i = 0; i < 5; i++)
    {
        // Calculate the net sum of the weighted inputs
        outputs[i] = 0;
        for (j = 0; j < n; j++)
        {
            outputs[i] += tempcc[j]*inputWeights[i][j];
        }
        
        // The input to the second layer is the weighted tranfer fnc of the biased net sum of weighted inputs
        out += tanh(outputs[i] + layerBias[i])*layerWeights[i];
    }
    
    // Now we apply the transfer function of the second layer output
    out = tanh(out);
    
    // We apply an arbitrary cutoff and what is definitely a vowel
    if (out > 0.4)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

// Print the array
void print_array(float data[], int n)
{
    int i;
    
    printf("[");
    for (i = 0; i < n; i++)
    {
        printf("%f",data[i]);
        if (i != n-1)
        {
            printf(",");
        }
    }
    printf("]\n");
}

// shift the n point spectrum x into the mel frequency m point spectrum xm
void melshift(float x[], int n, float xm[], int m, float fs)
{
    int i, j;
    
    float deltaf = fs / n;
    for (i = 0; i < m; i++) {
        xm[i] = 0.0;
        for (j = 0; j < n; j++) {
            xm[i] += x[j]*melH(j*deltaf, i+1);
        }
        xm[i] = log10(xm[i]);
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
void dct(float x[], float y[], int n)
{
    int i,j;
    
    double pn = PI / n;
    for (i = 0; i < n; i++) {
        y[i] = 0.0;
        for (j = 0; j < n; j++) {
            y[i] += x[j]*cos(i*pn*(j+0.5));
        }
    }
}

// KNN initialize
void initdbase()
{
    int i,j,k;
    
    dbasesize = 0;
    for (i=0; i<POPULATION_SIZE; i++) {
        trainindex[i] = 0;
        for (j=0; j<TRAINING_SAMPLES; j++) {
            for (k=0; k<CEPSTRAL_COEFFS; k++) {
                cepstrumdbase[i][j][k] = 0.0f;
            }
        }
    }
    for (i=0; i<CEPSTRAL_COEFFS; i++) {
        cepstrumsum[i] = 0.0f;
        cepstrumsumsq[i] = 0.0f;
    }
}

void addtrain(int speakeridx, float coeffs[])
{
    int i;
    
    int idx = trainindex[speakeridx];
    // don't overwrite the array
    if (idx >= TRAINING_SAMPLES) return;
    
    dbasesize++;
    for (i=0; i<CEPSTRAL_COEFFS; i++) {
        float c = coeffs[i];
        cepstrumdbase[speakeridx][idx][i] = c;
        cepstrumsum[i] += c;
        cepstrumsumsq[i] += c*c;
    }
    trainindex[speakeridx]++;
}

int nearestneighbor(float coeffs[], unsigned char euclidean)
{
    int i,j,k;
    
    // normalize coeffs
    float mean = 0.0f;
    float var = 0.0f;
    float stdev = 0.0f;
    float val = 0.0f;
    float norm = 0.0f;
    float diff = 0.0f;
    for (i=0; i<CEPSTRAL_COEFFS; i++) {
        mean = cepstrumsum[i] / dbasesize;
        var = cepstrumsumsq[i] / dbasesize;
        stdev = sqrt(var - mean*mean);
        coeffs[i] = (coeffs[i]-mean) / stdev;
    }
    
    // compare to each vector in the database
    float dist = 0.0f, bestdist = 99999.0f;
    int closespeaker  = -1;
    int samples = 0;
    for (i=0; i<POPULATION_SIZE; i++) {
        samples = trainindex[i];
        for (j=0; j<samples; j++) {
            dist = 0.0f;
            for (k=0; k<CEPSTRAL_COEFFS; k++) {
                // normalize this coeff
                val = cepstrumdbase[i][j][k];
                mean = cepstrumsum[k] / dbasesize;
                var = cepstrumsumsq[k] / dbasesize;
                stdev = sqrt(var - mean*mean);
                norm = (val-mean) / stdev;
                diff = coeffs[k]-norm;
                if (euclidean)
                    dist += diff*diff;
                else
                    dist += ABSF(diff);
            }
            if (dist < bestdist) {
                bestdist = dist;
                closespeaker = i;
            }
        }
    }
    
    return closespeaker;
}

// Classify using linear separator
unsigned char classify(float cc[],int n)
{
    int i,j;
    float out;
    
    // Normalize the ccs
    for (i = 0; i < 12; i++)
    {
        tempcc[i] = (cc[i]-mins2[i])*normC2[i] - 1.0;
    }
    
#if (DEBUG == NNCLASSIFICATION_DEBUG)
    print_array(cc,12);
#endif
    
    // Initialize the output
    out = outputBias2;
    
    // Get the input layer outputs (20 neurons)
    for (i = 0; i < 20; i++)
    {
        // Calculate the net sum of the weighted inputs (for input layer)
        outputs2[i] = 0;
        for (j = 0; j < n; j++)
        {
            outputs2[i] += tempcc[j]*inputWeights2[i][j];
        }
        
        // Calculate the biased transfered output for the input layer
        outputs2[i] = tanh(outputs2[i] + layerBias2[i]);
        out += outputs2[i]*layerWeights2[i];
    }
    
    // Now we apply the transfer function of the second layer output
    out = tanh(out);
    
#if (DEBUG == NNCLASSIFICATION_DEBUG)
    print_array(tempcc,12);
    printf("Net Value: %f\n",out);
#endif
   
    // We want to be really sure its me
    if (out > 0.9)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
