fn rv_do_render filepath = (
	max quick render
	bm = getLastRenderedImage()
	bm.filename = filepath
	save bm
	close bm
)

fn rendervariations = (
	indices = #(2, 3, 4, 8, 12, 14, 15, 16 ,17 ,18 ,19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 , 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 57, 58, 62, 63, 64, 69)
	id1 = $Cylinder435.modifiers[1]
	id2 = $Object186.modifiers[1]	
	
	p = "X:\!Budynki-Xrefy\Warsaw Spire\3d\smieci\kieliszek akustyczny\2020.07.07 kolory cd\variations\a11_wool_"
		
	--stopval = 2
	stopval = indices.count

	for i = 1 to stopval do (
		for j = 1 to stopval while keyboard.altPressed == false do  (
			id1.materialID = indices[i]
			id2.materialID = indices[j]
			
			fp = p +  id1.materialID as string + "_" + id2.materialID as string + ".jpg"
		
			render outputfile:fp vfb:false
		)
	)
	
)

clearlistener()
rendervariations()