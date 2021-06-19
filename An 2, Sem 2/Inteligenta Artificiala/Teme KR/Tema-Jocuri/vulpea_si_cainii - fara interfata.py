#import pygame
import sys
import copy
import time

ADANCIME_MAX = 5



class Game:
    COLUMNS = 8
    JMIN = None
    JMAX = None
    EMPTY_SPACE = "_"
    FORBIDDEN_SPACE = "#"
    FOX_SIMBOL = "v"
    HOUND_SIMBOL = "c"


    def __init__(self, table = None):  # Joc()
        if table == None:
            self.matr = initial_state()
        else:
            self.matr = table

    @classmethod
    def jucator_opus(cls, jucator):
        return cls.JMAX if jucator == cls.JMIN else cls.JMIN

    def final(self):
        if self.FOX_SIMBOL in self.matr[0]:
            return self.FOX_SIMBOL
        if fox_cannot_move(self.matr):
            return self.HOUND_SIMBOL
        return False

    def moves(self, jucator):
        l_moves = []
        if jucator == self.FOX_SIMBOL:
            fox_line, fox_col = find_fox(self.matr)
            plus_minus_one = [1, -1]
            for line in plus_minus_one:
                for col in plus_minus_one:
                    matr_copy = move(self.matr, fox_line, fox_col, fox_line + line, fox_col + col)
                    if matr_copy != self.matr:
                        l_moves.append(Game(matr_copy))
        elif jucator == self.HOUND_SIMBOL:
            plus_minus_one = [1, -1]
            for (hound_line, hound_col) in find_hounds(self.matr):
                for line in plus_minus_one:
                    for col in plus_minus_one:
                        matr_copy = move(self.matr, hound_line, hound_col, hound_line + line, hound_col + col)
                        if matr_copy != self.matr:
                            l_moves.append(Game(matr_copy))
        return l_moves

    def fox_rating1(self):
        fox_line, fox_col = find_fox(self.matr)
        hound_line, hound_col = find_hounds(self.matr)[0]
        return hound_line - fox_line

    def fox_rating2(self):
        fox_line, fox_col = find_fox(self.matr)
        s = 0
        for (hound_line, hound_col) in find_hounds(self.matr):
            if hound_line > fox_line:
                s = s + hound_line - fox_line
        return s

    def hound_rating1(self):
        fox_line, fox_col = find_fox(self.matr)
        s = 0
        for (hound_line, hound_col) in find_hounds(self.matr):
            s = s + distance(fox_line, fox_col, hound_line, hound_col)
        return -s

    def hound_rating2(self):
        fox_line, fox_col = find_fox(self.matr)
        s = 0
        for (hound_line, hound_col) in find_hounds(self.matr):
            s = s + distance(fox_line, fox_col, hound_line, hound_col)
        return -s - number_of_directions_fox_can_go(self.matr)

    def estimeaza_scor(self, adancime):
        t_final = self.final()
        if t_final == self.__class__.JMAX:
            return (99 + adancime)
        elif t_final == self.__class__.JMIN:
            return (-99 - adancime)
        else:
            if self.JMAX == self.FOX_SIMBOL:
                return self.fox_rating2() - self.hound_rating2()
                #return self.fox_rating1() - self.hound_rating1()
            else:
                return self.hound_rating2() - self.fox_rating2()
                #return self.hound_rating1() - self.fox_rating1()

    def __str__(self):
        return print_matrix(self.matr)

    def __repr__(self):
        return print_matrix(self.matr)


class Stare:

    def __init__(self, tabla_joc, j_curent, adancime, parinte=None, estimare=None):
        self.tabla_joc = tabla_joc
        self.j_curent = j_curent

        # adancimea in arborele de stari
        self.adancime = adancime

        # estimarea favorabilitatii starii (daca e finala) sau al celei mai bune stari-fiice (pentru jucatorul curent)
        self.estimare = estimare

        # lista de mutari posibile (tot de tip Stare) din starea curenta
        self.mutari_posibile = []

        # cea mai buna mutare din lista de mutari posibile pentru jucatorul curent
        # e de tip Stare (cel mai bun succesor)
        self.stare_aleasa = None

    def mutari(self):
        l_mutari = self.tabla_joc.moves(self.j_curent)  # lista de informatii din nodurile succesoare
        juc_opus = Game.jucator_opus(self.j_curent)

        # mai jos calculam lista de noduri-fii (succesori)
        l_stari_mutari = [Stare(mutare, juc_opus, self.adancime - 1, parinte=self) for mutare in l_mutari]

        return l_stari_mutari

    def __str__(self):
        sir = str(self.tabla_joc) + "(Juc curent:" + self.j_curent + ")\n"
        return sir


