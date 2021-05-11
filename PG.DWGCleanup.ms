-- Developed by Pawel Grzelak
-- www.pawelgrzelak.com
 
(
	rollout DWGCleanup "DWGCleanup by Pawel Grzelak" width:360 (
			
		global DWGCleanupDwgLayerName = "_DWG"
		global DWGCleanupBlocksLayerName = "_BLOCKS"

		fn unlinkObjects objs = (
			print "DWGCleanup - Unlinking..."

			progressstart "DWGCleanup - Unlinking..."
			
			for i = 1 to objs.count do (
				progressupdate (100.0 * i / objs.count)
						
				obj = objs[i]
				if (classof obj.parent == LinkComposite) do (
					obj.transform.controller = prs() --assign position/rotation/scale controller
					obj.parent == undefined
				)
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
				
				if obj != undefined do (
					--search for material diffuse color first, then try layer color
					diffcol = undefined
					if obj.material != undefined then (
						if hasProperty obj.material "diffuse" do diffcol = obj.material.diffuse
						if hasProperty obj.material "Metal_Color" do diffcol = obj.material.Metal_Color
						if hasProperty obj.material "Generic_Color" do diffcol = obj.material.Generic_Color
					)
					
					-- if white or black try to get color from layer
					if diffcol == undefined or diffcol == (color 0 0 0) or diffcol == (color 255 255 255) then (
						diffcol = obj.layer.wireColor
					)
					
					if diffcol == undefined do diffcol = gray 
									
					obj.colorbylayer = false
					obj.wirecolor = diffcol
				)
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

		local space = 5
		local separator = bitmap 350 1 color:[128,128,128]
		
		checkbox cbUnlink "1. Remove Parent/Child linkage" enabled:true checked:true offset:[0, 5]
		checkbox cbRemoveMaterials "2. Remove Materials" checked:true
		checkbox cbWireColors "3. Assign Wire Color from Material of from Layer Color" checked:true
		local drawingCbName = "4. Move Splines and Meshes To Separate Layer: '" + DWGCleanupDwgLayerName + "'"
		checkbox cbMoveDrawing drawingCbName checked:false
		local blocksCbName = "5. Move Blocks/Style Parent Objects To Separate Layer: '" + DWGCleanupBlocksLayerName + "'"
		checkbox cbMoveBlocks blocksCbName checked:true
		checkbox cbRemoveEmpty "6. Remove Empty Layers" checked:true
		checkbox cbRemoveHidden "7. Remove Disabled Layers and their Nodes" checked:true
		
		imgTag s1 bitmap:separator align:#center offset:[0, 5]
		
		button btnClean "Cleanup!" width:150 height:40 offset:[0, 5]
		
		on btnClean pressed do (
			print "DWGCleanup - Start!"
			
			clearNodeSelection()
			
			objs = collectVisibleElementsExceptBlocks()
			
			if cbUnlink.checked do unlinkObjects objs
			if cbWireColors.checked do wireColorFromLayer objs
			if cbRemoveMaterials.checked do removeMaterial objs
			if cbMoveDrawing.checked do moveToLayer DWGCleanupDwgLayerName objs
			if cbMoveBlocks.checked do moveBlocksToLayer DWGCleanupBlocksLayerName objects
			removeLayers cbRemoveEmpty.checked cbRemoveHidden.checked
			
			print "DWGCleanup - Finished!"
		)
		
		on dial close do () 
	)
	createDialog DWGCleanup
)


