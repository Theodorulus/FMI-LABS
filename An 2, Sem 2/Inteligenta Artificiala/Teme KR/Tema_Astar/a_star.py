import copy
import sys
import time
import os

# 1BAREM
folderInput = sys.argv[1]
folderOutput = sys.argv[2]
nrSolutiiCautate = int(sys.argv[3])
timpTimeout = time.time() + int(sys.argv[4])  # (timpul de timeout se da in linia de comanda in secunde)


class NodParcurgere:
    def __init__(self, info, parinte, mutare_precedenta, cost=0, h=0):
        self.info = info
        self.parinte = parinte
        self.mutare_precedenta = mutare_precedenta # un tuplu cu piesa mutata pe prima pozitie si directia in care a fost mutata pe a doua pozitie
        self.g = cost
        self.h = h
        self.f = self.g + self.h

    def obtineDrum(self):
        l = [self]
        nod = self
        while nod.parinte is not None:
            l.insert(0, nod.parinte)
            nod = nod.parinte
        return l

    # 8BAREM
    def afisDrum(self, afisCost=False, afisLung=False):
        l = self.obtineDrum()
        for index, nod in enumerate(l):
            print(str(index + 1) + ")")
            print(str(nod))
        if afisCost:
            print("Cost: ", self.g)
        if afisLung:
            print("Lungime: ", len(l))
        return len(l)

    def contineInDrum(self, infoNodNou):
        nodDrum = self
        while nodDrum is not None:
            if (infoNodNou == nodDrum.info):
                return True
            nodDrum = nodDrum.parinte

        return False

    def __repr__(self):
        sir = ""
        sir += str(self.info)
        return (sir)

    def __str__(self):
        if self.mutare_precedenta == None:
            sir = ""
        # 9BAREM
        else:
            sir = "Mutam " + self.mutare_precedenta[0] + " in " + self.mutare_precedenta[1] + ".\n"
        for linie in self.info:
            sir += "".join([str(elem) for elem in linie]) + "\n"
        return sir


class Graph:

    def __init__(self, nume_fisier="input1.in"):
        # 2BAREM
        self.start = read_matrix(nume_fisier)
        self.costuri = find_costuri(self.start)
        self.potAplicaAlgoritmi = True
        # 10BAREM -> verificare corectitudine date intrare
        if not check_border(self.start):
            print("Input-ul este gresit!")
            self.potAplicaAlgoritmi = False
        if not check_pieces(self.start, self.costuri):
            print("Input-ul este gresit!")
            self.potAplicaAlgoritmi = False
        # 10BAREM -> gasirea unui mod de a realiza din starea initiala ca problema nu are solutii
        listaPiese = []
        for L in self.start:
            listaPiese.extend(L)
        if "*" in listaPiese:
            if not piesa_speciala_incape(self.start):
                print("Nu exista solutii pentru input-ul dat.")
                self.potAplicaAlgoritmi = False
        self.costuri.update({"*": 1})

    # 5BAREM
    def testeaza_scop(self, nodCurent):
        listaPiese = []
        for L in nodCurent.info:
            listaPiese.extend(L)
        return not("*" in listaPiese)

    # 3BAREM
    def genereazaSuccesori(self, nodCurent, tip_euristica="euristica banala"):
        M = nodCurent.info
        listaPiese = find_pieces(M)
        listaSuccesori = []
        for piesa in listaPiese:
            sus = muta_piesa(M, listaPiese, piesa, "sus")
            jos = muta_piesa(M, listaPiese, piesa, "jos")
            stanga = muta_piesa(M, listaPiese, piesa, "stanga")
            dreapta = muta_piesa(M, listaPiese, piesa, "dreapta")
                                                                      # 9BAREM                    # 4BAREM
            if sus != None and not nodCurent.contineInDrum(sus):
                listaSuccesori.append(NodParcurgere(sus, nodCurent, (piesa, "sus"), nodCurent.g + self.costuri[piesa], self.calculeaza_h(sus, tip_euristica)))
            if jos != None and not nodCurent.contineInDrum(jos):
                listaSuccesori.append(NodParcurgere(jos, nodCurent, (piesa, "jos"), nodCurent.g + self.costuri[piesa], self.calculeaza_h(jos, tip_euristica)))
            if stanga != None and not nodCurent.contineInDrum(stanga):
                listaSuccesori.append(NodParcurgere(stanga, nodCurent, (piesa, "stanga"), nodCurent.g + self.costuri[piesa], self.calculeaza_h(stanga, tip_euristica)))
            if dreapta != None and not nodCurent.contineInDrum(dreapta):
                listaSuccesori.append(NodParcurgere(dreapta, nodCurent, (piesa, "dreapta"), nodCurent.g + self.costuri[piesa], self.calculeaza_h(dreapta, tip_euristica)))
        return listaSuccesori

    def calculeaza_h(self, infoNod, tip_euristica="euristica banala"):
        listaPiese = []
        for L in infoNod:
            listaPiese.extend(L)
        if not ("*" in listaPiese):
            return 0
        # 6BAREM
        if tip_euristica == "euristica banala":
            return 1
        elif tip_euristica == "euristica admisibila 1":
            return distanta_piesa_speciala_exit(infoNod)

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return sir


