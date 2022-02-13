from math import pi

def lungime_arie_cerc (r):
    lung = 2 * r * pi
    arie = r * r * pi
    return lung, arie

r = int(input ("r="))
print (lungime_arie_cerc(r))

