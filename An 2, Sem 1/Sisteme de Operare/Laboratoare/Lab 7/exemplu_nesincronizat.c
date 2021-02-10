#include <stdio.h>
#include <string.h>
#include <pthread.h>

char a[1001] = {0};

void *scrie_a(void *arg)
{
    while (1)
    {
        for (int i = 0; i < 1000; i++)
            a[i] = 'a';
    }
    return NULL;
}

void *scrie_b(void *arg)
{
    while (1)
    {
        for (int i = 0; i < 1000; i++)
            a[i] = 'b';
    }
    return NULL;
}

void *este_o_singura_litera(void *arg)
{
    while (1)
    {
        char prima_litera = a[0];
        for (int i = 1; i < 1000; i++)
        {
            if (a[i] != prima_litera)
            {
                puts("a este invalid");
                break;
            }
        }
        puts("a este ok");
    }
    return NULL;
}

int main()
{
    pthread_t thread_a, thread_b, thread_citeste;
    puts("Cream threaduri");
    pthread_create(&thread_a, NULL, scrie_a, NULL);
    pthread_create(&thread_b, NULL, scrie_b, NULL);
    pthread_create(&thread_citeste, NULL, este_o_singura_litera, NULL);
    while(1);
}
