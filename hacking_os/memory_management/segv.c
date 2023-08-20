
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    int *p = NULL;
    puts("before invalid access");
    *p = 0;
    puts("after invalid access");
    return 0;
}

