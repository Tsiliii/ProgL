conditions(Dictionary,Mid,0):-
    get_assoc(Mid,Dictionary,Value), Value =< 0 -> true;false.
conditions(Dictionary,Mid,1):-
    get_assoc(Mid,Dictionary,Value), Value =< 1 -> true;false.
conditions(Dictionary,Mid,Ranger):-
    get_assoc(Mid,Dictionary,Value), Value =< Ranger -> true;
                                                        NewRanger is Ranger - 1, get_assoc(Mid-1,Dictionary,NewRanger),get_assoc(Mid+1,Dictionary,NewRanger).

foreveryinput([],Answer,X):-
    reverse(Answer,NewAnswer),
    X = NewAnswer.

foreveryinput([Head|Tail],Answer,X):-
    [Lin, Rin, _, _] = Head,
    empty_assoc(Dictionary),
    Mid is (Lin+Rin)//2, Range is Rin - Mid,
    put_assoc(Mid, Dictionary, Range, NewDictionary),
    %print(Tail), nl,
    solver(Head,[],[],NewDictionary,Answer,[],['h'],Tail,0,X).

success(Lin,Rin,Lout,Rout):-
    Lin >= Lout,
    Rin =< Rout.

solver(_,[],[],_,Answer,_,[],Tail,_,X):-
    NewAnswer = ['IMPOSSIBLE'|Answer],foreveryinput(Tail,NewAnswer,X).

solver(_,_,_,_,Answer,_,_,Tail,1000000,X):-
    NewAnswer = ['IMPOSSIBLE'|Answer],foreveryinput(Tail,NewAnswer,X).

solver([Lin,Rin,Lout,Rout],_,_,_,Answer,[],_,Tail,_,X):-
    success(Lin,Rin,Lout,Rout) -> NewAnswer = ['EMPTY'|Answer],foreveryinput(Tail,NewAnswer,X).

solver([_,_,Lout,Rout],[],[SecondH|SecondT],NewDictionary,Answer,_,[],Tail,I,X):-
    NewI is I+1,
    reverse([SecondH|SecondT],NewSecond),
    %print(NewSecond), nl,
    [SecH|SecT] = NewSecond,
    [String,Lin,Rin] = SecH,
    %length(String,Length),
    %print(Length),nl,%print(String),print(' '),print(Lin),print(' '),print(Rin),print(' '),print(Lout),print(' '),print(Rout),print(' '),nl,
    (success(Lin,Rin,Lout,Rout) -> reverse(String,Temp1),atomic_list_concat(Temp1,Temp2),NewAnswer = [Temp2|Answer],Temp = Tail,foreveryinput(Temp,NewAnswer,X);
                                solver([Lin,Rin,Lout,Rout],SecT,[],NewDictionary,Answer,String,['h'],Tail,NewI,X)).

solver([_,_,Lout,Rout],[FirstH|FirstT],Second,NewDictionary,Answer,_,[],Tail,I,X):-
    NewI is I+1,
    [String,Lin,Rin] = FirstH,
    %length(String,Length),
    %print(Length),nl,%print(String),print(' '),print(Lin),print(' '),print(Rin),print(' '),print(Lout),print(' '),print(Rout),print(' '), nl,
    (success(Lin,Rin,Lout,Rout) -> reverse(String,Temp1),atomic_list_concat(Temp1,Temp2),NewAnswer = [Temp2|Answer],Temp = Tail,foreveryinput(Temp,NewAnswer,X);
                                solver([Lin,Rin,Lout,Rout],FirstT,Second,NewDictionary,Answer,String,['h'],Tail,NewI,X)).

solver([Lin,Rin,Lout,Rout],First,[],NewDictionary,Answer,String,[],Tail,I,X):-
    solver([Lin,Rin,Lout,Rout],[],First,NewDictionary,Answer,String,[],Tail,I,X).

solver([Lin,Rin,Lout,Rout],First,Second,Dictionary,Answer,String,['h'],Tail,I,X):-
    L1 is Lin//2, R1 is Rin//2, Mid is (R1+L1)//2, Range is R1 - Mid,
    (conditions(Dictionary,Mid,Range) -> solver([Lin,Rin,Lout,Rout],First,Second,Dictionary,Answer,String,['t'],Tail,I,X);
        put_assoc(Mid,Dictionary,Range,NewDictionary),solver([Lin,Rin,Lout,Rout],First,[[['h'|String],L1,R1]|Second],NewDictionary,Answer,String,['t'],Tail,I,X)).

solver([Lin,Rin,Lout,Rout],First,Second,Dictionary,Answer,String,['t'],Tail,I,X):-
    L1 is (Lin*3)+1, R1 is (Rin*3)+1, Mid is (R1+L1)//2, Range is R1 - Mid,
    (R1 > 1000000 -> solver([Lin,Rin,Lout,Rout],First,Second,Dictionary,Answer,String,[],Tail,I,X);
    (conditions(Dictionary,Mid,Range)->  solver([Lin,Rin,Lout,Rout],First,Second,Dictionary,Answer,String,[],Tail,I,X);
         put_assoc(Mid,Dictionary,Range,NewDictionary),solver([Lin,Rin,Lout,Rout],First,[[['t'|String],L1,R1]|Second],NewDictionary,Answer,String,[],Tail,I,X))).

ztalloc(File,Answer):-
    open(File, read, Str),
    read_file(Str,[_|Lines]),
    close(Str),
    once(foreveryinput(Lines,[],Answer)).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream,Codes),
    atom_codes(Atom, Codes),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, X),
    read_file(Stream,L), !.
