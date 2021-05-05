fin = open("input1.in")
fout = open("output1.out", "w")
n = int(fin.readline())


class Point:

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        return '(' + str(self.x) + ', ' + str(self.y) + ')'

    def subtract(self, p):
        return Point(self.x - p.x, self.y - p.y)


def cross_product(p1, p2):
    return p1.x * p2.y - p2.x * p1.y


def direction(p1, p2, p3):
    dir = cross_product(p2.subtract(p1), p3.subtract(p1))
    if dir > 0:
        return 1
    elif dir < 0:
        return -1
    else:
        return 0;


while n > 0:
    L = [int(x) for x in fin.readline().split()]
    P = Point(L[0], L[1])
    L = tuple([int(x) for x in fin.readline().split()])
    Q = Point(L[0], L[1])
    L = tuple([int(x) for x in fin.readline().split()])
    R = Point(L[0], L[1])
    dir = direction(P, Q, R)
    if dir == 1:
        fout.write("stanga\n")
    elif dir == -1:
        fout.write("dreapta\n")
    else:
        fout.write("coliniare\n")
    n -= 1

fin.close()
fout.close()