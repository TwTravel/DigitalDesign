/*
 * Mapping Robot Project:
 * 
 * This code is responsible for communicating with the Robot.  It
 * controls robot movement (next robot placement) by viewing the mapping
 * progress.
 */
#include "math.h"
#include "system.h"
#include "sys/alt_irq.h"
#include "altera_avalon_uart_regs.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_jtag_uart_regs.h"
#include "alt_types.h"
#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

// Number of Sound Samples
#define SAMPLE_BUFFER 16
// Samples Used in Average
#define KEEP 4

// Number of Robot Moves before Calibration
#define CAL_PERIOD 5
// 1 = Robot on Batteries - 0 = Robot on AC
#define BATTERY 1

// Interrupt Flags
volatile int distFlag,angleFlag,graphicsFlag;

// Ready Signal from distance calc Hardware (Calculation Complete)
static void distance_interrupt(void* context, alt_u32 id)
{
    /* cast the context pointer to an integer pointer. */
    volatile int* distFlag = (volatile int*) context;
   
    *distFlag =1;
    /* Write to the edge capture register to reset it. */
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(DIST_READY_BASE, 0);
    /* reset interrupt capability for the Button PIO. */
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(DIST_READY_BASE, 0xf);
}

// Ready Signal from angle calc Hardware (Calculation Complete)
static void angle_interrupt(void* context, alt_u32 id)
{
    /* cast the context pointer to an integer pointer. */
    volatile int* angleFlag = (volatile int*) context;
   
    *angleFlag =1;
    /* Write to the edge capture register to reset it. */
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(ANGLE_READY_BASE, 0);
    /* reset interrupt capability for the Button PIO. */
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(ANGLE_READY_BASE, 0xf);
}

// Ready Signal from Graphics hardware (draw started)
static void graphics_interrupt(void* context, alt_u32 id)
{
    /* cast the context pointer to an integer pointer. */
    volatile int* graphicsFlag = (volatile int*) context;
   
    *graphicsFlag =1;
    /* Write to the edge capture register to reset it. */
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(GRAPHICS_READY_BASE, 0);
    /* reset interrupt capability for the Button PIO. */
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(GRAPHICS_READY_BASE, 0xf);
}

// Draw a box on the VGA screen at x, y position
void drawRect(int x,int y,int color){
    graphicsFlag = 0;				// Clear the Graphics Flag
    while(!graphicsFlag);			// Wait for graphics flag to be set
    IOWR_ALTERA_AVALON_PIO_DATA(XVALUE_BASE, x);// Send x-value to hardware
    IOWR_ALTERA_AVALON_PIO_DATA(YVALUE_BASE, y);// Send y-value to hardware
    IOWR_ALTERA_AVALON_PIO_DATA(COLOR_BASE, color); // Send color to hardware
    while(!graphicsFlag);			// Wait for it to complete
}


void init(){
  // Cast the interrupt flags
  void* distFlag_ptr = (void*) &distFlag;
  void* angleFlag_ptr = (void*) &angleFlag;
  void* graphicsFlag_ptr = (void*) &graphicsFlag;
  
  // Enable distance calc interrupt
  IOWR_ALTERA_AVALON_PIO_IRQ_MASK(DIST_READY_BASE, 1);
  // Reset the edge capture register
  IOWR_ALTERA_AVALON_PIO_EDGE_CAP(DIST_READY_BASE, 0x0);
  // Register the ISR
  alt_irq_register(DIST_READY_IRQ, distFlag_ptr,distance_interrupt );
  
  // Enable anlge calc interrupt
  IOWR_ALTERA_AVALON_PIO_IRQ_MASK(ANGLE_READY_BASE, 1);
  // Reset the edge capture register
  IOWR_ALTERA_AVALON_PIO_EDGE_CAP(ANGLE_READY_BASE, 0x0);
  // Register the ISR
  alt_irq_register(ANGLE_READY_IRQ,angleFlag_ptr , angle_interrupt);
  
  // Enable graphics interrupt
  IOWR_ALTERA_AVALON_PIO_IRQ_MASK(GRAPHICS_READY_BASE, 1);
  // Reset the edge capture register
  IOWR_ALTERA_AVALON_PIO_EDGE_CAP(GRAPHICS_READY_BASE, 0x0);
  // Register the ISR
  alt_irq_register(GRAPHICS_READY_IRQ, graphicsFlag_ptr, graphics_interrupt);
  
  //clear screen
  int i,g;
  for(i=-16;i<16;i+=2){
    for(g=-16;g<16;g+=2){
        drawRect(i,g,0);
    }
  }
 
}

