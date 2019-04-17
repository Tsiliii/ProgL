fun read_N([], _) = raise Empty
	| read_N(x::_,_) = x
fun read_K([], _) = raise Empty
	| read_K(x::y::_,_) = y
