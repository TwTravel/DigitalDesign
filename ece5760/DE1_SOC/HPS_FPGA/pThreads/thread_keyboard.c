//////////////////////////////////////////////////////////////
// From 
// https://linuxprograms.wordpress.com/2007/12/29/threads-programming-in-linux-examples/
//
// Modified by bruce.land@cornell.edu
///////////////////////////////////////////////////////////////

#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0

char input_buffer[64];

// access to enter condition
// -- for signalling enter done
pthread_mutex_t enter_lock= PTHREAD_MUTEX_INITIALIZER;
// access to print condition
// -- for signalling print done
pthread_mutex_t print_lock= PTHREAD_MUTEX_INITIALIZER;
// counter protection
pthread_mutex_t count_lock= PTHREAD_MUTEX_INITIALIZER;

// the two condition variables related to the mutex above
pthread_cond_t enter_cond ;
pthread_cond_t print_cond ;

// globals for perfromance
int count1, count2;

///////////////////////////////////////////////////////////////
// read the keyboard
///////////////////////////////////////////////////////////////
void * read1()
{
		while(1){
                //wait for print done
				pthread_mutex_lock(&print_lock);
				pthread_cond_wait(&print_cond,&print_lock);
				// the actual enter				
                printf("Enter a string: ");
                scanf("%s",input_buffer);
				// unlock the input_buffer
                pthread_mutex_unlock(&print_lock);
			    // and tell write1 thread that enter is complete
                pthread_cond_signal(&enter_cond);
        } // while(1)
}

///////////////////////////////////////////////////////////////
// write the input string
///////////////////////////////////////////////////////////////
void * write1() {
		sleep(1);
		// signal that the print process is ready when started
		pthread_cond_signal(&print_cond);
		
        while(1){
				// wait for enter done
                pthread_mutex_lock(&enter_lock);
                pthread_cond_wait(&enter_cond,&enter_lock);
				// the protected print (with protected counter)
				pthread_mutex_lock(&count_lock);
                printf("The string entered is %s, %d\n",input_buffer, count1);
				count1 = 0;
				pthread_mutex_unlock(&count_lock);
				// unlock the input_buffer
				pthread_mutex_unlock(&enter_lock);
                // and tell read1 thread that print is done
				pthread_cond_signal(&print_cond);         
        } // while(1)
}

///////////////////////////////////////////////////////////////
// counter 1
///////////////////////////////////////////////////////////////
// with mutex, about 9 to 10 million/sec
// -- adding a second copy drops rate to about 4 million/sec
// -- adding a second copy pegs BOTH processors at 100%
// without mutex about 200 to 400 millon/sec
// 
void * counter1() {
		//
        while(1){
				// count as fast as possible
				pthread_mutex_lock(&count_lock);
                count1++;    
				pthread_mutex_unlock(&count_lock);
				              
        } // while(1)
}

///////////////////////////////////////////////////////////////
int main()
{
        int status;
		// the thread identifiers
        pthread_t thread_read, thread_write, thread_count1, thread_count2;
		
		// the condition variables
		pthread_cond_init (&enter_cond, NULL);
		pthread_cond_init (&print_cond, NULL);
		
		//For portability, explicitly create threads in a joinable state 
		// thread attribute used here to allow JOIN
		pthread_attr_t attr;
		pthread_attr_init(&attr);
		pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
		
		// now the threads
        pthread_create(&thread_read,NULL,read1,NULL);
        pthread_create(&thread_write,NULL,write1,NULL);
		pthread_create(&thread_count1,NULL,counter1,NULL);
		// second copy of counter
		//pthread_create(&thread_count2,NULL,counter1,NULL);
		 
        pthread_join(thread_read,NULL);
        pthread_join(thread_write,NULL);
        return 0;
}