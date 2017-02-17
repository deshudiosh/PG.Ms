fn applyColors c1 c2 = (
	mtl = meditMaterials[activeMeditSlot]

	
	-- if selected material is multi-material, just change diffuse color of its sub-materials
	if (classof mtl == Multimaterial) do (
		mats = mtl.materiallist
		iters = mats.count - 1
		for i = 0 to iters do (
			bias = (i as float) / iters
			col = c1 * (1 - bias) + c2 * bias
			
			curMat = mats[i+1]
			
			if classof curMat == Standardmaterial do curMat.diffuse = col
			if classof curMat == CoronaMtl do curMat.colorDiffuse = col
			if classof curMat == VRayMtl do curMat.diffuse = col
		)
	)
	
	
	--search for supported maps in diffuse slot of various materials
	--and if found, apply color gradation to them
	supportedMaps = #(CoronaMultiMap, VRayMultiSubTex)

	if classof mtl == Standardmaterial do
		if (findItem supportedMaps (classOf mtl.diffuseMap) > 0) do 
			mtl = mtl.diffuseMap
	
	if classof mtl == CoronaMtl do
		if (findItem supportedMaps (classOf mtl.texmapDiffuse) > 0) do 
			mtl = mtl.texmapDiffuse
	
	if classof mtl == VRayMtl do
		if (findItem supportedMaps (classOf mtl.texmap_diffuse) > 0) do 
			mtl = mtl.texmap_diffuse
	
	
	
	-- code changeing color gradation specific for certain map type
	if (classof mtl == CoronaMultiMap) do (
		iters = mtl.items - 1
		for i = 0 to iters do (
			bias = (i as float) / iters
			col = c1 * (1 - bias) + c2 * bias
			mtl.colors[i +1] = col
		)
	)
	
	if (classof mtl == VRayMultiSubTex) do (
		iters = mtl.texmap_color.count - 1
		for i = 0 to iters do (
			bias = (i as float) / iters
			col = c1 * (1 - bias) + c2 * bias
			mtl.texmap_color[i +1] = col
		)
	)
	
)


rollout dial "Color Gradation"
(
	label theLabel0 ""
	colorpicker cp1 color:[0,0,0] modal:false across:2 offset:[20,0]
	colorpicker cp2 color:[255,255,255] modal:false 
	button btnApply "Apply" offset:[0,10]
	on btnApply pressed do applyColors cp1.color cp2.color
	
	label theLabel ""
	label theLabel2 ""
	label theLabel3 "by Pawel Grzelak"
	hyperlink www "be.net/pawelgrzelak" address:"http://be.net/pawelgrzelak" offset:[20,2] color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
)
createDialog dial