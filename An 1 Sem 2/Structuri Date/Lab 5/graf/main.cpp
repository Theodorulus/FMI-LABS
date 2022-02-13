#include <iostream>
#include <vector>
#include <list>

using namespace std;

class directedGraph{

    vector< vector<int> > list_;

    int size_;

    bool *viz_;

    void DFS_(int startNode);

    void dfs(int startNode);

    void dfs_(int startNode);

    public:

    directedGraph(): size_(0){}

    directedGraph(int size): size_(size)
    {
        for(int i = 0 ; i < size_ ; i++)
        {
            vector<int> v1;
            list_.push_back(v1);
        }
    }


    void addNode(int a); //construieste si/sau modifica lista de adiacenta

    void addEdge(int source, int target); //construieste si/sau modifica lista de adiacenta

    int hasEdge(int source, int target); // return 1 daca exista muchie

    //[1. (1p)]
    void BFS(int startNode); //afiseaza nodurile; folosind o coada; puteti folosi librarii

    //[2. (1p)]
    void DFS(int startNode); //afiseaza nodurile; folosind o recursie e ok

    //[3. (1p)]
    int twoCycles(); //numara si intoarce cate 2-cicluri sunt in graf; [3->5 , 5->3] este un 2-ciclu

};

void directedGraph::addNode(int a)
{
    size_++;
    vector<int> v1;
    list_.push_back(v1);
}

void directedGraph::addEdge(int source, int target)
{
    if(source < size_ && target < size_)
        list_[source].push_back(target);
}

int directedGraph::hasEdge(int source, int target)
{
    for(int i = 0; i < list_[source].size(); i++)
        if(list_[source][i] == target)
            return 1;
    return 0;
}

void directedGraph::BFS(int startNode)
{
    bool viz[size_] = {0};
    list<int> q;
    viz[startNode] = 1;
    q.push_back(startNode);
    while (!q.empty())
    {
        int  k = q.front();
        cout << k << ' ';
        for(int i = 0 ; i < size_; i++)
            if(!viz[i] && hasEdge(k,i))
            {
                viz[i] = 1;
                q.push_back(i);
            }
        q.pop_front();
    }
}

void directedGraph::DFS_(int startNode)
{
    viz_[startNode] = 1;
    cout << startNode << ' ';
    for(int i = 0 ; i < size_ ; i++)
        if(viz_[i] == 0 && hasEdge(startNode, i))
            DFS_(i);
}

void directedGraph::DFS(int startNode)
{
    viz_  = new bool[size_];
    for(int i = 0; i < size_; i++)
        viz_[i] = 0;
    DFS_(startNode);
    delete[] viz_;
}

void directedGraph::dfs_(int startNode)
{
    viz_[startNode] = 1;
    for(int i = 0 ; i < size_ ; i++)
        if(viz_[i] == 0 && hasEdge(startNode, i))
            dfs_(i);
}

void directedGraph::dfs(int startNode)
{
    viz_  = new bool[size_];
    for(int i = 0; i < size_; i++)
        viz_[i] = 0;
    dfs_(startNode);
    delete[] viz_;
}

int directedGraph::twoCycles()
{
    int nr = 0;
    for(int i = 0; i < size_; i++)
    {
        dfs(i);
        bool viz[size_];
        for(int j = 0 ; j < size_; j++)
            viz[j] = viz_[j];
        // acum in viz avem toate nodurile la care se poate ajunge din i

        //pentru fiecare nod din viz care este true verificam daca putem ajunge in i:
        for(int j = 0 ; j < size_; j++)
            if(viz[j])
            {
                dfs(j);
                if(viz_[i] && i != j)
                {
                    nr++;
                    cout << i << ' ' << j << endl;
                }
            }
    }
    cout << endl;
    return nr/2; // impart la 2 pentru ca le numara de doua ori pe fiecare
}

int main()
{/*
    directedGraph g(5);
    g.addNode(6);
    g.addNode(7);
    g.addEdge(0, 1);
    g.addEdge(0, 2);
    g.addEdge(0, 3);
	g.addEdge(1, 3);
	g.addEdge(1, 4);
	g.addEdge(2, 5);
	g.addEdge(3, 2);
	g.addEdge(3, 5);
	g.addEdge(3, 6);
	g.addEdge(4, 3);
	g.addEdge(4, 6);
	g.addEdge(5, 1);
	g.addEdge(6, 5);
	cout << "BFS din 1: ";
    g.BFS(1);
    cout << endl << "BFS din 3: ";
    g.BFS(3);
    cout << endl << "BFS din 4: ";
    g.BFS(4);
    cout << endl << "DFS din 0: ";
    g.DFS(0);
    cout << endl << "DFS din 2: ";
    g.DFS(2);
    cout << endl << "DFS din 5: ";
    g.DFS(5);
    cout << endl << "DFS din 6: ";
    g.DFS(6);
    cout << endl;
    cout << g.twoCycles() << " (Numarul de 2-cicluri)";*/
    directedGraph g(3);
    g.addEdge(0, 1);
    g.addEdge(1, 2);
    g.addEdge(2, 0);
    cout << g.twoCycles() << " (Numarul de 2-cicluri)";
    return 0;
}

