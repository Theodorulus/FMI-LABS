sir1 = input ("Primul cuvant: ")
sir2 = input ("Al doilea cuvant: ")
if len (sir1) != len (sir2):
    print ("Cuvintele nu sunt anagrame.")
else:
    ok=1
    for i in sir1:
        if i in sir2:
            sir2 = sir2.replace (i, "", 1)
        else:
            ok=0
            break
    if ok == 1 and sir2 == "":
        print ("Cuvintele sunt anagrame.")
    else:
        print ("Cuvintele nu sunt anagrame.")