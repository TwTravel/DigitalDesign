
/////////////////////////////////////////////////////////////////////////
// Simple MicroC/OS example: 
// Task 1 controls a hardware DDS unit running in the top level module
// Task 1 controls Task 3 via a semaphore 
// -- so that Task 3 runs every time Task 1 does, 
// -- unless Task 1 suspends Task 3 using a pushbutton
// -- clears the LCD using a pushbutton
// Task 1 sends a message to Task 2, which prints it.
// Task 2 waits for a message
// -- prints it to the LCD  when it can acquire the mutex
// Task 3 waits for a semaphore 
// -- prints system time to the LCD when it can acquire the mutex
// Task 4 waits for signal from timer1 ISR 
// -- then increments LEDs
// -- print ISR count to the LCD  when it can acquire the mutex
// Note that tasks 2, 3 and 4 access the LCD, so they need to share it
// using a mutex.
/////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include "includes.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "sys/alt_irq.h"

// I like these
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
#define ESC_TOP_MID   "[1;9H"
#define ESC_BOTTOM_LEFT "[2;0H"
#define LCD_CLR "[2J"
#define LCD_CLR_LINE "[K"
static unsigned char esc = 0x1b; // Integer ASCII value of the ESC character
//File descriptor for the LCD
FILE * lcd_fd;

///// Define Task parameters //////////////////////////////////
#define   TASK_STACKSIZE  2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];
OS_STK    task3_stk[TASK_STACKSIZE];
OS_STK    task4_stk[TASK_STACKSIZE];

#define TASK1_PRIORITY      8
#define TASK2_PRIORITY      9
#define TASK3_PRIORITY      10
#define TASK4_PRIORITY      5      //high priority ISR handler

///// Message queue Define /////////////////////////////////////
#define   MSG_QUEUE_SIZE  10           //Size of message queue
OS_EVENT  *msgqueue;                   //Message queue pointer 
void      *msgqueueSt[MSG_QUEUE_SIZE]; //Storage for messages

///// Semaphore Define  ////////////////////////////////////////
OS_EVENT *sem;  //task 1 signal to task 3
OS_EVENT *isr_signal; //timer ISR signal to task 4

///// Define LCD exclusion mutex //////////////////////////////
OS_EVENT  *lcd_mutex;

///// task 1 ///////////////////////////////////////////////////
// Controls DDS frequency, sends message and signals Task 3
void task1(void* pdata)
begin
  int sw, key, notecount, noteinput;
  int task3_status; //keeps track of suspend state
  //frequencies in Hz of middle C octave
  unsigned int notes[9]={262, 294, 330, 349, 392, 440, 494, 523, 0};
  unsigned int msg = 0;
  
  notecount = 0;
  task3_status = 1;
  
  while (1)
  begin
    // read the toggle switches on the DE2
    sw = IORD_ALTERA_AVALON_PIO_DATA(IN0_BASE);
    
    // read the pushbuttons -- inverted because a pressed KEY is a zero
    // masked because there are only 4 buttons
    key = 0xf & ~IORD_ALTERA_AVALON_PIO_DATA(IN1_8BIT_BASE); 
    
    // write to the DDS controller
    // the frequency can go from 262 Hz up to over a MHz.
    IOWR_ALTERA_AVALON_PIO_DATA(OUT0_BASE, notes[notecount]*86*sw);
    
    // Update the DDS note value
    notecount++;
    if (notecount>8) notecount = 0;
    
    //send a message to task 2
    msg = notecount;
    OSQPost(msgqueue, (void *)&msg);   
    
    // Task 3 control
    // signal task 3 if it is running
    if (task3_status==1) OSSemPost(sem);                    
    //IF KEY3 is pushed, suspend task 3 
    if (key==8 && task3_status==1) 
    begin
      OSTaskSuspend(TASK3_PRIORITY);
      task3_status = 0;
    end
    //IF KEY2 is pushed, resume task 3
    if (key == 4 && task3_status==0) 
    begin
      OSTaskResume(TASK3_PRIORITY);
      task3_status = 1;
    end
    
    //IF KEY1 is pushed, clear the LCD
    if (key == 2) fprintf(lcd_fd, "%c%s", esc, LCD_CLR);
    
    //wait a second to let lower priority tasks run
    OSTimeDlyHMSM(0, 0, 1, 1);         
  end
end

///// task 2 /////////////////////////////////////////////////////
// Prints a message from task 1 
void task2(void* pdata)
begin
  INT8U return_code = OS_NO_ERR;
  INT32U *msg;
  
  while (1)
  begin
    //wait for a message 
    msg = (int *)OSQPend(msgqueue, 0, &return_code); 
    // get the mutex and print to LCD
    OSMutexPend(lcd_mutex, 0, &return_code);
    fprintf(lcd_fd, "%c%sNote=%1d\n", esc, ESC_TOP_MID, *msg);
    OSMutexPost(lcd_mutex);
  end
