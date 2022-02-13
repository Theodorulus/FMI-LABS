import liste_adiacenta as la
import queue

n, L = la.citire(True, "graf2.in")
grad_intrare = [0 for i in range(n)]
viz = [0 for i in range(n)]
q = []
res = []

la.afisare(L)

for x in L:
    for y in x:
        grad_intrare[y] += 1

#print(grad_intrare)

for i in range(n):
    if grad_intrare[i] == 0:
        q.append(i)
        viz[i] = 1

while len(q):
    v = q.pop(0)
    #print(v + 1, end= " ")
    res.append(v)
    for x in L[v]:
        if viz[x] == 0:
            grad_intrare[x] -= 1
            if grad_intrare[x] == 0:
                q.append(x)
                viz[x] = 1

print()
for x in res:
    print(x + 1, end = " ")
#print(q)