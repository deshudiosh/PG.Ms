fn cadLikeRotate = (
	pp1 = pickPoint snap:#3D
	pp2 = pickPoint rubberBand:pp1 snap:#3D
	pp3 = pickPoint rubberBand:pp1 snap:#3D
	if(pp1 == #escape or pp2 == #escape or pp3 == #escape or pp1 == #rightClick or pp2 == #rightClick or pp3 == #rightClick) do (
		redrawViews()
		return "3 Point Click Aborted"
	)
	
	p1 = Point()
	p1.pos = pp1
	p2 = Point()
	p2.pos = pp2
	lac = LookAt_Constraint()
	lac.appendTarget p2 100
	p1.rotation.controller = lac
	selection.parent = p1
	p2.pos = pp3
	delete p1
	delete p2
)

cadLikeRotate()