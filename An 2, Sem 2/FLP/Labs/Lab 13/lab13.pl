aexp(I) :- integer(I).
aexp(X) :- atom(X).
aexp(A1 + A2) :- aexp(A1), aexp(A2).
aexp(A1 - A2) :- aexp(A1), aexp(A2).
aexp(A1 * A2) :- aexp(A1), aexp(A2).


bexp(true). 
bexp(false).
bexp(A1 =< A2) :- aexp(A1), aexp(A2).
bexp(A1 >= A2) :- aexp(A1), aexp(A2).
bexp(A1 == A2) :- aexp(A1), aexp(A2).
bexp(and(BE1,BE2)) :- bexp(BE1), bexp(BE2).
bexp(or(BE1,BE2)) :- bexp(BE1), bexp(BE2).
bexp(not(B)) :- bexp(B).

stmt(skip).
stmt(X = AE) :- atom(X), aexp(AE).
stmt(St1;St2) :- stmt(St1), stmt(St2).
stmt({St}) :- stmt(St).
stmt(if(BE,St1,St2)) :- bexp(BE), stmt(St1), stmt(St2).
stmt(iff(S1, I, B)) :- stmt(S1), aexp(I), bexp(B).
stmt(while(B, St)) :- bexp(B), stmt(St).

program(St, AE) :- stmt(St), aexp(AE).

test0 :- program( {x = 10 ; sum = 0;
while(0 =< x,
{sum = sum + x; x = x-1}
)}
, sum).

get(S,X,I) :- member(vi(X,I),S).
get(_,_,0).
set(S,X,I,[vi(X,I)|S1]) :- del(S,X,S1).
del([vi(X,_)|S],X,S).
del([H|S],X,[H|S1]) :- del(S,X,S1) .
del([],_,[]).

smallstepA(X,S,I,S) :-atom(X), get(S,X,I).

smallstepA(I1 + I2,S,I,S):- integer(I1), integer(I2), I is I1 + I2.
smallstepA(I + AE1,S,I + AE2,S):- integer(I),
smallstepA(AE1,S,AE2,S).
smallstepA(AE1 + AE, S, AE2 + AE, S):- smallstepA(AE1, S, AE2, S).

smallstepB(I1 =< I2,S,true,S):- integer(I1),integer(I2),
(I1 =< I2).
smallstepB(I1 =< I2,S,false,S):- integer(I1),integer(I2),
(I1 > I2).
smallstepB(I =< AE1, S, I =< AE2, S):- integer(I), smallstepA(AE1, S, AE2, S).
smallstepB(AE1 =< AE, S, AE2 =< AE, S):- smallstepA(AE1, S, AE2, S).

smallstepB(not(true), S, false, S) .
smallstepB(not(false), S, true, S) .
%smallstepB(not(BE1), S, not(BE2), S) :- ...

%semantica blocurilor
smallstepS({E},S,E,S).

%semantica compunerilor
smallstepS((skip;St2), S, St2, S).
smallstepS((St1;St), S1, (St2;St), S2) :- smallstepS(St1, S1, St2, S2).

%semantica atribuirii
smallstepS(X = AE, S, skip, S1) :- integer(AE), set(S,X,AE,S1).
smallstepS(X = AE1,S,X = AE2,S) :- smallstepA(AE1, S, AE2, S).
    
%semantica lui if
smallstepS(if(true, St1, _), S, St1, S).
smallstepS(if(false, _, St2), S, St2, S).
smallstepS(if(BE1, St1, St2), S, if(BE2, St1, St2), S) :- smallstepB(BE1, S, BE2, S).
    
smallstepS(while(BE, St), S, if(BE, (St; while(BE, St)), skip), S).

%semantica programelor
smallstepP(skip, AE1, S1, skip, AE2, S2) :- smallstepA(AE1,S1,AE2,S2) .
smallstepP(St1, AE, S1, St2, AE, S2) :- smallstepS(St1,S1,St2,S2).

run(skip,I,_,I):- integer(I).
run(St1,AE1,S1,I) :- smallstepP(St1,AE1,S1,St2,AE2,S2), run(St2,AE2,S2,I).
run_program(Name) :- defpg(Name, {P}, E), run(P, E, [], I), write(I).

defpg(pg3, {x = 10 ; sum = 0; if(0 =< x,  sum = sum + x; sum = x + 100)}, sum).

mytrace(skip,I,_) :- integer(I).
mytrace(St1,AE1,S1) :- smallstepP(St1,AE1,S1,St2,AE2,S2), 
    write(St2),nl, write(AE2),nl, write(S2),nl, 
    mytrace(St2,AE2,S2).

trace_program(Name) :- defpg(Name,{P},E), mytrace(P,E,[]).

/** <examples>
aexp(1+2).
true

aexp(y+a).
true

aexp(1+a).
true

bexp(1=<2).
true

bexp(not(1=<2)).
true

bexp(or(1=<2, true)).
true

bexp(or(1=<2, 7)).
false

stmt(z=y).
true

stmt(z=1+2).
1true

stmt(z=1+2;x=3).
1true

stmt(z=1+2;3).
false

stmt(if(true, x=2;y=3, x=1;y=0)).
true

stmt(while(x =< 0,skip)).
1true

stmt(while(x =< 0)).
false

stmt(while(x =< 0,skip)).
1true

test0
1true

member(3, [1,2,3]).
1true

member(vi(X, 3), [vi(X, 3), vi(Y, 2)]).
1true

member(vi(X, 5), [vi(X, 3), vi(Y, 2)]).
false

member(vi(X, N), [vi(X, 3), vi(Y, 2)]).
N = 3

smallstepA(a + b, [vi(a,1),vi(b,2)],AE, S).
AE = 1+b,
S = [vi(a, 1), vi(b, 2)]

smallstepA(1 + b, [vi(a,1),vi(b,2)],AE, S).
AE = 1+2,
S = [vi(a, 1), vi(b, 2)]
*/
