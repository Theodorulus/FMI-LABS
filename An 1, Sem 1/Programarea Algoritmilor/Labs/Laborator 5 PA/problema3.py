fin = open ("cuburi.txt")
n = int (fin.readline())
L = []
for i in range (n):
    x = (fin.readline().split())
    L.append((int(x[0]),x[1]))
fin.close()
L1 = sorted(L, key = lambda x : x[0],reverse = True)
print(L1)

fout = open ("turn.txt","w")
culoare = ""
s = 0
for x in L1:
    if x[1] != culoare:
        fout.write(f"{x[0]} {x[1]}\n")
        culoare = x[1]
        s += x[0]
fout.write ("\nInaltime totala: " + str(s))
