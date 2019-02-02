/////////////////////////////////////////////////////////
// POSIX pthread example
// adapted from
// https://computing.llnl.gov/tutorials/pthreads/
//
// gcc thread_1.c -o th -pthread
/////////////////////////////////////////////////////////

 #include <pthread.h>
 #include <stdio.h>
 
 #define NUM_THREADS 5

 /////////////////////////////////////////////////////////
 //  print function used as all threads
 /////////////////////////////////////////////////////////
 void *PrintHello(void *threadid)
 {
    int tid;
    tid = (int)threadid;
    printf("Hello World! It's me, thread #%d!\n", tid);
	
    pthread_exit(NULL);
 }

 /////////////////////////////////////////////////////////
 // start the threads and print in MAIN
 /////////////////////////////////////////////////////////
 int main (int argc, char *argv[])
 {
    // array of thread handles
	pthread_t threads[NUM_THREADS];
	// create return code
    int rc;
	// thread counter
    int t;

	// launch the threads and note that the print order 
	// between MAIN and the threads is
	// not deterministic and may change when you SSH in versus
	// use serial console, and from run to run
    for(t=0; t<NUM_THREADS; t++){
       printf("In main: creating thread %d\n", t);
	   // now make a thread
       rc = pthread_create(&threads[t], NULL, PrintHello, (void *)t);
       if (rc){
          printf("ERROR; return code from pthread_create() is %d\n", rc);
       } // if (rc)
		
    } //for(t=0; t<NUM_THREADS; t++)

    /* Last thing that main() should do */
    pthread_exit(NULL);
 } // main
 
 /////////////////////////////////////////////////////////
