// lab1exH.c
// ENCM 369 Winter 2023 Lab 1 Exercise H

#include <stdio.h>

void print_array(const char *str, const int *a, int n);
// Prints the string given by str on stdout, then
// prints a[0], a[1], ..., a[n - 1] on stdout on a single line.

void sort_array(int *x, int n);
// Sorts x[0], x[1], ..., x[n - 1] from smallest to largest.

int main(void)
{
    int test_array[] = {4000, 5000, 7000, 1000, 3000, 4000, 2000, 6000};

    print_array("before sorting ...", test_array, 8);
    sort_array(test_array, 8);
    print_array("after sorting ...", test_array, 8);
    return 0;
}

void print_array(const char *str, const int *a, int n)
{
    int i;
    puts(str);

    i = 0;
for_start1:
    if (i >= n)
        goto for_end1;
    printf("    %d", a[i]);
    i++;
    goto for_start1;

for_end1:

    printf("\n");
}

void sort_array(int *x, int n)
{
    // This is an implementation of an algorithm called insertion sort.

    int outer, inner, vti;

    outer = 1;
for_start2:
    if (outer >= n)
        goto for_end2;
    vti = x[outer];
    inner = outer;

while_start1:
    if (inner <= 0)
        goto while_end;
    if (vti >= x[inner - 1])
        goto while_end;
    x[inner] = x[inner - 1];
    inner--;
    goto while_start1;

while_end:
    x[inner] = vti;
    outer++;
    goto for_start2;

for_end2:;
}
