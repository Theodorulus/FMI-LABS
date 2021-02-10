def citire (orientat = False, file_name = "graf.in"):
    f = open (file_name, "r")
    n, m = (int(i) for i in f.readline().split())
    L = []
    for k in range(m):
        i, j, cost = (int(l) for l in f.readline().split())
        i -= 1
        j -= 1
        L.append((cost, (i, j)))
    L.sort(key = lambda x: x[0])
    return n, L

n, L = citire()
t = [i for i in range(n)] #vector tati
h = [0 for i in range(n)] #vector inaltime


def Reprez (x):
    global t
    if x == t[x]:
        return x
    return Reprez(t[x])

def Reuneste (x, y):
    a = Reprez(x)
    b = Reprez(y)
    if h[b] > h[a]:
        t[a] = b
    elif h[b] < h[a]:
        t[b] = a
    elif a != b:  # merge si else:
        t[b] = a
        h[a] += 1


viz = [0 for i in range(n)]
T =[]
s = 0

for x in L:
    c = x[0]
    a = x[1][0]
    b = x[1][1]
    if Reprez(a) != Reprez(b):
        T.append((a, b))
        s += c
        Reuneste(a, b)


print("Cost: " + str(s))
for x in T:
    print (x[0] + 1, x[1] + 1)

for x in t:
    print (x + 1, end = " ")