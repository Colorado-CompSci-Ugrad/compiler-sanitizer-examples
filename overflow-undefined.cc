#include <stdio.h>
#include <stdlib.h>

//
// The following version of isTmax uses (undefined) overflow
// properties of integers to determine if the value 'x'
// is the largest possible integer (Tmax).
//
// The C and C++ language standards say that arithmetic overflow for
// signed integers is undefined while unsigned integers always wrap
// around. Specifically, they say ( https://en.cppreference.com/w/cpp/language/operator_arithmetic#Overflows ):
// When signed integer arithmetic operation overflows (the result does
// not fit in the result type), the behavior is undefined, — the
// possible manifestations of such an operation include:

// * it wraps around according to the rules of the representation (typically 2's complement),
// * it traps — on some platforms or due to compiler options (e.g. -ftrapv in GCC and Clang),
// * it saturates to minimal or maximal value (on many DSPs),
// * it is completely optimized out by the compiler.
//

int isTmax(int x) { return (x > 0) && ((x+1) < 0); }

int main(int argc, char **argv)
{
    int x = strtol(argv[1], NULL, 0);
    printf("isTMax(%x) = %d\n", x, isTmax(x));
}
