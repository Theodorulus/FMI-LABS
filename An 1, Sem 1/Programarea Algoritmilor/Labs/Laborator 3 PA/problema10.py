fin = open ("inventar.txt")
inv = fin.read()
#cerinta 1:
d={}
for lin in inv.split ("\n"):
    x = lin.split()
    nume = x[0]
    d[nume] = [int(x[1])]
    for i in range (2, len(x)):
        d[nume].append (int(x[i]))
print (d)

#cerinta 2:
intersectia = []
vf = {}
for v in d.values():
    for x in v:
        if x in vf.keys():
            vf[x] += 1
        else:
            vf[x] = 1
for v in d.values():
    for x in v:
        if vf[x] == len(d) and x not in intersectia:
            intersectia.append(x)
print (intersectia)

#cerinta 3:
reuniunea = []
for v in d.values():
    for x in v:
        reuniunea.append (x)
reuniunea = set(reuniunea)
print (reuniunea)

#cerinta 4:
for m in d.keys():
    print (m, end = ": ")
    for x in d[m]:
        if vf[x] == 1:
            print (x, end = " ")
    print ("\n")
