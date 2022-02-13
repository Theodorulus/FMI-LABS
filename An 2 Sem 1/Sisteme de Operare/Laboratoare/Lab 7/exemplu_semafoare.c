#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>
#include <semaphore.h>

char a[1001] = {0};
sem_t sem;
void *scrie_a(void *arg)
{
    while (1)
    {
        if (sem_wait(&sem)) {
            perror(NULL);
            return errno;
        }
        for (int i = 0; i < 1000; i++)
            a[i] = 'a';
        if (sem_post(&sem)) {
            perror(NULL);
            return errno;
        }
    }
    return NULL;
}

void *scrie_b(void *arg)
{
    while (1)
    {
        if (sem_wait(&sem)) {
            perror(NULL);
            return errno;
        }
        for (int i = 0; i < 1000; i++)
            a[i] = 'b';
        if (sem_post(&sem)) {
            perror(NULL);
            return errno;
        }
    }
    return NULL;
}

void *este_o_singura_litera(void *arg)
{
    while (1)
    {
        if (sem_wait(&sem)) {
            perror(NULL);
            return errno;
        }
        char prima_litera = a[0];
        for (int i = 1; i < 1000; i++)
        {
            if (a[i] != prima_litera)
            {
                puts("a este invalid");
                break;
            }
        }
        if (sem_post(&sem)) {
            perror(NULL);
            return errno;
        }
        puts("a este ok");
    }
    return NULL;
}

int main()
{
    if (sem_init(&sem, 0, 1))
    {
        perror(NULL);
        return errno;
    }

    pthread_t thread_a, thread_b, thread_citeste;
    puts("Cream threaduri");
    pthread_create(&thread_a, NULL, scrie_a, NULL);
    pthread_create(&thread_b, NULL, scrie_b, NULL);
    pthread_create(&thread_citeste, NULL, este_o_singura_litera, NULL);
    while (1);
    //pthread_mutex_destroy(&mtx);
    sem_destroy(&sem);
}
//ex 1 cu mutex
//ex 2 cu semafoare