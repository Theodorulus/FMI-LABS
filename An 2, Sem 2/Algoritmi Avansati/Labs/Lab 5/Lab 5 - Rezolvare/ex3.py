fin = open("input3.in")
fout = open("output3.out", "w")
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

def binary_search_inferior(point, margin):
    left = 0
    right = len(margin) - 1
    while right != next_index(left):
        mid = (left + right) // 2

        if points[margin[mid]].x < point.x:
            left = mid
        else:
            right = mid
    return margin[left]

def binary_search_superior(point, margin):
    left = 0
    right = len(margin) - 1
    while right != next_index(left):
        mid = (left + right) // 2

        if points[margin[mid]].x <= point.x:
            left = mid
        else:
            right = mid
    return margin[right]

indexPMinX = 0
indexPMaxX = 0

for i in range(n):
    L = [int(x) for x in fin.readline().split()]
    P = Point(L[0], L[1])
    points.append(P)
    if P.x < points[indexPMinX].x:
        indexPMinX = i
    if P.x > points[indexPMaxX].x:
        indexPMaxX = i

number_of_points = int(fin.readline())
while number_of_points > 0:

    L = [int(x) for x in fin.readline().split()]
    Q = Point(L[0], L[1])

    superior_margin =[]
    inferior_margin =[]

    current_index = indexPMinX
    while current_index != indexPMaxX:
        inferior_margin.append(current_index)
        current_index = next_index(current_index)
    inferior_margin.append(current_index)

    while current_index != indexPMinX:
        superior_margin.append(current_index)
        current_index = next_index(current_index)
    superior_margin.append(current_index)
    superior_margin.reverse()

    index_inf = binary_search_inferior(Q, inferior_margin)
    index_sup = binary_search_superior(Q, superior_margin)

    dir_inf = direction(points[index_inf], points[next_index(index_inf)], Q)
    dir_sup = direction(points[index_sup], points[next_index(index_sup)], Q)

    if dir_inf > 0 and dir_sup > 0:
        fout.write("inside\n")
    elif dir_inf == 0 or dir_sup ==0:
        fout.write("on edge\n")
    else:
        fout.write("outside\n")

    number_of_points -= 1

fin.close()
fout.close()