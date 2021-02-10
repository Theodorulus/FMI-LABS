import liste_adiacenta as la
import heapq as heap

n, L = la.citire()
t = [-1 for i in range(n)]  #vector tati
d = [9999 for i in range(n)]
viz = [0 for i in range(n)]

start = 0
d[start] = 0
q = []

heap.heappush(q, (d[start], start))
while len(q):
    x = heap.heappop(q)[1]
    viz[x] = 1
    for y in L[x]:
        i = y[0]
        j = y[1]
        if viz[i] == 0 and d[i] > j:
            t[i] = x
            d[i] = j
            heap.heappush(q, (d[i], i))

print("Cost: " + str(sum(d)))

for i in range(n):
    if t[i] != -1:
        print(t[i] + 1, i + 1)