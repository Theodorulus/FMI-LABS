import liste_adiacenta as la
from collections import deque

n, L = la.citire()
viz = [0 for i in range(n)]
tata = [-1 for i in range(n)]
dist = [99999 for i in range(n)]

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
        print(k + 1, end = " ")
        for x in L[k]:
            if viz[x] == 0:
                viz[x] = 1
                dist[x] = dist [k] + 1
                tata[x] = k
                q.append(x)

def DF(k):
    global viz, tata
    viz = [0 for i in range(n)]
    tata = [-1 for i in range(n)]
    DFS(k - 1)

def DFS (k):
    viz [k] = 1
    print(k + 1, end = " ")
    for x in L[k]:
        if viz[x] == 0:
             tata[x]=k
             DFS(x)


'''
start = 1
print("DFS(1):")
BFS(start)
print("\nVectorul de tati:")
for i in tata:
    print(i + 1, end = " ")
print("\nVectorul de distante:")
print(dist)
'''
'''
la.afisare(L)
start = 1
print("DFS(1):")
DF(start)
print("\nVectorul de tati:")
for i in tata:
    print(i + 1, end = " ")
print("\n\nDFS(2):")
DF(start + 1)
print("\nVectorul de tati:")
for i in tata:
    print(i + 1, end = " ")


print("\n\nBFS(1):")
BFS(start)
print("\nVectorul de tati:")
for i in tata:
    print(i + 1, end = " ")
'''