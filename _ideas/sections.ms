fn selectAllKnots theShape = (  
    for s = 1 to (numSplines theShape) do (  
        kArray = #{1..(numKnots theShape s)} as array  
        setKnotSelection theShape s kArray keep:true  
    )  
) 


sel = $
minZ = sel.min.z
maxZ = sel.max.z
numLevels = 10
delta = (maxZ - minZ) / (numLevels + 1)
for currentZ = minZ to maxZ by delta do
(
	s = section pos:[0, 0, currentZ] rot:[45, 0, 0]
	max views redraw
	convertToSplineShape s
	
	--updateShape s
	
	select s
	subobjectlevel = 1
	selectAllKnots s
	weldSpline s 0.1
	--updateShape s
	
	--selectAllKnots s
	--weldSpline s 1.0
	--updateShape s
	
-- 	sNum = s.numSplines
-- 	
-- 	for sp = 1 to sNum do
-- 	(
-- 		kNum = numKnots s sp
-- 		
-- 		for kn = 1 to kNum do
-- 		(
-- 			setKnotType s sp kn #corner
-- 		)
-- 	)
)