def citire () :
    n = int(input ("n= "))
    print("Dati elementele vectorului: ")
    x = input()
    v = [int(y) for y in x.split()]
    return n, v

def afisare (v):
    for x in v:
        print (x, end = " ")
    print ("\n")

def valpoz (v):
    l = []
    for x in v:
        if x >= 0:
            l.append(x)
    return l

def semn (v):
    l = []
    for x in v:
        l.append(-x)
    return l