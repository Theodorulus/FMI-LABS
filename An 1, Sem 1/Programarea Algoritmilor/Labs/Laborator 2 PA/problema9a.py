d = input ("Discutia dintre cei 2 s-a desfasurat astfel: ")
i=0
s1 = 0
s2 = 0

while d[i] != "$":
    i+=1
i+=1
while d[i].isnumeric() == True:
    s1 = s1 * 10 + int(d[i])
    i+=1

while d[i] != "$":
    i+=1
i+=1
while d[i].isnumeric() == True:
    s2 = s2 * 10 + int(d[i])
    i+=1

print (s1, s2)

