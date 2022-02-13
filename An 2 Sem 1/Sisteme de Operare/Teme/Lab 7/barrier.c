#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>
#include <semaphore.h>

sem_t sem;
pthread_mutex_t mtx;
int n = 5;
int count;

void barrier_point()
{
    pthread_mutex_lock(&mtx);
    count ++;
    if (count == n)
        sem_post(&sem);
    pthread_mutex_unlock(&mtx);
    sem_wait(&sem);
    sem_post(&sem);
}

void *tfun(void *v)
{
    int *tid = (int *) v;
    printf("%d reached the barrier\n", *tid);
    barrier_point();
    printf("%d passed the barrier\n", *tid);
    free(tid);
    return NULL;
}

int main()
{
    count = 0;

    if(pthread_mutex_init(&mtx, NULL)) {
        perror(NULL);
        return errno;
    }

    if (sem_init(&sem, 0, 0))
    {
        perror(NULL);
        return errno;
    }

    pthread_t threads[n];

    int args[n];

    for(int i = 0; i < n; i ++)
    {
        args[i] = i;
        if(pthread_create(&threads[i], NULL, tfun, &args[i])) {
            perror(NULL);
            return errno;
        }
    }

    for(int i = 0; i < n; i ++)
    {
        if(pthread_join(threads[i], NULL)) {
            perror(NULL);
            return errno;
        }
    }
    pthread_mutex_destroy(&mtx);
    sem_destroy(&sem);
    return 0;
}
