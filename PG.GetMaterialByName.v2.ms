fn getMat namestring = (
	local found = false
	
	for mat in scenematerials do (
		if mat.name == namestring do (
			meditMaterials[activeMeditSlot] = mat
			found = true
		)
	)
	
	if found == false 
	then (
		dial.hlStatus.text = "Material NOT found!"
		dial.hlStatus.color = (color 255 0 0) 
		dial.hlStatus.hovercolor = (color 255 0 0)
	)
	else (
		dial.hlStatus.text = "Material found!"
		dial.hlStatus.color = (color 255 255 255) 
		dial.hlStatus.hovercolor = (color 255 255 255)
	)
)


rollout dial "Get Material By Name" width:250
(
	label theLabel ""
	
	edittext etName text:"put name here" bold:true height:30 width:230
	hyperLink hlStatus offset:[60, 0]
	
	button btnGetMat "Assign Material to active MatEdit slot" width:230
	on btnGetMat pressed do (
		getMat etName.text
	)

	label theLabel2 ""
	label theLabel3 "by Pawel Grzelak"
	hyperlink www "be.net/pawelgrzelak" address:"http://be.net/pawelgrzelak" offset:[64,2] \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
)
createDialog dial