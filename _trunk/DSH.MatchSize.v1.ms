fn match areaTo areaFrom = (
	undo "Match Script" on
	(	
		toSize = areaTo.max - areaTo.min
		fromSize = areaFrom.max - areaFrom.min

		ratio = toSize / fromSize

		scale areaFrom [ratio.x, ratio.y, 1]

		shift = areaTo.min - areaFrom.min
		move areaFrom [shift.x, shift.y, shift.z]
	)
)




rollout dial "Match Region" width:250
(
	label theLabel ""
	
	label theLabelMatchTo "Match To:" across:2
	pickbutton areaTo "<<>>"
	on areaTo picked obj do (
		areaTo.text = obj.name
	)

	label theLabelMatchFrom "Match From:" across:2
	pickbutton areaFrom "<<>>"
	on areaFrom picked obj do (
		areaFrom.text = obj.name
	)
	
	button apply "Apply"
	on apply pressed do (match areaTo.object areaFrom.object)
	
	label theLabel1 ""
		
	label theLabel3 "by Pawel Grzelak"
	hyperlink www "be.net/pawelgrzelak" address:"http://be.net/pawelgrzelak" offset:[64,2] \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
)
createDialog dial