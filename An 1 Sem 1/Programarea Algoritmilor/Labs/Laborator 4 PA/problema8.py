fin = open("angajati.txt")
L= []
while True:
    x = fin.readline()
    if x == "":
        break
    x = x.replace("\n", "")
    x = x.split(", ")
    x[1] = int(x[1])
    x[2] = int(x[2])
    L.append(x)
fin.close()
nume = input ("Numele angajatului:")
for x in L:
    if x[0] == nume:
        print (x[1], x[2])
        break
maxi = 0
for x in L:
    if x[2] > maxi:
        maxi = x[2]
print ("Salariul maxim este de:", maxi, "iar angajatii cu acest salariu sunt: ",end = "")
for x in L:
    if x[2] == maxi:
        print(x[0], end = ", ")
print("")
s = 0
for x in L:
    s += x[2]
sm = s / len(L)
print("Salariul mediu din firma este de", sm)
