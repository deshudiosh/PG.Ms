for i = 1 to selection.count do (
	inverseIter = selection.count - i 
	val = 1 - (2 * i)
	rotate selection[i] (angleaxis val [0,0,1])
)