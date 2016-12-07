% Prolog HW2 - HASAN MEN 131044009
% -------
%  PART1
% -------

%facts : flight routes
flight(istanbul,izmir).
flight(istanbul,antalya).
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

flight(antalta,istanbul).

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

%Part2 distances facts
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

member(X,[X|_]).
member(X,[_|Tail]):- member(X,Tail).

getEmptyList([]).
getListCopy(L,L).

addList([],L,L).
addList(Element,L,[Element|L]).

getNextCity(X,Y,Old):-
  flight(X,Y),
  not(member(Y,Old)).
