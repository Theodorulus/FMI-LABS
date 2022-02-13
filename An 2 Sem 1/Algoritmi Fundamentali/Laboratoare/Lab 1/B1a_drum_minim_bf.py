import liste_adiacenta as la
from collections import deque

n, L = la.citire(True)
viz = [0 for i in range(n)]
tata = [-1 for i in range(n)]

def BFS (start):
    global viz, tata, dist
    viz = [0 for i in range(n)]
    tata = [-1 for i in range(n)]
    start -= 1
    q = deque()
    q.append(start)
    viz[start] = 1
    print(start + 1, end = " ")
    while len(q) > 0:
        k = q.popleft()
        for x in L[k]:
            if viz[x] == 0:
                print(x + 1, end = " ")
                viz[x] = 1
                tata[x] = k
                q.append(x)


f = open ("graf.in", "r")
m = int(f.readline().split()[1]) # obtin numarul de muchii
linii = f.read().split("\n") # obtin lista liniilor din fisier, inafara de prima linie
pct_control = [int(i)-1 for i in linii[m].split()] # a 'm'-a linie este lista punctelor de control, asa ca o pun intr-o lista de int-uri
print(pct_control)
start = int(input("Nodul dorit = "))

if (start - 1 in pct_control):
    print("Lant minim: " + str(start))
else:
    print("\nBFS(1):")
    BFS(start)
    print("\nVectorul de tati:")
    for i in tata:
        print(i + 1, end = " ")
    dist_min = m + 1
    lant_min = []
    print()
    for x in pct_control:
        if tata[x] != -1: # daca se poate ajunge de la nodul de start la nodul x
            nod_curent = x
            lant = []
            while nod_curent != start - 1:
                lant.append(nod_curent + 1)
                nod_curent = tata[nod_curent]
            if nod_curent == start - 1:
                lant.append(start)
            if len(lant) - 1 < dist_min:
                dist_min = len(lant) - 1
                lant_min = lant
    if len(lant_min) > 0:
        lant_min.reverse()
        print("\nLant minim:")
        print(lant_min)
    else:
        print("\nNu se poate ajunge la niciun punct de control din nodul " + str(start))





