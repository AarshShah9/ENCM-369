// lab1exG.c
// ENCM 369 Winter 2023 Lab 1 Exercise G

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAX_ABS_F (5.0e-9)
#define POLY_DEGREE 4

double polyval(const double *a, int n, double x);
/* Return a[0] + a[1] * x + ... + a[n] * pow(x, n). */

int main(void)
{
    double f[] = {1.47, 0.73, -2.97, -1.15, 1.00};
    double dfdx[POLY_DEGREE];

    double guess;
    int max_updates;
    int update_count;
    int n_scanned;
    int i;

    double current_x, current_f, current_dfdx;

    printf("This program demonstrates use of Newton's Method to find\n"
           "approximate roots of the polynomial\nf(x) = ");
    printf("%.2f", f[0]);

    i = 1;
for_top1:
    if (i > POLY_DEGREE)
        goto for_end1;
    if (f[i] < 0)
        goto else_block1;
    printf(" + %.2f*pow(x,%d)", f[i], i);
    i++;
    goto for_top1;
else_block1:
    printf(" - %.2f*pow(x,%d)", -f[i], i);
    i++;
    goto for_top1;

for_end1:

    printf("\nPlease enter a guess at a root, and a maximum number of\n"
           "updates to do, separated by a space.\n");
    n_scanned = scanf("%lf%d", &guess, &max_updates);
    if (n_scanned == 2)
        goto next10;
    printf("Sorry, I couldn't understand the input.\n");
    exit(1);

next10:
    if (max_updates >= 1)
        goto next11;
    printf("Sorry, I must be allowed do at least one update.\n");
    exit(1);

next11:
    printf("Running with initial guess %f.\n", guess);
    i = POLY_DEGREE - 1;

for_start2:
    if (i < 0)
        goto for_end2;
    dfdx[i] = (i + 1) * f[i + 1]; // Calculus!
    i--;
    goto for_start2;
for_end2:

    current_x = guess;
    update_count = 0;

while_start1:

    current_f = polyval(f, POLY_DEGREE, current_x);
    printf("%d update(s) done; x is %.15f; f(x) is %.15e\n",
           update_count, current_x, current_f);
    if (fabs(current_f) < MAX_ABS_F)
        goto while_end1;
    if (update_count == max_updates)
        goto while_end1;
    current_dfdx = polyval(dfdx, POLY_DEGREE - 1, current_x);
    current_x -= current_f / current_dfdx;
    update_count++;
    goto while_start1;

while_end1:

    if (fabs(current_f) < MAX_ABS_F)
        goto else_if1;
    printf("%d updates performed, |f(x)| still >= %g.\n",
           update_count, MAX_ABS_F);
    goto end_of_func;
else_if1:
    printf("Stopped with approximate solution of %.10f.\n",
           current_x);

end_of_func:

    return 0;
}

double polyval(const double *a, int n, double x)
{
    double result = a[n];
    int i;

    i = n - 1;
for_start3:
    if (i < 0)
        goto for_end3;
    result *= x;
    result += a[i];
    i--;
    goto for_start3;

for_end3:
    return result;
}
