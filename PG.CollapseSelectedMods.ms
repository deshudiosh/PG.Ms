--TODO: 
-- SELECT TOPMOST  MOD !!!!!

fn getSelectedModsIndexes = (
	LB_GETCOUNT= 0x18B
	LB_GETSEL = 0x187
	 
	hwnd = (windows.getChildHWND #max "Command Panel")[1]
	list_box = for c in windows.getChildrenHWND hwnd   where  c[4] == "ListBox" do exit with c[1]
		 
	count = windows.SendMessage list_box LB_GETCOUNT 0 0
	 
	items = for i=0 to count-1 where (windows.SendMessage  list_box  LB_GETSEL i 0) == 1 collect (i+1)
		
	items = for k in items collect (if k > $.modifiers.count then continue else k)
	items
)

fn routine obj mods = (
	-- DUPLICATE OBJ
	local dup = copy obj
	
	-- REMOVE ALL MODS ABOVE SELECTED ONES (ON COPY)
	for i = 1 to (mods[1] - 1) do ( deleteModifier dup 1 )
	maxOps.CollapseNode dup true
	numfaces = getNumFaces dup
	
	-- ON ORIG, REMOVE SELECTED MODS
	for i = 1 to mods.count do ( deleteModifier obj mods[1] )
	
	-- ON ORIG ADD EDIT POLY MOD 
	local ep = edit_poly()
	ep.name += " (c)"
	addmodifier obj ep before:(mods[1]-1)
	
	-- REMOVE ALL POLYS INSIDE
	max modify mode
	modPanel.setCurrentObject ep
	subObjectLevel = 4
	EditPolyMod.select ep #Face #{1..numfaces}
	EditPolyMod.ButtonOp ep #DeleteFace
	
	-- ATTACH COPY AND DISABLE EDITING
	ep.attach dup
	subObjectLevel = 0
)

fn collapseSelectedMods = (
	--IF ONE OBJECT SELECTED
	if selection.count == 1 do (
		--IF MODIFY PANEL VISIBLE
		if modPanel.getCurrentObject() != undefined do (
			
			local mods = getSelectedModsIndexes()
			local adjacent = ((findItem (for i = 2 to mods.count collect (mods[i] - mods[i-1] == 1)) false) == 0)
			
			if mods.count == 0 do ( messagebox "Select modifiers in stack first." )
			if mods.count == 1 do ( messagebox "There is no sense to collapse one modifier maaan!" )
			if mods.count > 1 do (
				if not adjacent then messagebox "Only adjacent modifiers can be collapsed."
				else routine $ mods
			)
		)
	)
)

clearlistener()
collapseSelectedMods()
