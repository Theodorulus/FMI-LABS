fin = open ("dateafn.in")
cuv = fin.readline()
cuv = cuv.replace("\n","") # ca sa scap de \n
init = fin.readline()
init = init[0] # ca sa scap de \n
nrsf = int(fin.readline())
sf = []
alfabet = []
for x in fin.readline():
    sf.append(x)
n = int(fin.readline())
d = {}
for i in range(n):
    L = fin.readline().split()
    cheie = L[0] + L[1]
    if cheie not in d.keys():
        d[cheie] = [L[2]]
    else:
        d[cheie].append(L[2])
    alfabet.append(L[2])

if cuv == "VID":
    if init in sf:
        print("Cuvant acceptat")
    else:
        print("Cuvant respins")
else:
    print(d)
    ok = True

    for x in cuv:
        if x not in alfabet:
            print("Cuvant respins: in cuvant exista litere ce nu sunt in alfabet.")
            ok = False
            break
    if ok == True:
        stari_curente = [init]

        while cuv != "":
            print(stari_curente)
            new_list = []
            for x in d.keys():
                if x[0] in stari_curente and cuv[0] in d[x]:
                    if x[1] not in new_list:
                        new_list.append(x[1])
            cuv = cuv.replace(cuv[0],"",1)
            stari_curente = new_list
        ok = False
        for x in stari_curente:
            if x in sf:
                ok = True
        if ok == True:
            print("Cuvant acceptat")
        else:
            print("Cuvant respins")