def a_star(gr, nrSolutiiCautate=1, tip_euristica="euristica banala"):
    t1 = time.time()
    c = [NodParcurgere(gr.start, None, None, 0, gr.calculeaza_h(gr.start))]
    noduriMaxime = 1
    noduriTotal = 1
    while len(c) > 0:
        if time.time() > timpTimeout:
            sys.exit(1)
        if len(c) > noduriMaxime:
            noduriMaxime = len(c)
        nodCurent = c.pop(0)

        # 8BAREM
        if gr.testeaza_scop(nodCurent):
            print("Solutie: ")
            nodCurent.afisDrum(afisCost=True, afisLung=True)
            t2 = time.time()
            milis = round(1000*(t2-t1))
            print("Solutie gasita in " + str(milis) + " milisecunde")
            print("Nr. maxim de noduri existente la un moment dat in memorie: " + str(noduriMaxime))
            print("Nr. total de noduri calculate: " + str(noduriTotal))
            print("\n----------------\n")
            #input()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent, tip_euristica)
        noduriTotal += len(lSuccesori)
        for s in lSuccesori:
            i = 0
            gasit_loc = False
            for i in range(len(c)):
                if c[i].f >= s.f:
                    gasit_loc = True
                    break
            if gasit_loc:
                c.insert(i, s)
            else:
                c.append(s)


def a_star_optimizat(gr, nrSolutiiCautate=1, tip_euristica="euristica banala"):
    t1 = time.time()
    l_open = [NodParcurgere(gr.start, None, None, 0, gr.calculeaza_h(gr.start))]
    l_closed = []
    noduriMaxime = 1
    noduriTotal = 1
    while len(l_open) > 0:
        if time.time() > timpTimeout:
            sys.exit(1)
        if len(l_open) > noduriMaxime:
            noduriMaxime = len(l_open)
        #print("Coada actuala: " + str(l_open))
        #input()
        nodCurent = l_open.pop(0)
        l_closed.append(nodCurent)
        if gr.testeaza_scop(nodCurent):
            print("Solutie: ")
            nodCurent.afisDrum(afisCost=True, afisLung=True)
            t2 = time.time()
            milis = round(1000 * (t2 - t1))
            print("Solutie gasita in " + str(milis) + " milisecunde")
            print("Nr. maxim de noduri existente la un moment dat in memorie: " + str(noduriMaxime))
            print("Nr. total de noduri calculate: " + str(noduriTotal))
            print("\n----------------\n")
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent, tip_euristica)
        noduriTotal += len(lSuccesori)
        for s in lSuccesori:
            gasitC = False
            for nodC in l_open:
                if s.info == nodC.info:
                    gasitC = True
                    if s.f >= nodC.f:
                        lSuccesori.remove(s)
                    else:
                        l_open.remove(nodC)
                    break
            if not gasitC:
                for nodC in l_closed:
                    if s.info == nodC.info:
                        if s.f >= nodC.f:
                            lSuccesori.remove(s)
                        else:
                            l_closed.remove(nodC)
                        break
        for s in lSuccesori:
            i = 0
            gasit_loc = False
            for i in range(len(l_open)):
                if l_open[i].f > s.f or (l_open[i].f == s.f and l_open[i].g <= s.g):
                    gasit_loc = True
                    break
            if gasit_loc:
                l_open.insert(i, s)
            else:
                l_open.append(s)


