def negative_pozitive (L):
    neg = []
    poz = []
    for x in L:
        if x >= 0:
            poz.append (x)
        else:
            neg.append (x)
    yield neg
    yield poz

L = [19, 0, 5, -1, -23, 34, 90]
x = negative_pozitive(L)
neg = next(x)
poz = next(x)
neg.sort()
poz.sort()

nume = input("Dati numele fisierului: ")
fout = open(nume, "w")
for x in neg:
    fout.write(f"{x} ")
fout.write("\n")
for x in poz:
    fout.write(f"{x} ")
fout.close()
