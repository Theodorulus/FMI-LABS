#include <iostream>

using namespace std;

struct arbore{
    int info;
    arbore *st, *dr;
} *rad;

arbore* inserare(arbore* rad, int x)
{
    arbore* a1 = new arbore;
    a1->info = x;
    a1->st = a1->dr = NULL;
    arbore* a = NULL;
    arbore* b = rad;
    while(b != NULL)
    {
        a = b;
        if(x <= b->info)
            b = b->st;
        else
            b = b->dr;
    }
    if(a == NULL)
        a = a1;
    else
        if (x <= a->info)
            a->st = a1;
        else
            a->dr = a1;
    return a;
}

bool cautare(arbore* rad, int x)
{
    arbore* a = NULL;
    arbore* b = rad;
    while(b != NULL)
    {
        a = b;
        if(x < b->info)
            b = b->st;
        else
            if(x > b->info)
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

void RSD(arbore* rad)
{
    if (rad != NULL)
    {
        cout << rad->info << " ";
        RSD(rad->st);
        RSD(rad->dr);
    }
}

int main()
{
    rad = NULL;
    rad = inserare(rad, 6);
    inserare(rad, 4);
    inserare(rad, 9);
    inserare(rad, 2);
    inserare(rad, 1);
    inserare(rad, 5);
    inserare(rad, 3);
    inserare(rad, 7);
    inserare(rad, 8);
    cout << "SRD:" << endl;
    SRD(rad);
    cout << endl << "RSD:" << endl;
    RSD(rad);
    cout << endl << cautare(rad,5) << ' ' << cautare(rad,15) << ' ' << cautare(rad,1);
    return 0;
}
