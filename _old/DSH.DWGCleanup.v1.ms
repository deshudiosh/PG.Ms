fn cleanDwg objs = (
	
	blocks = #()
	
	progressstart "Cleaning - unlinking..."
	
	for i = 1 to objs.count do (
		progressupdate (100.0 * i / objs.count)
				
		obj = objs[i]
		
		if classof obj == LinkComposite then (
			append blocks obj
		) else (
			obj.transform.controller = prs()
			if classof obj.parent == undefined
		)
	)
	
	progressend()
	
	
	
-- 	progressstart "Cleaning - removing..."
-- 	for j = 1 to blocks.count do (
-- 		progressupdate (100.0 * j / blocks.count)
-- 		delete blocks[j]
-- 	)
-- 	progressend()
	
)

clearlistener()
cleanDwg selection