n = int(input())
A = []
for i in range (n):
    A.append([])
    for j in range(n):
        A[i].append (i * n + (j + 1))
lista_poz = []
i = 0
j = 0
while i != (n-1)/2 and j != (n-1)/2:
    #Nu stiu sa generez tuple-urile :(