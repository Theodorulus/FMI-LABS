fin = open("input1.in")
fout = open("output1.out", "w")
number_of_inputs = int(fin.readline())

while number_of_inputs > 0:
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
                if lim < y_sup:
                    y_sup = lim
            else:
                if lim > y_inf:
                    y_inf = lim
        elif b == 0:
            lim = -c / a
            if a > 0:
                if lim < x_sup:
                    x_sup = lim
            else:
                if lim > x_inf:
                    x_inf = lim

    if x_inf > x_sup or y_inf > y_sup:
        fout.write("Intersectia este vida\n")
    else:
        fout.write("Intersectia este nevida, ")
        if x_inf == float('-inf') or y_inf == float('-inf') or x_sup == float('inf') or y_sup == float('inf'):
            fout.write("nemarginita.\n")
        else:
            fout.write("marginita.\n")
    number_of_inputs -= 1
