import pygame
import sys
import copy

BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
#FOX_COLOR = (170, 0, 0)
#HOUND_COLOR = (102, 51, 0)

WINDOW_HEIGHT = 1000
WINDOW_WIDTH = 1000
COLUMNS = 8
FOX_SIMBOL = "v"
HOUND_SIMBOL = "c"
EMPTY_SPACE = "_"
FORBIDDEN_SPACE = "#"


def drawGrid(matrix):
    blockSize = WINDOW_HEIGHT / COLUMNS
    for line in range(COLUMNS):
        for col in range(COLUMNS):
            rect = pygame.Rect(line * blockSize, col * blockSize, blockSize, blockSize)
            if (line + col) % 2 == 0:
                pygame.draw.rect(SCREEN, WHITE, rect)
            else:
                pygame.draw.rect(SCREEN, BLACK, rect)

    fox = pygame.image.load('fox.png')
    foxSize = int(blockSize)
    fox = pygame.transform.scale(fox, (foxSize, foxSize))

    hound = pygame.image.load('hound.png')
    houndSize = int(blockSize)
    hound = pygame.transform.scale(hound, (houndSize, houndSize))

    for line in range(COLUMNS):
        for col in range(COLUMNS):
            if matrix[line][col] == HOUND_SIMBOL:
                SCREEN.blit(hound, (col * blockSize, line * blockSize))
            elif matrix[line][col] == FOX_SIMBOL:
                SCREEN.blit(fox, (col * blockSize, line * blockSize))
    fontObj = pygame.font.SysFont('arial', 30)
    textRandat = fontObj.render('GATA', True, (0, 255, 255))
    SCREEN.blit(textRandat, (col * blockSize, line * blockSize))
    '''
    line = 7
    col = 0
    SCREEN.blit(fox, (col * blockSize, line * blockSize))
    selected_fox = pygame.image.load('selected_fox.png')
    selected_fox = pygame.transform.scale(selected_fox, (foxSize, foxSize))
    col = 2
    SCREEN.blit(selected_fox, (col * blockSize, line * blockSize))
    #pygame.draw.circle(SCREEN, FOX_COLOR, (col * (blockSize) + blockSize / 2, line * (blockSize) + blockSize / 2), blockSize/3)

    line = 0

    for col in range(1, COLUMNS, 2):
        SCREEN.blit(hound, (col * blockSize, line * blockSize))
        #pygame.draw.circle(SCREEN, HOUND_COLOR, (col * (blockSize) + blockSize / 2, line * (blockSize) + blockSize / 2), blockSize / 3)

    line = 1
    selected_hound = pygame.image.load('selected_hound.png')
    selected_hound = pygame.transform.scale(selected_hound, (houndSize, houndSize))
    for col in range(0, COLUMNS, 2):
        SCREEN.blit(selected_hound, (col * blockSize, line * blockSize))
    '''


# functie care returneaza starea initiala a tablei de joc
def initial_state():
    matrix = [[EMPTY_SPACE for i in range(COLUMNS)] for j in range(COLUMNS)]
    for line in range(COLUMNS):
        for col in range(COLUMNS):
            if (line + col) % 2 == 0:
                matrix[line][col] = FORBIDDEN_SPACE
            else:
                matrix[line][col] = EMPTY_SPACE
    matrix[COLUMNS - 1][0] = FOX_SIMBOL
    for i in range(1, COLUMNS, 2):
        matrix[0][i] = HOUND_SIMBOL
    return matrix


# functia de afisare a starii curente
def print_matrix(matrix):
    for line in matrix:
        for x in line:
            print(x, end=" ")
        print()
    print()


