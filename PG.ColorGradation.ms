fn applyGradation c1:undefined c2:undefined gradientMap:undefined useMap:false = (
	fn getColorsFromPickers count c1 c2= (
		local arr = #()
		for i = 0 to (count - 1) do (
			local bias = (i as float) / (count - 1)
			local col = c1 * (1 - bias) + c2 * bias
			append arr col
		)
		arr
	)
	
	fn getColorsFromGradient count gradientMap = (
		sampleMult = 100
		b = bitmap ((count - 1) * sampleMult + 1) 1
		renderMap gradientMap into:b
		local arr = #()
		for i = 0 to (count - 1) do (
			append arr (getPixels b [i*sampleMult, 0] 1)[1]
		)
		arr
	)
	
	mtl = meditMaterials[activeMeditSlot]
	
	-- if selected material is multi-material, just change diffuse color of its sub-materials
	if (classof mtl == Multimaterial) do (
		mats = mtl.materiallist
		
		local colors
		if useMap == true then colors =getColorsFromGradient mats.count gradientMap
		else colors = getColorsFromPickers mats.count c1 c2
		
		for i = 1 to mats.count do (
			curMat = mats[i]
			if classof curMat == Standardmaterial do curMat.diffuse = colors[i]
			if classof curMat == CoronaMtl do curMat.colorDiffuse = colors[i]
			if classof curMat == VRayMtl do curMat.diffuse = colors[i]
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
		local colors, iters = mtl.items
		if useMap == true then colors = getColorsFromGradient iters gradientMap
		else colors = getColorsFromPickers iters c1 c2
		
		for i = 1 to iters do mtl.colors[i] = colors[i]
	)
	
	if (classof mtl == VRayMultiSubTex) do (
		local iters = mtl.texmap_color.count
		local colors
		if useMap == true then colors = getColorsFromGradient iters gradientMap
		else colors = getColorsFromPickers iters c1 c2
				
		for i = 1 to iters do mtl.texmap_color[i] = colors[i]
	)
	
)

rollout dial "Color Gradation" width:200
(
	local space = 10
	local separator = bitmap 180 1 color:[128,128,128]
	
	colorpicker cp1 color:[0,0,0] modal:false across:3 align:#center offset:[0, space]
	colorpicker cp2 color:[255,255,255] modal:false align:#center offset:[0, space]
	button btnApply "Apply" offset:[0, space]
	on btnApply pressed do applyGradation c1:cp1.color c2:cp2.color
	
	imgTag s1 bitmap:separator align:#center offset:[0, space]
	
	local selectedMap
	label mapName "<<No Map>>" offset:[0, space]
	imgTag gradientImg
	
	fn drawGradient = (
		b = bitmap 180 20
		renderMap selectedMap into:b
		gradientImg.bitmap = b
	)
	
	on btnGetMap pressed do (
		selectedMeditSlot = meditMaterials[activeMeditSlot]
		if (classof selectedMeditSlot == Gradient_Ramp) do (
			selectedMap = selectedMeditSlot
			mapName.text = "Map: " + selectedMap.name
			drawGradient()		
			when parameters selectedMap changes id:#colorGradation do drawGradient()
			when name selectedMap changes id:#colorGradation do mapName.text = "Map: " + selectedMap.name
		)
	)
	button btnGetMap "Get Gradient" across:2
	button btnApplyMap "Apply Gradient"
	on btnApplyMap pressed do applyGradation gradientMap:selectedMap useMap:true
		
	imgTag s2 bitmap:separator align:#center offset:[0, space]

	label theLabel3 "by Pawel Grzelak" offset:[0, space]
	hyperlink www "www.pawelgrzelak.com" align:#center address:"http://pawelgrzelak.com" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
	
	on dial close do ( 
		deleteAllChangeHandlers id:#colorGradation
	) 
)
createDialog dial