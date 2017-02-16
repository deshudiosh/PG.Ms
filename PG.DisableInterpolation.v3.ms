stats
vraySssArr = #()
hadInterpolation = #()

fn resetArrays = (
	vraySssArr = #()
	hadInterpolation = #()
)

fn disableInterpolation materials justAnalize= (

	for mtl in materials do (
		
		if classof mtl == VRayMtl do (	
			if mtl.reflection_useInterpolation == true or \
				mtl.refraction_useInterpolation == true do (
				if justAnalize == false do (
					mtl.reflection_useInterpolation = false 
					mtl.refraction_useInterpolation = false
				)
				
				append hadInterpolation mtl
			)
		)
		
		if classof mtl == VRayFastSSS or \
		   classof mtl == VRayFastSSS2 do (
			append vraySssArr mtl
			print mtl
		)
		
		if classof mtl == VRayBlendMtl do (
			disableInterpolation #(mtl.baseMtl) false
			disableInterpolation mtl.coatMtl false
		)
		
		if classof mtl == Multimaterial do (
			disableInterpolation mtl.materialList false
		)
		
	)
	
	dial.stats.text = "Refl/Refr Interpolations: " + hadInterpolation.count as string \
		+ "   SSS: " + (vraySssArr.count as string)
)

rollout dial "Disable VrayMtl Interpolation" width:250
(
	label theLabel ""
	
	button btnSelected "Selected" across:2
	on btnSelected pressed do (
		resetArrays()
		
		for obj in selection do
			disableInterpolation #(obj.material) false
	)

	button btnScene "Scene"
	on btnScene pressed do (
		resetArrays()
		disableInterpolation sceneMaterials false
	)
	
	label theLabel1 ""
	
	button btnAnalyze "Analyze Scene"
	on btnAnalyze pressed do (
		resetArrays()
		disableInterpolation sceneMaterials true
	)
		
	edittext stats
		
	label theLabel2 ""
	label theLabel3 "by Pawel Grzelak"
	hyperlink www "be.net/pawelgrzelak" address:"http://be.net/pawelgrzelak" offset:[64,2] \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
)
createDialog dial