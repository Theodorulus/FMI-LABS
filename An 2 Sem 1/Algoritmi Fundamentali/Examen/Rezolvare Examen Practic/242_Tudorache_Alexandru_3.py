'''
Rezolvarea se bazeaza pe un algoritm de determinare a unui flux maxim folosind algoritmul Ford-Fulkerson(implementarea Edmonds Karp)
'''

from collections import deque

def citire (orientat = False, file_name = "graf.in"):
    f = open (file_name, "r")
    n, m = (int(i) for i in f.readline().split())
    L = [[] for i in range(n)]
    for k in range(m):
        i, j = (int(l) for l in f.readline().split())
        i -= 1
        j -= 1
        L[i].append(j)
        if not orientat:
            L[j].append(i)
    for i in range(len(L)):
        L[i].sort()
    return n, L


n, L = citire(False, "graf3.in")

col = [-1 for i in range(n)]
tata = [-1 for i in range(n)]

#coloram graful in 2 culori pentru a putea construi graful orientat

def BFS (start):
    global col
    start -= 1
    q = deque()
    q.append(start)
    col[start] = 0
    while len(q) > 0:
        k = q.popleft()
        #print(k + 1, end = " ")
        for x in L[k]:
            if col[x] == -1:
                col[x] = 1 - col[k]
                tata[x] = k
                q.append(x)
            elif col[x] == col[k]:
                #tata[k] = x
                return k
    return -1

#Edmonds-Karp:

vizitat = [False for i in range(n + 2)]
tata1 = [-1 for i in range(n + 2)]

def BFS1 (M, start, final):
    global tata1
    viz = [0 for i in range(n)]
    tata1 = [-1 for i in range(n)]
    q = deque()
    q.append(start)
    viz[start] = 1
    tata1[start] = -1
    while len(q) > 0:
        u = q.popleft()
        #print(u + 1, end = " ")
        for v in range(n):
            if viz[v] == 0 and M[u][v] > 0:
                viz[v] = 1
                tata1[v] = u
                q.append(v)
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
    while (BFS1(rGraf, start, final)):
        path_flow = 99999
        v = final
        while v != start:
            u = tata1[v]
            path_flow = min(path_flow, rGraf[u][v])
            v = tata1[v]
        v = final
        while v != start:
            u = tata1[v]
            rGraf[u][v] -= path_flow
            rGraf[v][u] += path_flow
            v = tata1[v]
        max_flow += path_flow
    dfs(rGraf, start)
    for i in range(n):
        for j in range(n):
            if vizitat[i] and not vizitat[j] and graf[i][j] > 0:
                print(str(i + 1) + " " + str(j + 1))
    print()
    return max_flow


BFS(1)

#print(col)

#transformam muchiile in arce din multimea colorata cu 0 catre multimea colorata cu 1

n += 2

L1 = [[] for i in range(n)]

for i in range(n - 2):
    for v in L[i]:
        if col[v] == 1:
            L1[i].append([v, 1])

#nodul sursa:
s = n - 2
#nodul target:
t = n - 1

for i in range(n - 2):
    if col[i] == 0:
        L1[s].append([i, 1])
    else:
        L1[i].append([t, 1])

Graf = [[0 for i in range(n)] for i in range(n)]

for i in range(n):
    for x in L1[i]:
        Graf[i][x[0]] = x[1]

FordFulkerson(Graf, s, t)






