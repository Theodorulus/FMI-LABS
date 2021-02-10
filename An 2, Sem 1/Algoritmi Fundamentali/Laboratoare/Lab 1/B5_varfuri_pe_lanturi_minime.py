import liste_adiacenta as la
from collections import deque

n, L = la.citire(False)
viz = [[0 for i in range(n)] for j in range(2)]
tata = [-1 for i in range(n)]
dist = [[99999 for i in range(n)] for j in range (2)]

print(viz)
print(dist)


def BFS (start, l):
    global viz, tata, dist
    #viz = [[0 for i in range(n)] for j in range(2)]
    tata = [-1 for i in range(n)]
    #dist = [[99999 for i in range(n)] for j in range(2)]
    start -= 1
    q = deque()
    q.append(start)
    viz[l][start] = 1
    dist[l][start] = 0
    print(start + 1, end = " ")
    while len(q) > 0:
        k = q.popleft()
        for x in L[k]:
            if viz[l][x] == 0:
                print(x + 1, end = " ")
                viz[l][x] = 1
                dist[l][x] = dist[l][k] + 1
                tata[x] = k
                q.append(x)


f = open ("graf.in", "r")
m = int(f.readline().split()[1]) # obtin numarul de muchii
linii = f.read().split("\n") # obtin lista liniilor din fisier, inafara de prima linie
ultima_linie = linii[m].split() # a 'm'-a linie este lista punctelor de control, asa ca o pun intr-o lista de int-uri
s, t =  int(ultima_linie[0]), int(ultima_linie[1])

print("\nBFS:")
BFS(s, 0)
print("\nVectorul de distante:")
for i in dist[0]:
    print(i, end = " ")

print("\n\nBFS:")
BFS(t, 1)
print("\nVectorul de distante:")
for i in dist[1]:
    print(i, end = " ")
print()
print("\nSolutie:")

for i in range(n):
    if dist[0][i] + dist[1][i] == dist[0][t - 1] and i + 1 != s and i + 1 != t:
        #print(dist[0][t])
        print(i + 1, end = " ")