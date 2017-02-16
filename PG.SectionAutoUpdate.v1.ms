fn updateSection sectionObj =  (
	sectionObj.transform = (rotateZmatrix 0.001) * sectionObj.transform
)

fn deleteTopoHandlers = (
	deleteAllChangeHandlers id:#topoChange
)

rollout dial "Section Auto Update" width:200
(
	local separator = bitmap 180 1 color:[128,128,128], space = 10
	local sectionObj, topoObj
	
	fn checkForSectionUpdate = ( if sectionObj != undefined do updateSection sectionObj	)
	fn sectionFilter obj = ( classof obj == section )
	fn geoFilter obj = ( superclassof obj == GeometryClass )
	
	label theLabel1 ""	
	
	pickButton sectionBtn "<<Pick Section Shape>>" filter:sectionFilter
	on sectionBtn picked obj do (
		sectionBtn.text = obj.name
		sectionObj = obj
	)
	
	pickButton topoBtn "<<Pick Geometry Object>>" filter:geoFilter
	on topoBtn picked obj do (
		topoBtn.text = obj.name
		
		deleteTopoHandlers()		
		when geometry obj changes id:#topoChange do checkForSectionUpdate()
	)
	
	imgTag s1 bitmap:separator align:#center offset:[0, space]

	label theLabel3 "by Pawel Grzelak" offset:[0, space]
	hyperlink www "be.net/pawelgrzelak" align:#center address:"http://be.net/pawelgrzelak" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
	
	on dial close do ( deleteTopoHandlers() ) 
)
createDialog dial