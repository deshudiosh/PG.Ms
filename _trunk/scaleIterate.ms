for i = 1 to selection.count do (
	inverseIter = selection.count - i 
	--val = 1 - (0.0007 * i)
	val = 1 - (0.016 * i)
	scale selection[i] [val,val,1]
)