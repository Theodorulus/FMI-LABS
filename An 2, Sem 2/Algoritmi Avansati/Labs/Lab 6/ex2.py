fin = open("input2.in")
fout = open("output2.out", "w")
number_of_inputs = int(fin.readline())


class Point:

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        return '(' + str(self.x) + ', ' + str(self.y) + ')'

    def subtract(self, p):
        return Point(self.x - p.x, self.y - p.y)


def next_index(i):
    if i < n - 1:
        return i + 1
    elif i == n - 1:
        return 0
    else:
        print("Wrong index")


while number_of_inputs > 0:
    n = int(fin.readline())
    points = []
    index_x_min = 0
    index_x_max = 0
    index_y_min = 0
    index_y_max = 0
    x_mon = True
    y_mon = True


    for i in range(n):
        L = [int(x) for x in fin.readline().split()]
        P = Point(L[0], L[1])
        if i > 0:  # am pus index-ii pentru min si max pe 0, deci pentru points[0] nu trebuie facuta verificarea
            if P.x < points[index_x_min].x:
                index_x_min = i
            if P.x > points[index_x_max].x:
                index_x_max = i
            if P.y < points[index_y_min].y:
                index_y_min = i
            if P.y > points[index_y_max].y:
                index_y_max = i

        points.append(P)

    #print(points[index_x_min])
    #print(points[index_x_max])
    #print(points[index_y_min])
    #print(points[index_y_max])

    #  testare x-monotonie:

    current_index = index_x_min

    while current_index != index_x_max and x_mon:
        if points[current_index].x >= points[next_index(current_index)].x:
            x_mon = False
        current_index = next_index(current_index)

    if x_mon:
        while current_index != index_x_min and x_mon:
            if points[current_index].x <= points[next_index(current_index)].x:
                x_mon = False
            current_index = next_index(current_index)

    #  testare y-monotonie:

    current_index = index_y_min

    while current_index != index_y_max and y_mon:
        if points[current_index].y >= points[next_index(current_index)].y:
            y_mon = False
        current_index = next_index(current_index)

    if y_mon:
        while current_index != index_y_min and y_mon:
            if points[current_index].y <= points[next_index(current_index)].y:
                y_mon = False
            current_index = next_index(current_index)

    if x_mon:
        fout.write("Poligonul este ")
    else:
        fout.write("Poligonul nu este ")
    fout.write("x-monoton.\n")

    if y_mon:
        fout.write("Poligonul este ")
    else:
        fout.write("Poligonul nu este ")
    fout.write("y-monoton.\n\n")
    number_of_inputs -= 1

fin.close()
fout.close()
