n = int (input ("n="))
x = int (input())
y = int (input())
i=2
while y == x and i<n:
    y = int(input())
    i+=1
if x == y:
    print("Imposibil")
else:
    max1, max2 = max(x, y), min(x, y)
    for j in range (i,n):
        x = int (input())
        if x > max1:
            max2 = max1
            max1 = x
        elif x > max2 and x != max1:
            max2 = x
    print (max2, max1)
