fn alignToNearestAxis s = (
	local abortMsg = "\n Point Align Aborted"
	pp = pickPoint snap:#3D
	if(pp == #escape or pp == #rightClick) do ( redrawViews() return abortMsg )
	
	kIndexes = getKnotSelection s 1
	for j = 1 to kIndexes.count do (
		kP = getKnotPoint s 1 kIndexes[j]
		xD = abs (kP.x - pp.x)
		yD = abs (kP.y - pp.y)
		zD = abs (kP.z - pp.z)
		dists = #(xD, yD, zD)

-- 		print (dists as string)
		
		for i = 1 to dists.count do (
			if dists[i] == 0.0 do (
				deleteItem dists i
				i -= 1
			)
		)
		
		m = amin dists

		print m
		
		print (kp as string)
		if m == xD do ( kP.x = pp.x )
		if m == yD do ( kP.y = pp.y )
		if m == zD do ( kP.z = pp.z )
		print (kp as string)
		
		setKnotPoint s 1 kIndexes[j] kP
	)
	
	updateShape s
)

alignToNearestAxis $