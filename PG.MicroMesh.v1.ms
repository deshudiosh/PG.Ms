global tempbox

fn micromesh target src = (
	-- 1. GET NUMBER OF POLYS
	local polycount = polyOp.getNumFaces target
	local polycountHalf = polycount/2
	
	-- 2. CREATE POLY PAIRS (1 + 21, 2+22, 3+23)
	local polyPairs = for i=1 to polycountHalf collect #(i, i+polycountHalf)
		
	-- 3. ITERATE: COLLECT VERTS POSITIONS FOR EACH PAIR
	local polyPairVertsPositions = #()
	for pair in polyPairs do ( 
		local positions = (getPolyVertPositions target pair[1])
		join positions (getPolyVertPositions target pair[2])
		append polyPairVertsPositions positions
	)
	
	-- 4. ITERATE: COPY SOURCE OBJECT AND APPLY FFD 2X2X2, AND APPLY VERTS POSITIONS TO FFD
-- 	for polyPairVerts in polyPairVertsPositions do (
-- 		ffdSourceToVerts src verts
-- 	)
	ffdSourceToVerts src polyPairVertsPositions[1]
	
)

fn ffdSourceToVerts src verts = (
	local b = box length:1 height:1 width:1
	local ffd = ffdBox()
	setDimensions ffd [2, 2, 2]
	addmodifier b ffd
	animateAll ffd
	
	tempbox = b ---WYWAL TO
	
	-- ASSIGN ffd control points anim tracks array to variable 
	local cps = ffd["Master"]

	cps[1].value = verts[5]
	cps[2].value = verts[6]
	cps[3].value = verts[8]
	cps[4].value = verts[7]
	cps[5].value = verts[3]
	cps[6].value = verts[2]
	cps[7].value = verts[4]
	cps[8].value = verts[1]
	
	
-- 	for i=1 to verts.count do (
		--ffd["Master"][i].value = verts[i]
		--text size:2 pos:vert isSelected:off text:(i as String)
-- 	)
)

fn getPolyVertPositions target polyIdx = (
 	local faceVertsIdxs = polyOp.getFaceVerts target polyIdx
	local positions = for vertIdx in faceVertsIdxs collect (polyOp.getVert target vertIdx)
	positions
)

delete tempbox
clearlistener()
micromesh $Sphere001 $