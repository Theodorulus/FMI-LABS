#include <stdio.h>
#include <unistd.h>
//#include <sys/wait.h>

int main()
{
    pid_t pid = fork();
    if(pid < 0)
    {
        return -1;
    }
    else if(pid == 0)
    {
        // Copilul
        printf("My PID=%d, Child PID=%d \n", getppid(), getpid());
        char *argv[] = {"ls", NULL};
        execve("/bin/ls", argv, NULL);
        perror(NULL);
    }
    else
    {
        // Parintele
        printf("Child %d finished",wait(NULL));
    }

    return 0;
}