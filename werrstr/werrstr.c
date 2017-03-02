#include <stdio.h>
#include <stdlib.h>


int main(int argc, char** argv)
{
    if (argc != 2) {
        printf("%s errno\n", argv[0]);
        exit(-1);
    }

    int err = atoi(argv[1]);
    printf("err(%d) : 0x%x\n", err, err);

    return 0;
}
