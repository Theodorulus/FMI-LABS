fin = open ("rime.txt")
text = fin.read()
text = text.replace(",", "")
text = text.replace("\n", " ")
d={}
for cuv in text.split():
    u2 = cuv[-2:]
    if u2 not in d.keys():
        d[u2] = [cuv]
    elif cuv not in d[u2]:
        d[u2].append(cuv)
for x in d.values():
    x.sort()
    if len(x) > 1:       #un cuvant nu poate rima cu el insusi, deci trebuie sa fie 2 cuvinte care sa rimeze intre ele.
        for cuv in x:
            print (cuv, end = " ")
        print ("\n")
