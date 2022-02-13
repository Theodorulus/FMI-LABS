def Knapsack(n, A, B, W):
    if W == 0 or n == 0:
        return 0
    T = [[0 for i in range(0, W + 1)] for g in range(0, n + 1)]

    for i in range(0, n + 1):
        for g in range(0, W + 1):
            if g == 0 or i == 0:
                T[i][g] = 0
            else:
                if W >= B[i - 1]:
                    T[i][g] = max(T[i - 1][g], A[i - 1] + T[i - 1][g - B[i - 1]])

                else:
                    T[i][g] = T[i - 1][g]

    return T[n][W]


n = 3
W = 50
A = [60, 100, 120] #costul
B = [10, 20, 30] #capacitatea
print(Knapsack(n, A, B, W))