def uniform_cost(gr, nrSolutiiCautate=1, tip_euristica="euristica banala"):
    t1 = time.time()
    c = [NodParcurgere(gr.start, None, None, 0, gr.calculeaza_h(gr.start))]
    noduriMaxime = 1
    noduriTotal = 1
    while len(c) > 0:
        if time.time() > timpTimeout:
            sys.exit(1)
        #print("Coada actuala: " + str(c))
        #input()
        if len(c) > noduriMaxime:
            noduriMaxime = len(c)
        nodCurent = c.pop(0)

        if gr.testeaza_scop(nodCurent):
            print("Solutie: ")
            nodCurent.afisDrum(afisCost=True, afisLung=True)
            t2 = time.time()
            milis = round(1000 * (t2 - t1))
            print("Solutie gasita in " + str(milis) + " milisecunde")
            print("Nr. maxim de noduri existente la un moment dat in memorie: " + str(noduriMaxime))
            print("Nr. total de noduri calculate: " + str(noduriTotal))
            print("\n----------------\n")
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return
        lSuccesori = gr.genereazaSuccesori(nodCurent, tip_euristica)
        noduriTotal += len(lSuccesori)
        for s in lSuccesori:
            i = 0
            gasit_loc = False
            for i in range(len(c)):
                if c[i].g > s.g:
                    gasit_loc = True
                    break
            if gasit_loc:
                c.insert(i, s)
            else:
                c.append(s)


def ida_star(gr, nrSolutiiCautate=1, tip_euristica="euristica banala"):
    t1 = time.time()
    nodStart = NodParcurgere(gr.start, None, None, 0, gr.calculeaza_h(gr.start))
    limita = nodStart.f
    while True:
        if time.time() > timpTimeout:
            sys.exit(1)
        #print("Limita de pornire: ", limita)
        nrSolutiiCautate, rez = construieste_drum(gr, nodStart, limita, nrSolutiiCautate, t1, tip_euristica)
        if rez == "gata":
            break
        if rez == float('inf'):
            print("Nu exista solutii!")
            break
        limita = rez
        #print(">>> Limita noua: ", limita)
        #input()


def construieste_drum(gr, nodCurent, limita, nrSolutiiCautate, t1, tip_euristica="euristica banala"):
    #print("A ajuns la: ", nodCurent)
    if nodCurent.f>limita:
        return nrSolutiiCautate, nodCurent.f
    if gr.testeaza_scop(nodCurent) and nodCurent.f==limita :
        print("Solutie: ")
        nodCurent.afisDrum(afisCost=True, afisLung=True)
        t2 = time.time()
        milis = round(1000 * (t2 - t1))
        print("Solutie gasita in " + str(milis) + " milisecunde")
        #print(limita)
        print("\n----------------\n")
        #input()
        nrSolutiiCautate-=1
        if nrSolutiiCautate==0:
            return 0,"gata"
    lSuccesori=gr.genereazaSuccesori(nodCurent, tip_euristica)
    minim=float('inf')
    for s in lSuccesori:
        nrSolutiiCautate, rez=construieste_drum(gr, s, limita, nrSolutiiCautate, t1)
        if rez=="gata":
            return 0,"gata"
        #print("Compara ", rez, " cu ", minim)
        if rez<minim:
            minim=rez
            #print("Noul minim: ", minim)
        return nrSolutiiCautate, minim


