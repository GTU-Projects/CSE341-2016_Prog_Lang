% Prolog HW2 - HASAN MEN 131044009
%---------------%
%---  PART 1 ---%
%---------------%

%facts : flight routes
flight(istanbul,antalya).
flight(istanbul,izmir).
flight(istanbul,konya).
flight(istanbul,gaziantep).
flight(istanbul,ankara).
flight(istanbul,kars).
flight(istanbul,trabzon).

flight(edirne,edremit).

flight(edremit,edirne).
flight(edremit,erzincan).

flight(erzincan,edremit).

flight(izmir,istanbul).
flight(izmir,ankara).

flight(antalya,istanbul).

flight(konya,istanbul).
flight(konya,ankara).

flight(ankara,istanbul).
flight(ankara,izmir).
flight(ankara,konya).
flight(ankara,trabzon).
flight(ankara,kars).

flight(gaziantep,istanbul).

flight(kars,ankara).
flight(kars,istanbul).

flight(trabzon,istanbul).
flight(trabzon,ankara).


connected(A,B):- flight(A,B); flight(B,A).
foo(Place,Visited,X):-
  flight(Place,Y),
  not(member(Y,Visited)),
  foo(Y,[Y|Visited],X),
  X is Y.

route(Place,X):-
  foo(Place,[Place],X).

path(A,B,Path) :-
       travel(A,B,[A],Path).

travel(A,B,P,[B|P]) :-
       connected(A,B).
travel(A,B,Visited,Path) :-
       connected(A,C),
       C \== B,
       \+member(C,Visited),
       travel(C,B,[C|Visited],Path).

%---------------%
%---  PART 2 ---%
%---------------%

%distances facts
distance(istanbul,izmir,328).
distance(istanbul,antalya,482).
distance(istanbul,konya,461).
distance(istanbul,gaziantep,848).
distance(istanbul,ankara,350).
distance(istanbul,kars,1189).
distance(istanbul,trabzon,902).

distance(edirne,edremit,225).

distance(edremit,edirne,225).
distance(edremit,erzincan,1044).

distance(erzincan,edremit,1044).

distance(izmir,istanbul,328).
distance(izmir,ankara,521).

distance(antalta,istanbul,482).

distance(konya,istanbul,461).
distance(konya,ankara,231).

distance(ankara,istanbul,350).
distance(ankara,izmir,521).
distance(ankara,konya,231).
distance(ankara,trabzon,593).
distance(ankara,kars,872).

distance(gaziantep,istanbul,848).

distance(kars,ankara,872).
distance(kars,istanbul,1189).

distance(trabzon,istanbul,902).
distance(trabzon,ankara,593).


% a predicate indicating there exist a route between X and Y if there is
% flight between X and Y

addList([],L,L).
addList(Element,L,[Element|L]).

getEmptyList([]).
getListCopy(L,L).

member(X,[X|_]).
member(X,[_|Tail]):- member(X,Tail).


getNextCity(X,Y,Old):-
  flight(X,Y),
  not(member(Y,Old)).




%---------------%
%---  PART 3 ---%
%---------------%
% completed
when(102,10).
when(108,12).
when(341,14).
when(455,16).
when(452,17).

where(102,z23).
where(108,z11).
where(341,z06).
where(455,z07).
where(452,z07).

enrol(a,102).
enrol(a,108).
enrol(b,102).
enrol(c,108).
enrol(d,341).
enrol(e,455).

% 3.1
schedule(X,P,T):- enrol(X,C),where(C,P), when(C,T).

% 3.2
usage(P,T):- where(C,P), when(C,T).

% 3.3
confClass(X,Y):- where(X,A),
                where(Y,B),
                A==B.

confTime(X,Y):-  when(X,A),
                 when(Y,B),
                 A == B.
conflict(X,Y):- not((not(confClass(X,Y)),not(confTime(X,Y)))).


% 3.4
meet(X,Y):- enrol(X,C1),where(C1,P1),
            enrol(Y,C2),where(C2,P2),
            C1==C2,P1==P2,!.


%---------------%
%---  PART 4 ---%
%---------------%

% 4.1

add([],0).
add([H|T],L2):- add(T,L3), L2 is H+L3.

% 4.2
uniqueHelper([],L,L).

uniqueHelper([H|T],L1,L2):-
  member(H,L1),
  uniqueHelper(T,L1,L2).

uniqueHelper([H|T],L1,L2):-
  uniqueHelper(T,[H|L1],L2).

unique(List,Set):-
  uniqueHelper(List,[],Set),!.

% 4.3

appendList([],L2,L2).
appendList([H|T],L2,[H|L3]):- appendList(T,L2,L3).
flatten(L1,L2):- appendList([L1],[],L2).

%flatten(L1,[L1]). buda bir diger cozum
























%
