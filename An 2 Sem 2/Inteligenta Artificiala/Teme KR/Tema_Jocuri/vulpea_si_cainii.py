import pygame
import sys
import copy
import time

BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
BACKGROUND = (45, 51, 64)
WINDOW_HEIGHT = 1000
WINDOW_WIDTH = 1000


class Game:
    COLUMNS = 8
    JMIN = None
    JMAX = None
    EMPTY_SPACE = "_"
    FORBIDDEN_SPACE = "#"
    FOX_SIMBOL = "v"
    HOUND_SIMBOL = "c"

    # 4BAREM -> interfata grafica
    @classmethod
    def initializeaza(cls, display, COLUMNS = 8, blockSize = WINDOW_HEIGHT / COLUMNS):
        cls.display = display
        cls.blockSize = blockSize
        cls.fox_img = pygame.image.load('fox.png')
        foxSize = int(blockSize)
        cls.fox_img = pygame.transform.scale(cls.fox_img, (foxSize, foxSize))

        cls.selected_fox_img = pygame.image.load('selected_fox.png')
        cls.selected_fox_img = pygame.transform.scale(cls.selected_fox_img, (foxSize, foxSize))

        cls.hound_img = pygame.image.load('hound.png')
        houndSize = int(blockSize)
        cls.hound_img = pygame.transform.scale(cls.hound_img, (houndSize, houndSize))

        cls.selected_hound_img = pygame.image.load('selected_hound.png')
        cls.selected_hound_img = pygame.transform.scale(cls.selected_hound_img, (houndSize, houndSize))

        cls.celuleGrid = []
        for line in range(COLUMNS):
            for col in range(COLUMNS):
                rect = pygame.Rect(line * blockSize, col * blockSize, blockSize, blockSize)
                cls.celuleGrid.append(rect)

    # 4BAREM -> interfata grafica
    def deseneaza_grid(self, marcaj_lin=None, marcaj_col=None):  # tabla de exemplu este ["#","x","#","0",......]
        for line in range(self.COLUMNS):
            for col in range(self.COLUMNS):
                rect = pygame.Rect(line * self.__class__.blockSize, col * self.__class__.blockSize, self.__class__.blockSize, self.__class__.blockSize)
                if (line + col) % 2 == 0:
                    pygame.draw.rect(self.__class__.display, WHITE, rect)
                else:
                    pygame.draw.rect(self.__class__.display, BLACK, rect)
        for line in range(self.COLUMNS):
            for col in range(self.COLUMNS):
                if self.matr[line][col] == self.FOX_SIMBOL:
                    if marcaj_lin == line and marcaj_col == col:
                        self.__class__.display.blit(self.__class__.selected_fox_img,(col * self.__class__.blockSize, line * self.__class__.blockSize))
                    else:
                        self.__class__.display.blit(self.__class__.fox_img, (col * self.__class__.blockSize, line * self.__class__.blockSize))
                elif self.matr[line][col] == self.HOUND_SIMBOL:
                    if marcaj_lin == line and marcaj_col == col:
                        self.__class__.display.blit(self.__class__.selected_hound_img, (col * self.__class__.blockSize, line * self.__class__.blockSize))
                    else:
                        self.__class__.display.blit(self.__class__.hound_img, (col * self.__class__.blockSize, line * self.__class__.blockSize))

        pygame.display.flip()  # pentru a actualiza interfata

    def __init__(self, table = None):  # Joc()
        # 3BAREM
        if table == None:
            self.matr = initial_state()
        else:
            self.matr = table

    @classmethod
    def jucator_opus(cls, jucator):
        return cls.JMAX if jucator == cls.JMIN else cls.JMIN

    # 7BAREM
    def final(self):
        if self.FOX_SIMBOL in self.matr[0]:
            return self.FOX_SIMBOL
        if fox_cannot_move(self.matr):
            return self.HOUND_SIMBOL
        return False

    # 5BAREM
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

    # 8BAREM
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

    # 4BAREM -> tabla in consola
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

# 11BAREM


# 3BAREM
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

# 4BAREM -> afisare in consola
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

# 5BAREM
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

# 7BAREM
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
    if fox_line - 1 >= 0:
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


# 1BAREM -> indicarea la finalul jocului a castigatorului
# 7BAREM
def afis_daca_final(stare_curenta):
    final = stare_curenta.tabla_joc.final()  # metoda final() returneaza "remiza" sau castigatorul ("x" sau "0") sau False daca nu e stare finala
    if final != False:
        print("A castigat " + final)
        return True
    return False

