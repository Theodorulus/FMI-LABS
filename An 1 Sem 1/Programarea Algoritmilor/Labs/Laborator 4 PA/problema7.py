fin = open ("cuvinte.txt")
fout = open ("cuv_sortate.txt","w")
L = fin.read().split()
fin.close()
desc = sorted(L,reverse = True)
for x in desc:
    fout.write(x+" ")
fout.write("\n")
cresc = sorted(L)
cresc.sort(key = lambda x : len(x))
for x in cresc:
    fout.write(x+" ")
fout.write("\n")
cresc1 = sorted(L, key = lambda x: len(x))
for x in cresc1:
    fout.write(x+" ")
    fout.close()