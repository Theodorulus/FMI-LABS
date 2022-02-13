#include <iostream>
#include <fstream>
#include <vector>
#include <list>
#include <queue> 

using namespace std;
 
vector<list<int>> graf;
vector<vector<int>> tati;
vector<bool> viz, relee;
vector<int> nivel;
int n,m,k;
 
void citire(int &n, int &m)
{
    ifstream f ("date.in");
    f>>n>>m>>k;
    int x, y;
    graf.resize(n+1);
    viz.resize(n+1);
    relee.resize(n+1);
    tati.resize(n+1);
    nivel.resize(n+1);
    for(int i = 0; i < m; i++)
    {
        f>>x>>y;
        graf[x].push_back(y);
        graf[y].push_back(x);
    }
    for (int i = 0; i < k; i++) {
        int x;
        f >> x;
        relee[x] = true;
    }
    f.close();
}
 
void BF(int nod)
{
    queue<int> Q;
    Q.push(nod);
    viz[nod] = true;

    int nod_curent;
    while (!Q.empty()) {
        nod_curent = Q.front();
        Q.pop();

        if (relee[nod_curent]) break;
        
        for (auto it: graf[nod_curent]) {
            if (viz[it] == false) {
                nivel[it] = nivel[nod_curent] + 1;
                tati[it].push_back(nod_curent);
                viz[it] = true;
                Q.push(it);
            } else if (nivel[it] == nivel[nod_curent] + 1) {
                tati[it].push_back(nod_curent);
            }
        }
    }

    tati[nod].push_back(0);
    while (nod_curent != 0) {
        cout << nod_curent << " ";
        nod_curent = tati[nod_curent][0];
    }
    cout << endl;
}
 
int main()
{
    int nod = 1;
    citire(n, m);
    nivel[nod] = 1;
    BF(nod);
    return 0;
}