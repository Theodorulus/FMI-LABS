#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

struct Pair{
    int i, j;
};

int** mat1;
int** mat2;
int** result;
int n1, n2, m1, m2;

void *calculare_element(void *arg)
{
    struct Pair *ij = (struct Pair*) arg;
    int i = ij->i;
    int j = ij->j;
    result[i][j] = 0;
    for(int k = 0 ; k < m1; k++)
        result[i][j] += mat1[i][k] * mat2[k][j];
    return NULL;
}

int main(int argc, char **args)
{
	scanf("%d %d", &n1, &m1);

	mat1 = (int**)malloc(n1 * sizeof(int*));

	for (int i = 0; i< n1; i++)
		mat1[i] = (int *)malloc(m1 * sizeof(int));

	for (int i = 0; i <  n1; i++)
      for (int j = 0; j < m1; j++)
         scanf("%d", &mat1[i][j]);

    scanf("%d %d", &n2, &m2);
	mat2 = (int**)malloc(n2 * sizeof(int*));

	for (int i = 0; i< n2; i++)
		mat2[i] = (int *)malloc(m2 * sizeof(int));

	for (int i = 0; i <  n2; i++)
      for (int j = 0; j < m2; j++)
         scanf("%d", &mat2[i][j]);

	if(m1 != n2)
        return -1;
    else
    {
        pthread_t thr[m1 * n2];

        result = (int**)malloc(n1 * sizeof(int*));

        for (int i = 0; i< n1; i++)
            result[i] = (int *)malloc(m2 * sizeof(int));

        for (int i = 0; i < n1; ++i)
            for (int j = 0; j < m2; ++j)
            {
                struct Pair ij;
                ij.i = i;
                ij.j = j;

                if(pthread_create(&thr[i * m2 + j], NULL, calculare_element, (void*)&ij)) {
                    perror(NULL);
                    return errno;
                }

                if(pthread_join(thr[i * m2 + j], NULL)) {
                    perror(NULL);
                    return errno;
                }
            }
        printf("\n");
        for (int i = 0; i < n1; ++i)
        {
            for (int j = 0; j < m2; ++j)
                printf("%d ", result[i][j]);
            printf("\n");
        }
        free(result);
    }
    free(mat1);
    free(mat2);
    return 0;
}


/*
input:
4 4
3 7 3 6
9 2 0 3
0 2 1 7
2 2 7 9
4 3
6 5 5
1 7 9
6 6 8
0 3 5
*/
