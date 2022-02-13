import liste_adiacenta as la

n, L = la.citire()
viz = [0 for i in range(n)]
tata = [-1 for i in range(n)]
niv = [9999 for i in range(n)]
niv_min = [9999 for i in range(n)]
ok = True

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
    global ok
    niv[k] = nvl
    niv_min[k] = nvl
    nvl += 1
    viz [k] = 1
    #print(k + 1, end = " ")
    for x in L[k]:
        if tata[k] != x:
            if viz[x] == 0:
                 tata[x] = k
                 DFS(x, nvl)
                 niv_min[k] = min(niv_min[k], niv_min[x])
                 if niv_min[x] > niv[k]:
                     ok = False
                     print(k + 1, x + 1)
            else:
                niv_min[k] = min(niv_min[k], niv[x])
                '''
                niv_min[k] = niv[x]
                print("\nk: " + str(k+1) + " x: " + str(x+1))
                #print(tata)
                nod_curent = k
                if niv[k] > niv[x]:
                    while nod_curent != x:
                        if niv_min[nod_curent] > niv[x]:
                            print("Modificat: niv_min[" + str(nod_curent + 1) + "] = " + str(niv[x]))
                            niv_min[nod_curent] = niv[x]
                        nod_curent = tata[nod_curent]
                '''


DF(1)

if ok:
    print("retea 2 muchie-conexa")

print()
print(tata)
print(niv)
print(niv_min)