# Nume: Tudorache Alexandru-Theodor
# Grupa: 242

fin = open("knapsackA.in")

print("Punctul a: ", end="")

K = int(fin.readline())
S = [int(x) for x in fin.readline().split()]
n = len(S)

# Voi folosi o matrice M de marime (n + 1) * (K + 1) si tip boolean astfel:
# M[i][j] va fi True daca exista o submultime din multimea S[0:i] cu suma egala cu j
# Initializez matricea cu False
M = ([[False for i in range(K + 1)] for i in range(n + 1)])

# Initializez prima coloana cu True, intrucat suma 0 se poate forma fara niciun element
for i in range(n + 1):
    M[i][0] = True

#Parcurg matricea
for i in range(1, n + 1):
    for j in range(1, K + 1):
        if S[i - 1] > j: # Daca elementul curent din multumea S este mai mare decat j, atunci acesta cu siguranta nu va putea incapea in o noua suma <= K
            M[i][j] = M[i - 1][j]
        else:
            M[i][j] = (M[i - 1][j] or M[i - 1][j - S[i - 1]]) # Daca M[i - 1][j - S[i - 1]] este True, atunci elementul curent din multimea S va incapea in o noua suma <= K

#Parcugem ultima linie a matricea de la cel mai mare indice la cel mai mic si il afisam pe primul care este True, acesta fiind suma noastra maxima.
for j in range(K, -1, -1):
    if M[n][j]:
        print(j)
        break

