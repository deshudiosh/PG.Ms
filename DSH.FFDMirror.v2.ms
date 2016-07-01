fn applyMirrorToFDD ffd idxMap axis flip = (	
	
	for i = 1 to idxMap.count do (
		pairIdx = if not flip then #(1,2) else #(2,1)
		cp1 = "control_point_" + idxMap[i][pairIdx[1]]
		cp2 = "control_point_" + idxMap[i][pairIdx[2]]
		
		c = getPropertyController ffd cp1
		v = (addnewkey c 0f).value

		v[axis] = v[axis] * -1 + 1

		c = getPropertyController ffd cp2
		k = addnewkey c 0f
		k.value = v
	)
)

fn getCP3Darray ffd = (
	dim = getDimensions ffd
	
	cpNumbers = #()
	
	lastIdx = 1
	
	--  x = width    y = length    z = height
	for z = 1 to dim.z do (
		append cpNumbers #()
		for y = 1 to dim.y do (
			append cpNumbers[z] #()
			for x = 1 to dim.x do (
				--print ("w:" + (x as integer) as string + " l:" + (y as integer) as string + " z:" + (z as integer) as string + " cp: " + lastIdx as string)
				append (cpNumbers[z][y]) (lastIdx as String)
				lastIdx += 1
			)
		)
	)

	cpNumbers
)

fn getFfdCpIdxPairs arr axis = (
	--access Z Y X
	
	pairs = #()
	
	for z = 1 to arr.count do (
		yArr = arr[z]
		for y = 1 to yArr.count do (
			xArr = arr[z][y]
						
			while xArr.count >= 2 do (
				cp1 = xArr[1]
				cp2 = xArr[xArr.count]
				
				xArr = deleteItem xArr 1
				xArr = deleteItem xArr xArr.count
				
				append pairs #(cp1, cp2)
			)
		)
	)
	
	pairs
)

fn init = (
	selectedMod = modPanel.getCurrentObject();
	
	if classof selectedMod == FFDBox do (		
		ffd = selectedMod
		ffdPointCount = getDimensions ffd
		
		animateAll ffd

		axis = 1
		flip = false
		
		cp3Darray = getCP3Darray ffd
		idxMap = getFfdCpIdxPairs cp3Darray axis
			
		applyMirrorToFDD ffd idxMap axis flip
	)
)

clearListener()
init()
