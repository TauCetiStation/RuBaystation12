
/obj/MBT_mark/Del

	New()
		if (src.loc.contents.len)
			for(var/obj/I in src.loc.contents)
				del(I)
		spawn(1)
			del src

/obj/MBT_mark/Del/S_Del

	New()
		spawn()
			var/turf/T = get_turf(src)
			T.ChangeTurf(/turf/space)
		..()

/obj/MBT_mark/Del/P_Del

	New()
		spawn()
			var/turf/T = get_turf(src)
			T.ChangeTurf(/turf/simulated/floor/plating)
		..()

/obj/Mega_Build_Tool
	icon = 'icons/obj/items.dmi'
	icon_state = "upickaxe"
	name = "Tool of God"
	var/win = "window=MBT,size=600x400"

	var/COD = "3 1 1 1 1 1 1 1 1 3\n3 2 2 2 2 2 2 2 2 3\n3 2 2 2 2 2 2 2 2 3\n3 2 2 1 1 4 1 2 2 3\n3 2 2 1 2 2 1 2 2 3\n3 2 2 1 2 2 1 2 2 3\n3 2 2 1 3 3 1 2 2 3\n3 2 2 2 2 2 2 2 2 3\n3 2 2 2 2 2 2 2 2 3\n3 1 1 1 4 4 1 1 1 3"

	var/error

	var/LG = "1 /turf/simulated/wall\n2 /turf/simulated/floor/plating\n3 /turf/simulated/floor/plating /obj/structure/grille /obj/structure/window/reinforced\n4 /turf/simulated/floor/plating /obj/machinery/door/airlock"

	var/list/grid = new/list(10,10)
	var/DrX = 10
	var/DrY = 10
	
	var/dX = 0
	var/dY = 0

	var/list/A ()
	var/list/B ()

	var/list/LeG=new/list()

	var/list/LGL()
	LGL = new/list(2,2)

	Click(location, control, params)
		var/list/pa = params2list(params)

		Viev()

		if (src.loc!=usr)
			src.loc=usr
			GUI()

		if(pa.Find("middle"))
			if (win=="_")
				win = "window=MBT,size=600x400"
			else
				win="_"


	verb/GUI()
		set category = "Mega Build Tool"

		var/obj/Mega_Build_Tool/B = src
		B.loc = usr
		B.screen_loc = "NORTH,EAST"
		usr.client.screen += B

	verb/GUI_Exit()
		set category = "Mega Build Tool"
		usr.client.screen -= src

	verb/MBT_Del()
		set category = "Mega Build Tool"
		del(src)

	proc
		Viev(mob/user)
			var/t = "<TT><B>Tool of God</B><HR>"
			t += "<B><span class='danger'>[error]</span></B><HR>"
			t += "<BR>Current position: [usr.x] : [usr.y]<BR>"
			t += "<BR>Build shift: [dX] : [dY] <A href='?src=\ref[src];action=Edit d'>Edit</A><BR>"
			t += "<BR><A href='?src=\ref[src];action=Make blank drawning'>Make blank drawning</A><BR>"
			t += "<HR>"
			t += "<BR><A href='?src=\ref[src];action=Change drawning'>Edit drawning pointed</A><BR>"
			t += "<BR><A href='?src=\ref[src];action=Enter LG'>Edit LG</A><BR>"
			t += "<HR>"
			t += "<BR><A href='?src=\ref[src];action=Import LG'>Import LG</A><BR>"
			t += "<BR><A href='?src=\ref[src];action=Import drawning'>Import drawning</A><BR>"
			t += "<HR>"
			t += "<BR><A href='?src=\ref[src];action=Use God POWER'>Use God POWER</A><BR>"
			t += "<BR></table></FONT></PRE></TT>"
			usr << browse(t, win)

		LG()
			var/L_Y = length(LGL)
			var/LG_D = "<CENTER><TT><B>LG</B><BR><A href='?src=\ref[src];action=LG add line'>LG add line</A>	<A href='?src=\ref[src];action=return'>Return</A><HR></CENTER>"
			for(var/y = 1, y <= L_Y, y++)
				var/L_X = length(LGL[y])
				for(var/x = 1,x <= L_X, x++)
					LG_D += "	<A href='?src=\ref[src];action=LG act;param_X=[x];param_Y=[y]'>[LGL [y][x]]</A>"
					if(x==1)	LG_D += "	||"
				LG_D += "	<A href='?src=\ref[src];action=LG add path;param_Y=[y]'>+</A>"
				LG_D += "	<A href='?src=\ref[src];action=LG del path;param_Y=[y]'>-</A>"
				LG_D += "<BR>"
			usr << browse(LG_D, win)

		CD()
			var/L_Y = length(grid)
			var/CD = "<CENTER><TT><B>Change Drawning</B><BR><A href='?src=\ref[src];action=return'>Return</A><HR></CENTER>"
			for(var/y = 1, y <= L_Y, y++)
				var/L_X = length(grid[y])
				for(var/x = 1,x <= L_X, x++)
					CD += "	<A href='?src=\ref[src];action=CD act;param_X=[x];param_Y=[y]'>[grid [y][x]]</A>"
				CD += "<BR>"
			usr << browse(CD, win)

	Topic(href, list/href_list)
		error = ""
		switch(href_list["action"])
			if("return")
				Viev()
				return

			if("Enter LG")
				LG()
				return

			if("LG add line")
				var/list/NL = list("Key", "Path")
				var/M = LGL.len
				LGL.Add(1)
				LGL[M+1] = NL
				LG()
				return

			if("LG add path")
				var/Y = text2num(href_list["param_Y"])
				var/list/L = LGL[Y]
				L.Add("Path")
				LG()
				return

			if("LG del path")
				var/Y = text2num(href_list["param_Y"])
				var/list/L = LGL[Y]
				var/Llen = L.len
				if(L[Llen]==""||"Path"||"_")	L.len--
				LG()
				return

			if("LG act")
				var/X = text2num(href_list["param_X"])
				var/Y = text2num(href_list["param_Y"])
				var/inp = input("","",LGL [Y][X]) as message
				if(inp==" "||"") inp = "_"
				LGL [Y][X] = inp
				LG()
				return

			if("Change drawning")
				CD()
				return

			if("CD act")
				var/X = text2num(href_list["param_X"])
				var/Y = text2num(href_list["param_Y"])
				grid [Y][X] = input("","",grid [Y][X]) as text
				CD()
				return

			if("Import drawning")
				COD = input("Enter what you want to build:", "Drawning", "[COD]", null)  as message
				A = text2list(COD, "\n") // A -> cod1|cod2|cod3
				grid = new/list(length(A),0)
				for(var/u = 1, u <= length(A), u++)
					B = text2list(A [u], " ") // B -> n11 n12 n13|n21 n22 n23|...
					for(var/i = 1, i <= length(B), i++)
						var/list/L = grid[u]
						L.Add("[B[i]]")
					del(B)
				del(A)
				Viev()
				return

			if("Import LG")
				LG = input("Enter LG:", "LG", "[LG]", null)  as message
				LeG = list (  )
				A = text2list(LG, "\n") // A -> cod1|cod2|cod3
				LGL = new/list(length(A),0)
				for(var/u = 1, u <= length(A), u++)
					B = text2list(A [u], " ") // B -> n11 n12 n13|n21 n22 n23|...
					for(var/i = 1, i <= length(B), i++)
						var/list/L = LGL[u]
						L.Add("[B[i]]")
					del(B)
				del(A)
				Viev()
				return

			if("Edit d")
				dX = text2num(input("Enter dX:", "dX", "[dX]", null))
				dY = text2num(input("Enter dY:", "dY", "[dY]", null))

				Viev()
				return

			if("Make blank drawning")
				DrX = text2num(input("Enter X:", "Drawning X", "[DrX]", null))
				DrY = text2num(input("Enter Y:", "Drawning Y", "[DrY]", null))
				var/fill = input("", "", "0", null)
				grid = new/list(DrX,DrY)
				error += "Drawning [DrX]:[DrY] - this is [DrX*DrY] turfs!"
				for(var/u = 1, u <= length(grid), u++)
					for(var/i = 1, i <= length(grid[u]), i++)
						grid[u][i] = fill
				Viev()
				return

			if("Use God POWER")

				LeG=new/list(length(LGL))
				for(var/y = length(LGL), y >= 1, y--)
					LeG[y] = LGL[y][1]

				var/L_Y = length(grid)

				var/B_X = usr.x-1 + dX
				var/B_Y = usr.y+L_Y + dY
				var/B_Z = usr.z

				for(var/y = 1, y <= L_Y, y++)
					var/L_X = length(grid[y])
					for(var/x = 1,x <= L_X, x++)

						if (LeG.Find(grid [y][x]))
							var/list/L = LGL [LeG.Find(grid [y][x])]

							for(var/e = 2, e <= L.len, e++)
								var/o = text2path(L[e])

								if(ispath(o,/turf))
									var/turf/T = get_turf(locate(B_X+x,B_Y-y,B_Z))
									T.ChangeTurf(o)
								else
									var/obj/A = new o (get_turf(locate(B_X+x,B_Y-y,B_Z)))
									A.set_dir(NORTHWEST)

				Viev()
				return
