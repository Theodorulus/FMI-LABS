from itertools import product
from random import randint

def read(f):
    n = int(f.readline())
    ws = [int(x) for x in f.readline().split()]
    return (n, ws)

def solve(n, ws):
    T = [[0 for _ in range(n)] for _ in range(n)]
    for i in range(n):
        T[i][i] = ws[i]
    for i in range(n-1):
        T[i][i+1] = max(ws[i], ws[i+1])


    moves = [[None for _ in range(n)] for _ in range(n)]
    for i, l in product(range(0, n), range(2, n)):
        j = i + l
        if j >= n: break

        left_branch  = ws[i] + min(T[i+2][j], T[i+1][j-1])
        right_branch = ws[j] + min(T[i][j-2], T[i+1][j-1])
        T[i][j] = max(left_branch, right_branch)
        moves[i][j] = 'left' if left_branch >= right_branch else 'right'

    return T, moves

#data = read(open("joc.in"))
#res = solve(*data)
#print (res[0], res[1][0][3])

def create_game(n, a = 1, b = 100):
    ws = [randint(a, b) for _ in range(n)]
    return ws

def play_move(ws, move):
    return (ws[0], ws[1:]) if move == 'left' else (ws[-1], ws[:-1])

def play_game(n):
    ws = create_game(n)
    T, moves = solve(n, ws)
    scores = [0, 0]
    player = 0
    i, j = 0, n - 1

    while len(ws) != 0:
        print (f"Score Human: {scores[0]}\t\t\tScore Computer: {scores[1]}")
        print (f"Table: {' '.join([str(w) for w in ws])}")
        print (f"Expected score: {T[i][j]}")

        if player == 0:
            move = input("Enter your move: ")
            score, ws = play_move(ws, move)
            scores[0] += score
            if move == 'left': i += 1
            else: j -= 1
        else:
            move = moves[i][j]
            score, ws = play_move(ws, move)
            scores[1] += score
            if move == 'left': i += 1
            else: j -= 1
            print (f"Computer played {move}")
        player += 1
        player %= 2

        print ("\n\n\n")

    if scores[0] > scores[1]:
        print ("Humans won!")
    else:
        print ("Computers won!")

play_game(3)
