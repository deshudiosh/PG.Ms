global pgMatCopyPaste
(	
	try(destroyDialog pgMatCopyPaste)catch()
	
	rollout pgMatCopyPaste "Mat copy/paste" (
		local maxFile = (GetDir #temp) + "\\pg.matcopypaste.max"
		
		fn copyMat = (
			disablesceneredraw()
			
			obj = selection[1]
			mat = obj.material
			
			cube = box()
			cube.material = mat
			saveNodes cube maxFile
			delete cube
			
			enablesceneredraw()
			redrawviews()
			
			"PG Material Copied"
		)
		
		fn pasteMat = (
			disablesceneredraw()
			
			mergeMAXFile maxFile mergedNodes:&mergedObjs quiet:true
			
			print(mergedObjs)
			cube = mergedObjs[1]
			mat = cube.material
			
			for i = 1 to selection.count do (
				selection[i].material = mat
			)
			
			delete mergedObjs
			
			enablesceneredraw()
			redrawviews()
			
			"PG Material Pasted"
		)
			
		
		button btnCopy "Copy" across:2 pos:[10, 10] width:70
		button btnPaste "Paste" pos:[90, 10] width:70
		
		on btnCopy pressed do ( 
			copyMat() 
			DestroyDialog pgMatCopyPaste
		)
		
		on btnPaste pressed do ( 
			pasteMat() 
			DestroyDialog pgMatCopyPaste
		)
		
		on pgMatCopyPaste open do ( 
		)
	)
	
	createDialog pgMatCopyPaste 170 38
	"PG.MatCopyPaste"
)
