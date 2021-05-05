# Nume: Tudorache Alexandru-Theodor
# Grupa: 242

K = int(input("K= "))
suma = 0
print("Introduceti cate numere doriti. Pentru a va opri, introduceti -1.")
x = int(input())
while x != -1:
    y = suma + x   # in y salvez suma + x pentru a avea doar 3 variabile
    if y <= K:
        suma = y
    elif x > suma:
        suma = x
    x = int(input())

print(suma)

''' 
Exemplu input:
K= 71
Introduceti cate numere doriti. Pentru a va opri, introduceti -1.
19
36
48
-1

Output:
55
'''

'''
JUSTIFICARE:

Varibila de tip stream: x
Variabila 1: K
Variabila 2: suma
Variabila 3: y (= suma + x)

Solutia prezentata parcurge sirul S si aduna la variabila `suma` (initializata cu 0) elementul curent, daca noua suma nu depaseste K, 
altfel inlocuieste `suma` cu maximul dintre `suma` si elementul curent.

Solutia furnizeaza o suma cel putin pe jumatate la fel de buna ca cea optima astfel:
    Presupunem ca `suma` este < k/2 la pasul i. 
    Fie Xi elementul curent de la pasul i.
    Avem doua cazuri:
    Caz 1. Xi < K/2, atunci acesta va 'incapea' in `suma` a.i. sa nu fie > K. Daca si urmatoarele elemente dupa Xi vor 'incapea' in `suma`, atunci algoritmul va furniza 
           chiar solutia optima. Dar daca va fi un element Xj care nu va 'incapea' in `suma`, atunci `suma` va fi inlocuita cu max(`suma`, Xj),
           acest maxim fiind >= K/2, deoarece pentru a fi indeplinita conditia `suma` + Xj > K, cel putin unul dintre `suma` si Xj trebuie sa fie >= K/2.
           Astfel, se obtine un rezultat cel putin pe jumatate la fel de bun ca cel furnizat de solutia optima.
           (deoarece rezultatul furnizat de solutia optima este cel mult = K)
    Caz 2. Xi >= K/2. Daca acesta nu va 'incapea' in `suma` fara a depasi K, atunci `suma` va fi inlocuita cu Xi, care este >= K/2.
                      Daca acesta va 'incapea' in `suma` fara a depasi K, atunci noua suma va fi `suma` + Xi, care este >= K/2 (deoarece Xi >= K/2, iar `suma` > 0)
           Astfel se obtine un rezultat cel putin pe jumatate la fel de bun ca cel furnizat de solutia optima.
           (deoarece rezultatul furnizat de solutia optima este cel mult = K)

'''
