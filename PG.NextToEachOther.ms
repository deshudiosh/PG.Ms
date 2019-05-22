fn compareNames str1 str2 = stricmp str1.name str2.name   
-- MyCustomObjs = for obj in selection where (classOf obj != XRefObject) collect obj 
-- qSort MyCustomObjs compareNames 
-- print MyCustomObjs



fn nextToEachOther = (
	objs = selection as array
	qSort objs compareNames
	
	lists = #()
	similarNameLength = 1
	lastname = ""
	
	-- sort objs by name similarity, and add to arrays
	for i = 1 to objs.count do (
		objname = objs[i].name
		
		strippedName = substring objname 1 similarNameLength
		strippedLastName = substring lastname 1 similarNameLength
		
		--if first x characters of name are different then last name, create new array/list
		if (stricmp strippedName strippedLastName) > 0 do (
			newList = #()
			append lists newList
		)
		
		append lists[lists.count] objs[i]
		
		lastname = objname
	)
	
	
	margin = 2
	lastX = 0
	
	for listIdx = 1 to lists.count do (
		
		list = lists[listIdx]
		lastY = 0
		biggestX = 0
		
		col = [(random 100 255), (random 100 255), (random 100 255)] as color
		
		for objsInListIdx = 1 to list.count do (
			obj = list[objsInListIdx]
			half = (obj.max - obj.min)/2
			obj.pos.y = half.y + lastY + margin
			obj.pos.x = lastX
			
			obj.wirecolor = col
			
			lastY = obj.max.y
			
			if (half.x*2 > biggestX) do (
				biggestX = half.x
			)
		)
		
		
		-- TO NAPISZ JAKOS KURWA SENSOWNIE
		lastX = lastX + 50
	)
	
		
)

nextToEachOther()