fraza = input ("Scrieti fraza din jurnalul Anei: ")
sum = 0
for x in fraza.split ():
    if x.isnumeric():
        sum += int (x)
print ("Suma este", sum, "RON")