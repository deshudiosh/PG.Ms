rollout DWGCleanup "DWGCleanup by Pawel Grzelak" width:360 (
		
	global DWGCleanupDwgLayerName = "_DWG"
	global DWGCleanupBlocksLayerName = "_BLOCKS"

	fn unlinkObjects objs = (
		print "DWGCleanup - Unlinking..."

		progressstart "DWGCleanup - Unlinking..."
		
		for i = 1 to objs.count do (
			progressupdate (100.0 * i / objs.count)
					
			obj = objs[i]
			obj.transform.controller = prs()
			obj.parent == undefined
		)
		
		progressend()
	)

	fn removeMaterial objs = (
		print "DWGCleanup - Removing Materials..."
		objs.material = undefined
	)

	fn wireColorFromLayer objs = (
		print "DWGCleanup - Applying wire colors..."
		
		progressstart "DWGCleanup - Applying wire colors..."
		for i = 1 to objs.count do (
			progressupdate (100.0 * i / objs.count)
			
			obj = objs[i]
			obj.colorbylayer = false
			obj.wirecolor = obj.layer.wireColor
		)
		progressend()
	)

	fn moveToLayer layerName objs = (
		print "DWGCleanup - Moving elements to one layer..."
		layer = LayerManager.getLayerFromName layerName
		if layer == undefined do layer = LayerManager.newLayerFromName layerName
		
		for obj in objs do layer.addnode obj
	)

	fn moveBlocksToLayer layerName objs = (
		print "DWGCleanup - Moving blocks to one layer..."
		
		blocks = for obj in objs where (classof obj == LinkComposite) collect obj
		
		layer = LayerManager.getLayerFromName layerName
		if layer == undefined do layer = LayerManager.newLayerFromName layerName
			
		for obj in blocks do layer.addnode obj
		
		layer.isHidden = true
		layer.isFrozen = true
	)

	fn removeLayers deleteEmpty deleteHidden = (
		print "DWGCleanup - Removing layers..."
		
		layersToDelete = #()
		

		for i = 0 to LayerManager.count - 1 do (		
			ilayer = LayerManager.getLayer i
			layerName = ilayer.name
			layer = ILayerManager.getLayerObject i
			layer.nodes &nodes
				
			-- if is empty 
			if deleteEmpty AND nodes.count == 0 do (append layersToDelete #(layerName, nodes))
				
			-- if is hidden
			if deleteHidden AND layer.isHidden AND layer.name != DWGCleanupBlocksLayerName do (
	--			delete nodes
				append layersToDelete #(layerName, nodes)
			)
		)
		
		progressstart "DWGCleanup - Removing layers..."
		for i = 1 to layersToDelete.count do (
			progressupdate (100.0 * i / layersToDelete.count)
			layerName = layersToDelete[i][1]
			layerNodes = layersToDelete[i][2]
			
			delete layerNodes
			LayerManager.deleteLayerByName layerName
		)
		progressend()
	)

	fn collectVisibleElementsExceptBlocks = (
		collected = for obj in objects where ( \
			classof obj != LinkComposite AND obj.layer.isHidden == false AND obj.layer.name != DWGCleanupDwgLayerName \
			) collect obj
			
		collected
	)



	local space = 10
	local separator = bitmap 350 1 color:[128,128,128]
	
	checkbox cbUnlink "1. Remove Parent/Child linkage" enabled:false checked:true offset:[0, space]
	checkbox cbRemoveMaterials "2. Remove Materials" checked:true
	checkbox cbWireColors "3. Assign Wire Color From Layer Color" checked:true
	local drawingCbName = "4. Move Splines and Meshes To Separate Layer: '" + DWGCleanupDwgLayerName + "'"
	checkbox cbMoveDrawing drawingCbName checked:true
	local blocksCbName = "5. Move Blocks/Style Parent Objects To Separate Layer: '" + DWGCleanupBlocksLayerName + "'"
	checkbox cbMoveBlocks blocksCbName checked:true
	checkbox cbRemoveEmpty "6. Remove Empty Layers" checked:true
	checkbox cbRemoveHidden "7. Remove Hidden Layers and their Nodes" checked:true
	
	imgTag s1 bitmap:separator align:#center offset:[0, space]
	
	button btnClean "Cleanup!" width:150 height:40 across:2 offset:[0, space]
	button btnSaveSelected "Save cleaned to .max file" width:150 height:40 offset:[0, space] enabled:false
	
	on btnClean pressed do (
		print "DWGCleanup - Start!"
		
		clearNodeSelection()
		
		objs = collectVisibleElementsExceptBlocks()
		
		if cbUnlink.checked do unlinkObjects objs
		if cbRemoveMaterials.checked do removeMaterial objs
		if cbWireColors.checked do wireColorFromLayer objs
		if cbMoveDrawing.checked do moveToLayer DWGCleanupDwgLayerName objs
		if cbMoveBlocks.checked do moveBlocksToLayer DWGCleanupBlocksLayerName objects
		removeLayers cbRemoveEmpty.checked cbRemoveHidden.checked
		
		print "DWGCleanup - Finished!"
		
		btnSaveSelected.enabled = true
	)
	
	on btnSaveSelected pressed do (
		select (collectVisibleElementsExceptBlocks())
	)
		
	imgTag s2 bitmap:separator align:#center offset:[0, space]

	label theLabel3 "by Pawel Grzelak" offset:[0, space]
	hyperlink www "www.pawelgrzelak.com" align:#center address:"http://pawelgrzelak.com" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
	
	on dial close do () 
)
createDialog DWGCleanup


