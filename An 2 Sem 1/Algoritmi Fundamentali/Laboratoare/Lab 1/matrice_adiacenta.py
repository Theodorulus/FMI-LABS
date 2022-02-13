def citire (orientat = False, file_name = "graf.in"):
    f = open (file_name, "r")
    n, m = (int(i) for i in f.readline().split())
    mat = [[0 for i in range(n)] for j in range(n)]
    for k in range(m):
        i, j = (int(l) for l in f.readline().split())
        i -= 1
        j -= 1
        mat[i][j] = 1
        if not orientat:
            mat[j][i] = 1
    return n, mat

def afisare(mat):
    for linie in mat:
        for x in linie:
            print(x, end=' ')
        print()

#main:

n, mat = citire(True)
afisare(mat)