// Robot Commands:
//      'P': Ping (Beep)
//      'H': High Speed
//      'L': Low Speed
//      'S': Stop Robot
//      'F': Forward
//      'B': Backward
//      'C': Clockwise
//      'U': Counter-Clockwise
void sendChar(char byte){
    // Wait for transmit buffer to clear
    while(!(IORD_ALTERA_AVALON_UART_STATUS(XBEE_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));
    // Send the byte    
    IOWR_ALTERA_AVALON_UART_TXDATA(XBEE_BASE, byte);
    // Wait for transmit buffer to clear
    while(!(IORD_ALTERA_AVALON_UART_STATUS(XBEE_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));
}

// Get distance values from hardware (assumed a ping was sent first)
int getDistances(unsigned int * right,unsigned int * left,unsigned int * back){

      do{
          usleep(15000); // Sleep to separate pings in time
          distFlag = 0;  // Reset the distance flag
          IOWR_ALTERA_AVALON_PIO_DATA(START_TIME_BASE, 0); // Reset the hardware timer
          //send ping command and wait for transfer to complete
          sendChar('P');
          //start timing
          IOWR_ALTERA_AVALON_PIO_DATA(START_TIME_BASE, 1);
          //wait for distance measure to finish
          while (!distFlag);
          // Store the distance values
          *left = IORD_ALTERA_AVALON_PIO_DATA(DIST_L_BASE);
          *right = IORD_ALTERA_AVALON_PIO_DATA(DIST_R_BASE);
          *back = IORD_ALTERA_AVALON_PIO_DATA(DIST_B_BASE);
      }while(!((*left)&&(*right)&&(*back))); // Make sure all distances have a value
      
      return (*left==4194303)||(*right==4194303)||(*back==4194303); // Return a 1 if any value timed out
    
}   

// Get an average distance value
void getMedians( unsigned int * right,unsigned int * left,unsigned int * back){
    unsigned int distanceBufferL[SAMPLE_BUFFER]; // Buffer for left microphones
    unsigned int distanceBufferR[SAMPLE_BUFFER]; // Buffer for right microphones
    unsigned int distanceBufferB[SAMPLE_BUFFER]; // Buffer for middle microphones
    int i,j;
    unsigned int meanR=0, meanB=0, meanL=0;
    
    // Fill all sample buffers (order them from low distance values to high while filling)
    for(i=0;i<SAMPLE_BUFFER;i++){
       getDistances(&distanceBufferR[i], &distanceBufferL[i],&distanceBufferB[i]);
       for(j=i;j>0&&(distanceBufferL[j]<distanceBufferL[j-1]);j--){
        int swap=distanceBufferL[j-1];
        distanceBufferL[j-1]=distanceBufferL[j];
        distanceBufferL[j]=swap;
       }
       for(j=i;j>0&&(distanceBufferR[j]<distanceBufferR[j-1]);j--){
        int swap=distanceBufferR[j-1];
        distanceBufferR[j-1]=distanceBufferR[j];
        distanceBufferR[j]=swap;
       }
       for(j=i;j>0&&(distanceBufferB[j]<distanceBufferB[j-1]);j--){
        int swap=distanceBufferB[j-1];
        distanceBufferB[j-1]=distanceBufferB[j];
        distanceBufferB[j]=swap;
       }
       
    } 
  
    // Take average of middle samples from all buffers 
    for (i=SAMPLE_BUFFER/2-KEEP/2; i<SAMPLE_BUFFER/2+KEEP/2; i++){
        meanR+=distanceBufferR[i];
        meanL+=distanceBufferL[i];
        meanB+=distanceBufferB[i];
    }
    
    // Return the averages
    *right=meanR/KEEP;	
    *left=meanL/KEEP;
    *back=meanB/KEEP;
} 


// Get the angle value from hardware
int getAngle(int right,int left){
      angleFlag = 0;	// Set the angle flag to 0
      IOWR_ALTERA_AVALON_PIO_DATA(ANGLE_START_BASE, 0);  // Reset angle registers
      IOWR_ALTERA_AVALON_PIO_DATA(DIST_LOUT_BASE, left); // Send left distance value
      IOWR_ALTERA_AVALON_PIO_DATA(DIST_ROUT_BASE, right); // Send right distance value
      IOWR_ALTERA_AVALON_PIO_DATA(ANGLE_START_BASE, 1); // Start angle calculation
      while (!angleFlag);				// Wait for calculation to complete
      return IORD_ALTERA_AVALON_PIO_DATA(ANGLE_BASE);	// Return angle value (9-bit int, 15-bit frac)
}

// Get alcohol reading from robot
int getAlcohol(){
    int upper,lower;
    // Clear data receive register
    upper=IORD_ALTERA_AVALON_UART_RXDATA(XBEE_BASE);
    // Request Alcohol Level
    sendChar('A');
    // Wait for first byte
    while(!(IORD_ALTERA_AVALON_UART_STATUS(XBEE_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK));
    // Read low byte
    lower=IORD_ALTERA_AVALON_UART_RXDATA(XBEE_BASE);
    // Send that data received
    sendChar('G');
    // Clear data receive register
    upper=IORD_ALTERA_AVALON_UART_RXDATA(XBEE_BASE);
    // Wait for second byte
    while(!(IORD_ALTERA_AVALON_UART_STATUS(XBEE_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK));   
    // Get upper byte
    upper=IORD_ALTERA_AVALON_UART_RXDATA(XBEE_BASE);
    // Send that data received
    sendChar('G');
    return lower|(upper<<8); // Concatenate low and high value
}

// Make Robot Face the Nios
void faceNios(){
   unsigned int time = -1, timePrevious;
   int junk;
   char direction = 'C';
   int lowCount = 0, turnCount = 0;
   
   // Pass the Nios twice before honing in
   while (turnCount < 2){
       sendChar(direction); // Direction for Robot to Turn 
       sendChar('L');	    // Turn speed
       usleep(200*1000<<BATTERY); // Wait while turns
       sendChar('S');	    // Stop turning
       timePrevious = time; // Last distance value
       getMedians(&junk,&junk,&time); // Get middle distance value
     
     // If time is getting greater increment counter  
     if ((time > timePrevious)&&(time != 4194303))
        lowCount = lowCount + 1;
     else
        lowCount=0;
   
     // If gets greater too many times then change direction
     if(lowCount > 1){
       direction=(direction == 'C')?'U':'C';
       turnCount = turnCount + 1;
       lowCount=0;
     }
   }
   
   // Hone in on Nios
   do{
     sendChar(direction);
     sendChar('L');
     usleep(150*1000<< BATTERY);
     sendChar('S');
     timePrevious = time;
     getMedians(&junk,&junk,&time);
     
     if (time > timePrevious)
        lowCount = lowCount + 1;
     else
        lowCount=0;
     
   }while(lowCount<2);
   
   // Change direction if necessary
   direction=(direction == 'C')?'U':'C';
   
   // Move robot back one position
   sendChar(direction);
   sendChar('L');
   usleep(150*1000<<BATTERY);
   sendChar('S');

}


// figures out turn time for 360 degree turn
int calTurn(){
   unsigned int time = -1, timePrevious;
   int junk;
   char direction = 'C';
   int lowCount = 0, timeCount = 0;
   
   // Turn for about 3/4 a circle
   sendChar(direction);
   sendChar('L');
   usleep(4000*1000);
   if (BATTERY){
    usleep(2000*1000);
   }
   sendChar('S');
   timeCount+= BATTERY ? 6000: 4000;
   // Keep turning to find the Nios
   do{
     sendChar(direction);
     sendChar('L');
     usleep(150*1000<<BATTERY);
     timeCount+=(150<<BATTERY);
     sendChar('S');
     timePrevious = time;
     getMedians(&junk,&junk,&time);
     
     if ((time > timePrevious)||(lowCount&&(time == timePrevious)))
        lowCount = lowCount + 1;
     else
        lowCount=0;
     
   }while(lowCount<2);
   
   direction=(direction == 'C')?'U':'C';
   
   // Move back one space so facing Nios
   sendChar(direction);
   sendChar('L');
   usleep(150*1000<<BATTERY);
   timeCount-=(150<<BATTERY);
   sendChar('S');
  
  // Return time to turn in 360 degrees   
  return timeCount;

}

int main()
{
    int timeSinceCal=100;
    init();
 // Initialize interrupts and graphics card
  
  //  code for autonomous control 
  //  roboangle foward=0:right=1
    unsigned int meanL,meanR,meanB,angle,turnTime,roboAngle;
    signed int xLoc=0,yLoc=0, xPrev,yPrev,targetPrevX,targetPrevY, xTempLoc=0, yTempLoc=0;
    signed int targetX = 0, targetY=4<<16;
    int boozeLevel = 0;
    int done = 1;
    
    // Infinite Loop
    while(1){
         if(done){  // If Robot is at target -- allow user to move target
            int wait=1;  
            while(wait){
	      // Print current target position to console
              printf("target is X:%i Y:%i\n", targetX>>16,targetY>>16);           
              // Erase previous target
              drawRect(targetPrevX>>15,targetPrevY>>15,0x0);
	      // Draw new target
              drawRect(targetX>>15,targetY>>15,0x00F);
	      // Draw Old Booze level
              drawRect(xTempLoc>>15,yTempLoc>>15,(boozeLevel>400)?(boozeLevel&0x3C0)<<2:(boozeLevel&0x3C)<<2);
	      // Redraw FPGA
              drawRect(0,0,0xFFF);
              
  	      // Make old target equal to new target
              targetPrevX=targetX;
              targetPrevY=targetY;
              
              char charin = 0;
              // Only let go into this loop if a new value is received
              while (!(charin =='w'||charin =='a'||charin =='s'||charin =='d'||charin =='q'))  {       
                scanf("%c",&charin);
              }
              switch(charin){
                case 'w':
                    targetY-=1<<15;  // Move target up
                break;
                case 's':
                    targetY+=1<<15; // Move target down
                break;
                case 'a':
                    targetX-=1<<15; // Move target left
                break;
                case 'd':
                    targetX+=1<<15; // Move target right
                break;
                case 'q':
                    wait=0;  // Done moving target
                break;
               }
               
            }
          }
       
 	   // Make Robot face FPGA (Nios)      
           faceNios();
           timeSinceCal++; // Increment # robot moves since calibration
	   // If period has expired recalibrate robot turns
           if(timeSinceCal>=CAL_PERIOD){
            turnTime=calTurn();
            timeSinceCal=0;
           }
           
           // Get distance values (robot distance from FPGA)
           getMedians(&meanR,&meanL,&meanB);
           
           //get angle calculation from hardware using averaged values
           angle=getAngle(meanR,meanL);
           
           // Make angle equal to robot angle
           roboAngle=angle;
          
           //update previous cartesian coordinates
           xPrev=xTempLoc;
           yPrev=yTempLoc;
           
           // New X Cartesian coordinate   
           xLoc=IORD_ALTERA_AVALON_PIO_DATA(XDIST_BASE);
           int sign = xLoc>>21;
           sign = (sign) ? 0xFFC00000:0;
           xLoc|= sign;
           xLoc=-xLoc;  // Change sign of x if necessary
           // New Y Cartesian coordinate
           yLoc=IORD_ALTERA_AVALON_PIO_DATA(YDIST_BASE);

           sign = yLoc>>21;
           sign = (sign) ? 0xFFC00000:0;
           yLoc|= sign;


           // Round Cartesian values           
           xTempLoc = (xLoc > 0) ? xLoc + 0x4000: xLoc - 0x4000;
           yTempLoc = yLoc + 0x4000;
           
           // Draw Alcohol level at previous position
           drawRect(xPrev>>15,yPrev>>15,(boozeLevel>400)?(boozeLevel&0x3C0)<<2:(boozeLevel&0x3C)<<2);
           // Draw New Robot
           drawRect(xTempLoc>>15,yTempLoc>>15,0xF0F);
           // Redraw Target
           drawRect(targetX>>15,targetY>>15,0x00F);
           // Redraw FPGA
           drawRect(0,0,0xFFF);
           
           // Get the Alcohol level
           boozeLevel=getAlcohol();
         
           done = 1;
         
          // If the robot is not within the target range  
          if ((xLoc > (targetX + 50000))||(xLoc < (targetX - 50000))){
             char dir,turnDir;
             int turnAngle;
             int turnFraction;
             
             // Determine the angle to turn to go left or right
             // Determine direction to turn
             // Determine direction to move after turn 
             if(roboAngle>(90<<15)){
                turnAngle=(180<<15)-roboAngle;
                dir=(xLoc > (targetX + 50000))?'F':'B';
                turnDir='U';
             }
             else{
                turnAngle=roboAngle;
                dir=(xLoc > (targetX + 50000))?'B':'F';
                turnDir='C';
             }
             
             // Turn fraction is equal to the angle divided by 360 degrees (we know how long to turn 360)
             turnFraction=(turnAngle>>9)+(turnAngle>>11)+(turnAngle>>12)+(turnAngle>>14)+(turnAngle>>15);
             
             // Set the amount of time to turn based on turn fraction and time to turn 360 degrees
             int sleepTime=((turnFraction*turnTime)>>15)*1000;
             sendChar(turnDir);
             sendChar('L');
             usleep(sleepTime);
             sendChar('S');
             
             // Reset the robot angle (now facing left or right)
             roboAngle=(turnDir=='C')?0:180<<15;
             
             // Move forward or backward amount based on how far off target
             sendChar(dir);
             sendChar('L');
             usleep(abs(xLoc - targetX)<<(4+BATTERY));
             sendChar('S');
             done=0;
          }

 	  // If the robot is not within y target range        
          if((yLoc > (targetY + 50000))||(yLoc < (targetY - 50000))){
             
             char dir,turnDir;
             int turnAngle;
             int turnFraction;
             
             // Determine the angle to turn to go up or down
             // Determine direction to turn
             // Determine direction to move after turn
             if(roboAngle>90<<15){
                turnAngle=roboAngle-(90<<15);
                dir=(yLoc > (targetY + 50000))?'F':'B';
                turnDir='C';
             }
             else{
                turnAngle=(90<<15)-roboAngle;
                dir=(yLoc > (targetY + 50000))?'F':'B';
                turnDir='U';
             }
             
             // Fraction angle to turn is of 360 degrees  
             turnFraction=(turnAngle>>9)+(turnAngle>>11)+(turnAngle>>12)+(turnAngle>>14)+(turnAngle>>15);
	     
             // Set amount of time to turn based on turn fraction and time to turn 360 degrees
             int sleepTime=((turnFraction*turnTime)>>15)*1000;
             sendChar(turnDir);
             sendChar('L');
             usleep(sleepTime);
             sendChar('S');
             
             // Robot is now facing 90 degrees
             roboAngle=90<<15;
             
             // Move forward or backward depending on how far off the target
             sendChar(dir);
             sendChar('L');
             usleep(abs(yLoc - targetY)<<(4+BATTERY));
             sendChar('S');
             done=0;
          }
          
       }
   return 0;
}