# functie care returneaza matricea dupa ce s-a efectuat o mutare, daca aceasta mutare este legala
def move(matrix, line, col, new_line, new_col):
    new_matrix = copy.deepcopy(matrix)
    if matrix[line][col] != FOX_SIMBOL and matrix[line][col] != HOUND_SIMBOL:
        return new_matrix

    if new_line not in range(COLUMNS) or new_col not in range(COLUMNS):
        return new_matrix

    if matrix[new_line][new_col] != EMPTY_SPACE:
        return new_matrix

    if matrix[line][col] == FOX_SIMBOL:
        if new_line == line + 1:
            if new_col == col + 1:
                new_matrix[line][col] = EMPTY_SPACE
                new_matrix[new_line][new_col] = FOX_SIMBOL
            if new_col == col - 1:
                new_matrix[line][col] = EMPTY_SPACE
                new_matrix[new_line][new_col] = FOX_SIMBOL
        if new_line == line - 1:
            if new_col == col + 1:
                new_matrix[line][col] = EMPTY_SPACE
                new_matrix[new_line][new_col] = FOX_SIMBOL
            if new_col == col - 1:
                new_matrix[line][col] = EMPTY_SPACE
                new_matrix[new_line][new_col] = FOX_SIMBOL

    if matrix[line][col] == HOUND_SIMBOL:

        if new_line == line + 1:
            if new_col == col + 1:
                new_matrix[line][col] = EMPTY_SPACE
                new_matrix[new_line][new_col] = HOUND_SIMBOL
            if new_col == col - 1:
                new_matrix[line][col] = EMPTY_SPACE
                new_matrix[new_line][new_col] = HOUND_SIMBOL
    return new_matrix


# functie care returneaza un tuplu ce reprezinta pozitia vulpii pe tabla de joc
def find_fox(matrix):
    fox_line = -1
    fox_col = -1
    for line in range(COLUMNS):
        if fox_line != -1 and fox_col != -1:
            break
        for col in range(COLUMNS):
            if matrix[line][col] == FOX_SIMBOL:
                fox_line = line
                fox_col = col
                break
    return(fox_line, fox_col)


# functie care returneaza o lista de tupluri ce reprezinta pozitiile cainilor pe tabla de joc
def find_hounds(matrix):
    hounds = []
    for line in range(COLUMNS):
        if len(hounds) == 4:
            break
        for col in range(COLUMNS):
            if matrix[line][col] == HOUND_SIMBOL:
                hounds.append((line, col))
    return hounds


# functie care verifica daca vulpea nu se poate muta din pozitia actuala si returneaza un boolean
def fox_cannot_move(matrix):
    fox_line, fox_col = find_fox(matrix)
    # try to move down
    if fox_line + 1 < COLUMNS:
        # left
        if fox_col - 1 > 0:
            if matrix[fox_line + 1][fox_col - 1] == EMPTY_SPACE:
                return False
        # right
        if fox_col + 1 < COLUMNS:
            if matrix[fox_line + 1][fox_col + 1] == EMPTY_SPACE:
                return False

    # try to move up
    if fox_line - 1 > 0:
        # left
        if fox_col - 1 > 0:
            if matrix[fox_line - 1][fox_col - 1] == EMPTY_SPACE:
                return False
        # right
        if fox_col + 1 < COLUMNS:
            if matrix[fox_line - 1][fox_col + 1] == EMPTY_SPACE:
                return False

    return True


# functie care verifica daca starea data ca parametru este stare finala
def final(matrix):
    if FOX_SIMBOL in matrix[0]:
        return FOX_SIMBOL
    if fox_cannot_move(matrix):
        return HOUND_SIMBOL
    return False



if __name__ == "__main__":
    global SCREEN, CLOCK
    pygame.init()
    pygame.display.set_caption('Tudorache Alexandru-Theodor --- Vulpea si cainii')
    SCREEN = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
    CLOCK = pygame.time.Clock()
    SCREEN.fill(BLACK)


    matrix = initial_state()
    print_matrix(matrix)
    print(fox_cannot_move(matrix))

    '''
    i = int(input("i= "))
    j = int(input("j= "))
    matrix1 = move(matrix, 0, 1, i, j)
    while matrix == matrix1:
        print("Wrong input!")
        i = int(input("i= "))
        j = int(input("j= "))
        matrix1 = move(matrix, 0, 1, i, j)
    print_matrix(matrix1)
    print(matrix == matrix1)
     '''
    celuleGrid = []  # este lista cu patratelele din grid
    for line in range(COLUMNS):
        for col in range(COLUMNS):
            rect = pygame.Rect(line * 125, col * 125, 125, 125)
            celuleGrid.append(rect)
    while True:
        drawGrid(matrix)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == pygame.MOUSEBUTTONDOWN:
                pos = pygame.mouse.get_pos()
                print(pos)
                for np in range(len(celuleGrid)):
                    if celuleGrid[np].collidepoint(pos):
                        line = np // COLUMNS
                        col = np % COLUMNS
                        print(line, col)

        pygame.display.update()

