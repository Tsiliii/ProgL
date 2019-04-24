structure Cmap = BinaryMapFn(struct
				type ord_key = int * int
				fun compare ((x1,y1),(x2,y2)) =
				if x1<x2 then LESS else if x1>x2 then GREATER else if y1<y2 then LESS else if y1>y2 then GREATER else EQUAL
			end)


fun savethecat file =
	let
			(* A function to read an integer from specified input. *)
			(* Open input file. *)
		val inStream = TextIO.openIn file

		fun max(a,b) =
			if a<b then b
			else a

		fun pf(a,i,j,t) =
		let
			val y = Queue.enqueue(a,(i,j,t))
		in
			a
		end

		fun readGrid (y,arr,time_array,cats,water,i:int,j:int,n,m,water_num) =
			case y of NONE => (arr,time_array,cats,water,n,m-1,1,1,water_num,0)
			| SOME(#" ") => readGrid(TextIO.input1 inStream,arr,time_array,cats,water,i,j,n,m,water_num)
			| SOME(#"\n") => readGrid(TextIO.input1 inStream,arr,time_array,cats,water,i+1,0,max(n,i),max(m,j),water_num)
			| SOME(#"A") => readGrid(TextIO.input1 inStream,Cmap.insert(arr,(i,j),#"A"),Cmap.insert(time_array,(i,j),0),pf(cats,i,j,0),water,i,j+1,max(n,i),max(m,j),water_num)
			| SOME(#"W") => readGrid(TextIO.input1 inStream,Cmap.insert(arr,(i,j),#"W"),Cmap.insert(time_array,(i,j),0),cats,pf(water,i,j,0),i,j+1,max(n,i),max(m,j),water_num+1)
			| SOME(#".") =>	readGrid(TextIO.input1 inStream,Cmap.insert(arr,(i,j),#"."),Cmap.insert(time_array,(i,j),0),cats,water,i,j+1,max(n,i),max(m,j),water_num)
			| SOME(#"X") =>	readGrid(TextIO.input1 inStream,Cmap.insert(arr,(i,j),#"X"),Cmap.insert(time_array,(i,j),0),cats,water,i,j+1,max(n,i),max(m,j),water_num)
			| _ => (arr,time_array,cats,water,n,m-1,1,1,water_num,0)

		fun conflict(x,y) =
			if x>y then x
			else y

		fun is_cat (x) =
		case x of #"A" => true
		| #"L" => true
		| #"D" => true
		| #"U" => true
		| #"R" => true
		| _ => false

		fun kill (x) = Char.chr(Char.ord x + Char.ord#"a" - Char.ord#"A")

		fun update_c(arr,time_array,cats,water,i:int,j:int,c:char,t,n,m,cats_num,water_num,water_prev) =
			let
				val	x = Cmap.find(arr,(i,j))
				val	y = Cmap.find(time_array, (i,j))
			in
				case c of #"R" =>
					if j<=m andalso valOf(x) = #"." then  update_c(Cmap.insert(arr,(i,j),c),Cmap.insert(time_array, (i,j),t),pf(cats,i,j,t+1),water,i,j-2,#"L",t,n,m,cats_num+1,water_num,water_prev)
					else if j<=m andalso is_cat(valOf(x)) andalso valOf(y) = t then update_c(Cmap.insert(arr,(i,j),conflict(c,valOf(x))),Cmap.insert(time_array, (i,j),t),cats,water,i,j-2,#"L",t,n,m,cats_num,water_num,water_prev)
				else update_c(arr,time_array,cats,water,i,j-2,#"L",t,n,m,cats_num,water_num,water_prev)
				| #"L" =>
					if j>=0 andalso valOf(x) = #"." then update_c(Cmap.insert(arr,(i,j),c),Cmap.insert(time_array, (i,j),t),pf(cats,i,j,t+1),water,i+1,j+1,#"U",t,n,m,cats_num+1,water_num,water_prev)
					else if j>=0 andalso is_cat(valOf(x)) andalso valOf(y) = t then update_c(Cmap.insert(arr,(i,j),conflict(c,valOf(x))),Cmap.insert(time_array, (i,j), t+1),cats,water,i+1,j+1,#"U",t,n,m,cats_num,water_num,water_prev)
					else update_c(arr,time_array,cats,water,i+1,j+1,#"U",t,n,m,cats_num,water_num,water_prev)
				| #"U" =>
					if i<=n andalso valOf(x) = #"." then update_c(Cmap.insert(arr,(i,j),c),Cmap.insert(time_array, (i,j),t),pf(cats,i,j,t+1),water,i-2,j,#"D",t,n,m,cats_num+1,water_num,water_prev)
					else if i<=n andalso is_cat(valOf(x)) andalso valOf(y) = t then update_c(Cmap.insert(arr,(i,j),conflict(c,valOf(x))),Cmap.insert(time_array, (i,j),t),cats,water,i-2,j,#"D",t,n,m,cats_num,water_num,water_prev)
					else print("U\n") (*update_c(arr,time_array,cats,water,i-2,j,#"D",t,n,m,cats_num,water_num,water_prev)*)
				| #"D" =>
					if i>=0 andalso valOf(x) = #"." then update_cat(Cmap.insert(arr,(i,j),c),Cmap.insert(time_array, (i,j),t),pf(cats,i,j,t+1),water,t,n,m,cats_num+1,water_num,water_prev)
					else if i>=0 andalso is_cat(valOf(x)) andalso valOf(y) = t then update_cat(Cmap.insert(arr,(i,j),conflict(c,valOf(x))),Cmap.insert(time_array, (i,j),t),cats,water,t,n,m,cats_num,water_num,water_prev)
					else update_cat(arr,time_array,cats,water,t,n,m,cats_num,water_num,water_prev)
			end

		and update_cat (arr,time_array,cats,water,t,n,m,cats_num,water_num,water_prev) =
			if Queue.isEmpty(cats) then print(Int.toString(14)) (*update_water(arr,time_array,cats,water,t,n,m,cats_num,water_num,water_prev)*)
			else if cats_num = 5 then
			let
					val (i,j,time) = Queue.dequeue(cats)
					val (ii,jj,tt) = Queue.dequeue(cats)
			in
					print(Int.toString(i) ^","^ Int.toString(j) ^","^ Int.toString(time)^"\n"^Int.toString(ii)^","^Int.toString(jj)^","^Int.toString(tt)^ "\n")
			end
			(*else if  t = 2
			then print("AAA")*)
			else
			let
					val (i,j,time) = Queue.dequeue(cats)
				in
					case time-t of 1 =>  update_cat(arr,time_array,pf(cats,i,j,time),water,t+1,n,m,cats_num,water_num,water_prev) (*print(Int.toString(i) ^","^ Int.toString(j) ^","^ Int.toString(time)^"\n") update_water(arr,time_array,pf(cats,i,j,time),water,t,n,m,cats_num,water_num,water_prev)
*)					| _ => update_c(arr,time_array,cats,water,i,j+1,#"R",t,n,m,cats_num,water_num,water_prev)
				end

		and update_w(arr,time_array,cats,water,i:int,j:int,c:char,t,n,m,cats_num,water_num,water_prev) =
			let
				val x = Cmap.find(arr,(i,j))
				val y = Cmap.find(time_array,(i,j))
			in
				case c of #"R" =>
					if j<=m andalso valOf(x) = #"." then update_w(Cmap.insert(arr,(i,j),#"W"),Cmap.insert(time_array, (i,j),t),cats,pf(water,i,j,t+1),i,j-2,#"L",t,n,m,cats_num,water_num+1,water_prev)
					else if j<=n andalso is_cat(valOf(x)) then update_w(Cmap.insert(arr,(i,j),kill(valOf(x))),Cmap.insert(time_array, (i,j),t),cats,water,i,j-2,#"L",t,n,m,cats_num-1,water_num+1,water_prev)
					else update_w(arr,time_array,cats,water,i,j-2,#"L",t,n,m,cats_num,water_num,water_prev)
				| #"L" =>
					if j>=0 andalso valOf(x) = #"." then update_w(Cmap.insert(arr,(i,j),#"W"),Cmap.insert(time_array, (i,j),t),cats,pf(water,i,j,t+1),i+1,j+1,#"U",t,n,m,cats_num,water_num+1,water_prev)
					else if j>=0 andalso is_cat(valOf(x)) then update_w(Cmap.insert(arr,(i,j),kill(valOf(x))),Cmap.insert(time_array, (i,j),t),cats,water,i+1,j+1,#"U",t,n,m,cats_num-1,water_num+1,water_prev)
					else update_w(arr,time_array,cats,water,i+1,j+1,#"U",t,n,m,cats_num,water_num,water_prev)
				| #"U" =>
					if i>=0 andalso valOf(x) = #"." then update_w(Cmap.insert(arr,(i,j),#"W"),Cmap.insert(time_array, (i,j),t),cats,pf(water,i,j,t+1),i-2,j,#"D",t,n,m,cats_num,water_num+1,water_prev)
					else if i>=0 andalso is_cat(valOf(x)) then update_c(Cmap.insert(arr,(i,j),kill(valOf(x))),Cmap.insert(time_array, (i,j),t),cats,water,i-2,j,#"D",t,n,m,cats_num-1,water_num+1,water_prev)
					else update_w(arr,time_array,cats,water,i-2,j,#"D",t,n,m,cats_num,water_num,water_prev)
				| #"D" =>
					if i<=n andalso valOf(x) = #"." then update_water(Cmap.insert(arr,(i,j),#"W"),Cmap.insert(time_array, (i,j),t),cats,pf(water,i,j,t+1),t,n,m,cats_num,water_num+1,water_prev)
					else if i<=m andalso is_cat(valOf(x)) then update_water(Cmap.insert(arr,(i,j),kill(valOf(x))),Cmap.insert(time_array, (i,j),t),cats,water,t,n,m,cats_num-1,water_num+1,water_prev)
					else update_water(arr,time_array,cats,water,t,n,m,cats_num,water_num,water_prev)
			end

		and update_water(arr,time_array,cats,water,t,n,m,cats_num,water_num,water_prev) =
			if Queue.isEmpty(water) then answer(arr,time_array,cats,water,t,n,m,cats_num,water_num,water_prev)
			else let
				val (i,j,time) = Queue.dequeue(cats)
			in
				case time-t of 1 => answer(arr,time_array,pf(cats,i,j,time),water,t,n,m,cats_num,water_num,water_prev)
				| _ => update_w(arr,time_array,cats,water,i,j+1,#"R",t,n,m,cats_num,water_num,water_prev)
			end

		(*
		fun find_time (*...*)
		fun ananeothikan_nera (*...*)
		*)
		and answer (arr,time_array,cats,water,t,n,m,cats_num,water_num,water_prev) =
			(*...*)
			if Queue.isEmpty(cats) andalso cats_num = 0 then
					print("Cats_num = 0")
			(*print xrono, kiniseis *)
			else if Queue.isEmpty(cats) andalso water_num = water_prev then
					print("Prev = current")
			else update_cat(arr, time_array, cats, water, t+1, n, m,cats_num,water_num,water_prev)

	in
		update_cat(readGrid(TextIO.input1 inStream,Cmap.empty,Cmap.empty,Queue.mkQueue(),Queue.mkQueue(),0,0,0,0,0))
end

(* an oura gates einai mideniki
	an oi gates einai miden sto tablo	}	kalese tin synartisi exoume teleiwsei peta xrono-3, print string twn thesewn
	or den exoun ananeothei ta nera		}*)
