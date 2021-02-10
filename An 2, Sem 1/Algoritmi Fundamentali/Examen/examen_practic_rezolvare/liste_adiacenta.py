def citire (orientat = False, file_name = "graf.in"):
    f = open (file_name, "r")
    n, m = (int(i) for i in f.readline().split())
    L = [[] for i in range(n)]
    for k in range(m):
        i, j = (int(l) for l in f.readline().split())
        i -= 1
        j -= 1
        #tup = (i,j)
        L[i].append(j)
        if not orientat:
            L[j].append(i)
    for i in range(len(L)):
        L[i].sort()
    return n, L

def afisare(L):
    for (i, li) in enumerate(L):
        print(i + 1, end = ": ")
        for x in li:
            print(x + 1, end=' ')
        print()
