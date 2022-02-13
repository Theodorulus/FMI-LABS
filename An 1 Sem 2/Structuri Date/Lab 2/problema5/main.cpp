#include <cstdio>

int main()
{
    int v[101], n, i, x, nr_ap;
    scanf("%d", &n);
    for(i = 0 ; i < n ; i ++)
        scanf("%d", &v[i]);
    x = v[0];
    nr_ap = 1;
    for(i = 1 ; i < n ; i ++)
    {
        if(v[i] == x)
            nr_ap ++;
        else
        {
            nr_ap --;
            if(nr_ap == 0)
            {
                x = v[i];
                nr_ap = 1;
            }
        }
    }
    int nr_final = 0;
    for(i = 0 ; i < n ; i ++)
        if(x == v[i])
            nr_final ++;
    if(nr_final >= n / 2 + 1)
        printf("Element majoritar: %d", x);
    else
        printf("Nu exista element majoritar");
    return 0;
}
