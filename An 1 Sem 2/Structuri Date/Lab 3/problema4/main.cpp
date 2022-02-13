#include <iostream>

using namespace std;

int v[1001];
int n;

void CountSort(int v[], int n, int exp)
{

    int i, vf[10] = {0};
    for (i = 0; i < n; i++)
        vf[ (v[i] / exp) % 10 ]++;
    for (i = 1; i < 10; i++)
        vf[i] += vf[i - 1];

    int w[n];
    for (i = n - 1; i >= 0; i--)
    {
        w[vf[ (v[i] / exp) % 10 ] - 1] = v[i];
        vf[ (v[i]/exp) % 10 ]--;
    }
    for (i = 0; i < n; i++)
        v[i] = w[i];
}

void RadixSort()
{
    int mini, maxi, i;
    mini = maxi = v[0];
    for (i = 0; i < n; i++)
    {
        if(v[i] > maxi)
            maxi = v[i];
        if(v[i] < mini)
            mini = v[i];
    }
    int nrcif = 0, aux = maxi;
    while(aux)
        nrcif++, aux /= 10;
    int nrcifmax = nrcif;
    while(nrcif)
    {
        aux = 1;
        for(i = 1;i <= nrcifmax - nrcif; i++)
            aux *= 10;
        CountSort(v, n, aux);
        nrcif--;
    }
}

int main()
{
    int i ;
    cin >> n ;
    for (i = 0; i < n; i++)
        cin >> v[i];
    RadixSort();
    cout << "Vectorul sortat: \n";
    for (i = 0; i < n; i++)
        cout << v[i] << ' ';
    return 0;
}

