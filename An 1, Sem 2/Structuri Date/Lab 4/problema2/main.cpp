#include <iostream>
#include <string>
#include <string.h>

using namespace std;

struct arbore{
    char* info;
    arbore *st, *dr;
} *rad;

arbore* inserare(arbore* rad, char* x)
{
    arbore* a1 = new arbore;
    a1->info = x;
    a1->st = a1->dr = NULL;
    arbore* a = NULL;
    arbore* b = rad;
    while(b != NULL)
    {
        a = b;
        if(strcmp(x, b->info) <= 0)
            b = b->st;
        else
            b = b->dr;
    }
    if(a == NULL)
        a = a1;
    else
        if (strcmp(x, a->info) <= 0)
            a->st = a1;
        else
            a->dr = a1;
    return a;
}


bool cautare(arbore* rad, char* x)
{
    arbore* a = NULL;
    arbore* b = rad;
    while(b != NULL)
    {
        a = b;
        if(strcmp(x, b->info) < 0)
            b = b->st;
        else
            if(strcmp(x, b->info) > 0)
                b = b->dr;
            else
                return 1;
    }
    return 0;
}

void SRD(arbore* rad)
{
    if (rad != NULL)
    {
        SRD(rad->st);
        cout << rad->info << " ";
        SRD(rad->dr);
    }
}

int main()
{
    rad = NULL;
    int n;
    cin >> n;
    char s[101];
    cin >> s;
    rad = inserare(rad, s);

    for(int i = 1; i < n; i++)
    {
        cin >> s;
        inserare(rad, s);
    }
    /*inserare(rad, "d");
    inserare(rad, "i");
    inserare(rad, "b");
    inserare(rad, "a");
    inserare(rad, "e");
    inserare(rad, "c");
    inserare(rad, "g");
    inserare(rad, "h");*/
    cout << rad->info <<endl;
    cout << "Vectorul de siruri sortat:" << endl;
    SRD(rad);

    return 0;
}
