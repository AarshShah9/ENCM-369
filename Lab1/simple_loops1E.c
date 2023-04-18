// simple_loops1E.c
// ENCM 369 Winter 2023 Lab 1 Exercise E

// INSTRUCTIONS:
//   Recode the definition of main in Goto-C
//   Make sure your modified program produces exactly the same
//   output as the original.

#include <stdio.h>
void main2(void);

int main(void)
{

  int a[4] = {1200, 3400, 5600, 7800};
  int *p;
  int i;
  for (p = a; p < a + 4; p++)
    printf("%d\n", *p);
  i = 234567;
  while (i > 1)
  {
    printf("%d\n", i);
    i /= 16;
  }

  main2();
  return 0;
}

void main2()
{
  int a[4] = {1200, 3400, 5600, 7800};
  int *p = a;
  int i = 234567;

for_top:
  if (p >= a + 4)
    goto for_end;
  printf("%d\n", *p);
  p++;
  goto for_top;
for_end:

while_top:
  if (i <= 1)
    goto while_bottom;
  printf("%d\n", i);
  i /= 16;

while_bottom:
  printf("Done");
}
