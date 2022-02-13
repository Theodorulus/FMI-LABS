n = int(input("n="))
x = float(input())
maxi = 0
i1 = 0
i2 = 0
for i in range(2, n + 1):
    y = float(input())
    if y - x > maxi:
        maxi = y-x
        i1 = i-1
        i2 = i
    x = y
if maxi == 0:
    print ("Nu s-a produs nicio crestere in cele" , n , "zile")
else:
    print ("Cea mai mare crestere a fost de" , maxi , "RON,intre zilele" , i1 , "si" , i2)