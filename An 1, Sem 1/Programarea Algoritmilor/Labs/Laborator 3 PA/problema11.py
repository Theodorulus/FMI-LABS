fin = open ("dictionar.txt")
p = fin.read()
list = []
for lin in p.split ("\n"):
    nr = 0
    cuv = lin.split (":")[0]
    lin = lin.replace ("-", "")
    lin = lin.replace(",", "")
    lin = lin.replace("=", "")
    lin = lin.replace("(", "")
    lin = lin.replace(")", "")
    lin = lin.replace(".", "")
    lin = lin.replace("/", "")
    for x in lin.split(":"):
        for y in x.split():
            if y == cuv or y == "~":
                nr += 1
    list.append((cuv, nr-1))

print (list)