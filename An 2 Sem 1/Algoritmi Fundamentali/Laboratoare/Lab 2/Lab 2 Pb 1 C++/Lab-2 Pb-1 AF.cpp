#include <iostream>
#include <fstream>
#include <vector>
#include <list>

using namespace std;

vector< list<int> > graf;
vector<int> viz, niv, nivMin;
int n,m;

void citire(int &n, int &m)
{
    ifstream f ("date.in");
    f>>n>>m;
    int x, y;
    graf.resize(n+1);
    viz.resize(n+1);
    niv.resize(n+1);
    nivMin.resize(n+1);
    for(int i = 0; i < m; i++)
    {
        f>>x>>y;
        graf[x].push_back(y);
        graf[y].push_back(x);
    }
    f.close();
}

void DF(int nod)
{
    //cout<<nod<<" ";
    viz[nod] = 1;
    nivMin[nod] = niv[nod];
    for(auto &it : graf[nod])
    {
        if(viz[it] == 0)
        {
            niv[it] = niv[nod] + 1;
            DF(it);
            nivMin[nod] = min(nivMin[it], nivMin[nod]);
            if( niv[nod] < nivMin[it] )
            {
                cout<<nod<<" : "<< it<<endl;
            }
        }
        else if( niv[nod] - niv[it] > 1 )
        {
            nivMin[nod] = min(niv[it], nivMin[nod]);
        }
    }

}

int main()
{
    int nod = 1;
    citire(n, m);
    niv[nod] = 1;
    DF(nod);
    return 0;
}
