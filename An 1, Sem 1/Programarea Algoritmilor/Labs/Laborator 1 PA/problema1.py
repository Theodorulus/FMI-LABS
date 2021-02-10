a = int ( input ("a="))
b = int( input ("b="))
c = int( input ("c="))
d = b * b - 4 * a * c
if d < 0:
    print ("Ecuatia nu are nicio radacina.")
elif d == 0:
    x = (-b) / (2 * a)
    print ("Ecuatia are o singura radacina x=", x)
else:
    x1 = (-b + d ** 0.5 ) / (2 * a)
    x2 = (-b - d ** 0.5) / (2 * a)
    print ("Ecuatia are doua radacini x1=", x1, "si x2=", x2)
