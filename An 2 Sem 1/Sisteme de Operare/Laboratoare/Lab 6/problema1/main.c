#include <pthread.h> 
#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <errno.h>

void *invers(void *v) {
    char *src = (char*) v;
    int n = strlen(src);
    char *dst = malloc(n * sizeof(char));
    for(int i = 0; i < n; i++)
        dst[n - i - 1] = src[i];
    return dst;
}


int main(int argc, char **args) {
    pthread_t thr;
    if(argc != 2)
        return - 1;
    char *str = args[1];
    if(pthread_create(&thr, NULL, invers, str)) {
        perror(NULL);
        return errno;
    }
    char *result;
    if(pthread_join(thr, &result)) {
        perror(NULL);
        return errno;
    }
    printf("%s", result);
    free(result);
    return 0;
}