
/////////////////////////////////////////////////////////////////////////
// Simple MicroC/OS example: 
// Task 1 controls a hardware DDS unit running in the top level module
// Task 1 controls Task 3 via a semaphore 
// -- so that Task 3 runs every time Task 1 does, 
// -- unless Task 1 suspends Task 3 using a pushbutton
// Task 1 sends a message to Task 2, which prints it.
// Task 2 waits for a message, prints it and waits again
// Task 3 waits for a semaphore, prints the system time, and waits again
/////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include "includes.h"
#include "altera_avalon_pio_regs.h"

// I like these
#define begin {
#define end }

///// Define Task parameters //////////////////////////////////
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];
OS_STK    task3_stk[TASK_STACKSIZE];
OS_STK    task4_stk[TASK_STACKSIZE];

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2
#define TASK3_PRIORITY      5
#define TASK4_PRIORITY      10

///// Message queue Define /////////////////////////////////////
#define   MSG_QUEUE_SIZE  10           //Size of message queue
OS_EVENT  *msgqueue;                   //Message queue pointer 
void      *msgqueueSt[MSG_QUEUE_SIZE]; //Storage for messages

///// Semaphore Define  ////////////////////////////////////////
OS_EVENT *sem;

///// task 1 ///////////////////////////////////////////////////
// Controls DDS frequency, sends message and signals Task 3
void task1(void* pdata)
begin
  int sw, key, notecount;
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
    key = 0xf & ~IORD_ALTERA_AVALON_PIO_DATA(IN1_8BIT_BASE); 
    // write to the DDS controller
    IOWR_ALTERA_AVALON_PIO_DATA(OUT0_BASE, notes[notecount]*85899*sw/4000); 
    // Update the DDS note value
    notecount++;
    if (notecount>8) notecount = 0;
    msg = notecount;
    OSQPost(msgqueue, (void *)&msg);   //send a message to task 2
    
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
    
    //wait a second
    OSTimeDlyHMSM(0, 0, 1, 0);         
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
    //wait forever for a message 
    msg = (int *)OSQPend(msgqueue, 0, &return_code); 
    printf("task2 note index=%d\n", *msg);
  end
end

///// task 3 //////////////////////////////////////////////////////
// Prints OS tick count every time task 1 sets semaphore 
void task3(void* pdata)
begin
  int time;
  INT8U return_code = OS_NO_ERR;
  while (1)
  begin
    OSSemPend(sem, 0, &return_code); 
    time = OSTimeGet();
    printf("task3 OS ticks=%d\n", time);
  end
end

///// task 4 //////////////////////////////////////////////////////
// Prints blinks some LEDs at LOW priority and does not block!
// This gives a visual estimate of other task execution 
void task4(void* pdata)
begin
  int count;
  while(1)
  begin
    IOWR_ALTERA_AVALON_PIO_DATA(OUT1_BASE, (count++)>>16);
  end
end

////// main ////////////////////////////////////////////////////
// The main function makes a queue and a semaphore,
//creates three tasks, and starts multi-tasking
int main(void)
begin
  
  //Make a mesage Queue
  msgqueue = OSQCreate(&msgqueueSt[0], MSG_QUEUE_SIZE);
  //Create a semaphore set at zero, so task 3 will wait for task 1
  sem = OSSemCreate(0);  
  
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
  
  OSTaskCreateExt(task3,
                  NULL,
                  (void *)&task3_stk[TASK_STACKSIZE],
                  TASK3_PRIORITY,
                  TASK3_PRIORITY,
                  task3_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);
  
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
//////////////////////////////////////////////////////////////////

