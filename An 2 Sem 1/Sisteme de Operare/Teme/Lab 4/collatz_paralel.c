#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    pid_t pid;
    printf("Starting parent %d\n", getpid());
    for(int i = 1; i < argc; i++)
    {
        pid = fork();
		if (pid < 0)
        {
            perror("fork");
            exit( 1 );
        }
        else if(pid == 0)
        {
            //Copil
            int x = atoi(argv[i]);
            printf("%d: %d ", x, x);
            while(x != 1)
            {
                if (x % 2 == 0)
                    x /= 2;
                else
                    x = 3 * x + 1;
                printf("%d ", x);
            }
            printf("\n");
            printf("Done  Parent %d Me %d \n", getppid(), getpid());
            exit(0);
        }
        else
        {
            // Parinte
			wait(NULL);
        }
    }
    printf("Done  Parent %d Me %d \n", getppid(), getpid());
    return 0;
}
