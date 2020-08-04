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
	
	select s
	subobjectlevel = 1
	selectAllKnots s
	weldSpline s 0.1
)