# 11BAREM \/

# 2BAREM + 10BAREM
# functia de citire a matricei
def read_matrix(file="input1.in"):
    fin = open(file)
    rows = fin.read().split("\n")
    M = []
    for row in rows:
        L = []
        for c in row:
            L.append(c)
        M.append(L)
    return M


# functia de afisare a matricei
def print_matrix(M):
    for row in M:
        for c in row:
            print(c, end="")
        print()

# 10BAREM
# functie care verifica daca marginile nodului de start sunt conform cu restrictiile date
def check_border(M):
    n = len(M)
    m = len(M[0])
    number_of_exits = 0
    where_is_the_exit = ""
    #top
    for x in M[0]:
        if x != "#":
            number_of_exits += 1
            where_is_the_exit = "top"
            break

    #left
    for i in range(n):
        x = M[i][0]
        if x != "#":
            number_of_exits += 1
            where_is_the_exit = "left"
            break

    # right
    for i in range(n):
        x = M[i][m - 1]
        if x != "#":
            number_of_exits += 1
            where_is_the_exit = "right"
            break

    #bottom
    for x in M[n - 1]:
        if x != "#":
            number_of_exits += 1
            where_is_the_exit = "bottom"
            break
    if number_of_exits != 1:
        return False

    if where_is_the_exit == "top":
        number_of_gates = 0
        for i in range(m):
            if i != 0:
                if M[0][i] != "#" and M[0][i - 1] == "#":
                    number_of_gates += 1
            elif M[0][i] != "#":
                number_of_gates += 1
        if number_of_gates != 1:
            return False

    elif where_is_the_exit == "bottom":
        number_of_gates = 0
        for i in range(m):
            if i != 0:
                if M[n - 1][i] != "#" and M[n - 1][i - 1] == "#":
                    number_of_gates += 1
            elif M[n - 1][i] != "#":
                number_of_gates += 1
        if number_of_gates != 1:
            return False
    elif where_is_the_exit == "left":
        number_of_gates = 0
        for i in range(n):
            if i != 0:
                if M[i][0] != "#" and M[i - 1][0] == "#":
                    number_of_gates += 1
            elif M[i][0] != "#":
                number_of_gates += 1
        if number_of_gates != 1:
            return False
    elif where_is_the_exit == "right":
        number_of_gates = 0
        for i in range(n):
            if i != 0:
                if M[i][m - 1] != "#" and M[i - 1][m - 1] == "#":
                    number_of_gates += 1
            elif M[i][m - 1] != "#":
                number_of_gates += 1
        if number_of_gates != 1:
            return False
    return True

# 4BAREM
# functie care gaseste costul mutarii fiecarei piese de pe tabla si returneaza un dictionar avand cheile simbolurile pieselor de pe tabla si valorile costul mutarii piesei respective
def find_costuri(M):
    d = {}
    for L in M:
        for x in L:
            if x != "#" and x != ".":
                if x in d.keys():
                    d.update({x: d[x] + 1})
                else:
                    d.update({x: 1})
    return d


# functie care verifica daca langa un simbol al unei piese se mai afla alt simbol al aceleiasi piese si returneaza un boolean
def check_one_piece(M, i, j):
    if i > 0 and M[i - 1][j] == M[i][j]:
        return True
    if i < len(M) - 1 and M[i + 1][j] == M[i][j]:
        return True
    if j > 0 and M[i][j - 1] == M[i][j]:
        return True
    if j < len(M[i]) - 1 and M[i][j + 1] == M[i][j]:
        return True
    return False

