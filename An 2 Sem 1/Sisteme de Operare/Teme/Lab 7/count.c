#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>
#include <time.h>

#define MAX_RESOURCES 5

int available_resources = MAX_RESOURCES;

pthread_mutex_t mtx;

int decrease_count(int count)
{
    pthread_mutex_lock(&mtx);
    if(available_resources < count)
        return -1;
    else
    {
        available_resources -= count;
        printf("Got %d resources %d remaining\n", count, available_resources);
    }
    return 0;
}

int increase_count(int count)
{
    if(available_resources + count <= MAX_RESOURCES)
    {
        available_resources += count;
        printf("Released %d resources %d remaining\n", count, available_resources);
        pthread_mutex_unlock(&mtx);
        return 0;
    }
    else
    {
        pthread_mutex_unlock(&mtx);
        return -1;
    }
}

void *init(void *arg)
{
    for (int i = 0; i < 3; i++) // iau cate 3 numere reprezentand numarul de resurse cerut pentru fiecare thread
    {
        int count = rand() % 5 + 1; // generez un numar random intre 1 si MAX_RESOURCES (inclusiv) reprezentand numarul de resurse pe care il va lua thread-ul curent

        decrease_count (count);
        increase_count (count);
    }
    return NULL;
}

int main()
{
    srand(time(0));

    if(pthread_mutex_init(&mtx, NULL)) {
        perror(NULL);
        return errno;
    }

    int n = 4;

    pthread_t threads[n];
    printf("MAX_RESOURCES = %d\n", MAX_RESOURCES);

    for(int i = 0; i < n; i ++)
    {
        if(pthread_create(&threads[i], NULL, init, NULL)) {
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
    return 0;
}
