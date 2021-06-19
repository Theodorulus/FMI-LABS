distance((X1, Y1), (X2, Y2), Z) :- Z is sqrt(((X1-X2)**2+(Y1-Y2)**2)).

fib(0, 1).
fib(1, 1).
fib(N, Result) :- 
    N > 1,
    N1 is N - 1, 
    N2 is N - 2, 
    fib(N1, R1), 
    fib(N2, R2), 
    Result is R1 + R2.

fibo(0, 1).
fibo(1, 1).
fibo(N, F) :-
    fibo(1, 1, 1, N, F).

fibo(_, F1, N, N, F1).
fibo(F0, F1, I, N, F) :-
    F2 is F0 + F1,
    NextI is I + 1,
    fibo(F1, F2, NextI, N, F).

fib2(1, 1, 0).
fib2(2, 1, 1).
fib2(N, Current, Last) :- 
    N > 2, 
    N1 is N-1, 
    fib2(N1, Last, OldLast), 
    Current is Last + OldLast.

square(N, Str) :- square(1, 0, N, Str).
square(N, N, N, _) :- write('').
square(I, N, N, Str) :- 
    nl,
    NextI is I + 1,
    square(NextI, 0, N, Str).
 
square(I, J, N, Str) :- 
    write(Str),
    NextJ is J + 1,
    square(I, NextJ, N, Str).

square2(N, Str) :- square3(1, 1, N, Str).
square3(N, N, N, C) :- write(C).
square3(I, N, N, Str) :- write(Str),
    nl,
    NextI is I + 1,
    square3(NextI, 1, N, Str).
 
square3(I, J, N, Str) :- 
    write(Str),
    NextJ is J + 1,
    square3(I, NextJ, N, Str).

element_of(X,[X|_]).
element_of(X,[_|Tail]) :- element_of(X,Tail).

all_equal([_|[]]).
all_equal([X, Y | T]) :-
    X == Y,
    all_equal([Y | T]).

all_a([_|[]]).
all_a([X, Y | T]) :-
    X == Y, X == a,
    all_a([Y | T]).

all_a3([_|[]]).
all_a3([X, Y | T]) :-
    X = Y, X = a,
    all_a3([Y | T]).

all_a2([]).
all_a2([a|Tail]) :- all_a2(Tail).

trans_a_b([], []).
trans_a_b([a|Tail1], [b|Tail2]) :-
    trans_a_b(Tail1, Tail2).


/** <examples>
?- 3+5 = +(3,5).
true

?- 3+5 = 8
false

?- 3+5 is 8
false

?- 8 is 3+5
true

?- X is 3+5
X = 8

distance((0,0),(3,4),X)
X = 5.0

distance((0,0),(3,4),5.0)
true

distance((-2.5,1),(3.5,-4),X)
X = 7.810249675906654

fib(2,X)
X = 2

fib(5,X)
X = 8

fib(20,X)
X = 10946

write('Hello World!'), nl.
Hello World!
true

[X,Y|T]=[1,2,3,4,5].
T = [3, 4, 5],
X = 1,
Y = 2

element_of(a,[a,b,c]).
true

element_of(X,[a,b,c]).
X = a
X = b
X = c

all_equal([b,b])
true

all_equal([b,a])
false

all_a([a,a])
true

all_a([a,a,a,a,a])
true

all_a([a,a,a,a,b])
false

all_a3([A,a,a,a,a])
A = a

all_a([A,a,a,a,a])
false

all_a3([b,a,a,a,a])
false

trans_a_b([a,a,a],L).
L = [b, b, b]

trans_a_b([a,a,a],[b]).
false

trans_a_b([a,a,a],[b, b, b]).
true

trans_a_b(L,[b,b]).
L = [a, a]

*/