# functie care returneaza starea initiala a tablei de joc
def initial_state():
    matrix = [[Game.EMPTY_SPACE for i in range(Game.COLUMNS)] for j in range(Game.COLUMNS)]
    for line in range(Game.COLUMNS):
        for col in range(Game.COLUMNS):
            if (line + col) % 2 == 0:
                matrix[line][col] = Game.FORBIDDEN_SPACE
            else:
                matrix[line][col] = Game.EMPTY_SPACE
    matrix[Game.COLUMNS - 1][0] = Game.FOX_SIMBOL
    for i in range(1, Game.COLUMNS, 2):
        matrix[0][i] = Game.HOUND_SIMBOL
    return matrix

# functie care returneaza un sir cu matricea afisata elegant
def print_matrix(matrix):
    sir = "   "
    for i in range(len(matrix)):
        sir = sir + str(i) + " "
    sir = sir + "\n"
    for i in range(len(matrix)):
        sir = sir + str(i) + ": "
        line = matrix[i]
        for x in line:
            sir = sir + x + " "
        sir = sir + "\n"
    sir = sir + "\n"
    return sir


# functie care returneaza matricea dupa ce s-a efectuat o mutare, daca aceasta mutare este legala
def move(matrix, line, col, new_line, new_col):
    new_matrix = copy.deepcopy(matrix)
    if matrix[line][col] != Game.FOX_SIMBOL and matrix[line][col] != Game.HOUND_SIMBOL:
        return new_matrix

    if new_line not in range(Game.COLUMNS) or new_col not in range(Game.COLUMNS):
        return new_matrix

    if matrix[new_line][new_col] != Game.EMPTY_SPACE:
        return new_matrix

    if matrix[line][col] == Game.FOX_SIMBOL:
        if new_line == line + 1:
            if new_col == col + 1:
                new_matrix[line][col] = Game.EMPTY_SPACE
                new_matrix[new_line][new_col] = Game.FOX_SIMBOL
            if new_col == col - 1:
                new_matrix[line][col] = Game.EMPTY_SPACE
                new_matrix[new_line][new_col] = Game.FOX_SIMBOL
        if new_line == line - 1:
            if new_col == col + 1:
                new_matrix[line][col] = Game.EMPTY_SPACE
                new_matrix[new_line][new_col] = Game.FOX_SIMBOL
            if new_col == col - 1:
                new_matrix[line][col] = Game.EMPTY_SPACE
                new_matrix[new_line][new_col] = Game.FOX_SIMBOL

    if matrix[line][col] == Game.HOUND_SIMBOL:

        if new_line == line + 1:
            if new_col == col + 1:
                new_matrix[line][col] = Game.EMPTY_SPACE
                new_matrix[new_line][new_col] = Game.HOUND_SIMBOL
            if new_col == col - 1:
                new_matrix[line][col] = Game.EMPTY_SPACE
                new_matrix[new_line][new_col] = Game.HOUND_SIMBOL
    return new_matrix


# functie care verifica daca vulpea nu se poate muta din pozitia actuala si returneaza un boolean
def fox_cannot_move(matrix):
    fox_line, fox_col = find_fox(matrix)
    # try to move down
    if fox_line + 1 < Game.COLUMNS:
        # left
        if fox_col - 1 >= 0:
            if matrix[fox_line + 1][fox_col - 1] == Game.EMPTY_SPACE:
                return False
        # right
        if fox_col + 1 < Game.COLUMNS:
            if matrix[fox_line + 1][fox_col + 1] == Game.EMPTY_SPACE:
                return False

    # try to move up
    if fox_line - 1 > 0:
        # left
        if fox_col - 1 >= 0:
            if matrix[fox_line - 1][fox_col - 1] == Game.EMPTY_SPACE:
                return False
        # right
        if fox_col + 1 < Game.COLUMNS:
            if matrix[fox_line - 1][fox_col + 1] == Game.EMPTY_SPACE:
                return False
    return True


# functie care returneaza numarul de directii in care vulpea se poate muta
def number_of_directions_fox_can_go(matrix):
    fox_line, fox_col = find_fox(matrix)
    s = 0
    # try to move down
    if fox_line + 1 < Game.COLUMNS:
        # left
        if fox_col - 1 >= 0:
            if matrix[fox_line + 1][fox_col - 1] == Game.EMPTY_SPACE:
                s = s + 1
        # right
        if fox_col + 1 < Game.COLUMNS:
            if matrix[fox_line + 1][fox_col + 1] == Game.EMPTY_SPACE:
                s = s + 1

    # try to move up
    if fox_line - 1 > 0:
        # left
        if fox_col - 1 >= 0:
            if matrix[fox_line - 1][fox_col - 1] == Game.EMPTY_SPACE:
                s = s + 1
        # right
        if fox_col + 1 < Game.COLUMNS:
            if matrix[fox_line - 1][fox_col + 1] == Game.EMPTY_SPACE:
                s = s + 1
    return s


