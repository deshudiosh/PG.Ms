rollout PGSectionAnalysis "Section Auto Update" width:200
(
	local separator = bitmap 180 1 color:[128,128,128], space = 10
	local sectionObj, topoObj
	
	fn checkForSectionUpdate = ( if sectionObj != undefined do updateSection sectionObj	)
	fn sectionFilter obj = ( classof obj == section )
	fn geoFilter obj = ( superclassof obj == GeometryClass )
	
	label theLabel1 ""	
	
	on PGSectionAnalysis open do (
	)
	on PGSectionAnalysis close do (
		-- CLEANUP
	) 
)

createDialog PGSectionAnalysis