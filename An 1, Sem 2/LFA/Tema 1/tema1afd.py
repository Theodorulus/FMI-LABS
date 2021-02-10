fin = open ("dateafd.in")
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

print(d)
ok = True

for x in cuv:
    if x not in alfabet:
        print("Cuvant respins: in cuvant exista litere ce nu sunt in alfabet.")
        ok = False
        break
if ok == True:
    stare_curenta = init

    while cuv != "":
        for x in d.keys():
            if x[0] == stare_curenta and cuv[0] in d[x]:
                stare_curenta = x[1]
                cuv = cuv.replace(cuv[0],"",1)
                break

    if stare_curenta in sf:
        print ("Cuvant acceptat")
    else:
        print ("Cuvant respins")