# functie care returneaza un tuplu ce reprezinta pozitia vulpii pe tabla de joc
def find_fox(matrix):
    fox_line = -1
    fox_col = -1
    for line in range(Game.COLUMNS):
        if fox_line != -1 and fox_col != -1:
            break
        for col in range(Game.COLUMNS):
            if matrix[line][col] == Game.FOX_SIMBOL:
                fox_line = line
                fox_col = col
                break
    return(fox_line, fox_col)


# functie care returneaza o lista de tupluri ce reprezinta pozitiile cainilor pe tabla de joc
def find_hounds(matrix):
    hounds = []
    for line in range(Game.COLUMNS):
        if len(hounds) == 4:
            break
        for col in range(Game.COLUMNS):
            if matrix[line][col] == Game.HOUND_SIMBOL:
                hounds.append((line, col))
    return hounds

# functie care returneaza distanta dintre vulpe si un caine
def distance(fox_line, fox_col, hound_line, hound_col):
    return max(abs(fox_line - hound_line), abs(fox_col - hound_col))


def afis_daca_final(stare_curenta):
    final = stare_curenta.tabla_joc.final()  # metoda final() returneaza "remiza" sau castigatorul ("x" sau "0") sau False daca nu e stare finala
    if final != False:
        print("A castigat " + final)
        return True
    return False


def min_max(stare):
    # daca sunt la o frunza in arborele minimax sau la o stare finala
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    # calculez toate mutarile posibile din starea curenta
    stare.mutari_posibile = stare.mutari()

    # aplic algoritmul minimax pe toate mutarile posibile (calculand astfel subarborii lor)
    mutariCuEstimare = [min_max(x) for x in stare.mutari_posibile]  # expandez(constr subarb) fiecare nod x din mutari posibile

    if stare.j_curent == Game.JMAX:
        # daca jucatorul e JMAX aleg starea-fiica cu estimarea maxima
        stare.stare_aleasa = max(mutariCuEstimare, key=lambda x: x.estimare)  # def f(x): return x.estimare -----> key=f
    else:
        # daca jucatorul e JMIN aleg starea-fiica cu estimarea minima
        stare.stare_aleasa = min(mutariCuEstimare, key=lambda x: x.estimare)

    stare.estimare = stare.stare_aleasa.estimare
    return stare


def alpha_beta(alpha, beta, stare):
    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    if alpha > beta:
        return stare  # este intr-un interval invalid deci nu o mai procesez

    stare.mutari_posibile = stare.mutari()

    if stare.j_curent == Game.JMAX:
        estimare_curenta = float('-inf')  # in aceasta variabila calculam maximul

        for mutare in stare.mutari_posibile:
            # calculeaza estimarea pentru starea noua, realizand subarborele
            stare_noua = alpha_beta(alpha, beta, mutare)  # aici construim subarborele pentru stare_noua

            if (estimare_curenta < stare_noua.estimare):
                stare.stare_aleasa = stare_noua
                estimare_curenta = stare_noua.estimare
            if (alpha < stare_noua.estimare):
                alpha = stare_noua.estimare
                if alpha >= beta:
                    break

    elif stare.j_curent == Game.JMIN:
        estimare_curenta = float('inf')
        # completati cu rationament similar pe cazul stare.j_curent==Joc.JMAX
        for mutare in stare.mutari_posibile:
            # calculeaza estimarea
            stare_noua = alpha_beta(alpha, beta, mutare)  # aici construim subarborele pentru stare_noua

            if (estimare_curenta > stare_noua.estimare):
                stare.stare_aleasa = stare_noua
                estimare_curenta = stare_noua.estimare
            if (beta > stare_noua.estimare):
                beta = stare_noua.estimare
                if alpha >= beta:
                    break

    stare.estimare = stare.stare_aleasa.estimare

    return stare

tip_algoritm = '2'
Game.JMIN = Game.FOX_SIMBOL
Game.JMAX = Game.HOUND_SIMBOL
tabla_curenta = Game()
print("Tabla initiala")
print(str(tabla_curenta))
stare_curenta = Stare(tabla_curenta, Game.FOX_SIMBOL, ADANCIME_MAX)


