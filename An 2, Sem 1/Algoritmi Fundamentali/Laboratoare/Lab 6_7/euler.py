import liste_adiacenta1 as la

n, L = la.citire(False, "graf2.in")
rez = []
la.afisare(L)

def Euler(v):
    while len(L[v]) > 0:
        w = L[v].pop(0)
        Euler(w)
    rez.append(v)

Euler(0)

print(rez)