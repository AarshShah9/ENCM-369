#include <stdio.h>

// globals1B.c
// ENCM 369 Winter 2023 Exercise B

void copy(int *to, const int *from, int n)
{
  int i;
  for (i = 0; i < n; i++)
    to[i] = from[i];

  // point one (which is AFTER the loop is finished)

  return;
}

void reverse(int *dest, const int *src, int n)
{
  const int *guard;
  int k = n - 1;
  guard = dest + n;
  while (dest != guard)
  {
    *dest = src[k];
    dest++;

    // point two

    k--;
  }
  // point three
}

int aa[] = {210, 321, 432, 543};
int bb[4];
int cc = 600;

void update_cc(int z)
{
  cc += z;
}

int main(void)
{
  int dd[6];
  int ee[4] = {1001, 2002, 3003, 4004};

  update_cc(30);
  copy(dd, aa, 4);
  update_cc(100);
  reverse(bb, ee, 4);
  printf("%d", bb[3]);

  update_cc(7);
  return 0;
}
