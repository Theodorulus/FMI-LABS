from math import log2, pow, ceil
import random
import sys #pentru afisare in fisier

fin = open("date.in")

#dimensiunea populatiei
dim_pop = int(fin.readline())
#intervalul de definitie al functiei
a, b = [float(x) for x in fin.readline().split()]
#parametri functiei de maximizat
x3, x2, x1, x0 = [float(x) for x in fin.readline().split()]
precizie = int(fin.readline())
prob_recomb = float(fin.readline())
prob_mutatie = float(fin.readline())
nr_etape = int(fin.readline())

fin.close()

#lungimea cromozomului -> folosind formula din curs
l = ceil(log2((b - a) * pow(10, precizie)))

fout = open("Evolutie.txt", "w")

#pentru afisare in fisier
original_stdout = sys.stdout
sys.stdout = fout

def binary_search(c, intervale):
    left = 0
    right = len(intervale) - 1
    mid = (left + right) // 2
    while left <= right:
        mid = (left + right) // 2
        capat_stang, capat_drept = intervale[mid][0], intervale[mid][1]
        if c >= capat_drept: # >= pentru ca trebuie sa fie interval inchis in stanga
            left = mid + 1
        elif c < capat_stang: # < pentru ca trebuie sa fie interval deschis in dreapta
            right = mid - 1
        else:
            return mid
    return -1 # nu ar trebui sa se ajunga niciodata aici

def afisare_cromozom(cromozom, end):
    for bin in cromozom:
        print(bin, end="")
    print(end = end)

def calculare_x(cromozom):
    x = 0.0
    power = len(cromozom) - 1
    for bin in cromozom:
        x += bin * pow(2, power)
        power -= 1
    x = round(((b - a) / (pow(2, l) - 1)) * x + a, precizie)
    return x

def calculare_f(x):
    return x * x * x * x3 + x * x * x2 + x * x1 + x0

#populatia (array de array-uri binare):
pop = []
print("Populatia initiala:")
for i in range(dim_pop):
    cromozom = []
    for j in range(l):
        cromozom.append(random.randint(0, 1))
    pop.append(cromozom)