# 10BAREM
# functie care verifica daca piesele de pe tabla sunt conform cu restrictiile date(sa nu aiba "gauri" in ele) si returneaza un boolean
def check_pieces(M, costuri):
    for i in range(len(M)):
        for j in range(len(M[i])):
            if M[i][j] != "#" and M[i][j] != "." and costuri[M[i][j]] > 1:
                if not check_one_piece(M, i, j):
                    return False
    return True


# functie care returneaza marimea iesirii de pe tabla si pozitia acestei iesiri (sus/jos/stanga/dreapta)
def exit_size(M):
    n = len(M)
    m = len(M[0])
    size = 0
    where_is_the_exit = ""
    #NU vom lua in considerare colturile matricei

    # top
    for x in M[0][1:-1]:
        if x != "#":
            where_is_the_exit = "sus"
            size += 1

    # left
    for i in range(1, n - 1):
        x = M[i][0]
        if x != "#":
            where_is_the_exit = "stanga"
            size += 1

    # right
    for i in range(1, n - 1):
        x = M[i][m - 1]
        if x != "#":
            where_is_the_exit = "dreapta"
            size += 1

    # bottom
    for x in M[n - 1][1:-1]:
        if x != "#":
            where_is_the_exit = "jos"
            size += 1

    return size, where_is_the_exit


# functie care returneaza lungimea si latimea piesei speciale (*)
def piesa_speciala_size(M):

    listaIndici = find_pieces(M)["*"]
    min_i = float("+inf")
    min_j = float("+inf")
    max_i = 0
    max_j = 0
    for indici in listaIndici:
        if min_i > indici[0]:
            min_i = indici[0]

        if min_j > indici[1]:
            min_j = indici[1]

        if max_i < indici[0]:
            max_i = indici[0]

        if max_j < indici[1]:
            max_j = indici[1]

    return max_i - min_i + 1, max_j - min_j + 1

# 10BAREM
# functie care verifica daca piesa speciala are marimea suficient de mica incat sa iasa pe iesirea data si returneaza un boolean
def piesa_speciala_incape(M):
    exitSize, whereIsTheExit = exit_size(M)
    if whereIsTheExit == "sus" or whereIsTheExit == "jos":
        if exitSize < piesa_speciala_size(M)[1]:
            return False
    if whereIsTheExit == "stanga" or whereIsTheExit == "dreapta":
        if exitSize < piesa_speciala_size(M)[0]:
            return False
    return True


# functie care returneaza un dictionar avand cheile simbolurile pieselor de pe tabla si valorile liste continand liste de doua elemente care reprezinta indexii unde se afla piesa respectiva
def find_pieces(M):
    d = {}
    for i in range(len(M)):
        L = M[i]
        for j in range(len(L)):
            x = L[j]
            if x != "#" and x != ".":
                if x in d.keys():
                    d[x].append([i, j])
                else:
                    d.update({x: [[i, j]]})
    return d


