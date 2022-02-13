%---------------------------------
% Jon Snow and Daenerys Targaryen
%---------------------------------

male(rickardStark).
male(eddardStark).
male(brandonStark).
male(benjenStark).
male(robbStark).
male(branStark).
male(rickonStark).
male(jonSnow).
male(aerysTargaryen).
male(rhaegarTargaryen).
male(viserysTargaryen).
male(aegonTargaryen).

%---------------------------

female(lyarraStark).
female(catelynStark).
female(lyannaStark).
female(sansaStark).
female(aryaStark).
female(rhaellaTargaryen).
female(eliaTargaryen).
female(daenerysTargaryen).
female(rhaenysTargaryen).

%---------------------------

parent_of(rickardStark,eddardStark).
parent_of(rickardStark,brandonStark).
parent_of(rickardStark,benjenStark).
parent_of(rickardStark,lyannaStark).
parent_of(lyarraStark,eddardStark).
parent_of(lyarraStark,brandonStark).
parent_of(lyarraStark,benjenStark).
parent_of(lyarraStark,lyannaStark).

parent_of(eddardStark,robbStark).
parent_of(eddardStark,sansaStark).
parent_of(eddardStark,aryaStark).
parent_of(eddardStark,branStark).
parent_of(eddardStark,rickonStark).
parent_of(catelynStark,robbStark).
parent_of(catelynStark,sansaStark).
parent_of(catelynStark,aryaStark).
parent_of(catelynStark,branStark).
parent_of(catelynStark,rickonStark).

parent_of(aerysTargaryen,rhaegarTargaryen).
parent_of(aerysTargaryen,viserysTargaryen).
parent_of(aerysTargaryen,daenerysTargaryen).

parent_of(rhaellaTargaryen,rhaegarTargaryen).
parent_of(rhaellaTargaryen,viserysTargaryen).
parent_of(rhaellaTargaryen,daenerysTargaryen).

parent_of(rhaegarTargaryen,jonSnow).
parent_of(lyannaStark,jonSnow).

parent_of(rhaegarTargaryen,aegonTargaryen).
parent_of(rhaegarTargaryen,rhaenysTargaryen).

parent_of(eliaTargaryen,aegonTargaryen).
parent_of(eliaTargaryen,rhaenysTargaryen).

father_of(Father, Child) :- male(Father), parent_of(Father, Child).
    
mother_of(Mother, Child) :- female(Mother), parent_of(Mother, Child).

grandfather_of(Grandfather, Grandchild) :- father_of(Grandfather, X), parent_of(X, Grandchild).

grandmother_of(Grandmother, Grandchild) :- father_of(Grandmother, X), parent_of(X, Grandchild).

sister_of(Sister, Person) :- female(Sister), Sister \= Person, parent_of(Parent, Sister), parent_of(Parent, Person).

brother_of(Brother, Person) :- male(Brother), Brother \= Person, parent_of(Parent, Brother), parent_of(Parent, Person).

aunt_of(Aunt, Person) :- parent_of(Parent, Person), sister_of(Aunt, Parent).

uncle_of(Uncle, Person) :- brother_of(Uncle, Parent), parent_of(Parent, Person).

ancestor_of(Ancestor, Person) :- parent_of(Ancestor, Person); 
    							 parent_of(Ancestor, Parent), ancestor_of(Parent, Person).

% raspunde false pentru varibabile instantiate, dar nu forteaza instantierea
% not_parent(X,Y) :- \+ parent_of(X,Y).

not_parent(X,Y) :- (male(X);female(X)), (male(Y); female(Y)), \+ parent_of(X,Y).

ancestor_not_parent(X,Y) :- ancestor_of(X,Y), \+parent_of(X,Y).




