p(X) :- member(X,[1,2,3]).

qa(Z) :- p(X), p(Y), Z is X + Y.

qb(Z) :- p(X), !, p(Y), Z is X +Y .

pc(X) :- p(X), !.

qc(Z) :- pc(X), pc(Y), Z is X + Y.
