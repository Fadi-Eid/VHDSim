#include <stdio.h>
#include <signal.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

// "boite aux lettres"
volatile int compteur;

// structures a remplir pour specifier les intervalles
struct itimerval rt_itv;
struct timespec nanosleeptime;


// callback : c'est la fonction appelee periodiquement.
void timer_handler(int i) {
  compteur++;
}

void realtime_init(int ms) {
  // route le signal vers notre callback
  __sighandler_t e;
  e=signal(SIGALRM,timer_handler);
  if ((e!=SIG_IGN) && (e!=SIG_DFL)) {
    fflush(stdout);
    printf("Erreur : Signal temps réel occupé\n");
    exit(EXIT_FAILURE);
  }

  // configure les delais
  rt_itv.it_interval.tv_sec=ms / 1000;
  rt_itv.it_interval.tv_usec=(ms * 1000) % 1000000;
  rt_itv.it_value.tv_sec =rt_itv.it_interval.tv_sec;
  rt_itv.it_value.tv_usec=rt_itv.it_interval.tv_usec;

  // configure l'attente de 5ms
  nanosleeptime.tv_sec =0;
  nanosleeptime.tv_nsec=5*1000*1000;

  compteur=0;

  // lance le decompte
  setitimer(ITIMER_REAL,&rt_itv,NULL);
}

int realtime_delay(void) {
  // retour immediat sans attente :
  if (compteur!=0) {
    compteur=0;
    return 1;
  }

  // attente interruptible
  nanosleep(&nanosleeptime,NULL);

  // ne pas vider le compteur s'il est deja vide
  // (evite une race-condition stupide)
  if (compteur!=0) {
    compteur=0;
    return 1;
  }
  return 0;
}

void realtime_exit(void) {
  signal(SIGALRM,SIG_IGN);
}

#ifdef DEBUG_YG
// test autonome :
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