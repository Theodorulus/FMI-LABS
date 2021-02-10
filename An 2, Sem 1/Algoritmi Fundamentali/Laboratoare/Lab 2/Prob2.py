import liste_adiacenta as la

n, L = la.citire(False, "graf3.in")
viz = [0 for i in range(n)]
tata = [-1 for i in range(n)]
niv = [9999 for i in range(n)]
niv_min = [9999 for i in range(n)]
S = []

def DF(k):
    global viz, tata, niv, niv_min
    viz = [0 for i in range(n)]
    tata = [-1 for i in range(n)]
    niv = [9999 for i in range(n)]
    niv_min = [9999 for i in range(n)]
    niv[k - 1] = 1
    niv_min[k - 1] = 1
    DFS(k - 1, 1)

def DFS (k, nvl):
    global S
    niv[k] = nvl
    niv_min[k] = nvl
    nvl += 1
    viz [k] = 1
    #print(k + 1, end = " ")
    for x in L[k]:
        if tata[k] != x:
            if viz[x] == 0:
                tata[x] = k
                S.append((k, x))
                DFS(x, nvl)
                niv_min[k] = min(niv_min[k], niv_min[x])
                if niv_min[x] >= niv[k]:
                    Comp = []
                    #print(S)
                    while S[-1] != (k, x) and S[-1] != (x, k):
                        Comp.append(S.pop())
                    Comp.append(S.pop())
                    Comp = list(set(Comp))
                    Varfuri = []
                    for x in Comp:
                        Varfuri.append(x[0] + 1)
                        Varfuri.append(x[1] + 1)
                    Varfuri = list(set(Varfuri))
                    Varfuri.sort()
                    print(Varfuri)
            else:
                if niv[x] < niv[k] - 1:
                    niv_min[k] = min(niv_min[k], niv[x])
                    S.append((k, x))

DF(1)