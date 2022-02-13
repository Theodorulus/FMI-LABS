//Varianta profului:
/*
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>

void *invers(void *v)
{
    char *src = (char *)v;
    int n = strlen(src);
    char *dst = malloc(n * sizeof(char));
    for (int i = 0; i < n; i++)
        dst[n - i - 1] = src[i];
    return dst;
}

pthread_t *threads;

int main(int argc, char **args)
{
    if (argc == 1)
        return -1;
    threads = malloc((argc - 1) * sizeof(pthread_t));

    // Cream thread-uri si le dam de munca
    for (int i = 1; i < argc; i++)
    {
        if (pthread_create(&threads[i - 1], NULL, invers, args[i]))
        {
            perror(NULL);
            return errno;
        }
    }

    char *result;
    // Asteptam dupa thread-uri(cel mai probabil multe deja au terminat)
    for (int i = 0; i < argc - 1; i++)
    {
        if (pthread_join(threads[i], &result))
        {
            perror(NULL);
            return errno;
        }
        printf("%s\n", result);
        free(result);
    }
    return 0;
}
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>

void *invers(void *v) {
    char *src = (char*) v;
    int n = strlen(src);
    char *dst = malloc(n * sizeof(char));
    for(int i = 0; i < n; i++)
        dst[n - i - 1] = src[i];
    return dst;
}

pthread_t *threads;

int main(int argc, char **args) {
    pthread_t thr;
    if(argc == 1)
        return - 1;
    threads = malloc((argc-1) * sizeof(pthread_t));
    for(int i = 1; i < argc; i++)
    {
        if(pthread_create(&threads[i - 1], NULL, invers, args[i]))
        {
            perror(NULL);
            return errno;
        }
    }

    char *result;
    //Asteptam dupa thread-uri(cel mai probabil multe deja au terminat)
    for(int i = 0; i < argc - 1; i++)
    {
        if(pthread_join(threads[], &result)) {
            perror(NULL);
            return errno;
        }
        printf("%s\n", result);
        free(result);
    }
    return 0;
}


