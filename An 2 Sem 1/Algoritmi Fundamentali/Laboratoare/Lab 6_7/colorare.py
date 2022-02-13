import liste_adiacenta as la

n, L, ordine = la.citire()
rez = [-1 for i in range(n)]

def colorare():
    rez[ordine[0]] = 0
    liber = [False for i in range(n)]
    for u in ordine[1:]:
        for i in L[u]:
            if rez[i] != -1:
                liber[rez[i]] = True
        color = 0
        while liber[color] == True:
            color += 1
        rez[u] = color

        for i in L[u]:
            if rez[i] != -1:
                liber[rez[i]] = False
    return rez

col = colorare()

for i in range(n):
    print("Varful " + str(i + 1) + " are culoarea " + str(col[i]))