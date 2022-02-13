fin = open("input2.in")
fout = open("output2.out", "w")
number_of_inputs = int(fin.readline())
current_index = 1

class Point:

    def __init__(self, x, y):
        self.x = x
        self.y = y


while number_of_inputs > 0:
    P = [float(x) for x in fin.readline().split()]
    Q = Point(P[0], P[1])
    n = int(fin.readline())
    x_inf = float('-inf')
    x_sup = float('inf')
    y_inf = float('-inf')
    y_sup = float('inf')

    for i in range(n):
        L = [float(x) for x in fin.readline().split()]
        a = L[0]
        b = L[1]
        c = L[2]
        if a == 0:
            lim = -c / b
            if b > 0:
                if lim < y_sup and Q.y <= lim :
                    y_sup = lim
            else:
                if lim > y_inf and Q.y >= lim:
                    y_inf = lim
        elif b == 0:
            lim = -c / a
            if a > 0:
                if lim < x_sup and Q.x <= lim :
                    x_sup = lim
            else:
                if lim > x_inf and Q.x >= lim :
                    x_inf = lim

    fout.write("exemplul " + str(current_index) + ":\n")
    fout.write("(a) ")
    if x_inf > x_sup or y_inf > y_sup:
        fout.write("nu exista un dreptunghi cu proprietatea ceruta.\n")
    else:
        if x_inf == float('-inf') or y_inf == float('-inf') or x_sup == float('inf') or y_sup == float('inf'):
            fout.write("nu exista un dreptunghi cu proprietatea ceruta.\n")
        else:
            fout.write("exista un dreptunghi cu proprietatea ceruta.\n")

            fout.write("(b) valoarea minima a ariilor dreptunghiurilor cu proprietatea ceruta este ")
            fout.write(str((x_sup - x_inf) * (y_sup - y_inf)) + ".\n")
    fout.write("\n")


    #print(x_sup, x_inf, y_sup, y_inf)
    number_of_inputs -= 1
    current_index += 1
