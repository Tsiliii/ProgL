structure Cmap = BinaryMapFn(struct
				type ord_key = int*int
				fun compare((x1,y1),(x2,y2)) = 
				if x1<x2 then LESS else if x1>x2 then GREATER else if y1<y2 then LESS else if y1>y2 then GREATER else EQUAL
			end)

fun savethecat fileName =
	let
		fun parse file =
			let
				(* A function to read an integer from specified input. *)
				fun readInt input =
					Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
				(* Open input file. *)
				val inStream = TextIO.openIn file

				(* Read an integer (number of countries) and consume newline. *)
				val n = readInt inStream
				val k = readInt inStream
				val _ = TextIO.inputLine inStream

				(* A function to read N integers from the open file. *)
				fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
				  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
			in
				(n,k, readInts n [])
			end
	in
		savethecat_solution (parse fileName)
	end
