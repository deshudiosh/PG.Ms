struct PGSectionsStruct(
	sectionObjs = #(), sectionObj, topoObj,
	
	fn findSections = ( sectionObjs = for s in shapes where (classof  s == section) collect s ),
	
	fn sectionsUpdate = ( 
		PGSections.findSections()
		
		for sect in PGSections.sectionObjs do (
			origTransform = sect.transform
			sect.transform = (rotateZmatrix 0.001) * sect.transform
			redrawViews() 
			sect.transform = origTransform
		)
	),

	fn deleteTopoHandlers = (
		deleteAllChangeHandlers id:#PGtopoChange
	),
	
	fn run = (
		try (destroyDialog PGSectionsDial) catch()
		
		rollout PGSectionsDial "Section Auto Update" width:200
		(
			fn geoFilter obj = ( superclassof obj == GeometryClass )
						
			pickButton topoBtn "<<Pick Geometry Object>>" filter:geoFilter			
		
			on topoBtn picked obj do (
				topoBtn.text = obj.name
				
				PGSections.deleteTopoHandlers()		
				when geometry obj changes id:#PGtopoChange do PGSections.sectionsUpdate()
			)
			on PGSectionsDial close do ( PGSections.deleteTopoHandlers() ) 
		)
		
		createDialog PGSectionsDial
		""
	)
	
)


PGSections = PGSectionsStruct()
PGSections.run()