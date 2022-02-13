from math import sqrt

fin = open("input4.in")
fout = open("output4.out", "w")

class Point:

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        return '(' + str(self.x) + ', ' + str(self.y) + ')'

    def subtract(self, p):
        return Point(self.x - p.x, self.y - p.y)


def distance(p1, p2):
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))


def findCircle(p1, p2, p3):
    x1 = p1.x
    x2 = p2.x
    x3 = p3.x
    y1 = p1.y
    y2 = p2.y
    y3 = p3.y
    x12 = x1 - x2
    x13 = x1 - x3
    y12 = y1 - y2
    y13 = y1 - y3
    y31 = y3 - y1
    y21 = y2 - y1
    x31 = x3 - x1
    x21 = x2 - x1
    sx13 = pow(x1, 2) - pow(x3, 2)
    sy13 = pow(y1, 2) - pow(y3, 2)
    sx21 = pow(x2, 2) - pow(x1, 2)
    sy21 = pow(y2, 2) - pow(y1, 2)
    f = (((sx13) * (x12) + (sy13) * (x12) + (sx21) * (x13) + (sy21) * (x13)) // (2 * ((y31) * (x12) - (y21) * (x13))))
    g = (((sx13) * (y12) + (sy13) * (y12) + (sx21) * (y13) + (sy21) * (y13)) // (2 * ((x31) * (y12) - (x21) * (y13))))
    c = (-pow(x1, 2) - pow(y1, 2) - 2 * g * x1 - 2 * f * y1)
    h = -g
    k = -f
    sqr_of_r = h * h + k * k - c
    r = round(sqrt(sqr_of_r), 5)

    return Point(h, k), r


L = [int(x) for x in fin.readline().split()]
A = Point(L[0], L[1])
L = [int(x) for x in fin.readline().split()]
B = Point(L[0], L[1])
L = [int(x) for x in fin.readline().split()]
C = Point(L[0], L[1])

number_of_inputs = int(fin.readline())

while number_of_inputs > 0:
    L = [int(x) for x in fin.readline().split()]
    D = Point(L[0], L[1])

    epsilon = 1e-5

    center, radius = findCircle(A, B, C)
    dist = distance(D, center)

    fout.write("D = " + D.__str__())
    if dist < radius - epsilon:
        fout.write(" - AC este muchie ilegala.\n")
    elif dist > radius + epsilon:
        fout.write(" - BD este muchie ilegala.\n")
    else:
        fout.write(" - Nicio muchie ilegala.\n")
    number_of_inputs -= 1

fin.close()
fout.close()

