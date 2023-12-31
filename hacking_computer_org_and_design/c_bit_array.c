#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#define BITS_PER_INT (sizeof(int) * 8)

void setBit(int *arr, int index) {
    int arrIndex = index / BITS_PER_INT;
    int bitIndex = index % BITS_PER_INT;
    arr[arrIndex] |= (1 << bitIndex);
}

void clearBit(int *arr, int index) {
    int arrIndex = index / BITS_PER_INT;
    int bitIndex = index % BITS_PER_INT;
    arr[arrIndex] &= ~(1 << bitIndex);
}

bool getBit(int *arr, int index) {
    int arrIndex = index / BITS_PER_INT;
    int bitIndex = index % BITS_PER_INT;
    return (arr[arrIndex] & (1 << bitIndex)) != 0;
}

int main(int argc, char *argv[])
{
    const int SIZE = 20;
    const int ARR_LEN = (SIZE + BITS_PER_INT - 1) / BITS_PER_INT;
    int bitArray[ARR_LEN];
    memset(bitArray, 0, ARR_LEN * sizeof(int));

    setBit(bitArray, 2);
    setBit(bitArray, 5);
    setBit(bitArray, 8);

    int i = 0;
    for(i = 0; i < SIZE; i++) {
        if (getBit(bitArray, i))
            printf("%d\n", i);
    }
    
    return 0;
}

