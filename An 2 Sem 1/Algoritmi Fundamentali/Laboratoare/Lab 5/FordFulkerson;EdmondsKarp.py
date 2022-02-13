import matrice_adiacenta as ma
from collections import deque

s, t, n, Graf = ma.citire(True, "graf3.in")
vizitat = [False for i in range(n)]
tata = [-1 for i in range(n)]

def BFS (M, start, final):
    global tata
    viz = [0 for i in range(n)]
    tata = [-1 for i in range(n)]
    q = deque()
    q.append(start)
    viz[start] = 1
    tata[start] = -1
    while len(q) > 0:
        u = q.popleft()
        #print(u + 1, end = " ")
        for v in range(n):
            if viz[v] == 0 and M[u][v] > 0:
                viz[v] = 1
                tata[v] = u
                q.append(v)
    #print(tata)
    return viz[final] == 1

def dfs(M, k):
    vizitat[k] = True
    for i in range(n):
        if M[k][i] > 0 and vizitat[i] == False:
            dfs(M, i)

def FordFulkerson(graf, start, final):
    #rGraf = graf.copy() -> nu stiu de ce, dar il modifica si pe 'graf'
    rGraf = [[0 for i in range(n)] for j in range(n)]
    for i in range(n):
        for j in range(n):
            rGraf[i][j] = graf[i][j]
    max_flow = 0
    while (BFS(rGraf, start, final)):
        path_flow = 99999
        v = final
        while v != start:
            u = tata[v]
            path_flow = min(path_flow, rGraf[u][v])
            v = tata[v]
        v = final
        while v != start:
            u = tata[v]
            rGraf[u][v] -= path_flow
            rGraf[v][u] += path_flow
            v = tata[v]
        max_flow += path_flow
    dfs(rGraf, start)
    for i in range(n):
        for j in range(n):
            if vizitat[i] and not vizitat[j] and graf[i][j] > 0:
                print(str(i + 1) + " " + str(j + 1))
    print()
    return max_flow

print(FordFulkerson(Graf, s, t))
#print(tata)