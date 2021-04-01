# Nume: Tudorache Alexandru-Theodor
# Grupa: 242

print("Punctul b: ")

K = int(input("K= "))
s = 0
print("Introduceti cate numere doriti. Pentru a va opri, introduceti -1.")
x = int(input())
while x != -1:
    y = s + x   # in y salvez s + x pentru a avea doar 3 variabile
    if y <= K:
        s = y
    elif x > s:
        s = x
    x = int(input())

print(s)

''' 
JUSTIFICARE:

Varibila de tip stream: x
Variabila 1: K
Variabila 2: s
Variabila 3: y (= s + x)

Solutia prezentata parcurge sirul S si aduna la variabila s (initializata cu 0) elementul curent, daca aceasta suma nu depaseste K, 
altfel inlocuieste s cu maximul dintre s si elementul curent.

Solutia furnizeaza o suma cel putin pe jumatate la fel de buna ca cea optima astfel:
    Presupunem ca suma s este < k/2 la pasul i. 
    Fie Xi elementul curent de la pasul i.
    Avem doua cazuri:
    Caz 1. Xi < K/2, atunci acesta va incapea in suma s. Daca si urmatoarele elemente dupa Xi vor incapea in suma, atunci algoritmul va furniza 
           chiar solutia optima. Dar daca va fi un element Xj care nu va incapea in suma, atunci suma va fi inlocuita cu maximul dintre s si Xj,
           acesta fiind cel putin k/2, deoarece pentru a fi indeplinita conditia s + Xj > K, cel putin unul dintre s si Xj trebuie sa fie >= k/2.
           Astfel, se obtine un rezultat cel putin pe jumatate la fel de bun ca cel furnizat de solutia optima
           (deoarece rezultatul furnizat de solutia optima este cel mult = K).
    Caz 2. Xi >= K/2, daca acesta nu va incapea in suma s, atunci suma s va fi inlocuita cu Xi, 
           astfel obtinandu-se un rezultat cel putin pe jumatate la fel de bun ca cel furnizat de solutia optima
           (deoarece rezultatul furnizat de solutia optima este cel mult = K).

'''
