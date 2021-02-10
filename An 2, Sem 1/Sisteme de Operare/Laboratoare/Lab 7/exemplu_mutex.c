#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>

char a[1001] = {0};
pthread_mutex_t mtx;
void *scrie_a(void *arg)
{
    while (1)
    {
        pthread_mutex_lock(&mtx);
        for (int i = 0; i < 1000; i++)
            a[i] = 'a';
        pthread_mutex_unlock(&mtx);
    }
    return NULL;
}

void *scrie_b(void *arg)
{
    while (1)
    {
        pthread_mutex_lock(&mtx);
        printf("salut");
        for (int i = 0; i < 1000; i++)
            a[i] = 'b';
        pthread_mutex_unlock(&mtx);
    }
    return NULL;
}

void *este_o_singura_litera(void *arg)
{
    while (1)
    {
        pthread_mutex_lock(&mtx);
        char prima_litera = a[0];
        for (int i = 1; i < 1000; i++)
        {
            if (a[i] != prima_litera)
            {
                puts("a este invalid");
                break;
            }
        }
        pthread_mutex_unlock(&mtx);
        puts("a este ok");
    }
    return NULL;
}

int main()
{
    if(pthread_mutex_init(&mtx, NULL)) {
        perror(NULL);
        return errno;
    }

    pthread_t thread_a, thread_b, thread_citeste;
    puts("Cream threaduri");
    pthread_create(&thread_a, NULL, scrie_a, NULL);
    pthread_create(&thread_b, NULL, scrie_b, NULL);
    pthread_create(&thread_citeste, NULL, este_o_singura_litera, NULL);
    while(1);
}
