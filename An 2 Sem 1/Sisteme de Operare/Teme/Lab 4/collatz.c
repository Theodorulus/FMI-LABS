#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    pid_t pid = fork();
    if(pid < 0)
    {
        exit(-1);
    }
    else if(pid == 0)
    {
        int x = atoi(argv[1]);
        printf("%d: %d ", x, x);
        do
        {
            if (x % 2 == 0)
                x /= 2;
            else
                x = 3 * x + 1;
            printf("%d ", x);
        }while(x != 1);
        printf("\n");
    }
    else
    {
        // Parintele
        printf("Child %d finished",wait(NULL));
    }

    return 0;
}
