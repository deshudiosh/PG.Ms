fn disableInterpolation materials = (
	for mtl in materials do (
		
		if classof mtl == VRayMtl do (
			mtl.reflection_useInterpolation = false
			mtl.refraction_useInterpolation = false
		)
		
		if classof mtl == VRayBlendMtl do (
			disableInterpolation #(mtl.baseMtl)
			disableInterpolation mtl.coatMtl
		)
		
		if classof mtl == Multimaterial do (
			disableInterpolation mtl.materialList
		)
		
	)
)

rollout dial "Disable VrayMtl Interpolation" width:250
(
	label theLabel ""
	
	button btnSelected "Selected" across:2
	on btnSelected pressed do (
		for obj in selection do
			disableInterpolation #(obj.material)
	)

	button btnScene "Scene"
	on btnScene pressed do disableInterpolation sceneMaterials
		
	label theLabel2 ""
	label theLabel3 "by Pawel Grzelak"
	hyperlink www "be.net/pawelgrzelak" address:"http://be.net/pawelgrzelak" offset:[64,2] \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
)
createDialog dial