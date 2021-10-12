(
	fn objIdFromWirecolor = (
		for obj in selection do (
			col = obj.wirecolor
			r = col.r/100
			g = col.g/100
			b = col.b/100
			colseed = r + g*g + b*b*b
			colseed *= 100
			colseed = colseed as integer
			obj.gbufferChannel = colseed
		)
	)
	
	objIdFromWirecolor()
)