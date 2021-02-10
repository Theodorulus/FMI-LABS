#include <iostream>

using namespace std;

int h[101];
int n = 0;

int minim()
{
    if(n < 1)
        return -1;
    else
    {
        int ret = h[1];
        h[1] = h[n];
        n--;
        int i = 1;
        while((2 * i <= n) && (h[i] > h[2 * i] || h[i] > h[2 * i + 1]))
            if(2 * i <= n)
                if(h[2 * i] < h[2 * i + 1])
                {
                    int aux = h[i];
                    h[i] = h[2 * i];
                    h[2 * i] = aux;
                    i = 2 * i;
                }
                else
                {
                    int aux = h[i];
                    h[i] = h[2 * i + 1];
                    h[2 * i + 1] = aux;
                    i = 2 * i + 1;
                }
        return ret;
    }
}

void add(int x)
{
    if(n == 0)
    {
        n++;
        h[0] = -1; // incep cu indicele de la 1 pentru accesarea mai usoara a tatalui/copilului.
        h[1] = x;
    }
    else
    {
        n++;
        h[n] = x;
        int i = n;
        while(h[i] < h[i / 2] && i > 1)
        {
            int aux = h[i / 2];
            h[i / 2] = h[i];
            h[i] = aux;
            i = i / 2;
        }
    }

}

int main()
{
    add(3);
    add(8);
    add(7);
    add(15);
    add(6);
    add(2);
    add(11);
    add(12);
    add(9);
    add(5);
    add(10);
    for(int i = 1; i <= n; i++)
        cout << h[i] <<' ';
    cout << endl;
    cout << "Elementul minim este " << minim() << endl;
    for(int i = 1; i <= n; i++)
        cout << h[i] <<' ';
    cout<<endl;
    cout << "Elementul minim este " << minim() << endl;
    for(int i = 1; i <= n; i++)
        cout << h[i] <<' ';
    cout<<endl;
    add(1);
    for(int i = 1; i <= n; i++)
        cout << h[i] <<' ';
    cout<<endl;
    cout << "Elementul minim este " << minim() << endl;
    for(int i = 1; i <= n; i++)
        cout << h[i] <<' ';
    cout<<endl;
    return 0;
}
