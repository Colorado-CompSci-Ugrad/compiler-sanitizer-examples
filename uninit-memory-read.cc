#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
  int x = strtol(argv[1], NULL, 0);
  int* a = new int[10];
  a[5] = 0;
  if (a[x]) {
    printf("xx\n");
  }
  return 0;
}
