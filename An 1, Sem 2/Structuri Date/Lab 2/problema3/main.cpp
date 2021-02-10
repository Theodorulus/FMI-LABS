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
    int n, i, x;
    scanf("%d", &n);
    for(i = 1 ; i <= n ; i++)
    {
        scanf("%d", &x);
        if(top == NULL || top -> info != x)
            push(x);
        else
            if(top->info == x)
                pop();
    }
    if(top == NULL)
        printf("Solutie corecta");
    else
        printf("Solutie incorecta");
    return 0;
}
