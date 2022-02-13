import liste_adiacenta as la
from collections import deque

n, L = la.citire(True, "graf2.in")
viz = [0 for i in range(n)]
tata = [-1 for i in range(n)]
dist = [99999 for i in range(n)]
st = []

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
            st.append(x)
            tata[x] = k
            DFS(x)
        else:
            if tata[k] != x and tata[k] != tata[x]:
                st.append(x)
                st.append(-1)
                return True

la.afisare(L)
DF(1)

print(tata)
print(st)