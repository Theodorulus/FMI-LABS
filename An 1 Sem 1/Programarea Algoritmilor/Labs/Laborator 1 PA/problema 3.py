x = int (input("x="))
n = int (input("n="))
p = int (input("p="))
m = int (input("m="))
lung = 0
for i in range(1, m + 1):
    lung += x
    if i % n == 0:
        x = x - (p / 100) * x
print (lung)