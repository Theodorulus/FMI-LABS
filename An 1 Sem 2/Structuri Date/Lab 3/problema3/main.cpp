#include <iostream>

using namespace std;

int vf[1001];
int v[1001];
int n;

void CountSort()
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
    for(i = 0; i < n; i++)
        vf[v[i]] ++;
    int j = 0;
    for(i = mini; i <= maxi; i++)
        while(vf[i])
        {
            v[j++] = i;
            vf[i] --;
        }
}

int main()
{
    int i ;
    cin >> n ;
    for (i = 0; i < n; i++)
        cin >> v[i];
    CountSort();
    cout << "Vectorul sortat: \n";
    for (i = 0; i < n; i++)
        cout << v[i] << ' ';
    return 0;
}
