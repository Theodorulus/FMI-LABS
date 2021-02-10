'''
Rezolvarea se bazeaza pe o sortare topologica. Se creeaza 2 vectori de distante fata de varfurile sursa folosind sortarea topologica.
Complexitatea va fi cea a sortarii topologice: O(m+n), care se poate reduce la O(m)
'''

def citire (orientat = False, file_name = "graf.in"):
    f = open (file_name, "r")
    n, m = (int(i) for i in f.readline().split())
    L = [[] for i in range(n)]
    for k in range(m):
        i, j, cost  = (int(l) for l in f.readline().split())
        i -= 1
        j -= 1
        L[i].append([j, cost])
        if not orientat:
            L[j].append([i, cost])
    s1, s2 = (int(l) for l in f.readline().split())
    for i in range(len(L)):
        L[i].sort()
    return n, L, s1, s2

n, L, s1, s2 = citire(True, "graf2.in")

#Sortare topologica

grad_intrare = [0 for i in range(n)]
viz = [0 for i in range(n)]
q = []
SortTop = []

for x in L:
    for y in x:
        grad_intrare[y[0]] += 1

for i in range(n):
    if grad_intrare[i] == 0:
        q.append(i)
        viz[i] = 1

while len(q):
    v = q.pop(0)
    #print(v + 1, end= " ")
    SortTop.append(v)
    for x in L[v]:
        if viz[x[0]] == 0:
            grad_intrare[x[0]] -= 1
            if grad_intrare[x[0]] == 0:
                q.append(x[0])
                viz[x[0]] = 1

#crearea arborilor

d1 = [9999 for i in range(n)]
tata1 = [-1 for i in range(n)]

s1 -= 1

d2 = [9999 for i in range(n)]
tata2 = [-1 for i in range(n)]

s2 -= 1

d1[s1] = 0
for u in SortTop:
    for x in L[u]:
        v = x[0]
        cost = x[1]
        if d1[u] + cost < d1[v]:
            d1[v] = d1[u] + cost
            tata1[v] = u

#print(d1, tata1)

d2[s2] = 0
for u in SortTop:
    for x in L[u]:
        v = x[0]
        cost = x[1]
        if d2[u] + cost < d2[v]:
            d2[v] = d2[u] + cost
            tata2[v] = u

#print(d2, tata2)

rez = []

for i in range(n):
    if d1[i] == d2[i] and d1[i] < 9900:
        rez.append(i)
        min = i

for x in rez:
    if d1[x] < d1[min]:
        min = x

print("a)")
print("v = " +  str(min + 1))
print("b)")

drum = []
nod_curent = min
while nod_curent != s1:
    drum.append(nod_curent + 1)
    nod_curent = tata1[nod_curent]
drum.append(nod_curent + 1) # s1
drum.reverse()
for x in drum:
    print(x, end = " ")
print()

tata = [[] for i in range(n)]

for x in L[u]:
    v = x[0]
    cost = x[1]
    if d2[u] + cost < d2[v]:
        d2[v] = d2[u] + cost
        tata2[v] = u