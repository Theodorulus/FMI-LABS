import liste_adiacenta as la
from collections import deque

n, L = la.citire(False,"graf4.in")
col = [-1 for i in range(n)]
tata = [-1 for i in range(n)]
la.afisare(L)

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

if BFS(1) == -1:
    print("Bipartit")
else:
    print("Nu e bipartit")
print(col)