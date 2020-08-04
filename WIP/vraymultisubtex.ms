mat = getMeditMaterial 5
mat = mat.diffusemap

show mat

for i=1 to mat.texmap.count do (
	map = mat.texmap[i]
	
	if map != undefined do (
		map.name = getFilenameFile map.fileName
		map.coords.blur = 0.01
	
		pxarr = getPixels map.bitmap [0, 0] 100 linear:true
		
		r = 0
		g = 0
		b = 0
		
		for px in pxarr do (
			r += px.r
			g += px.g
			b += px.b
		)
		
		r /= pxarr.count
		g /= pxarr.count
		b /= pxarr.count
		
		--print px
		mat.texmap_color[i] = color r g b
	)

)