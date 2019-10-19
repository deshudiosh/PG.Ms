(
	local PGSections

	struct pgsects(
		grabbed,
		
		fn sectionsUpdate = ( 
			sections = for s in shapes where (classof  s == section) collect s
			
			for sect in sections do (
				sect.transform = (rotateZmatrix 0.001) * sect.transform
			)
		),

		fn deleteHandlers = ( deleteAllChangeHandlers id:#PGtopoChange ),

		fn geoFilter obj = ( superclassof obj == GeometryClass ),
		
		fn run = (
			try (destroyDialog PGSectionsDial) catch()
			
			rollout PGSectionsDial "Sections Auto Update" width:200
			(
				label l "Keep this dialog open\n for realtime updates" height:30 multiline:true
				pickButton topoBtn "<< Pick geometry... >>" filter:geoFilter width:180 height:25
				
				on topoBtn picked obj do (
					topoBtn.text = obj.name
					
					pgsects.deleteHandlers()
					when geometry obj changes id:#PGtopoChange do pgsects.sectionsUpdate()
				)
				
				on PGSectionsDial close do pgsects.deleteHandlers()
			)
			
			createDialog PGSectionsDial
		)
		
	)

	PGSections = pgsects()
	PGSections.run()
)