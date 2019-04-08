fn pFitsRect p rect = (
	x = p.x >= rect.min.x and p.x <= rect.max.x
	y = p.y >= rect.min.y and p.y <= rect.max.y
	x and y
)

fn sepByRect shpe rect = (
	--numSplines 
	--numKnots 
	--getKnotPoint
	--updateShape
	for s = 1 to numSplines shpe do (
		allKnotsInside = true
		for k = 1 to numKnots shpe s do (
			p = getKnotPoint shpe s k
			if pFitsRect p rect != true do (
				allKnotsInside = false
				break
			)
		)
		format "Shape % spline % % be detached\n" shpe.name s (if allKnotsInside then "should" else "shouldn't")
	)
)

clearlistener()
sepByRect $line $Rectangle001