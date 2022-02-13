cuvant = input("Cuvantul dat este: ")
fin = open ("fraza.txt")
fr = fin.read()
fr = fr.replace(",", "")
fr = fr.replace (".", "")
okei = 0
for cuv in fr.split():
    ok = 1
    for lit in cuv:
        if lit not in cuvant:
            ok = 0
    for lit in cuvant:
        if lit not in cuv:
            ok = 0
    if ok == 1:
        print (cuv)
        okei = 1
if okei == 0:
    print ("Nu exista niciun cuvant care sa corespunda cerintei.")