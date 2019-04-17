fun colors(filename) =
    let val file = TextIO.openIn filename
        val color = TextIO.inputAll file
        val _ = TextIO.closeIn file
        fun change x =
            map Int.tostring x
    in
        change(String.tokens (fn c => c = #"\n") color)

    end
