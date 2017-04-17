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

fn ffdSourceToVerts src polyVerts = (
	local obj = copy src
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
 		cps[i].value = (WorldSpaceToFFDSpace obj ffd polyVerts[map[i]].pos)
		cps[i+4].value = (WorldSpaceToFFDSpace obj ffd polyVerts[map[i]].childPos)
	)

	obj --return created copy
)

fn micromesh target src = (
	
	local offsetDistance = 2
	
	-- CREATE VERT STRUCTS --> pos and childPos holders
	local verts = for vertIdx=1 to (polyop.getNumVerts target) collect (
		local pos = polyOp.getVert target vertIdx
		local normal = getVertNormal target vertIdx
		local childPos = pos + normal * offsetDistance
		vertex vertIdx pos childPos normal
	)
	
	-- COLLECT VERTS FOR EACH POLYGON
	local vertsPerPoly = for polyIdx=1 to (polyOp.getNumFaces target) collect (
		local vertIdxes = polyOp.getFaceVerts target polyIdx
		for idx in vertIdxes collect ( verts[idx] )
	)
		
	-- FOR EACH POLY, CONFORM SOURCE
	local objs = #()
	for polyVerts in vertsPerPoly do (
		local obj = ffdSourceToVerts src polyVerts
		append objs obj
	)
	
	select objs
	
	-- ATTACH TO SINGLE OBJ AND WELD
	--for i=2 to objs.count do (polyOp.attach objs[1] objs[2])
)

clearlistener()
deselect selection
with redraw off ( micromesh $Plane001 $src002 )