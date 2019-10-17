struct PGSectionsStruct(
	sectionObjs = #(), sectionObj, topoObj,
	
	fn sectionsUpdate = ( 
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

	fn findSections = (
		sectionObjs = for s in shapes where (classof  s == section) collect s
	),
	
	fn run = (
		try (destroyDialog PGSectionsDial) catch()
		
		rollout PGSectionsDial "Section Auto Update" width:200
		(
			fn sectionFilter obj = ( classof obj == section )
			fn geoFilter obj = ( superclassof obj == GeometryClass )
						
			pickButton topoBtn "<<Pick Geometry Object>>" filter:geoFilter
			button sectionBtn "Sections found: 0   <<update>>"
			
			
			on topoBtn picked obj do (
				topoBtn.text = obj.name
				
				PGSections.deleteTopoHandlers()		
				when geometry obj changes id:#PGtopoChange do PGSections.sectionsUpdate()
				
				PGSections.findSections()
			)
			
			fn refreshText = (
				txt = stringStream ""
				format "Sections found: %   <<update>>" PGSections.sectionObjs.count to:txt
				sectionBtn.text = txt
			)
			
			on sectionBtn pressed do (
				PGSections.findSections()
				refreshText()
			)
			
			on PGSectionsDial open do ( 
				PGSections.findSections()
				refreshText()
			)
			
			on PGSectionsDial close do ( PGSections.deleteTopoHandlers() ) 
		)
		
		createDialog PGSectionsDial
		""
	)
	
)


PGSections = PGSectionsStruct()
PGSections.run()