#include <stdio.h>
#include <signal.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

//#define TEST

volatile int counter;

// struct to specify the intervals
struct itimerval rt_itv;
struct timespec nanosleeptime;


// periodic timer callback function
void timer_handler(int i) {
  counter++;
}

void realtime_init(int ms) {
  // route the signal to the timer_handler() callback
  __sighandler_t e;
  e=signal(SIGALRM,timer_handler);
  if ((e!=SIG_IGN) && (e!=SIG_DFL)) {
    fflush(stdout);
    printf("Error : Real-time signal busy\n");
    exit(EXIT_FAILURE);
  }

  // configure the delays
  rt_itv.it_interval.tv_sec  = ms / 1000;
  rt_itv.it_interval.tv_usec = (ms * 1000) % 1000000;

  rt_itv.it_value.tv_sec  = rt_itv.it_interval.tv_sec;
  rt_itv.it_value.tv_usec = rt_itv.it_interval.tv_usec;

  // configure the waiting of 5ms
  nanosleeptime.tv_sec =0;
  nanosleeptime.tv_nsec=5*1000*1000;

  counter=0;

  // start the count-down
  setitimer(ITIMER_REAL,&rt_itv,NULL);
}

int realtime_delay(void) {
  // immediate return without waiting or delays
  if (counter!=0) {
    counter=0;
    return 1;
  }

  // Wait statement that can be interrupted
  nanosleep(&nanosleeptime,NULL);

  // do not empty the counter if it is already empty (to avoid a race-condition)
  if (counter!=0) {
    counter=0;
    return 1;
  }
  return 0;
}

void realtime_exit(void) {
  signal(SIGALRM,SIG_IGN);
}

#ifdef TEST
// Automated test to check the working of the code
int main(int argc, char **argv) {
  int i,j=0;

  realtime_init(1000);

  for (i=0; i<10; i++) {
    j=0;
    while (0==realtime_delay())
      j++;
    printf("%d : %d\n",i,j);
  }

  realtime_exit();
  exit(EXIT_SUCCESS);
}
#endif