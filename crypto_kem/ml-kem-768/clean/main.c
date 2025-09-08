#include <stdio.h>
#include <stdint.h>

#include "ntt.h"
#include "params.h"  // for KYBER_Q

int main(void) {
    printf("KEM test program started.\n");

    // Step 1: Prepare input
    int16_t r[256];
    for (int i = 0; i < 256; i++) {
        r[i] = i % KYBER_Q;  // simple test data
    }

    // Step 2: Run forward NTT
    // PQCLEAN_MLKEM768_CLEAN_ntt(r);
    PQCLEAN_MLKEM768_CLEAN_invntt(r);

    // Step 3: Output result
    printf("NTT result:\n");
    for (int i = 0; i < 256; i++) {
        printf("%5d ", r[i]);
        if ((i + 1) % 16 == 0) printf("\n");
    }

    return 0;
}
