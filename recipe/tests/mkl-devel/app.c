#include <stdio.h>
#include <mkl.h>

int main(void) {
    printf("MKL max threads: %d\n", mkl_get_max_threads());
    return 0;
}
