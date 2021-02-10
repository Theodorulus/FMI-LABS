import liste_adiacenta as la

n, L = la.citire(True, "graf3.in")
d = [9999 for i in range(n)]
t = [-1 for i in range(n)]

start = 0
d[start] = 0
#la.afisare(L)

for i in range(n - 1):
    for u in range(n):
        for x in L[u]:
            v = x[0]
            c = x[1]
            if d[u] + c < d[v]:
                d[v] = d[u] + c
                t[v] = u

ok = -1

for u in range(n):
    if ok != -1:
        break
    for x in L[u]:
        v = x[0]
        c = x[1]
        if d[u] + c < d[v]:
            ok = v
            break

if ok != -1:  #in fisierul de intrare daca inlocuiesc ponderea de la muchia 4 3 cu -2 va rezulta ciclu negativ
    print("Ciclu negativ:")
    print(ok, end = " ")
    nod_curent = t[ok]
    while nod_curent != ok:
        print(nod_curent, end = " ")
        nod_curent = t[nod_curent]
    print(nod_curent)
else:
    print(d)
    print(t)