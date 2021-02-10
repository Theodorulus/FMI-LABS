fin = open ("date5.in")
init  = fin.readline()
init = init.split("\n")
init = init[0]          # ca sa scap de \n
nrsf = int(fin.readline())
sf = []
alfabet=[]
for x in fin.readline().split():
    sf.append(x)
n = int(fin.readline())
d={}
for i in range(n):
    L = fin.readline().split()
    cheie = L[0] + "." + L[2]
    val = L[1]
    if cheie in d.keys():
        d[cheie] = d[cheie] + "+" + val
    else:
        d[cheie] = val
    if L[2] not in alfabet:
        alfabet.append(L[2])
print("\nDelta AFN:\n",d)
alfabet.sort()
dafn1 = {}
for x in alfabet:
    if (init + "." + x) in d:
        dafn1[init + "." + x] = d[init + "." + x]

dafn2 = {}
for x in dafn1:
    dafn2[x] = dafn1[x]
verif = 0
while verif == 0:
    verif = 1
    for x in dafn1.values():
        ok = 0
        for lit in alfabet:
            if (x + "." + lit) in dafn1:
                ok = 1
        if ok == 0:
            L = x.split("+")
            for y in L:
                for lit in alfabet:
                    if (y + "." + lit) in d:
                        if (x + "." + lit) not in dafn2:
                            dafn2[x + "." + lit] = d[y + "." + lit]
                            verif = 0
                        else:
                            dafn2[x + "." + lit] = dafn2[x + "." + lit]+ "+" + d[y + "." + lit]
                            verif = 0
    for x in dafn2:
        L = dafn2[x].split("+")
        L = set(L)
        L = list(L)
        L.sort()
        val = L[0]
        for i in range(1,len(L)):
            val = val + "+" + L[i]
        dafn2[x] = val
    for x in dafn2:
        dafn1[x] = dafn2[x]

finale = []
for y in dafn1:
    st = y.split(".")
    st = st[0]
    for x in sf:
        if x in st :
            if st not in finale:
                finale.append(st)
for y in dafn1.values():
    for x in sf:
        if x in y :
            if y not in finale:
                finale.append(y)
print("\nStare initiala AFD: \n["+ init +  "]\n")

print("Delta AFD: ")
for x in dafn1:
    L1 = x.split(".")
    L2 = L1[0].split("+")
    print("[",end = "")
    for i in range(len(L2)-1):
        print(L2[i], end=", ")
    print(L2[len(L2)-1],end = "]") # ca sa afisez fara , la final
    print("-> " + L1[1], end = " : ")
    L3 = dafn1[x].split("+")
    print("[", end = "")
    for i in range(len(L3)-1):
        print(L3[i], end = ", ")
    print(L3[len(L3)-1], end = "") # ca sa afisez fara , la final
    print("]")

print("\nStari finale AFD: ")
for i in range(len(finale)-1):
    x = finale [i]
    L = x.split("+")
    print("[", end = "")
    for i in range(len(L)-1):
        print(L[i], end = ", ")
    print(L[len(L)-1], end = "]; ")
#ca sa afisez fara ; la final
x = finale [len(finale)-1]
L = x.split("+")
print("[", end = "")
for i in range(len(L)-1):
    print(L[i], end = ", ")
print(L[len(L)-1], end = "]")