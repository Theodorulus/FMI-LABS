def min_max(*args):
    if len(args) == 0:
        return None
    maxi = mini = None
    for x in args:
        if not isinstance(x, int) or x < 0:
            return None
        mini = x if mini == None or x < mini else mini
        maxi = x if maxi == None or x > maxi else maxi
    return mini, maxi


try:
    fin = open ("numere.txt")
    fout = open ("impartire.txt", "w")
    L=[int(x) for x in fin.read().split()]
    nr = min_max(*L)
    if nr != None:
        print (nr)
        min = nr [0]
        max = nr [1]
        fout.write (str(max / min))
    fin.close()
    fout.close()
except FileNotFoundError as e1:
    print(e1)
except ValueError as e2:
    print(e2)
except ZeroDivisionError as e3:
    print(e3)
except Exception as e:
    print (e)


