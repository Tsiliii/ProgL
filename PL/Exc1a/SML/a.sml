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
	fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	(n,k, readInts n [])
    end

	structure Cmap = BinaryMapFn(struct
		type ord_key = int
		fun compare(x,y) = 
		if x<y then LESS else if x>y then GREATER else EQUAL
	end)


fun addnode(ar,nodekey:int) =
	if Cmap.find(ar,nodekey) = NONE then Cmap.insert(ar,nodekey,1) 
	else Cmap.insert(ar,nodekey,valOf(Cmap.find(ar,nodekey))+1)

fun removenode(ar,nodekey:int) =
	let 
		val (x,y) = Cmap.remove(ar,nodekey)
	in
		if (y = 1) then x
		else Cmap.insert(x,nodekey,y-1)
	end


fun add(curr:int list,ar,ans:int,n:int,k:int,l:int list) =	
	let
		val y = hd l
		val z = rev curr	
	in
		(*if l = [1,3,1,3,1,3,3,2,2,1] then (curr,ar,ans,n,k,(tl l)) *)
		(rev(y::z),addnode(ar,(hd l)),ans,n,k,(tl l))
	end	
fun rem(curr:int list,ar,ans:int,n:int,k:int,l:int list) =
	(tl(curr),removenode(ar,hd(curr)),ans,n,k,l)

fun min(ans:int,curr:int list) =
	let 
		val len=length(curr)
	in
		if len<ans then len
		else ans
	end

fun cr(curr:int list,ar,ans:int,n:int,k:int,l:int list) =
		
	if Cmap.numItems(ar) < k andalso l <> [] then cr(add(curr,ar,ans,n,k,l))
	else if Cmap.numItems(ar) = k then cr(rem(curr,ar,min(ans,curr),n,k,l))
	else if (ans=n+1) then 0
	else ans

fun colors_solution(n:int,k:int,l:int list) =
	let
		val ans = n+1
		val ar = Cmap.empty
		val curr = []
	in
		cr(curr,ar,ans,n,k,l)
	end


fun colors fileName = colors_solution (parse fileName)
