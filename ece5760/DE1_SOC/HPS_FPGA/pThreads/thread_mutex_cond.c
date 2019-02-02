/////////////////////////////////////////////////////////
// POSIX pthread example
// adapted from
// https://computing.llnl.gov/tutorials/pthreads/
//
// gcc thread_2.c -o th -pthread
/////////////////////////////////////////////////////////

#include <pthread.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h> // for nanosleep

 #define NUM_THREADS  3
 #define TCOUNT 4 
 #define COUNT_LIMIT 5

 // global accessable to ALL threads
 int     count = 0;
 
 // thread mutex
 pthread_mutex_t count_mutex;
 // thread condition variable
 pthread_cond_t count_threshold_cv;

 //////////////////////////////////////////////////////////
 // thread count function used for two different threads
 //////////////////////////////////////////////////////////
 void *inc_count(void *t) 
 {
   int i;
   long my_id = (long)t;
   // nanosleep parameter
   struct timespec sleep_time;
   
   // set thread sleep time
   sleep_time.tv_sec = 0; // sec
   sleep_time.tv_nsec = (int)(0.5*1e9); // nanosec

   for (i=0; i<TCOUNT; i++) {
	  
	 // count increment is shared and thus must be protected
     pthread_mutex_lock(&count_mutex);
	 
     count++;
     // while mutex is locked:
	 // Check the value of count and signal waiting "watch"
	 // thread when condition is reached.   
     if (count == COUNT_LIMIT) {
       pthread_cond_signal(&count_threshold_cv);
	   // status message: done
       printf("inc_count(): thread %ld, count = %d  Threshold reached.\n", 
              my_id, count);
     } //if (count == COUNT_LIMIT)
	 // status message: unlock so someone else can increment
     printf("inc_count(): thread %ld, count = %d, unlocking mutex\n", 
			  my_id, count);

	 // unprotect count variable
     pthread_mutex_unlock(&count_mutex);

     /* Do some "work" so threads can alternate on mutex lock */
     nanosleep(&sleep_time, NULL);
   } //for (i=0; i<TCOUNT; i++)
   // bail out after TCOUNT is reached
   pthread_exit(NULL);
 }

 //////////////////////////////////////////////////////////
 // thread counter watch fuction
 //////////////////////////////////////////////////////////
 void *watch_count(void *t) 
 {
   long my_id = (long)t;

   printf("Starting watch_count(): thread %ld\n", my_id);

   /*
   Lock mutex and wait for signal.  Note that the pthread_cond_wait 
   routine will automatically and atomically unlock mutex while it waits. 
   Also, note that if COUNT_LIMIT is reached before this routine is run by
   the waiting thread, the loop will be skipped to prevent pthread_cond_wait
   from never returning. 
   */
   pthread_mutex_lock(&count_mutex);
   // if the COUNT_LIMIT is small, the condition variable can
   // be signaled before the cond_wait, resulting in deadlock
   // Originally the code had a WHILE protecting that.
   // I think it should be an IF
   // you can test the effect of omitting the IF by 
   // setting the COUNT_LIMIT=1 then commmenting out the IF
   // The system deadlocks and does not exit
   if (count<COUNT_LIMIT) {
	 // condition_wait unlocks the mutex, waits, then
	 // locks it again when the condition variable is signaled
     pthread_cond_wait(&count_threshold_cv, &count_mutex);
	 // status message: 
     printf("watch_count(): thread %ld Condition signal received.\n", my_id);
	 // changes count to a big number for easier tracing
	 // when the other threads keep running up to TCOUNT
     count += 125;
	 // status message
     printf("watch_count(): thread %ld count now = %d.\n", my_id, count);
   } // if (count<COUNT_LIMIT)
   // manually unlock to match the earlier mutex_lock
   pthread_mutex_unlock(&count_mutex);
   // and bail out
   pthread_exit(NULL);
 }

 //////////////////////////////////////////////////////////
 // set it up
 //////////////////////////////////////////////////////////
 int main (int argc, char *argv[])
 { 
   // identifiers to pass into each thread 
   int t1=1, t2=2, t3=3;
   
   // thread index into threads array
   int i;
   // array of thread handles
   pthread_t threads[3];
   // thread attribute used here to allow JOIN
   pthread_attr_t attr;

   /* Initialize mutex and condition variable objects */
   pthread_mutex_init(&count_mutex, NULL);
   pthread_cond_init (&count_threshold_cv, NULL);

   /* For portability, explicitly create threads in a joinable state */
   pthread_attr_init(&attr);
   pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
   pthread_create(&threads[0], &attr, watch_count, (void *)t1);
   pthread_create(&threads[1], &attr, inc_count, (void *)t2);
   pthread_create(&threads[2], &attr, inc_count, (void *)t3);

   /* Wait for all threads to complete */
   for (i=0; i<NUM_THREADS; i++) {
     pthread_join(threads[i], NULL);
   }
   printf ("Main(): Waited on %d  threads. Done.\n", NUM_THREADS);

   /* Clean up and exit */
   // Docs say that cleanup is a good idea, but implementation dependent
   // and may not be necessary
   //pthread_attr_destroy(&attr);
   //pthread_mutex_destroy(&count_mutex);
   //pthread_cond_destroy(&count_threshold_cv);
   //pthread_exit(NULL);

 } 
/////////////////////////////////////////////////////////