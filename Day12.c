#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    FILE* file = fopen("resource/day12/test.txt", "r");
    char line[256];

    if (file != NULL) {
        while (fgets(line, sizeof(line), file)) {
            printf("%s", line);
        }
        fclose(file);
    }

    else {
        fprintf(stderr, "Unable to open file!\n");
    }

    return 0;
}