#Vom avea nr_etape
#Daca k = 0, atunci suntem la prima etapa si trebuie afisate toate detaliile cerute, altfel, vom afisa doar maximul functiei f la final
for k in range(nr_etape):
    valori_x = []
    valori_f = []
    for i in range(1, len(pop) + 1):
        if k == 0:
            if i < 10:
                print(end=" ")
            print(str(i) + ":", end=" ")
            afisare_cromozom(pop[i - 1], end = "")
        x = calculare_x(pop[i - 1])
        if k == 0:
            if x < 0:
                print(" x =", end=" ")
            else:
                print(" x = ", end=" ")
            str_format = "{:." + str(precizie) + "f}"
            print(str_format.format(x), end=" ")
        f = calculare_f(x)
        if k == 0:
            print("f =", f)
        valori_x.append(x)
        valori_f.append(f)


    #Caut individul elitist
    max_f = max(valori_f)
    indice_individ_elitist = valori_f.index(max_f)
    individ_elitist = pop[indice_individ_elitist]
    max_x = valori_x[indice_individ_elitist]

    if k == 0:
        print()
        print("Probabilitati selectie:")

    #Initializez suma totala a functiilor
    f_total = 0
    for x in valori_f:
        if x > 0:
            f_total += x
    probabilitati_selectie = []
    for i in range(1, len(pop) + 1):
        if k == 0:
            print("cromozom", end=" ")
            if i < 10:
                print(end=" ")
        if valori_f[i - 1] > 0:  #in caz ca va fi input gresit si functia nu va fi strict pozitiva
            probabilitati_selectie.append(valori_f[i - 1] / f_total)
        else:
            probabilitati_selectie.append(0);
        if k == 0:
            print(i, "probabilitate", probabilitati_selectie[i - 1])

    if k == 0:
        print()
        print("Intervale selectie:")

    s = 0.0
    intervale_selectie = []
    for x in probabilitati_selectie:
        intervale_selectie.append((s, s + x))
        if k == 0:
            print(s, end=" ")
        s += x
    if k == 0:
        print(s)

    cromozomi_selectati = []
    for i in range(dim_pop - 1):          #fara -1
        u = random.uniform(0, s)
        cromozom_selectat = binary_search(u, intervale_selectie)
        cromozomi_selectati.append(cromozom_selectat)
        if k == 0:
            print("u =", u, "selectam cromozomul", cromozom_selectat + 1)


    if k == 0:
        print()
        print("Dupa selectie:")

    for i in range(1, dim_pop):             #  + 1):
        if k == 0:
            if i < 10:
                print(end=" ")
            print(str(i) + ":", end=" ")
            afisare_cromozom(pop[cromozomi_selectati[i - 1]], end = " ")
            print("x =", end = " ")
            if valori_x[cromozomi_selectati[i - 1]] >= 0:
                print(end = " ")
            str_format = "{:." + str(precizie) + "f}"
            print(str_format.format(valori_x[cromozomi_selectati[i - 1]]), end = " ")
            print("f =", valori_f[cromozomi_selectati[i - 1]])


    if k == 0:
        print()
        print("Probabilitatea de incrucisare", prob_recomb)

    # populatia dupa selectie
    pop_dupa_selectie = []
    nr_participanti_incrucisare = 0
    for i in range(1, dim_pop):             #  + 1):
        if k == 0:
            if i < 10:
                print(end=" ")
            print(str(i) + ":", end=" ")
            afisare_cromozom(pop[cromozomi_selectati[i - 1]], end=" ")

        u = random.uniform(0, 1)
        if k == 0:
            print("u =", u, end=" ")
        # pentru fiecare element din pop_dupa_selectie vom avea un tuplu cu cromozomul selectat
        # si o valoarea booleana care indica daca acesta a fost selectat pentru crossover sau nu
        if u < prob_recomb:
            pop_dupa_selectie.append((pop[cromozomi_selectati[i - 1]], True))
            nr_participanti_incrucisare += 1
            if k == 0:
                print("<", prob_recomb, "participa")
        else:
            pop_dupa_selectie.append((pop[cromozomi_selectati[i - 1]], False))
            if k == 0:
                print()

    #in cromozomi_crossover salvam cate un tuplu pentru fiecare din cromozomii selectati pentru incrucisare format din cromozom si indicele acestuia
    cromozomi_crossover = []
    for i in range(dim_pop - 1):                #fara -1
        if pop_dupa_selectie[i][1] == True:
            cromozomi_crossover.append((pop_dupa_selectie[i][0], i + 1))

    # Daca nr_participanti_incrucisare este impar, atunci vom incrucisa cromozomul 1 cu 2, 2 cu 3, ..., nr_participanti_incrucisare cu 1
    if nr_participanti_incrucisare % 2 == 1:
        punct_rupere1 = random.randint(0, l - 1)
        punct_rupere2 = random.randint(0, l - 1)
        if punct_rupere2 < punct_rupere1:
            aux = punct_rupere2
            punct_rupere2 = punct_rupere1
            punct_rupere1 = aux
        if k == 0:
            print()
        cromozomi_dupa_recombinare = []
        for i in range(len(cromozomi_crossover) - 1):
            if k == 0:
                print("Recombinare dintre cromozomul", cromozomi_crossover[i][1], "(partea din stanga) cu cromozomul", cromozomi_crossover[i + 1][1], "(partea din dreapta):")
                afisare_cromozom(cromozomi_crossover[i][0], end=" ")
                afisare_cromozom(cromozomi_crossover[i + 1][0], end=" ")
                print("puncte", punct_rupere1, punct_rupere2)
            left1 = cromozomi_crossover[i][0][:punct_rupere1].copy()
            #mid1 = cromozomi_crossover[i][0][punct_rupere1:punct_rupere2].copy()
            right1 = cromozomi_crossover[i][0][punct_rupere2:].copy()

            #left2 = cromozomi_crossover[i + 1][0][:punct_rupere1].copy()
            mid2 = cromozomi_crossover[i + 1][0][punct_rupere1:punct_rupere2].copy()
            #right2 = cromozomi_crossover[i + 1][0][punct_rupere2:].copy()

            cromozom_dupa_combinare = left1 + mid2 + right1
            if k == 0:
                print("Rezultat", end=" ")
                afisare_cromozom(cromozom_dupa_combinare, end="")
                print()
            cromozomi_dupa_recombinare.append(cromozom_dupa_combinare)
        if k == 0:
            print("Recombinare dintre cromozomul", cromozomi_crossover[-1][1], "(partea din stanga) cu cromozomul", cromozomi_crossover[0][1],"(partea din dreapta):")
            afisare_cromozom(cromozomi_crossover[-1][0], end=" ")
            afisare_cromozom(cromozomi_crossover[0][0], end=" ")
            print("puncte", punct_rupere1, punct_rupere2)
        left = cromozomi_crossover[-1][0][:punct_rupere1].copy()
        mid = cromozomi_crossover[0][0][punct_rupere1:punct_rupere2]
        right = cromozomi_crossover[-1][0][punct_rupere2:].copy()
        cromozom_dupa_combinare = left + mid + right
        if k == 0:
            print("Rezultat", end=" ")
            afisare_cromozom(cromozom_dupa_combinare, end="")
            print()
        cromozomi_dupa_recombinare.append(cromozom_dupa_combinare)
    # Daca nr_participanti_incrucisare este par, atunci vom incrucisa 2 cate 2 astfel: 1 cu 2, 3 cu 4, ..., nr_participanti_incrucisare - 1 cu nr_participanti_incrucisare
    else:
        if k == 0:
            print()
        cromozomi_dupa_recombinare = []
        for i in range(0, len(cromozomi_crossover) - 1, 2):
            punct_rupere1 = random.randint(0, l - 1)
            punct_rupere2 = random.randint(0, l - 1)
            if punct_rupere2 < punct_rupere1:
                aux = punct_rupere2
                punct_rupere2 = punct_rupere1
                punct_rupere1 = aux
            if k == 0:
                print("Recombinare dintre cromozomul", cromozomi_crossover[i][1], "cu cromozomul", cromozomi_crossover[i + 1][1],":")
                afisare_cromozom(cromozomi_crossover[i][0], end=" ")
                afisare_cromozom(cromozomi_crossover[i + 1][0], end=" ")
                print("puncte", punct_rupere1, punct_rupere2)
            left1 = cromozomi_crossover[i][0][:punct_rupere1].copy()
            mid1 = cromozomi_crossover[i][0][punct_rupere1:punct_rupere2].copy()
            right1 = cromozomi_crossover[i][0][punct_rupere2:].copy()

            left2 = cromozomi_crossover[i + 1][0][:punct_rupere1].copy()
            mid2 = cromozomi_crossover[i + 1][0][punct_rupere1:punct_rupere2].copy()
            right2 = cromozomi_crossover[i + 1][0][punct_rupere2:].copy()
            cromozom_dupa_combinare = left1 + mid2 + right1
            if k == 0:
                print("Rezultat", end=" ")
                afisare_cromozom(cromozom_dupa_combinare, end=" ")
            cromozomi_dupa_recombinare.append(cromozom_dupa_combinare)
            #left = cromozomi_crossover[i + 1][0][:punct_rupere].copy()
            #right = cromozomi_crossover[i][0][punct_rupere:].copy()
            cromozom_dupa_combinare = left2 + mid1 + right2
            if k == 0:
                afisare_cromozom(cromozom_dupa_combinare, end="")
            cromozomi_dupa_recombinare.append(cromozom_dupa_combinare)
            if k == 0:
                print()

    if k == 0:
        print()
        print("Dupa recombinare:")
    j = 0
    pop_dupa_incrucisare = []
    for i in range(1, dim_pop):      # +1):
        if k == 0:
            if i < 10:
                print(end=" ")
            print(str(i) + ":", end=" ")
        # Daca cromozomul nu a fost selectat pentru crossover, atunci il afisam
        if pop_dupa_selectie[i - 1][1] == False:
            if k == 0:
                afisare_cromozom(pop_dupa_selectie[i - 1][0], end=" ")
            pop_dupa_incrucisare.append(pop_dupa_selectie[i - 1][0])
            x = calculare_x(pop_dupa_selectie[i - 1][0])
        # Daca cromozomul a fost selectat pentru crossover, atunci afisam unul dintre cromozomii rezultati din crossover
        else:
            if k == 0:
                afisare_cromozom(cromozomi_dupa_recombinare[j], end=" ")
            pop_dupa_incrucisare.append(cromozomi_dupa_recombinare[j])
            x = calculare_x(cromozomi_dupa_recombinare[j])
            j = j + 1

        if k == 0:
            if x < 0:
                print(" x =", end=" ")
            else:
                print(" x = ", end=" ")
            str_format = "{:." + str(precizie) + "f}"
            print(str_format.format(x), end=" ")
            print("f =", calculare_f(x))


    if k == 0:
        print()
        print("Probabilitate de mutatie pentru fiecare gena", prob_mutatie)
        print("Au fost modificati cromozomii: ")
    # Variabila ok o folosind pentru a afla daca a fost vreun individ modificat
    ok = False
    for i in range(dim_pop - 1):                   # fara -1
        u = random.uniform(0, 1)
        if u < prob_mutatie:
            p = random.randint(0, l - 1)
            pop_dupa_incrucisare[i][p] = 1 - pop_dupa_incrucisare[i][p]
            ok = True
            if k == 0:
                print(i + 1)
    if k == 0:
        # Daca nu a fost niciun individ modificat, atunci afisam un text sugestiv
        if not ok:
            print("Nicio modificare")

    if k == 0:
        print()
        print("Dupa mutatie(fara membru elitist):")
    for i in range(1, dim_pop):                    # + 1):
        if k == 0:
            if i < 10:
                print(end=" ")
            print(str(i) + ":", end=" ")
            afisare_cromozom(pop_dupa_incrucisare[i - 1], end=" ")
        x = calculare_x(pop_dupa_incrucisare[i - 1])
        if k == 0:
            if x < 0:
                print(" x =", end=" ")
            else:
                print(" x = ", end=" ")
            str_format = "{:." + str(precizie) + "f}"
            print(str_format.format(x), end=" ")
            print("f =", calculare_f(x))

    #pop_dupa_incrucisare este acum populatia dupa mutatie
    pop_dupa_incrucisare.append(individ_elitist)

    if k == 0:
        print()
        print("Dupa mutatie(cu membru elitist) -> Populatia din generatia urmatoare:")
    for i in range(1, dim_pop + 1):
        if k == 0:
            if i < 10:
                print(end=" ")
            print(str(i) + ":", end=" ")
            afisare_cromozom(pop_dupa_incrucisare[i - 1], end=" ")
        x = calculare_x(pop_dupa_incrucisare[i - 1])
        if k == 0:
            if x < 0:
                print(" x =", end=" ")
            else:
                print(" x = ", end=" ")
            str_format = "{:." + str(precizie) + "f}"
            print(str_format.format(x), end=" ")
            print("f =", calculare_f(x))

    #Salvam o copie pentru a nu avea probleme cu modul in care sunt stocate in memorie variabilele
    pop = pop_dupa_incrucisare.copy()
    if k == 0:
        print()
        print("Evolutia maximului:")

    #Afisam maximul calculat la inceput si performanta medie
    print("x=", max_x, "f =", max_f, "Performanta medie =", sum(valori_f)/len(valori_f))

sys.stdout = original_stdout
fout.close()