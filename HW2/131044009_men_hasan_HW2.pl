% CSE341 Programming Languages HW2 - Prolog
% HASAN MEN 131044009

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

% bir sehirden yola cıkarak gidilecek sehirleri verir
route(A,B):- flight(A,B),flight(B,A).
route(A,B):- flight(A,C), flight(C,B), not(C ==B).

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

member(X,[X|_]).
member(X,[_|Tail]):- member(X,Tail).

sroute(A,B,D) :-
       travel(A,B,[A],P,D),
       write(P).

travel(A,B,P,[B|P],D) :-
       %write('travel1'),
       flight(A,B),
       distance(A,B,D),!.

travel(A,B,Visited,Path,D) :-
       %write('travel2'),
       flight(A,C),
       C \== B,
       \+member(C,Visited),
       distance(A,C,Old),
       travel(C,B,[C|Visited],Path,D2),
       D is Old+ D2.


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
where(455,207).
where(452,207).

enrol(a,102).
enrol(a,108).
enrol(b,102).
enrol(c,108).
enrol(d,341).
enrol(e,455).

% 3.1
% ogrencinin sinif ve ders saatini verir
schedule(X,P,T):- enrol(X,C),where(C,P), when(C,T).

% 3.2
% girilen sınıf icin ders suresini verir
usage(P,T):- where(C,P), when(C,T).

% 3.3
% sınıf ve ya zaman cakismasini kontrol eder
confClass(X,Y):- where(X,A),
                where(Y,B),
                A==B.

confTime(X,Y):-  when(X,A),
                 when(Y,B),
                 A == B.
conflict(X,Y):- not((not(confClass(X,Y)),
                     not(confTime(X,Y)))).


% 3.4
% iki ogrenci sınıf ve zaman olarak karsilasiyor mu?

meet(X,Y):- enrol(X,C1),where(C1,P1),
            enrol(Y,C2),where(C2,P2),
            C1==C2,P1==P2,!.

%---------------%
%---  PART 4 ---%
%---------------%

% 4.1
% This predicates adds all elements of a list and binds result to second parameter

add([],0).
add([H|T],L2):- add(T,L3), L2 is H+L3.

% 4.2
% This part takes a list and return new list which doesn't include recurrent element

uniqueHelper([],L,L).

uniqueHelper([H|T],L1,L2):-
  member(H,L1),
  uniqueHelper(T,L1,L2).

uniqueHelper([H|T],L1,L2):-
  uniqueHelper(T,[H|L1],L2).

unique(List,UList):-
  uniqueHelper(List,[],UList),!.

% 4.3
% This part takes a list, include lists then flats the main list
appendList([],L2,L2).
appendList([H|T],L2,[H|L3]):- appendList(T,L2,L3).

flatten([], []) :- !. % cut backtracking
flatten([H|T], List) :- !,
    %cut backtrac and just return new lists
    flatten(H, ListH),
    flatten(T, ListT),
    appendList(ListH, ListT, List).
flatten(L, [L]).
