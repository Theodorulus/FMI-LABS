'''
Pentru a determina arborele T folosim BFS. Cum BFS ia prima data vecinii nodului vizitat,
pornind cautarea din 1 se va afisa arborele de distante fata de varful 1.

Pentru a determina arborele T' folosim DFS. Cum DFS schimba nodul curent la fiecare vecin vizitat,
pornind cautarea din 1 va rezulta un arbore diferit fara de arborele rezultat din BFS.
Complexitatea va fi cea a parcugerilor: O(m)
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

n, L = citire(False, "graf.in")

viz = [0 for i in range(n)]
tata = [-1 for i in range(n)] #vectorul de tati pentru BFS
tata1 = [-1 for i in range(n)] #vectorul de tati pentru DFS
dist = [99999 for i in range(n)] #vectorul de distante pentru BFS
dist1 = [99999 for i in range(n)] #vectorul de distante pentru DFS

def BFS (start):
    global viz, tata, dist
    viz = [0 for i in range(n)]
    tata = [-1 for i in range(n)]
    dist = [99999 for i in range(n)]
    start -= 1
    q = deque()
    q.append(start)
    viz[start] = 1
    dist[start] = 0
    while len(q) > 0:
        k = q.popleft()
        #print(k + 1, end = " ")
        for x in L[k]:
            if viz[x] == 0:
                viz[x] = 1
                dist[x] = dist[k] + 1
                tata[x] = k
                q.append(x)

def DF(k):
    global viz, tata1
    viz = [0 for i in range(n)]
    tata1 = [-1 for i in range(n)]
    dist1[k - 1] = 0
    DFS(k - 1)

def DFS (k):
    viz [k] = 1
    #print(k + 1, end = " ")
    for x in L[k]:
        if viz[x] == 0:
             tata1[x] = k
             dist1[x] = dist1[k] + 1
             DFS(x)

BFS(1)

print("T:")

for i in range(n):
    if tata[i] != -1:
        print (tata[i] + 1, i + 1)

DF(1)

print("T':")
for i in range(n):
    if tata1[i] != -1 :
        print (tata1[i] + 1, i + 1)

print("v: ", end = "")

for i in range(n):
    if dist1[i] != dist[i] :
        print(i + 1, end = " ")


