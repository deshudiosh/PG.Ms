try (destroyDialog PGMicromesh) catch()

rollout PGMicromesh "PG Micromesh" width:250 (

	local copiedNodes = #()
	
	fn clearNodes = (
		if copiedNodes.count > 0 do delete copiedNodes
		copiedNodes = #()
	)
	
	fn mergeNodes = (
		j = 1
  		count = copiedNodes.count
  			
  		undo off
  		(
  			while copiedNodes.count > 1 do
  			(				
  				--if classof objArr[j] != Editable_Poly then converttopoly objArr[j]
  				polyop.attach copiedNodes[j] copiedNodes[j+1]
  				deleteItem copiedNodes (j+1)
  				j += 1
  					
  				if (j + 1) > copiedNodes.count then j = 1
  			)
  		)
  		
		select copiedNodes
	)
	
	
	-- function WorldSpaceToFFDSpace by Neil Marshall 12/31/2011
	-- https://neiltech.wordpress.com/2011/12/31/maxscript-converting-between-ffd-space-and-world-space/
	fn WorldSpaceToFFDSpace obj ffd pos = (
		classof obj  --this is a hack causing a fast reevaluation of the stack! http://forums.cgsociety.org/showthread.php?p=2945244#post2945244
		objTM = obj.objecttransform
		modTM = (getModContextTM obj ffd) * ffd.lattice_transform.value
		modBBMin = getModContextBBoxMin obj ffd
		modBBMax = getModContextBBoxMax obj ffd
		size = modBBMax - modBBMin
		thePoint = (pos * (inverse objTM) * (inverse modTM) - modBBMin) / size
		thePoint
	)

	-----------------

	struct vertex (idx, pos, childPos, normal)

	fn getVertNormal target vertIdx = (
		local vertFaces = polyOp.getFacesUsingVert target vertIdx
		local normal = [0,0,0]
		for faceIdx in vertFaces do normal += polyOp.getFaceNormal target faceIdx node:target
		normalize (normal / vertFaces.count)
	)

	fn ffdSourceToVerts src polyVerts orientation side = (
		local obj = copy src
		local ffd = ffdBox()
		setDimensions ffd [2, 2, 2]
		addmodifier obj ffd
		animateAll ffd
		
		-- control points
		local cps = ffd["Master"]
		
		local map = case orientation of (
			1: #(2,3,1,4) --up
			2: #(4,1,3,2) --down
			3: #(3,4,2,1) --left
			4: #(1,2,4,3) --right
		)
		
		for i=1 to 4 do (
			local pos = WorldSpaceToFFDSpace obj ffd polyVerts[map[i]].pos
			local childPos = WorldSpaceToFFDSpace obj ffd polyVerts[map[i]].childPos
			
			if side == 1 then (
				cps[i].value = pos
				cps[i+4].value = childPos
			)
			else  (
				cps[i].value = childPos
				cps[i+4].value = pos
			)
		)

		obj --return created copy
	)

	fn micromesh target src offsetDist orientation side = (
		
		-- CREATE VERT STRUCTS --> pos and childPos holders
		local verts = for vertIdx=1 to (polyop.getNumVerts target) collect (
			local pos = polyOp.getVert target vertIdx
			local normal = getVertNormal target vertIdx
			local childPos = pos + normal * offsetDist
			vertex vertIdx pos childPos normal
		)
		
		-- COLLECT VERTS FOR EACH POLYGON
		local vertsPerPoly = for polyIdx=1 to (polyOp.getNumFaces target) collect (
			local vertIdxes = polyOp.getFaceVerts target polyIdx
			for idx in vertIdxes collect ( verts[idx] )
		)
			
		-- FOR EACH POLY, CONFORM SOURCE
		for polyVerts in vertsPerPoly do (
			local obj = ffdSourceToVerts src polyVerts orientation side
			append copiedNodes obj
		)
		
		--select copiedNodes
		
		-- ATTACH TO SINGLE OBJ AND WELD
		--for i=2 to objs.count do (polyOp.attach objs[1] objs[2])
	)
	
	
	
	group "Target:" (
		pickbutton uiTarget "..."
		on uiTarget picked obj do uiTarget.text = obj.name
	)
	
	group "Source:" (
		pickbutton uiSource "..."
		on uiSource picked obj do uiSource.text = obj.name
	)
	
	group "Distance:" (
		spinner uiDistance range:[0, 1000, 2] align:#center
	)
	
	group "Orientation:" (
		radiobuttons uiOrientation labels:#("up", "down", "left", "right")
	)
	
	group "Side:" (
		radiobuttons uiSide labels:#("back->front", "front->back")
	)
	
	button uiApply "Apply?" across:3
	button uiCancel "Cancel?" offset:[-20, 0]
	button uiMerge "Attach and Weld"
	
	on uiCancel pressed do (
		clearNodes()
		destroyDialog PGMicromesh
	)
	
	on uiApply pressed do (
		deselect selection
		clearNodes()
		with redraw off ( 
			--undo "Micromesh" on (
				micromesh uiTarget.object uiSource.object uiDistance.value uiOrientation.state uiSide.state
			--) 
		)
	)
	
	on uiMerge pressed do (
		--mergeNodes()
	)
		
)

clearlistener()
createDialog PGMicromesh

