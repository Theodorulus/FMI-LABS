f = open("knapsack.in")
n = int(f.readline())
A = [int(x) for x in f.readline().split()]
B = [int(x) for x in f.readline().split()]
W = int(f.readline())
print(n, A, B, W)
T = [[0 for i in range(W + 1)] for j in range(n + 1)]
for i in range(n + 1):
    for g in range(W + 1):
        if g == 0 or i == 0:
            T[i][g] = 0
        else:
            if W >= B[i - 1]:
                T[i][g] = max(T[i - 1][g], A[i - 1] + T[i - 1][g-B[i - 1]])
            else:
                T[i][g] = T[i - 1][g]
print(T[n][W])