while True:
    if stare_curenta.j_curent == Game.JMIN:
        # muta jucatorul utilizator
        print("Acum muta utilizatorul cu simbolul", stare_curenta.j_curent)
        if stare_curenta.j_curent == Game.FOX_SIMBOL:
            raspuns_valid = False
            while not raspuns_valid:
                try:
                    fox_line, fox_col = find_fox(stare_curenta.tabla_joc.matr)
                    print("Unde vrei sa muti vulpea?")
                    linie = int(input("linie="))
                    coloana = int(input("coloana="))

                    if (linie in range(Game.COLUMNS) and coloana in range(Game.COLUMNS)):
                        matrix1 = move(stare_curenta.tabla_joc.matr, fox_line, fox_col, linie, coloana)
                        if matrix1 != stare_curenta.tabla_joc.matr:
                            raspuns_valid = True
                        else:
                            print("Mutare invalida.")
                    else:
                        print("Linie sau coloana invalida.")

                except ValueError:
                    print("Linia si coloana trebuie sa fie numere intregi")

            # dupa iesirea din while sigur am valide atat linia cat si coloana
            # deci pot plasa simbolul pe "tabla de joc"
            stare_curenta.tabla_joc.matr = matrix1
            #print(print_matrix(stare_curenta.tabla_joc.matr))

            # afisarea starii jocului in urma mutarii utilizatorului
            print("\nTabla dupa mutarea jucatorului")
            print(str(stare_curenta))
            # TO DO 8a
            # testez daca jocul a ajuns intr-o stare finala
            # si afisez un mesaj corespunzator in caz ca da
            if (afis_daca_final(stare_curenta)):
                break

            # S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)
        elif stare_curenta.j_curent == Game.HOUND_SIMBOL:
            hounds = find_hounds(stare_curenta.tabla_joc.matr)
            print("Ce caine vrei sa muti?")
            for i in range(len(hounds)):
                print(i, end=". ")
                print(hounds[i])
            ok = False
            while not ok:
                try:
                    index = int(input("Nr. caine= "))
                    if index in range(4):
                        ok = True
                    else:
                        print("Numarul cainelui trebuie sa fie un numar de la 0 la 3.")
                except ValueError:
                    print("Numarul cainelui trebuie sa fie un numar de la 0 la 3.")

            hound_line, hound_col = hounds[index]
            raspuns_valid = False
            while not raspuns_valid:
                try:

                    print("Unde vrei sa muti cainele?")
                    linie = int(input("linie="))
                    coloana = int(input("coloana="))

                    if (linie in range(Game.COLUMNS) and coloana in range(Game.COLUMNS)):
                        matrix1 = move(stare_curenta.tabla_joc.matr, hound_line, hound_col, linie, coloana)
                        if matrix1 != stare_curenta.tabla_joc.matr:
                            raspuns_valid = True
                        else:
                            print("Mutare invalida.")
                    else:
                        print("Linie sau coloana invalida.")

                except ValueError:
                    print("Linia si coloana trebuie sa fie numere intregi")

            # dupa iesirea din while sigur am valide atat linia cat si coloana
            # deci pot plasa simbolul pe "tabla de joc"
            stare_curenta.tabla_joc.matr = matrix1
            # print(print_matrix(stare_curenta.tabla_joc.matr))

            # afisarea starii jocului in urma mutarii utilizatorului
            print("\nTabla dupa mutarea jucatorului")
            print(str(stare_curenta))
            # TO DO 8a
            # testez daca jocul a ajuns intr-o stare finala
            # si afisez un mesaj corespunzator in caz ca da
            if (afis_daca_final(stare_curenta)):
                break

            # S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)


    # --------------------------------
    else:  # jucatorul e JMAX (calculatorul)
        # Mutare calculator

        print("Acum muta calculatorul cu simbolul", stare_curenta.j_curent)
        # preiau timpul in milisecunde de dinainte de mutare
        t_inainte = int(round(time.time() * 1000))

        # stare actualizata e starea mea curenta in care am setat stare_aleasa (mutarea urmatoare)
        if tip_algoritm == '1':
            stare_actualizata = min_max(stare_curenta)
        else:  # tip_algoritm==2
            stare_actualizata = alpha_beta(-500, 500, stare_curenta)
        stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc  # aici se face de fapt mutarea !!!
        print("Tabla dupa mutarea calculatorului")
        print(str(stare_curenta))
        
        # preiau timpul in milisecunde de dupa mutare
        t_dupa = int(round(time.time() * 1000))
        print("Calculatorul a \"gandit\" timp de " + str(t_dupa - t_inainte) + " milisecunde.")
        # TO DO 8b
        if (afis_daca_final(stare_curenta)):
            break

        # S-a realizat o mutare.  jucatorul cu cel opus
        stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)


'''
joc = Game()
print(joc)
mutari = joc.moves(joc.HOUND_SIMBOL)
print(print_matrix(mutari[0]))
joc.matr = mutari[0]
mutari = joc.moves(joc.HOUND_SIMBOL)
for x in mutari:
    print(print_matrix(x))
'''