n = int (input("n="))
copie = n
mare = 0
zero = 1
while copie > 0:
    if copie % 10 == 0:
        zero *= 10
    copie//=10
copie = n
while n > 0:
    '''
    caut cifra maxima si o elimin din numar
    '''
    cifmax = 0
    x = n
    while x > 0:
        if x % 10 > cifmax:
            cifmax = x % 10
        x //= 10
    x = n
    p = 10
    while x % 10 != cifmax:
        x//=10
        p*=10
    n = n//p * (p // 10) + n % (p//10)
    mare = mare * 10 + cifmax
mare = mare * zero
print (mare)
n = copie
mic = 0
'''
caut cea mai mica cifra diferita de 0 si o elimin din numar
'''
cifmin = 9
while n > 0:
    if n % 10 < cifmin and n % 10 != 0:
        cifmin = n % 10
    n//=10
mic = cifmin
n = copie
x = copie
while x % 10 != cifmin:
    x //= 10
    p *= 10
n = n // p * (p // 10) + n % (p // 10)
while n > 0:
    '''
    caut cifra minima si o elimin din numar
    '''
    cifmin = 9
    x = n
    while x > 0:
        if x % 10 < cifmin:
            cifmin = x % 10
        x //= 10
    x = n
    p = 10
    while x % 10 != cifmin:
        x //= 10
        p *= 10
    n = n//p * (p // 10) + n % (p//10)
    mic = mic * 10 + cifmin
print (mic)