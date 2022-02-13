text = input ("Textul este: ")
k = int(input ("k= "))
cript = int (input ("Criptare = 1, Decriptare = 0: "))
final = ""
if cript == 1:
    for c in text:
        if c.islower():
            cint = ord (c) - ord ("a")
            cint = (cint + k) % 26 + ord ("a")
            c = chr (cint)
        elif c.isupper():
            cint = ord(c) - ord ("A")
            cint = (cint + k) % 26 + ord ("A")
            c = chr(cint)
        final = final + c
    print (final)
else:
    for c in text:
        if c.islower():
            cint = ord (c) - ord ("a")
            cint = (cint - k) % 26 + ord ("a")
            c = chr (cint)
        elif c.isupper():
            cint = ord(c) - ord ("A")
            cint = (cint - k) % 26 + ord ("A")
            c = chr(cint)
        final = final + c
    print (final)