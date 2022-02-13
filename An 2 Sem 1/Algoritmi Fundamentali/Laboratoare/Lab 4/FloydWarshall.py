import matrice_adiacenta as ma

n, d, p = ma.citire(True, "graf4.in")

for k in range(n):
    for i in range(n):
        for j in range(n):
            if d[i][j] > d[i][k] + d[k][j]:
                d[i][j] = d[i][k] + d[k][j]
                p[i][j] = p[k][j]

print()

for i in range(n):
    if d[i][i] < 0:
        print("Circuit negativ!")
        break

for linie in d:
    for x in linie:
        if x < 90000:
            print(x, end=" ")
        else:
            print("∞", end = " ")
    print()

print()


for linie in p:
    print(linie)