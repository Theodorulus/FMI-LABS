fin = open ("activitati.txt")
n = int (fin.readline())
L = []
for i in range(n):
    x = fin.readline().split()
    l = (int(x[0]),int(x[1]))
    L.append(l)
fin.close()
fout = open ("intarzieri.txt","w")
fout.write("Interval\tTermen\tIntarziere\n")
L.sort(key = lambda x : x[1])
t = 0
maxi = 0
for x in L:
    fout.write(f"({t}--> {t + x[0]})\t{x[1]}\t\t{max(0,t + x[0] - x[1])}\n")
    if t + x[0] - x[1] > maxi:
        maxi = t + x[0] - x[1]
    t += x[0]
fout.write("Intarzierea maxima: {}".format(maxi))
fout.close()