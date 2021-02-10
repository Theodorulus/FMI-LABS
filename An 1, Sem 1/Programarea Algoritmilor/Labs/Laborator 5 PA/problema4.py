fin = open ("bani.txt")
banc = [int(x) for x in fin.readline().split()]
sum = int(fin.readline())
banc.sort(reverse = True)
fin.close()
fout = open ("plata.txt", "w")
fout.write (f"{sum} = ")
curr = 0
while sum > 0:
    i = 0
    while sum >= banc[curr]:
        i += 1
        sum -= banc[curr]
    if i > 0 and sum > 0:
        fout.write(f"{banc[curr]}*{i} + ")
    elif i > 0:
        fout.write(f"{banc[curr]}*{i}")
    curr += 1
fout.close()

