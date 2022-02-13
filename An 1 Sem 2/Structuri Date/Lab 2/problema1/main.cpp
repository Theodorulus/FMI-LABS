#include <cstdio>

struct stiva{
    int info;
    stiva *next;
} *top;

void push(int x)
{
    stiva *st = new stiva;
    st->info = x;
    st->next = top;
    top = st;
}

int pop()
{
    int nr = -1;
    stiva *aux = top;
    if (top != NULL)
    {
        top=top->next;
        nr = aux->info;
        delete aux;
    }
    return nr;
}

int main()
{
    push(1);
    printf("%d\n",pop());
    push(2);
    push(3);
    while(top!= NULL)
    {
        printf("%d ",top->info);
        top = top->next;
    }
    return 0;
}
