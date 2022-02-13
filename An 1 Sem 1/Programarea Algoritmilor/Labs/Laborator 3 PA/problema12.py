fin = open("partajare.in")
x = fin.readline()
i = 1
l = []
punctaje = []
while x != "-1":
    s = x.split()
    pct = int(s[0])
    nume = s[1] + " " + s[2]
    l.append ((pct, nume, i))
    punctaje.append (pct)
    i += 1
    x = fin.readline()
print ("a.", l)
punctaje = set(punctaje)
print ("b.", punctaje)

d={}
for p in punctaje:
    for x in l:
        if x[0] == p:
            y = (x[1],x[2])
            if p not in d:
                d[p] = []
                d[p].append (y)
            else:
                d[p].append (y)
print("c.",d)
