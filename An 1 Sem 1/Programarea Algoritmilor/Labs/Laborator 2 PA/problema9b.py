d = input ("Discutia dintre cei 2 s-a desfasurat astfel: ")
i = 0
a = 0
b = 0
while i < len (d):
    s = 0
    while i < len (d) and d[i] != "$":
        i+=1
    i+=1

    while i < len (d) and d[i].isnumeric() == True:
        s = s * 10 + int(d[i])
        i+=1
    if s != 0:
        a = b
        b = s
print (a, b)

if a == b:
    print ("DA")
else:
    print ("NU")


#Eu am de gând să vând vaza aceasta pentru $5. Ce plăcut, chiar mi-ar plăcea să o achiziționez, doar că am numai $3 la mine. Este suficient? Nu, insist să obțin $5 pe ea. Bine, atunci voi scoate niște bani și-ți aduc cei $5.
#Salut, am văzut în acel anunț că vindeți o mașină second-hand. M-ar interesa s-o achiziționez pentru suma de $2700. Vă amintesc că suma din anunț este de $3000, sir. Desigur. Și totuși, n-am putea ajunge la mijloc? $2850? $2750 de dolari, spuneți? E prea mult!