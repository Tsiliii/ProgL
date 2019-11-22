read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

zeroer([0],1).
zeroer([Head|Tail],K):-
        Head is 0,NewK is K-1,zeroer(Tail,NewK),!.

k_list(Start, Start, [Start]).
k_list(Start,K,[Start|L]) :- Start < K, Start1 is Start + 1, k_list(Start1,K,L),!.

has_all([],_):- false.
has_all(List, K) :-
    k_list(1,K,K_list), subset(K_list, List),!.

solver(N,K,[Head1|Tail1],[],Answer,Acc,Tlength,Counter,Assoc):- (Counter =:= K -> get_assoc(Head1, Assoc, CurrValue), (CurrValue =:= 1 -> Answer is min(Acc,Tlength);
                                                                                                                                          NewCurrValue is CurrValue - 1, Tlength1 is Tlength-1, put_assoc(Head1, Assoc, NewCurrValue,Assoc1),solver(N,K,Tail1,[],Answer,min(Acc,Tlength),Tlength1,Counter,Assoc1));
                                                                                  Acc =:= N+1 -> Answer is 0;
                                                                                                 Answer is min(Acc,Tlength)).

solver(N,K,[Head1|Tail1],[Head2|Tail2],Answer,Acc,Tlength,Counter,Assoc):- (Counter =:= K -> get_assoc(Head1, Assoc, CurrValue), (CurrValue =:= 1 -> put_assoc(Head1, Assoc, 0, Assoc1), NewCounter is Counter -1,Tlength1 is Tlength-1,solver(N,K,Tail1,[Head2|Tail2],Answer,min(Acc,Tlength),Tlength1,NewCounter,Assoc1);
                                                                                                                                             NewCurrValue is CurrValue - 1 ,Tlength1 is Tlength-1,put_assoc(Head1, Assoc, NewCurrValue,Assoc1),solver(N,K,Tail1,[Head2|Tail2],Answer,min(Acc,Tlength),Tlength1,Counter,Assoc1));
                                                                                             get_assoc(Head2, Assoc, CurrValue), (CurrValue =:= 0 -> put_assoc(Head2, Assoc, 1, Assoc1), NewCounter is Counter + 1,Tlength1 is Tlength+1,solver(N,K,[Head1|Tail1],Tail2,Answer,Acc,Tlength1,NewCounter,Assoc1);
                                                                                                                                                     NewCurrValue is CurrValue + 1 ,Tlength1 is Tlength+1,put_assoc(Head2, Assoc, NewCurrValue,Assoc1),solver(N,K,[Head1|Tail1],Tail2,Answer,Acc,Tlength1,Counter,Assoc1))).

colors(File,Answer) :-
    read_input(File,N,K,List),
    k_list(1,K,Keys),
    zeroer(Values,K),
    N1 is N+1,
    pairs_keys_values(Pairs, Keys, Values),
    list_to_assoc(Pairs, Assoc),
    solver(N,K,List,List,Answer,N1,0,0,Assoc),!.
