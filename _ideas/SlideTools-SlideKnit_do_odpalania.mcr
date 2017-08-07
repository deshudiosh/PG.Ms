fn getArrayOfMapVerts2Verts theObj theMapChannel =
(
	-- See cgsociety post here : http://forums.cgsociety.org/showpost.php?p=3284889&postcount=2
	-- Nice one, arketip!
	numMapVerts = meshOp.getNumMapVerts theObj theMapChannel
	mapVerts2Verts = for mv=1 to numMapVerts collect #()
	numMapFaces = meshOp.getNumMapFaces theObj theMapChannel
	for f = 1 to numMapFaces do
	(
		theMapFace = meshOp.getMapFace theObj theMapChannel f
		theMapFace = #(theMapFace.x as integer,theMapFace.y as integer,theMapFace.z as integer)
		meshFace = getFace theObj f
		meshFace = #(meshFace.x as integer,meshFace.y as integer,meshFace.z as integer)
		for mv=1 to theMapFace.count do
		(
			mapVert = theMapFace[mv]
			if findItem mapVerts2Verts[mapVert] meshFace[mv] == 0 do append mapVerts2Verts[mapVert] meshFace[mv]
		)
	)
mapVerts2Verts
) -- end getArrayOfMapVerts2Verts


fn createMeshFromUVs sourceObj channel UVscale =
(
	-- Create a temporary copy of the source object and clean it up a bit
	tempObj = copy sourceObj
	convertToMesh tempObj
	meshop.deleteIsoMapVertsAll tempObj
	
	-- Does it have UVs in the requested channel?
	channelExists = meshop.getMapSupport tempObj channel
	if(not channelExists)
	then
	(
		messagebox ("The selection has no UV data in channel " + (channel as string))
	)
	else
	(
		-- Generate a lookup table for mapvert indices to vert indices
		mapvertsToVerts = getArrayOfMapVerts2Verts tempObj channel
		
		-- Create a new empty mesh to fill with the new wrap object
		wrapObj = Editable_mesh()
		wrapObj.transform = tempObj.transform
		wrapObj.name = sourceObj.name + "_skWrap"

		-- Create a new empty mesh to fill with the new flat object
		flatObj = Editable_mesh()
		flatObj.transform = tempObj.transform
		flatObj.name = sourceObj.name + "_skFlat_channel" + (channel as string)
		
		-- Calculate how to adjust the flattened vert positions
		reposition = tempObj.position
		reposition.x -= UVscale/2
		reposition.y -= UVscale/2

		-- Copy the mapverts to mesh verts
		numMapVerts = meshop.getNumMapVerts tempObj channel
		meshop.setNumVerts wrapObj numMapVerts
		meshop.setNumVerts flatObj numMapVerts
		for i = 1 to numMapVerts do
		(
			thisMeshVertIndex = mapvertsToVerts[i][1]
			thisMeshVertPosition = meshop.getVert tempObj thisMeshVertIndex
			meshop.setVert wrapObj i thisMeshVertPosition
			thisMapVertPosition = meshop.getMapVert tempObj channel i
			meshop.setVert flatObj i (thisMapVertPosition*UVscale + reposition)
		)

		-- Copy the mapfaces to mesh faces
		numMapFaces = meshop.getNumMapFaces tempObj channel
		meshop.setNumFaces wrapObj numMapFaces
		meshop.setNumFaces flatObj numMapFaces
		for i = 1 to numMapFaces do
		(
			thisMapFace = meshop.GetMapFace tempObj channel i
			thisMapFace = #(thisMapFace.x as integer, thisMapFace.y as integer, thisMapFace.z as integer)
			meshop.createPolygon wrapObj thisMapFace
			meshop.createPolygon flatObj thisMapFace
		)
		
		-- Set up the morpher modifier on the flat object
		addModifier flatObj (Morpher())
		flatObjMorpher = flatObj.modifiers[1]

		completeRedraw() -- otherwise the next line doesn't work...
		WM3_MC_BuildFromNode flatObjMorpher 1 wrapObj

		-- Delete the wrap object
		delete wrapObj
	)
	-- Delete the temp object
	delete tempObj

) -- end createMeshFromUVs


rollout skRollout "SlideKnit" width:160 height:144
(
	label skChannelLabel "UV channel" pos:[8,8] width:56 height:16
	spinner skChannel "" pos:[72,8] width:80 height:16 type:#integer scale:1 range:[1,100,1]
	label skUVScaleLabel "UV scale" pos:[8,32] width:56 height:16
	spinner skUVScale "" pos:[72,32] width:80 height:16 type:#worldunits scale:0.1 range:[0,1000,100]
	button skUnwrap "Unwrap selected" pos:[8,56] width:144 height:32
	label skUVCredit1 "Created by Slide Ltd" pos:[30,96] width:100 height:16
	label skUVCredit2 "contact@slidelondon.com" pos:[16,112] width:128 height:16
	label skVersion "version : 2008-09-25" pos:[30,128] width:100 height:16
	on skUnwrap pressed do
	(
		if (selection.count == 1)
		then
			createMeshFromUVs $ skChannel.value skUVScale.value
		else
			messagebox "Please select a single object"
	)
)

createDialog skRollout