# 9BAREM
# functie care returneaza timpul de gandire minim, maxim si median al calculatorului
def time_min_max_median(l_time):
    mini = min(l_time)
    maxi = max(l_time)
    mean = sum(l_time) / len(l_time)
    median = l_time[len(l_time) // 2 + 1]
    print("Timpul minim de gandire al calculatorului:", mini)
    print("Timpul maxim de gandire al calculatorului:", maxi)
    print("Timpul mediu de gandire al calculatorului:", mean)
    print("Mediana timpului de gandire al calculatorului:", median)

# functie care returneaza numarul minim, maxim si median de noduri generate de calculator
def nodes_min_max_median(l_nodes):
    mini = min(l_nodes)
    maxi = max(l_nodes)
    mean = sum(l_nodes) / len(l_nodes)
    median = l_nodes[len(l_nodes) // 2 + 1]
    print("Numarul minim de noduri generate la o mutare:", mini)
    print("Numarul maxim de noduri generate la o mutare:", maxi)
    print("Numarul mediu de noduri generate la o mutare:", mean)
    print("Mediana numarului de noduri generate la o mutare:", median)



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


class Buton:
    def __init__(self, display=None, left=0, top=0, w=0, h=0, culoareFundal=(252, 124, 0), culoareFundalSel=(232, 77, 0), text="", font="arialblack", fontDimensiune=27, culoareText=(255,255,255), valoare=""):
        self.display = display
        self.culoareFundal = culoareFundal
        self.culoareFundalSel = culoareFundalSel
        self.text = text
        self.font = font
        self.w = w
        self.h = h
        self.selectat = False
        self.fontDimensiune = fontDimensiune
        self.culoareText = culoareText

        #creez obiectul font
        fontObj = pygame.font.SysFont(self.font, self.fontDimensiune)
        self.textRandat = fontObj.render(self.text, True, self.culoareText)
        self.dreptunghi = pygame.Rect(left, top, w, h)

        #aici centram textul
        self.dreptunghiText = self.textRandat.get_rect(center=self.dreptunghi.center)
        self.valoare=valoare

    def selecteaza(self, sel):
        self.selectat = sel
        self.deseneaza()

    def selecteazaDupacoord(self, coord):
        if self.dreptunghi.collidepoint(coord):
            self.selecteaza(True)
            return True
        return False

    def updateDreptunghi(self):
        self.dreptunghi.left = self.left
        self.dreptunghi.top = self.top
        self.dreptunghiText = self.textRandat.get_rect(center=self.dreptunghi.center)

    def deseneaza(self):
        culoareF = self.culoareFundalSel if self.selectat else self.culoareFundal
        pygame.draw.rect(self.display, culoareF, self.dreptunghi)
        self.display.blit(self.textRandat, self.dreptunghiText)

    def __str__(self):
        return self.text + " " + str(self.selectat)


class GrupButoane:
    def __init__(self, listaButoane=[], indiceSelectat=0, spatiuButoane=WINDOW_WIDTH/25,left=0, top=0):
        self.listaButoane = listaButoane
        self.indiceSelectat = indiceSelectat
        self.listaButoane[self.indiceSelectat].selectat = True
        self.top = top
        self.left = left
        leftCurent = self.left
        for b in self.listaButoane:
            b.top = self.top
            b.left = leftCurent
            b.updateDreptunghi()
            leftCurent += (spatiuButoane + b.w)

    def selecteazaDupacoord(self, coord):
        for ib, b in enumerate(self.listaButoane):
            if b.selecteazaDupacoord(coord):
                for i in range(len(self.listaButoane)):
                    self.listaButoane[i].selecteaza(False)
                self.listaButoane[ib].selecteaza(True)
                self.indiceSelectat = ib
                return True
        return False

    def deseneaza(self):
        #atentie, nu face wrap
        for b in self.listaButoane:
            b.deseneaza()

    def getValoare(self):
        return self.listaButoane[self.indiceSelectat].valoare


# 1BAREM
def deseneaza_alegeri(display, tabla_curenta) :
    fontObj = pygame.font.SysFont('arialblack', 50)
    textRandat = fontObj.render("Vulpea si Cainii", True, WHITE)
    display.blit(textRandat, (WINDOW_WIDTH / 3.5, WINDOW_HEIGHT / 30))
    btn_alg = GrupButoane(top=int(WINDOW_HEIGHT / 6), left=int(WINDOW_WIDTH / 2 - WINDOW_WIDTH / 6 - WINDOW_WIDTH / 50), listaButoane=[
                                                        Buton(display=display, w=int(WINDOW_WIDTH / 6), h=int(WINDOW_HEIGHT / 15), text="Mini-Max", valoare='0'),
                                                        Buton(display=display, w=int(WINDOW_WIDTH / 6), h=int(WINDOW_HEIGHT / 15), text="Alpha-Beta", valoare='1')
                                                        ],
                        indiceSelectat=0)
    btn_juc = GrupButoane(top=int(WINDOW_HEIGHT / 3.8), left=int(WINDOW_WIDTH / 2 - WINDOW_WIDTH / 6 - WINDOW_WIDTH / 50), listaButoane=[
                                                        Buton(display=display, w=int(WINDOW_WIDTH / 6), h=int(WINDOW_HEIGHT / 15), text="Vulpe", valoare=Game.FOX_SIMBOL),
                                                        Buton(display=display, w=int(WINDOW_WIDTH / 6), h=int(WINDOW_HEIGHT / 15), text="Caini", valoare=Game.HOUND_SIMBOL)
                                                        ],
                        indiceSelectat=0)
    btn_dif = GrupButoane(top=int(WINDOW_HEIGHT / 2.8), left=int(WINDOW_WIDTH / 2 - WINDOW_WIDTH / 4 - WINDOW_WIDTH / 50 - WINDOW_WIDTH / 50),
                          listaButoane=[
                              Buton(display=display, w=int(WINDOW_WIDTH / 6), h=int(WINDOW_HEIGHT / 15), text="Incepator",
                                    valoare='4'),
                              Buton(display=display, w=int(WINDOW_WIDTH / 6), h=int(WINDOW_HEIGHT / 15), text="Mediu",
                                    valoare='6'),
                              Buton(display=display, w=int(WINDOW_WIDTH / 6), h=int(WINDOW_HEIGHT / 15), text="Avansat",
                                    valoare='7')
                          ],
                          indiceSelectat=0)
    btn_players = GrupButoane(top=int(WINDOW_HEIGHT / 2.2),
                              left=int(WINDOW_WIDTH / 8 - WINDOW_WIDTH / 50 - WINDOW_WIDTH / 50),
                              listaButoane=[
                                  Buton(display=display, w=int(WINDOW_WIDTH / 4), h=int(WINDOW_HEIGHT / 15), fontDimensiune=18,
                                        text="Jucator vs Jucator",
                                        valoare='1'),
                                  Buton(display=display, w=int(WINDOW_WIDTH / 4), h=int(WINDOW_HEIGHT / 15), fontDimensiune=18,
                                        text="Jucator vs Calculator",
                                        valoare='2'),
                                  Buton(display=display, w=int(WINDOW_WIDTH / 4), h=int(WINDOW_HEIGHT / 15), fontDimensiune=18,
                                        text="Calculator vs Calculator",
                                        valoare='3')
                              ],
                              indiceSelectat=1)


    ok = Buton(display=display, top=int(WINDOW_HEIGHT / 1.8), left=int(WINDOW_WIDTH / 2 - WINDOW_WIDTH / 12), w=int(WINDOW_WIDTH / 6), h=int(WINDOW_HEIGHT / 15), text="OK", culoareFundal=(0, 184, 160))
    btn_alg.deseneaza()
    btn_juc.deseneaza()
    btn_dif.deseneaza()
    btn_players.deseneaza()
    ok.deseneaza()
    while True:
        for ev in pygame.event.get():
            if ev.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif ev.type == pygame.MOUSEBUTTONDOWN:
                pos = pygame.mouse.get_pos()

                if not btn_alg.selecteazaDupacoord(pos):
                    if not btn_juc.selecteazaDupacoord(pos):
                        if not btn_dif.selecteazaDupacoord(pos):
                            if not btn_players.selecteazaDupacoord(pos):
                                if ok.selecteazaDupacoord(pos):
                                    display.fill((0, 0, 0))  # stergere ecran
                                    tabla_curenta.deseneaza_grid()
                                    return btn_players.getValoare(), btn_alg.getValoare(), btn_juc.getValoare(), int(btn_dif.getValoare())

        pygame.display.update()

def main():
    tabla_curenta = Game()
    print("Tabla initiala")
    print(str(tabla_curenta))
    pygame.init()
    # 4BAREM -> titlul ferestrei
    pygame.display.set_caption('Tudorache Alexandru-Theodor --- Vulpea si cainii')
    SCREEN = pygame.display.set_mode(size=(WINDOW_WIDTH, WINDOW_HEIGHT))
    Game.initializeaza(SCREEN)
    SCREEN.fill(BACKGROUND)
    # 1BAREM -> utilizatorul va fi intrebat...
    # 2BAREM
    # 13BAREM
    game_type, tip_algoritm, Game.JMIN, ADANCIME_MAX = deseneaza_alegeri(SCREEN, tabla_curenta)
    Game.JMAX = Game.HOUND_SIMBOL if Game.JMIN == Game.FOX_SIMBOL else Game.FOX_SIMBOL
    stare_curenta = Stare(tabla_curenta, Game.FOX_SIMBOL, ADANCIME_MAX)


    #SCREEN.fill(BLACK)
    tabla_curenta.deseneaza_grid()
    time_of_thinking = []
    generated_nodes = []
    computer_moves = 0
    player_moves = 0
    if game_type == '2': # Player vs computer
        while True:

            if stare_curenta.j_curent == Game.JMIN:
                # 1BAREM -> afisarea a cui este randul sa mute
                # muta jucatorul utilizator
                print("Acum muta utilizatorul cu simbolul", stare_curenta.j_curent)
                t_inainte = int(round(time.time() * 1000))
                if stare_curenta.j_curent == Game.FOX_SIMBOL:
                    # 6BAREM
                    selected = False
                    player_moved = False
                    while not player_moved:
                        for event in pygame.event.get():
                            if event.type == pygame.QUIT:
                                pygame.quit()
                                sys.exit()
                            elif event.type == pygame.MOUSEBUTTONDOWN:
                                pos = pygame.mouse.get_pos()
                                for np in range(len(Game.celuleGrid)):
                                    if Game.celuleGrid[np].collidepoint(pos):
                                        col = np // Game.COLUMNS
                                        line = np % Game.COLUMNS
                                        if not selected and stare_curenta.tabla_joc.matr[line][col] == Game.JMIN:
                                            stare_curenta.tabla_joc.deseneaza_grid(line, col)
                                            selected = (line, col)
                                        elif selected:
                                            matrix1 = move(stare_curenta.tabla_joc.matr, selected[0], selected[1], line, col)
                                            if matrix1 != stare_curenta.tabla_joc.matr:
                                                stare_curenta.tabla_joc.matr = matrix1
                                                player_moved = True

                    print("\nTabla dupa mutarea jucatorului")
                    print(str(stare_curenta))
                    stare_curenta.tabla_joc.deseneaza_grid()
                    player_moves += 1

                    # 9BAREM -> a, b, d
                    t_dupa = int(round(time.time() * 1000))
                    print("Jucatorul a gandit timp de " + str(t_dupa - t_inainte) + " milisecunde.")
                    if afis_daca_final(stare_curenta):
                        time_min_max_median(time_of_thinking)
                        #nodes_min_max_median(generated_nodes)
                        print("Nr mutari jucator:", player_moves)
                        print("Nr mutari calculator:", computer_moves)
                        break

                    stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)

                elif stare_curenta.j_curent == Game.HOUND_SIMBOL:
                    selected = False
                    player_moved = False
                    while not player_moved:
                        for event in pygame.event.get():
                            if event.type == pygame.QUIT:
                                pygame.quit()
                                sys.exit()
                            elif event.type == pygame.MOUSEBUTTONDOWN:
                                pos = pygame.mouse.get_pos()
                                for np in range(len(Game.celuleGrid)):
                                    if Game.celuleGrid[np].collidepoint(pos):
                                        col = np // Game.COLUMNS
                                        line = np % Game.COLUMNS
                                        if stare_curenta.tabla_joc.matr[line][col] == Game.JMIN:
                                            stare_curenta.tabla_joc.deseneaza_grid(line, col)
                                            selected = (line, col)
                                        elif selected:
                                            matrix1 = move(stare_curenta.tabla_joc.matr, selected[0], selected[1], line,  col)
                                            if matrix1 != stare_curenta.tabla_joc.matr:
                                                stare_curenta.tabla_joc.matr = matrix1
                                                player_moved = True

                    print("\nTabla dupa mutarea jucatorului")
                    print(str(stare_curenta))
                    stare_curenta.tabla_joc.deseneaza_grid()
                    player_moves += 1
                    # 9BAREM -> a, b, d
                    t_dupa = int(round(time.time() * 1000))
                    print("Jucatorul a gandit timp de " + str(t_dupa - t_inainte) + " milisecunde.")
                    if afis_daca_final(stare_curenta):
                        time_min_max_median(time_of_thinking)
                        #nodes_min_max_median(generated_nodes)
                        print("Nr mutari jucator:", player_moves)
                        print("Nr mutari calculator:", computer_moves)
                        break

                    stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)



            # --------------------------------
            else:  # jucatorul e JMAX (calculatorul)
                # 1BAREM -> afisarea a cui este randul sa mute

                # Mutare calculator

                print("Acum muta calculatorul cu simbolul", stare_curenta.j_curent)
                t_inainte = int(round(time.time() * 1000))

                #nr_noduri_generate = None
                # stare actualizata e starea mea curenta in care am setat stare_aleasa (mutarea urmatoare)
                if tip_algoritm == '0':
                    stare_actualizata = min_max(stare_curenta)
                else:  # tip_algoritm == '1'
                    stare_actualizata = alpha_beta(-500, 500, stare_curenta)
                stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc  # aici se face mutarea
                print("Tabla dupa mutarea calculatorului")
                print(str(stare_curenta))
                stare_curenta.tabla_joc.deseneaza_grid()
                computer_moves += 1

                t_dupa = int(round(time.time() * 1000))
                print("Calculatorul a \"gandit\" timp de " + str(t_dupa - t_inainte) + " milisecunde.")
                time_of_thinking.append(t_dupa - t_inainte)
                #if nr_noduri_generate != None:
                #    generated_nodes.append(nr_noduri_generate)
                #    print("S-au generat", nr_noduri_generate, "mutari.")

                # 9BAREM -> a, b, d
                if afis_daca_final(stare_curenta):
                    time_min_max_median(time_of_thinking)
                #    nodes_min_max_median(generated_nodes)
                    print("Nr mutari jucator:", player_moves)
                    print("Nr mutari calculator:", computer_moves)
                    break

                stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)
    elif game_type == '3': # Computer vs Computer
        while True:
            if stare_curenta.j_curent == Game.JMIN:
                # 1BAREM -> afisarea a cui este randul sa mute
                print("Acum muta calculatorul cu simbolul", stare_curenta.j_curent)
                t_inainte = int(round(time.time() * 1000))

                # stare actualizata e starea mea curenta in care am setat stare_aleasa (mutarea urmatoare)
                if tip_algoritm == '0':
                    stare_actualizata = min_max(stare_curenta)
                else:  # tip_algoritm == '1'
                    stare_actualizata = alpha_beta(-500, 500, stare_curenta)
                stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc  # aici se face mutarea
                print("Tabla dupa mutarea calculatorului")
                print(str(stare_curenta))
                stare_curenta.tabla_joc.deseneaza_grid()
                player_moves += 1

                t_dupa = int(round(time.time() * 1000))
                print("Calculatorul1 a \"gandit\" timp de " + str(t_dupa - t_inainte) + " milisecunde.")
                time_of_thinking.append(t_dupa - t_inainte)
                # if nr_noduri_generate != None:
                #    generated_nodes.append(nr_noduri_generate)
                #    print("S-au generat", nr_noduri_generate, "mutari.")
                if afis_daca_final(stare_curenta):
                    time_min_max_median(time_of_thinking)
                    #    nodes_min_max_median(generated_nodes)
                    print("Nr mutari calculator1:", player_moves)
                    print("Nr mutari calculator2:", computer_moves)
                    break

                stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)
            else:  # jucatorul e JMAX (calculatorul)
                # 1BAREM -> afisarea a cui este randul sa mute

                # Mutare calculator

                print("Acum muta calculatorul cu simbolul", stare_curenta.j_curent)
                t_inainte = int(round(time.time() * 1000))

                #nr_noduri_generate = None
                # stare actualizata e starea mea curenta in care am setat stare_aleasa (mutarea urmatoare)
                if tip_algoritm == '0':
                    stare_actualizata = min_max(stare_curenta)
                else:  # tip_algoritm == '1'
                    stare_actualizata = alpha_beta(-500, 500, stare_curenta)
                stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc  # aici se face mutarea
                print("Tabla dupa mutarea calculatorului")
                print(str(stare_curenta))
                stare_curenta.tabla_joc.deseneaza_grid()
                computer_moves += 1

                t_dupa = int(round(time.time() * 1000))
                print("Calculatorul2 a \"gandit\" timp de " + str(t_dupa - t_inainte) + " milisecunde.")
                time_of_thinking.append(t_dupa - t_inainte)
                #if nr_noduri_generate != None:
                #    generated_nodes.append(nr_noduri_generate)
                #    print("S-au generat", nr_noduri_generate, "mutari.")
                if afis_daca_final(stare_curenta):
                    time_min_max_median(time_of_thinking)
                #    nodes_min_max_median(generated_nodes)
                    print("Nr mutari calculator1:", player_moves)
                    print("Nr mutari calculator2:", computer_moves)
                    break
                stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)
    else: # game_type == '1' Player vs Player
        while True:
                # 1BAREM -> afisarea a cui este randul sa mute

                # muta jucatorul utilizator
                print("Acum muta utilizatorul cu simbolul", stare_curenta.j_curent)
                t_inainte = int(round(time.time() * 1000))
                if stare_curenta.j_curent == Game.FOX_SIMBOL:
                    selected = False
                    player_moved = False
                    while not player_moved:
                        for event in pygame.event.get():
                            if event.type == pygame.QUIT:
                                pygame.quit()
                                sys.exit()
                            elif event.type == pygame.MOUSEBUTTONDOWN:
                                pos = pygame.mouse.get_pos()
                                for np in range(len(Game.celuleGrid)):
                                    if Game.celuleGrid[np].collidepoint(pos):
                                        col = np // Game.COLUMNS
                                        line = np % Game.COLUMNS
                                        if not selected and stare_curenta.tabla_joc.matr[line][col] == Game.FOX_SIMBOL:
                                            stare_curenta.tabla_joc.deseneaza_grid(line, col)
                                            selected = (line, col)
                                        elif selected:
                                            matrix1 = move(stare_curenta.tabla_joc.matr, selected[0], selected[1], line, col)
                                            if matrix1 != stare_curenta.tabla_joc.matr:
                                                stare_curenta.tabla_joc.matr = matrix1
                                                player_moved = True

                    print("\nTabla dupa mutarea jucatorului")
                    print(str(stare_curenta))
                    stare_curenta.tabla_joc.deseneaza_grid()
                    player_moves += 1

                    t_dupa = int(round(time.time() * 1000))
                    print("Jucatorul1 a gandit timp de " + str(t_dupa - t_inainte) + " milisecunde.")
                    if afis_daca_final(stare_curenta):
                        print("Nr mutari jucator1:", player_moves)
                        print("Nr mutari jucator2:", computer_moves)
                        break

                    stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)

                if stare_curenta.j_curent == Game.HOUND_SIMBOL:
                    selected = False
                    player_moved = False
                    while not player_moved:
                        for event in pygame.event.get():
                            if event.type == pygame.QUIT:
                                pygame.quit()
                                sys.exit()
                            elif event.type == pygame.MOUSEBUTTONDOWN:
                                pos = pygame.mouse.get_pos()
                                for np in range(len(Game.celuleGrid)):
                                    if Game.celuleGrid[np].collidepoint(pos):
                                        col = np // Game.COLUMNS
                                        line = np % Game.COLUMNS
                                        if stare_curenta.tabla_joc.matr[line][col] == Game.HOUND_SIMBOL:
                                            stare_curenta.tabla_joc.deseneaza_grid(line, col)
                                            selected = (line, col)
                                        elif selected:
                                            matrix1 = move(stare_curenta.tabla_joc.matr, selected[0], selected[1], line,  col)
                                            if matrix1 != stare_curenta.tabla_joc.matr:
                                                stare_curenta.tabla_joc.matr = matrix1
                                                player_moved = True

                    print("\nTabla dupa mutarea jucatorului")
                    print(str(stare_curenta))
                    stare_curenta.tabla_joc.deseneaza_grid()
                    computer_moves += 1

                    t_dupa = int(round(time.time() * 1000))
                    print("Jucatorul2 a gandit timp de " + str(t_dupa - t_inainte) + " milisecunde.")
                    if afis_daca_final(stare_curenta):
                        print("Nr mutari jucator1:", player_moves)
                        print("Nr mutari jucator2:", computer_moves)
                        break

                    stare_curenta.j_curent = Game.jucator_opus(stare_curenta.j_curent)




if __name__ == "__main__" :
    t1 = int(round(time.time() * 1000))
    main()
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                # 9BAREM -> d
                t2 = int(round(time.time() * 1000))
                print("Timpul final de joc: ", (t2 - t1) / 1000, "secunde.")

                sys.exit()