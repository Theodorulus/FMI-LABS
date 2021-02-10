n = input ("Numele persoanei este: ")
nrcrat = 0
ok = 1
#verific sa fie cel mult o cratima
for x in n:
    if x == "-":
        nrcrat += 1
if nrcrat > 1:
    ok = 0
#verific sa fie numai litere, spatii, si cratime
for x in n:
    if x.isalpha() == False and x !=" " and x != "-":
        ok = 0
#verific sa fie maxim un nume de familie si 2 prenume (2 prenume pentru ca deja am verificat daca exista mai mult de o cratima)
if len(n.split()) != 2:
    ok = 0
for cuv in n.split():
    for nume in cuv.split("-"):
        if nume[0].islower() == True:
             ok = 0
        if len (nume) < 3:
            ok = 0
if ok == 1:
    print ("Nume corect")
else:
    print ("Nume incorect")


