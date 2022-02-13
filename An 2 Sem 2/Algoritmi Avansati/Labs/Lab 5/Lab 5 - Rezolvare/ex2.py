fin = open("input2.in")
fout = open("output2.out", "w")
n = int(fin.readline())
points = []


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
        return 0


def next_index(i):
    if i < n - 1:
        return i + 1
    elif i == n - 1:
        return 0
    else:
        print("Wrong index")


for i in range(n):
    L = [int(x) for x in fin.readline().split()]
    P = Point(L[0], L[1])
    points.append(P)

indexPMinX = 0

for i in range(len(points)):
    p = points[i]
    pMinX = points[indexPMinX]
    if p.x < pMinX.x:
        indexPMinX = i

convex_coating = [indexPMinX, next_index(indexPMinX), next_index(next_index(indexPMinX))]

while convex_coating[-1] != indexPMinX:
    #for i in convex_coating:
    #    print(points[i])

    dir = direction(points[convex_coating[-3]], points[convex_coating[-2]], points[convex_coating[-1]])
    #print(dir)
    if dir > 0:
        convex_coating.append(next_index(convex_coating[-1]))
    else:
        while dir <= 0:
            del convex_coating[-2]
            if len(convex_coating) >= 3:
                dir = direction(points[convex_coating[-3]], points[convex_coating[-2]], points[convex_coating[-1]])
                #for i in convex_coating:
                #    print(points[i])
                #print(dir)
            else:
                break
        convex_coating.append(next_index(convex_coating[-1]))


for i in convex_coating[:-1]:
    print(points[i])
    fout.write(str(points[i]) + "\n")

print()
fin.close()
fout.close()