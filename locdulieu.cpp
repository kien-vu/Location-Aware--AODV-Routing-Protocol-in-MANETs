#include <stdio.h>

#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
  FILE *fp,*fnew;
  char s[80];
  int t, haha =1;
  float fl;
  char newfile[100];
  if((fp=fopen(argv[1], "r")) == NULL) {
    printf("Cannot open r file.\n");
    exit(1);
  }
  strcpy(newfile,argv[2]);
  strcat(newfile,argv[1]);
  
  if((fnew=fopen(newfile, "w")) == NULL) {
    printf("Cannot open w file.\n");
    exit(1);
  }
  while(fscanf(fp, "[%d] %f\n", &t, &fl) == 2){ /* read from file */
   
  fprintf(fnew, "%d %f\n", t, fl); /* print on screen */
  }
  
  fclose(fp);
  fclose(fnew);
  return 0;
}
