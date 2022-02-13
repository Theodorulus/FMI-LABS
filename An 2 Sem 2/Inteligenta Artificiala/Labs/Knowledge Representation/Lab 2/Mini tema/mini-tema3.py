fin = open("input3.txt")
x = fin.readline().replace("\n", '')
stare_initiala = []

while x != "stari_finale":
    y = x.split()
    stare_initiala.append(y)
    x = fin.readline().replace("\n", '')

print("Starea initiala: ", stare_initiala)

stari_finale = []
stringuri_stari_finale = fin.read().split("---")

for string in stringuri_stari_finale:
    stare_finala = []
    lista_stari_finale = string.split("\n")
    while '' in lista_stari_finale:
        lista_stari_finale.remove('')
    for elem in lista_stari_finale:
        if elem != "#":
            lista = elem.split()
        else:
            lista = []
        stare_finala.append(lista)
    stari_finale.append(stare_finala)

print("Lista starilor finale: ", stari_finale)


