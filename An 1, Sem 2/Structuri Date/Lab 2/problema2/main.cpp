#include <cstdio>

struct coada{
    int info;
    coada *prev, *next;
} *prim, *ultim;

void push_left(int x)
{
    coada *c = new coada;
    c->info = x;
    c->next = NULL;
    c->prev = NULL;
    if(prim == NULL && ultim == NULL)
        prim = ultim = c;
    else
    {
        c->next = prim;
        prim->prev = c;
        prim = c;
    }
}

void push_right(int x)
{
    coada *c = new coada;
    c->info = x;
    c->prev = NULL;
    c->next = NULL;
    if(prim == NULL && ultim == NULL)
        prim = ultim = c;
    else
    {
        c->prev = ultim;
        ultim->next = c;
        ultim = c;
    }
}

int pop_left()
{
    int nr = -1;
    coada *aux = prim;
    if (prim != NULL)
        if(prim->next == NULL)
        {
            nr = prim->info;
            prim = ultim = NULL;
            delete aux;
        }
        else
        {
            nr = prim->info;
            prim = prim->next;
            prim->prev = NULL;
            delete aux;
        }
    return nr;
}

int pop_right()
{
    int nr = -1;
    coada *aux = ultim;
    if(ultim != NULL)
        if(ultim->prev == NULL)
        {
            nr = ultim->info;
            prim = ultim = NULL;
            delete aux;
        }
        else
        {
            nr = ultim->info;
            ultim = ultim->prev;
            ultim->next = NULL;
            delete aux;
        }
    return nr;
}

int main()
{

    push_left(1);
    push_right(2);
    printf("S-a sters: %d\n",pop_right());
    printf("S-a sters: %d\n",pop_left());
    push_right(3);
    printf("Restul cozii: ");
    while(prim!= NULL)
    {
        printf("%d ",prim->info);
        prim = prim->next;
    }
    return 0;
}