end

///// task 3 //////////////////////////////////////////////////////
// Prints OS tick count and its own stack size
// every time task 1 sets the semaphore 
void task3(void* pdata)
begin
  int time;
  INT8U return_code = OS_NO_ERR;
  OS_STK_DATA stk_data;
  INT32U stk_size;
  
  while (1)
  begin
    //wait for task 1 to permit execution
    OSSemPend(sem, 0, &return_code); 
    
    //get OS ticks, position cursor and print time on LCD
    time = OSTimeGet();
    //get the mutex to assure sole access to LCD
    OSMutexPend(lcd_mutex, 0, &return_code);
    fprintf(lcd_fd, "%c%sTicks=%d\n", esc, ESC_BOTTOM_LEFT, time);
    OSMutexPost(lcd_mutex);
  end
end

///// task 4 //////////////////////////////////////////////////////
// Prints blinks some LEDs at HIGH priority and waits for 
// signal from ISR
void task4(void* pdata)
begin
  int count;
  INT8U return_code = OS_NO_ERR;
  while(1)
  begin
    //wait for timer1 ISR to permit execution
    OSSemPend(isr_signal, 0, &return_code);
    //output to the LEDs 
    IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, (count++));
    
    //get the mutex and print to LCD 
    OSMutexPend(lcd_mutex, 0, &return_code);
    fprintf(lcd_fd, "%c%sISR=%d\n", esc, ESC_TOP_LEFT, count);
    OSMutexPost(lcd_mutex);
  end
end

///// Timer 1 ISR //////////////////////////////////////////////
// timer ISR which is called by the HAL exception dispatcher
// the ISR only signals a task to do the actual work
static void timer_isr(void* context, alt_u32 id)
begin
  OSIntEnter();                   //tell uC/OS about entering ISR
  IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_1_BASE, 0); //reset TO flag
  OSSemPost(isr_signal);          //signal task 4 to execute
  OSIntExit();                    //tell uC/OS about exiting ISR
end

////// main ////////////////////////////////////////////////////
// The main function makes a queue, semaphores, opens the LCD, 
// sets up timer1, registers the ISR,
//creates four tasks, and starts multi-tasking
int main(void)
begin
  //context for ISR
  volatile int context;
  //os return data
  INT8U return_code = OS_NO_ERR;
  
  //Make a mesage Queue
  msgqueue = OSQCreate(&msgqueueSt[0], MSG_QUEUE_SIZE);
  
  //Create a semaphore set at zero, so task 3 will wait for task 1
  sem = OSSemCreate(0);
  
  //Create a semaphore set at zero, so task 4 will wait for timer1 ISR
  isr_signal = OSSemCreate(0);
  
  //Create a mutex with priority 6
  lcd_mutex = OSMutexCreate(4, &return_code);
  
  //open the lcd --- device name from system.h
  lcd_fd = fopen("/dev/lcd", "w");
  if(lcd_fd == NULL) printf("Unable to open lcd display\n");  
  
  //set up timer1
  //1/2 second period, 25e6 counts = 0x17D7840
  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_1_BASE, 0x7840);
  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_1_BASE, 0x27d);
  //set RUN, set CONTuous, set ITO
  IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_1_BASE, 7);
  //register the interrupt (and turn it on)
  alt_irq_register(TIMER_1_IRQ, (void*)&context, timer_isr);
  
  //make some tasks
  OSTaskCreateExt(task1,
                  NULL,
                  (void *)&task1_stk[TASK_STACKSIZE],
                  TASK1_PRIORITY,
                  TASK1_PRIORITY,
                  task1_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);            
               
  OSTaskCreateExt(task2,
                  NULL,
                  (void *)&task2_stk[TASK_STACKSIZE],
                  TASK2_PRIORITY,
                  TASK2_PRIORITY,
                  task2_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);
  
  //Task 3 is set up to monitor stack size
  // by specifiying the OS_TASK_OPT_STK_CHK option
  OSTaskCreateExt(task3,
                  NULL,
                  (void *)&task3_stk[TASK_STACKSIZE],
                  TASK3_PRIORITY,
                  TASK3_PRIORITY,
                  task3_stk,
                  TASK_STACKSIZE,
                  NULL,
                  OS_TASK_OPT_STK_CHK);
  
  OSTaskCreateExt(task4,
                  NULL,
                  (void *)&task4_stk[TASK_STACKSIZE],
                  TASK4_PRIORITY,
                  TASK4_PRIORITY,
                  task4_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);
                  
  OSStart();
  return 0;
end
///// end //////////////////////////////////////////////////////////

