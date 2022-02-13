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
            else:
                niv_min[k] = min(niv_min[k], niv[x])


DF(1)
print(tata)
print(niv)
print(niv_min)

print("\nPuncte de articulatie:")
pct_artic = []
fii_radacina = 0

for i in range(1, n):
    if niv[tata[i]] <= niv_min[i] and tata[i] != 0:
        pct_artic.append(tata[i])
    if tata[i] == 1:
        fii_radacina += 1

if fii_radacina > 1:
    pct_artic.append(0)

pct_artic = list(set(pct_artic))
if len(pct_artic):
    for x in pct_artic:
        print(x + 1, end = " ")
else:
    print("retea biconexa")