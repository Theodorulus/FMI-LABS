import liste_adiacenta as la
from queue import PriorityQueue

n, L = la.citire(True, "graf5.in")
d = [9999 for i in range(n)]
t = [-1 for i in range(n)]

start = 5
d[start] = 0
q = PriorityQueue()
q.put((d[start], start))
while not q.empty():
    x = q.get()[1]
    for i in L[x]:
        y = i[0]
        c = i[1]
        if d[y] > d[x] + c:
            if any((d[y], y) in item for item in q.queue):
                q.get((d[y], y))
            d[y] = d[x] + c
            t[y] = x
            q.put((d[y], y))


print(d)
print(t)
