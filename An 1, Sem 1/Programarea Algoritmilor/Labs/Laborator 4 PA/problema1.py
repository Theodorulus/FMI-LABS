from math import sqrt

def ipotenuza (a, b):
    c = a * a + b * b
    c = sqrt (c)
    return c

b = int(input("b="))
fout = open ("triplete_pitagoreice.txt", "w")
for a in range (1, b + 1):
    c = ipotenuza(a, b)
    if c == int(c):
        fout.write(f" {a}, {b}, {int(c)}\n")
fout.close()

