fun colors(filename) =
    let val file = TextIO.openIn filename
        val color = TextIO.inputAll file
        val _ = TextIO.closeIn file
	fun separate([], _) = raise Empty
		|separate(x::_, 1) = String.tokens Char.isSpace x
		|separate(x::y::_, 2) = String.tokens Char.isSpace y
	fun read_N([]) = raise Empty
		| read_N(x::_) = x
	fun read_K([]) = raise Empty
		| read_K(_::y::_) = y
    in
	String.tokens (fn c => c = #"\n") color
	val N = read_N(seperate(color,1))
	print(N)
    end

