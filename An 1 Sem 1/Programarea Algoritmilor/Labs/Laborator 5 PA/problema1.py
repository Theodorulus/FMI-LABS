def afisare_timpi_servire(l):
    s = 0
    tma = 0
    for x in l:
        s += x[1]
        print(f"{x[0]}\t{x[1]}\t{s}")
        tma += s
    return tma/len(l)

fin = open ("tis.txt")
y = fin.read()
fin.close()
timpi = [int(x) for x in y.split()]
L = [(x,timpi[x-1]) for x in range(1,len(timpi)+1)]
print(afisare_timpi_servire(L))
L1 = sorted(L,key=lambda x : x[1])
print(afisare_timpi_servire(L1))
