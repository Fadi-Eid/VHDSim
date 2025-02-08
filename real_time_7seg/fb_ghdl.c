/* Necessary */
#include <fcntl.h>     /* open() */
#include <linux/fb.h>  /* fb_***_screeninfo */
#include <stdio.h>     /* printf(), perror() */
#include <stdlib.h>    /* exit() */
#include <sys/ioctl.h> /* ioctl() */
#include <sys/mman.h>  /* mmap() */
#include <sys/stat.h>  /* open() */
#include <string.h>    /* memset() */

char *fb_name="/dev/fb0"; /* nom par defaut */
int fb_fd;  /* descripteur de fichier du framebuffer */

/* structures fournies par les ioctl() : */
struct fb_var_screeninfo vinfo;
struct fb_fix_screeninfo finfo;
long int screensize = 0; /* nombre d'octets affiches a l'ecran */
char *fbp = 0; /* pointeur vers la memoire video */

int init_done=0;

/* routine pour initialiser le framebuffer : */
void init_fb() {
  char * newname = getenv("FB_NAME");
  if (newname != NULL) {
    printf("ouverture du framebuffer : %s\n", newname);
    fb_name = newname;
   }

  fb_fd = open(fb_name, O_RDWR);
  if (fb_fd == -1) {
    perror("fopen : ouverture du framebuffer impossible\n");
    init_done = -1; return; }

  if (ioctl(fb_fd, FBIOGET_FSCREENINFO, &finfo)) {
    perror("FBIOGET_FSCREENINFO : erreur a la lecture des informations fixes.\n");
    init_done = -2; return; }

  if (ioctl(fb_fd, FBIOGET_VSCREENINFO, &vinfo)) {
    perror("FBIOGET_VSCREENINFO : erreur a la lecture des informations variables.\n");
    init_done = -3;  return; }

  /* calcule la taille de la zone affichable en octets */
  screensize = (vinfo.xres_virtual * vinfo.yres_virtual)
            * ((vinfo.bits_per_pixel+7) >> 3);
  /* l'arrondi de vinfo.bits_per_pixel evite le piege
    des modes 15 bits qui utilisent 2 octets au lieu d'un */

  /* projection du framebuffer en memoire utilisateur */
  fbp = (char *)mmap(0, screensize,
      PROT_READ|PROT_WRITE, MAP_SHARED|MAP_32BIT, fb_fd, 0);
  if (*(int*)fbp == -1) {
    perror("echec de mmap() du framebuffer.\n");
    init_done = -4; return; }

  init_done=1; /* succes */
}

long int get_fb(int w) {
  /* initialise la premiere fois */
  if (init_done==0)
    init_fb();

  /* si erreur d'initialisation, renvoie 0 */
  if (init_done!=1)
    return 0;

  switch(w) {
    case 0 : return (long)(fbp
     + (((vinfo.xres_virtual * vinfo.yoffset) + vinfo.xoffset)
         * ((vinfo.bits_per_pixel+7) >> 3) ));
    case 1 : return vinfo.xres;
    case 2 : return vinfo.yres;
    case 3 : return vinfo.xres_virtual;
    case 4 : return vinfo.yres_virtual;
    case 5 : return vinfo.bits_per_pixel;
    case 6 : return screensize;
  }
  return 0;
}

#ifdef TEST_NO_GHDL
/* compilation :
 gcc -DTEST_NO_GHDL -W -Wall fb_ghdl.c -o fbc && ./fbc */
int main(int arg, char**argv) {
  printf("pointeur : %lX\n", get_fb(0));
  printf("code de retour : %d\n", init_done);
  printf("resolution : %ldx%ld\n", get_fb(1), get_fb(2));
  printf("virtuelle  : %ldx%ld\n", get_fb(3), get_fb(4));
  printf("offset     : %ldx%ld\n", (long int)vinfo.xoffset, (long int)vinfo.yoffset);
  printf("bits/pix : %ld\n", get_fb(5));
  printf("memoire  : %ld\n", get_fb(6));
  if (fbp)
    memset(fbp, 127, get_fb(6));
  return EXIT_SUCCESS;
}
#endif