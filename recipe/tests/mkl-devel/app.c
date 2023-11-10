#include <stdio.h>
#include <mkl.h>
#include <omp.h>

int main(void) {
    printf("MKL max threads: %d\n", mkl_get_max_threads());
    #pragma omp parallel
    {
        printf("OpenMP: Hello from thread #%d\n", omp_get_thread_num());
    }
    return 0;
}
