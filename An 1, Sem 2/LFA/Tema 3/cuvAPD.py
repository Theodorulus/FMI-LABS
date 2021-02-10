fin = open("date3.in")
cuv = fin.readline()
cuv = cuv.split("\n")
cuv = cuv[0] # ca sa scap de \n
init  = fin.readline()
init = init.split("\n")
init = init[0]          # ca sa scap de \n
nrsf = int(fin.readline())
sf = []
for x in fin.readline().split():
    sf.append(x)
n = int(fin.readline())
d = {}
for i in range(n):
    L = fin.readline().split()
    cheie = (L[0], L[1], L[2], L[3])
    Sf_Stiva = L[4].split(",")
    Sf_Stiva.reverse()
    d[cheie] = Sf_Stiva
print("Dictionar de forma cheie(tuplet cu starea din care se pleaca, caracterul care se citeste, caracterul care trebuie scos din stiva, starea in care se ajunge) ; valoare(lista cu elementele ce trebuie adaugate in stiva) ")
print(d)
print("")
L1 = [[init, cuv, ["z0"]]]
L2 = [1]
while(len(L2) > 0):
    L2.clear()
    #print(L1)
    for l in L1:
        #print(l)
        stare_curenta = l[0]
        cuv = l[1]
        stiva = l[2]
        if cuv != "":
            lit = cuv[0]
        else:
            lit = "$"
        for x in d:
            if x[0] == stare_curenta and x[1] == lit and x[2] == stiva[-1]: # verific daca exista o tranzitie din starea curenta cu litera curenta din cuvant si
                                                                            # cu elementul ce trebuie scos din stiva egal cu elementul din varful stivei
                st_c = x[3]
                if lit in cuv:
                    cuv1 = cuv.replace(lit, "", 1)
                stiva1 = stiva.copy()
                del stiva1[-1]
                stiva1.extend(d[x])
                if "$" in stiva1:
                    stiva1.remove("$");
                lista = [st_c, cuv1, stiva1]
                if lista not in L2:
                    L2.append(lista)
            elif x[0] == stare_curenta and x[1] == "$" and x[2] == stiva[-1]:   # verific daca exista o tranzitie din starea curenta cu caracterul nul si
                                                                                # cu elementul ce trebuie scos din stiva egal cu elementul din varful stivei
                st_c = x[3]
                stiva1 = stiva.copy()
                del stiva1[-1]
                stiva1.extend(d[x])
                if "$" in stiva1:
                    stiva1.remove("$");
                lista = [st_c, cuv, stiva1]
                if lista not in L2:
                    L2.append(lista)

    if len(L2) > 0:
        L1 = L2.copy()

    for l in L1:
        print(l)
    print("")
ok = False
for l in L1:
    if l[0] in sf and l[1] == "" and len(stiva) == 0:
        print("Cuvant acceptat")
        ok = True
        break;
if ok == False:
    print("Cuvant respins")













'''
stiva = ["z0"]
stare_curenta = init
lit = cuv[0]
ok = True
while  ok == True and len(stiva) > 0:
    ok = False
    for x in d:
        if x[0] == stare_curenta and x[1] == lit and x[2] == stiva[-1]:
            ok = True
            stare_curenta = x[3]
            if lit in cuv:
                cuv = cuv.replace(lit, "", 1)
            del stiva[-1]
            stiva.extend(d[x])
            if "$" in stiva:
                stiva.remove("$");
            if cuv != "":
                lit = cuv[0]
            else:
                lit = "$"
            break;
    print(cuv, stare_curenta, stiva)
if (stare_curenta in sf) and len(stiva) == 0 :
    print("cuvant acceptat")
else:
    print("cuvant respins")
'''