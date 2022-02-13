from math import sqrt
def prim (x):
    if x < 2:
        return False
    if x > 2 and x % 2 == 0:
        return False
    for i in range (3, int(sqrt(x)),2):
        if x % i ==0:
            return False
    return True


def gen():
    yield 2
    x = 3
    while True:
        if prim (x) == True:
            yield x
        x += 2


n = int(input("n="))
x = gen()
y = next(x)
while y <= n:
    print (y,end = " ")
    y = next (x)
print("\n")
x = gen()
y = next(x)
for i in range (n):
    print(y,end = " ")
    y = next(x)