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

flight(erzincan,edirme).

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

% flight(X,izmir). % flight between X and izmir


% a predicate indicating there exist a route between X and Y if there is
% flight between X and Y
route(X,Y) :- flight(X,Y). % route rule

connected(X,Y) :- connected(X,connected(Y,flight(Y,_))).
