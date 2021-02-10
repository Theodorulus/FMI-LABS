def citire (orientat = False, file_name = "graf.in"):
    f = open (file_name, "r")
    n, m = (int(i) for i in f.readline().split())
    mat = [[99999 for i in range(n)] for j in range(n)]
    tata = [[-1 for i in range(n)] for j in range(n)]
    for k in range(m):
        i, j, c = (int(l) for l in f.readline().split())
        i -= 1
        j -= 1
        mat[i][j] = c
        tata[i][j] = i
        if not orientat:
            mat[j][i] = c
            tata[j][i] = j
    for i in range(n):
        mat[i][i] = 0
    return n, mat, tata

def afisare(mat):
    for linie in mat:
        for x in linie:
            print(x, end=' ')
        print()

#main:

#n, mat = citire(True)
#afisare(mat)