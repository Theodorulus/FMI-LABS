f = open("joc_minim_garantat.in")
W = [int(x) for x in f.readline().split()]
n = len(W)

T = [[0 for i in range(n)] for i in range(n)]