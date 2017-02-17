fn scalePointAboutAnchor scaledPoint anchorPoint scaleValue = (
	((scaledPoint - anchorPoint) * scaleValue) + anchorPoint
)

fn drawSplines curves = (	
	--CURVES
	for i = 1 to curves.count do (
		local s = splineshape()
		addnewspline s
		
		--SEGMENTS
		for j = 1 to curves[i].count do (
			local seg = curves[i][j]
			
			-- 3-KNOB BEZIER
			if seg.count == 3 do (
				local val = 0.551915024494
-- 				local val = 0.6666 -- - THIS IS WRONG VALUE
				
				pt1 = seg[1]
				pt2 = scalePointAboutAnchor seg[2] seg[1] val
				pt3 = scalePointAboutAnchor seg[2] seg[3] val
				pt4 = seg[3]
				addknot s 1 #bezierCorner #curve pt1 pt1 pt2
				addknot s 1 #bezierCorner #curve pt4 pt3 pt4
			)
			
			-- 4-KNOT BEZIER
			if seg.count == 4 do (
				pt1 = seg[1]
				pt2 = seg[2]
				pt3 = seg[3]
				pt4 = seg[4]
				addknot s 1 #bezierCorner #curve pt1 pt1 pt2
				addknot s 1 #bezierCorner #curve pt4 pt3 pt4
			)
			-- 2-KNOT LINE
			if seg.count == 2 do (
				pt1 = seg[1]
				pt2 = seg[2]
				addknot s 1 #corner #line pt1
				addknot s 1 #corner #line pt2
			)
		)
	
		
		
		if ( numKnots s > 2) do updateshape s
	)
)

fn sortCurvesToArray curvesString = (
	local curveSep = "|" 
	local segmentSep = ";" 
	local pointSep = "/"
	
	local curves = filterString curvesString curveSep
	local curvesSorted = #()
	
	for i = 1 to curves.count do (
 		print ("CURVE " + i as string + " -> " + curves[i])
		
		local segments = filterString curves[i] segmentSep
		local segmentsSorted = #()
			
		for j = 1 to segments.count do (
 			print ("	SEGMENT " + j as string + " -> " + segments[j])
			
			local points = filterString segments[j] pointSep
			local pointsSorted = #()
						
			for k = 1 to points.count do (
 				print ("		POINTS " + k as string + " -> " + points[k])
				
				local pointCoords = (execute points[k])
				append pointsSorted [pointCoords.x, pointCoords.y, pointCoords.z]
			)
			append segmentsSorted pointsSorted
		)
		append curvesSorted segmentsSorted
	)
	
	curvesSorted
)

drawSplines (sortCurvesToArray (getclipboardText()))
-- drawSplines (sortCurvesToArray "[0,1,0]/[-1,1,0]/[-1,6.12323399573677E-17,0]/;|")