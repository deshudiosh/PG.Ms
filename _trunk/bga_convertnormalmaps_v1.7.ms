/*//////////   SCRIPT:   Convert NormalMaps v1.7  //////////*/	
/*//////////   WRITTEN BY:   Branko Zivkovic   //////////*/
/*//////////   EMAIL:   barigazy@hotmail.com   //////////*/	

try(destroydialog ::nmRoll) catch() 
rollout nmRoll "Convert NormalMaps v1.7"
(
	local sioFile = dotNetClass "System.IO.File"
	fn mapConvert mapA mapB =
	(
		if isKindof mapA Normal_Bump then
		(
			mapB.normal_map = mapA.normal_map
			if isProperty mapB "normal_map_on" do
			(
				mapB.normal_map_on = mapA.map1on
				mapB.normal_map_multiplier = mapA.mult_spin
				mapB.bump_map = mapA.bump_map
				mapB.bump_map_on = mapA.map2on
				mapB.bump_map_multiplier = mapA.bump_spin
				mapB.flip_red = mapA.flipred
				mapB.flip_green = mapA.flipgreen
				mapB.swap_red_and_green = mapA.swap_rg
			)
		)
		else
		(
			mapB.normal_map = mapA.normal_map
			if isProperty mapA "normal_map_on" do
			(
				mapB.map1on = mapA.normal_map_on
				mapB.mult_spin = mapA.normal_map_multiplier
				mapB.bump_map = mapA.bump_map
				mapB.map2on = mapA.bump_map_on
				mapB.bump_spin = mapA.bump_map_multiplier
				mapB.flipred = mapA.flip_red
				mapB.flipgreen = mapA.flip_green
				mapB.swap_rg = mapA.swap_red_and_green
			)
		) ; replaceInstances mapA mapB
	)	
	label lbl1 "<< Convert Method >>"
	radiobuttons rb1 "" labels:#("NormalBump to VrayNormalMap", "VrayNormalMap to NormalBump")
	label lbl2 "<< Affect Only >>"
	radiobuttons rb2 "" labels:#("Selected Objects", "Secene Materials") columns:2
	label lbl3 "<< Bitmap Gamma >>"
	checkbox cb_on "Override Gamma :" across:2 align:#left enabled:((maxVersion())[1] >= 16000)
	spinner spn_gamma "" range:[-10,10,1.0] width:65 enabled:off
	button btn "Convert Normal Maps" width:210

	on cb_on changed state do spn_gamma.enabled = state
	on btn pressed do
	(
		if scenematerials.count != 0 do
		(
			node = if rb1.state == 1 then dataPair a:VRayNormalMap b:Normal_Bump else dataPair a:Normal_Bump b:VRayNormalMap
			object = #() ; number = #()
			if rb2.state == 2 then object = getClassInstances node.b target:scenematerials else
			(
				if selection.count > 0 do for o in selection where o.mat != undefined do join object (getClassInstances node.b target:o.mat)
			)
			makeuniquearray object
			if object.count > 0 do
			(
				if MatEditor.isOpen() do MatEditor.Close()
				for o in object do append number (node.a name:o.name)
				with undo off for i = 1 to object.count do
				(
					if cb_on.checked and isKindOf object[i].normal_map bitmaptex and sioFile.exists object[i].normal_map.filename do 
					(
						if object[i].normal_map.bitmap.inputGammaValue != spn_gamma.value do
						(
							object[i].normal_map.bitmap = openBitmap object[i].normal_map.filename gamma:spn_gamma.value
						)
					) ; mapConvert object[i] number[i]
				) ; free object ; free number ; freeSceneBitmaps() ; gc light:on
			)
		)
	)	
)
createDialog nmRoll 220 160 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)	
