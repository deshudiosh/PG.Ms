fn fourPointAlign = (
	local snapWasOn = snapMode.active
	--snapMode.active = true
	
	local abortMsg = "\n4 Point Align Aborted"
	pp1 = pickPoint prompt:"\nPick 1st point" snap:#3D
	if(pp1 == #escape or pp1 == #rightClick) do ( redrawViews() return abortMsg )
	pp2 = pickPoint prompt:"\nPick 2nd point" rubberBand:pp1 snap:#3D 
	if(pp2 == #escape or pp2 == #rightClick) do ( redrawViews() return abortMsg )
	pp3 = pickPoint prompt:"\nPick 3rd point" snap:#3D
	if(pp3 == #escape or pp3 == #rightClick) do ( redrawViews() return abortMsg )
	pp4 = pickPoint prompt:"\nPick 4th point" rubberBand:pp3 snap:#3D
	if(pp4 == #escape or pp4 == #rightClick) do ( redrawViews() return abortMsg )
	
	--snapMode.active = snapWasOn
	
	p1 = point()
	p1.pos = pp1
	p2 = point()
	p2.pos = pp2
	p3 = point()
	p3.pos = pp3
	
	pTransfromed = point()
		
	lac = LookAt_Constraint()
	lac.appendTarget p3 100
	p1.rotation.controller = lac
	
	pTransfromed.parent = p1
	p1.pos = p2.pos
	
	p3.pos = pp4
	
	delete p1
	delete p2
	delete p3
	
	for i = 1 to selection.count do (
		selection[i].transform *= pTransfromed.transform
	)
	
	delete pTransfromed
)

fourPointAlign()