fn mouseMove mPos arg = (
	p1 = point()
	p1.pos = arg[1]
	p2 = point()
	p2.pos = arg[2]
	p3 = point()
	p3.pos = arg[3]
	
	pTransfromed = point()
			
	lac = LookAt_Constraint()
	lac.appendTarget p3 100
	p1.rotation.controller = lac
	
	pTransfromed.parent = p1
	p1.pos = p2.pos
	
	p3.pos = mPos
	
	delete p1
	delete p2
	delete p3
	
	for i = 1 to selection.count do (
		selection[i].transform = arg[4][i]
		selection[i].transform *= pTransfromed.transform
	)
	
	local spline = arg[5]
	resetShape spline
	addnewspline spline
	addknot spline 1 #corner #line arg[6].pos
	addknot spline 1 #corner #line mPos
	updateShape spline
	
	delete pTransfromed
)

fn fourPointAlignSupported = (
	local snapWasOn = snapMode.active
	snapMode.active = true
	
	local originalTransforms = #()
	for i = 1 to selection.count do (
		append originalTransforms selection[i].transform
	)
	
	local spline = splineshape()
		
	--PRZEPISZ NA jezeli pickpoint nie równa sie escape AND nie rowna sie right click, to wtedy pickowanie nastepnego
	-- ( nested if if if )
	
	local abortMsg = "\n4 Point Align Aborted"
	pp1 = pickPoint prompt:"\nPick 1st point" snap:#3D
	if(pp1 == #escape or pp1 == #rightClick) do ( redrawViews() return abortMsg )
	pp2 = pickPoint prompt:"\nPick 2nd point" rubberBand:pp1 snap:#3D 
	if(pp2 == #escape or pp2 == #rightClick) do ( redrawViews() return abortMsg )
	pp3 = pickPoint prompt:"\nPick 3rd point" snap:#3D
	if(pp3 == #escape or pp3 == #rightClick) do ( redrawViews() return abortMsg )
	
	local pAttached = point()
	pAttached.pos = pp3
	pAttached.parent = selection[1]
	
	pp4 = pickPoint prompt:"\nPick 4th point" snap:#3D mouseMoveCallback:#(mouseMove, #(pp1, pp2, pp3, originalTransforms, spline, pAttached))
	if(pp4 == #escape or pp4 == #rightClick) do ( redrawViews() return abortMsg )
	
	snapMode.active = snapWasOn
	delete spline
	delete pAttached
)

fourPointAlignSupported()

