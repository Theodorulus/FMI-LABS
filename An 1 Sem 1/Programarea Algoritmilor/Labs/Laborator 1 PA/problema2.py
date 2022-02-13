l1 = int ( input ("L1="))
l2 = int ( input("L2="))
a = l1
b = l2
while(a != b):
    if a > b:
        a -= b
    else:
        b -= a
latura = a
placi = l1*l2 // (a * a)
print ("Mesterul are nevoie de", placi, "deci placi de gresie, fiecare avand latura de ", latura, "cm")