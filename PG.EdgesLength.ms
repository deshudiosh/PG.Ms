fn prompt step total = (
	percent = ((step as Float)/total*100) as String + "%"
	step = step as String
	total = total as String
		
	replacePrompt (step + "/" + total + " " + percent)
)

struct values (low, high, avg)

fn getMinMaxEdgeLength obj thresh = (
	numedges = obj.GetNumEdges()
	
	distances = #()
	threshedges = #()
	avg = 0
	
	for i = 1 to numedges do (
		vertex1 = obj.GetEdgeVertex i 1
		vertex2 = obj.GetEdgeVertex i 2
		
		pt1 = obj.GetVertex vertex1
		pt2 = obj.GetVertex vertex2
		
		if pt1 == pt2 do continue
		
		dist = distance pt1 pt2
		
		if dist <= thresh then (
			append threshedges i
		) 
		
		append distances dist
		avg += dist
		
		prompt i numedges
	)
	
	if threshedges.count > 0 do polyop.setEdgeSelection obj threshedges
	
	vals = values (amin distances) (amax distances) (avg /= numedges)
	
	x = (vals as string + " " +("Selected " + threshedges.count as String + " within threshold."))
	print x
	replacePrompt x
)

clearlistener()
getMinMaxEdgeLength $ 1.5