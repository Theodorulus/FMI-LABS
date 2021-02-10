import liste_adiacenta as la

n, L = la.citire(True, "graf5.in")
d = [9999 for i in range(n)]
t = [-1 for i in range(n)]

start = 5
d[start] = 0
q = []
q.append((d[start], start))
while len(q):
    x = q.pop(0)[1]
    for i in L[x]:
        y = i[0]
        c = i[1]
        if d[y] > d[x] + c:
            if(d[y], y) in q:
                q.remove((d[y], y))
            d[y] = d[x] + c
            t[y] = x
            q.append((d[y], y))


print(d)
print(t)
#la.afisare(L)