-- function by Neil Marshall 12/31/2011
-- https://neiltech.wordpress.com/2011/12/31/maxscript-converting-between-ffd-space-and-world-space/

fn WorldSpaceToFFDSpace obj ffd pos = (
	objTM = obj.objecttransform
	modTM = (getModContextTM obj ffd) * ffd.lattice_transform.value
	modBBMin = getModContextBBoxMin obj ffd
	modBBMax = getModContextBBoxMax obj ffd
	size = modBBMax - modBBMin
	thePoint = (pos * (inverse objTM) * (inverse modTM) - modBBMin) / size
)

-----------------

struct vertex (idx, pos, normal)

fn getVertNormal target vertIdx = (
	local vertFaces = polyOp.getFacesUsingVert target vertIdx
	local normal = [0,0,0]; 
	for faceIdx in vertFaces do normal += polyOp.getFaceNormal target faceIdx node:target
	normalize (normal / vertFaces.count)
)

fn ffdSourceToVerts src verts offsetVerts= (
	local obj = reference src
	local ffd = ffdBox()
	setDimensions ffd [2, 2, 2]
	addmodifier obj ffd
	animateAll ffd
	
	-- control points
	local cps = ffd["Master"]
	
	local map = #(2,3,1,4) --up
-- 	local map = #(4,1,3,2) --down
-- 	local map = #(3,4,2,1) --left
-- 	local map = #(1,2,4,3) --right
	
	for i=1 to 4 do (
		cps[i].value = verts[map[i]].pos
		cps[i+4].value = offsetVerts[map[i]].pos
	)
	
-- 	for i=1 to 4 do (
-- 		cps[i].value = WorldSpaceToFFDSpace obj ffd verts[map[i]].pos
-- 		cps[i+4].value = WorldSpaceToFFDSpace obj ffd offsetVerts[map[i]].pos
-- 	)

	obj
)

fn micromesh target src = (
	-- 1. CREATE VERT STRUCTS
	local verts = for vertIdx=1 to (polyop.getNumVerts target) collect (
		local pos = polyOp.getVert target vertIdx
		local normal = getVertNormal target vertIdx
		
		vertex vertIdx pos normal
	)
	
	-- 2. CREATE OFFSET VERTS
	local offsetDistance = 2
	local offsetVerts = for vert in verts collect (
		local newPos = vert.pos + vert.normal * offsetDistance
		vertex vert.idx newPos vert.normal
	) 
	
	-- 3. GET VERTS FOR EACH POLYGON
	local vertsIdxesPerPoly = for polyIdx=1 to (polyOp.getNumFaces target) collect (
		polyOp.getFaceVerts target polyIdx
	)
		
	-- 4. FOR EACH POLY, CONFORM SOURCE
	local objs = #()
	for vertIdxes in vertsIdxesPerPoly do (
		local polyVerts = for vertIdx in vertIdxes collect ( verts[vertIdx])
		local polyOffsetVerts = for vertIdx in vertIdxes collect ( offsetVerts[vertIdx])
		
		local obj = ffdSourceToVerts src polyVerts polyOffsetVerts
		append objs obj
	)
	
	select objs
	-- 5. ATTACH TO SINGLE OBJ AND WELD
	--for i=2 to objs.count do (polyOp.attach objs[1] objs[2])
)

clearlistener()
with redraw off ( micromesh $Plane002 $src001 )