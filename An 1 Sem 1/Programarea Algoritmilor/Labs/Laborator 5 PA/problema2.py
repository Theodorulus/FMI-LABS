fin = open ("spectacole.txt")
L=[]
while True:
    x = fin.readline()
    if x=="":
        break
    x = x.replace("-"," ", 1)
    x = x.replace("\n","")
    l = [y for y in x.split(" ",2)]
    l = tuple(l)
    L.append(l)
fin.close()
fout = open("programare.txt", "w")
L1 = sorted(L, key = lambda x : x[1])
final = "00:00"
for x in L1:
    if x[0] >= final:
        fout.write(f"{x[0]}-{x[1]} {x[2]}\n")
        final = x[1]
fout.close()
