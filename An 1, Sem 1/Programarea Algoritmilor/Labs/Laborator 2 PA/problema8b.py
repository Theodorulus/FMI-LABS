# b.1:
'''
p = input ("Propozitia in romana este: ")
print ("Propozitia in pasareasca, fara cratime, este: ", end="")
for cuv in p.split():
    for sil in cuv.split ("-"):
        k = len(sil) - 1
        lit = sil [k]
        if lit.isalpha() == True:
            sil = sil + "p" + lit.lower()
        print (sil, end = "")
    print (" ", end="")
'''

# b.2:

p = input ("Propizita in pasareasca, cu cratime, este: ")
print ("Propozitia in romana, cu cratime, este: ")
for cuv in p.split():
    for i in range(len(cuv.split ("-"))):
        sil = cuv.split ("-")[i]
        k = len (sil)
        if (i < len(cuv.split ("-"))-1):
            print (sil[:k - 2], end = "-")
        else:
            print(sil[:k - 2], end="")
    print (" ", end="")