# 3BAREM
# functie care incearca sa mute o piesa intr-o anumita directie. Daca reuseste, se va returna noua stare. Daca nu reuseste, se va returna None
def muta_piesa(M, listaPiese, piesa, directie):
    if directie == "sus":
        ok = True
        for indici in listaPiese[piesa]:
            if piesa != "*":
                if indici[0] == 0 or M[indici[0] - 1][indici[1]] not in [piesa, "."]:
                    ok = False
                    break
            else:
                if indici[0] != 0 and M[indici[0] - 1][indici[1]] not in [piesa, "."]:
                    ok = False
        if ok:
            copieMatrice = copy.deepcopy(M)
            for indici in listaPiese[piesa]:
                if indici[0] != 0:
                    copieMatrice[indici[0] - 1][indici[1]] = piesa
                copieMatrice[indici[0]][indici[1]] = "."
            return copieMatrice

    if directie == "jos":
        ok = True
        for indici in listaPiese[piesa]:
            if piesa != "*":
                if indici[0] == len(M) - 1 or M[indici[0] + 1][indici[1]] not in [piesa, "."]:
                    ok = False
            else:
                if indici[0] != len(M) - 1 and M[indici[0] + 1][indici[1]] not in [piesa, "."]:
                    ok = False
        if ok:
            copieMatrice = copy.deepcopy(M)
            for indici in reversed(listaPiese[piesa]):
                if indici[0] != len(M) - 1:
                    copieMatrice[indici[0] + 1][indici[1]] = piesa
                copieMatrice[indici[0]][indici[1]] = "."
            return copieMatrice

    if directie == "stanga":
        ok = True
        for indici in listaPiese[piesa]:
            if piesa != "*":
                if indici[1] == 0 or M[indici[0]][indici[1] - 1] not in [piesa, "."]:
                    ok = False
            else:
                if indici[1] != 0 and M[indici[0]][indici[1] - 1] not in [piesa, "."]:
                    ok = False

        if ok:
            copieMatrice = copy.deepcopy(M)
            for indici in listaPiese[piesa]:
                if indici[1] != 0:
                    copieMatrice[indici[0]][indici[1] - 1] = piesa
                copieMatrice[indici[0]][indici[1]] = "."
            return copieMatrice

    if directie == "dreapta":
        ok = True
        for indici in listaPiese[piesa]:
            if piesa != "*":
                if indici[1] == len(M[0]) - 1 or M[indici[0]][indici[1] + 1] not in [piesa, "."]:
                    ok = False
            else:
                if indici[1] != len(M[0]) - 1 and M[indici[0]][indici[1] + 1] not in [piesa, "."]:
                    ok = False
        if ok:
            copieMatrice = copy.deepcopy(M)
            for indici in reversed(listaPiese[piesa]):
                if indici[1] != len(M[0]) - 1:
                    copieMatrice[indici[0]][indici[1] + 1] = piesa
                copieMatrice[indici[0]][indici[1]] = "."
            return copieMatrice


# 6BAREM
# functie care returneaza distanta de la cea mai indepartata extrema a piesei speciale pana la iesire
def distanta_piesa_speciala_exit(M):
    listaIndiciPiesaSpeciala = find_pieces(M)["*"]
    size, exit = exit_size(M)
    if exit == "sus":
        return listaIndiciPiesaSpeciala[-1][0] + 1  # cea mai de jos piesa
    if exit == "jos":
        return len(M) - listaIndiciPiesaSpeciala[0][0]
    if exit == "stanga":
        maxi = 0
        for indici in listaIndiciPiesaSpeciala:
            if indici[1] > maxi:
                maxi = indici[1]
        return maxi + 1
    if exit == "dreapta":
        mini = float("inf")
        for indici in listaIndiciPiesaSpeciala:
            if indici[1] < mini:
                mini = indici[1]
        return len(M[0]) - mini


#MAIN:

try:
    # 1BAREM
    listaFisiereInput = os.listdir(folderInput)
except FileNotFoundError:
    print("Folder pentru fisierele de input gresit!")
    sys.exit()

if not os.path.exists(folderOutput):
    os.mkdir(folderOutput)

#gr = Graph(folderInput + "/input1.in")

original_stdout = sys.stdout

# 1BAREM
for fisier in listaFisiereInput:
    fout = open(folderOutput + "/" + fisier.replace("in", "out"), "w")
    sys.stdout = fout
    # 1BAREM
    gr = Graph(folderInput + "/" + fisier)
    if gr.potAplicaAlgoritmi:
        print("IDA* \n")
        ida_star(gr, nrSolutiiCautate, "euristica admisibila 1")
        if fisier != "input4.in":
            print("A* \n")
            a_star(gr, nrSolutiiCautate, "euristica admisibila 1")
            print("A* optimizat \n")
            a_star_optimizat(gr, nrSolutiiCautate, "euristica admisibila 1")
            print("UCS \n")
            uniform_cost(gr, nrSolutiiCautate, "euristica admisibila 1")


original_stdout = sys.stdout

