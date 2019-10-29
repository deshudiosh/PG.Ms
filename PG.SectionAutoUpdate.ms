(
	global PGSectionsDial
	local PGSections

	struct pgsects(
		grabbed = #(),

		fn sectionsUpdate = (
			origTransforms = #()
			
			with undo off ( with redraw off (
				sections = for s in shapes where (classof  s == section) collect s
				
				for sect in sections do (
					append origTransforms (copy sect.transform)
					sect.transform = (rotateZmatrix 360) * sect.transform
				)
			))
		),
		
		fn grabbedExistCheck = (
			grabbed = for s in grabbed where isValidNode s collect s
		),
		
		fn moveGrabbed delta = (
			grabbedExistCheck()
			
			with undo off (
				for s in grabbed do (
					deltaval = delta / 10.0
					if keyboard.shiftPressed do deltaval /= 10.0
					in coordsys #local s.pos.z -= deltaval
				)
				redrawViews()
			)
		),
		
		fn grabbedSavePos = (	for s in grabbed do ( 
				setUserProp s "origX" s.pos.x 
				setUserProp s "origY" s.pos.y
				setUserProp s "origZ" s.pos.z
			)	
		),
		fn grabbedRestorePos = (	
			for s in grabbed do ( 
				x = getUserProp s "origX"
				y = getUserProp s "origY"
				z = getUserProp s "origZ"
				s.pos =  [x, y, z]
			) 
		),

		fn deleteHandlers = ( deleteAllChangeHandlers id:#PGtopoChange ),

		fn geoFilter obj = ( superclassof obj == GeometryClass ),
		
		fn run = (
			try (destroyDialog PGSectionsDial) catch()
			
			rollout PGSectionsDial "Sections Auto Update" width:200
			(
				local lastX = 0
				local mousedragging = false
		
				label l "Keep this dialog open\n for realtime updates" height:30 multiline:true
				pickButton topoBtn "<< Pick geometry... >>" filter:geoFilter width:180 height:25
				
				button grab "Grab Sections" across:2 height:30 width:85
				dotNetControl  shifter "System.windows.forms.button" height:30 width:85
				
				
				on topoBtn picked obj do (
					topoBtn.text = obj.name
					
					pgsects.deleteHandlers()
					when geometry obj changes id:#PGtopoChange do pgsects.sectionsUpdate()
				)
				
				on grab pressed do ( 
					PGSections.grabbedRestorePos()
					PGSections.grabbed = (for s in selection where (classof  s == section) collect s)
					PGSections.grabbedSavePos()
				)
				
				on shifter MouseDown e do (
					if e.button == e.button.left do (
						mousedragging = true
						lastX = 0
					)
					if e.button == e.button.right do PGSections.grabbedRestorePos()
				)
				on shifter MouseUp e do ( mousedragging = false )
				on shifter MouseMove e do (
					if mousedragging == true do (
						delta = (e.x - lastX) as float
						lastX = e.x as float
						PGSections.moveGrabbed delta
					)
				)
				
				on PGSectionsDial close do (
					PGSections.deleteHandlers()
					PGSections.grabbedRestorePos()
				)
				
				on PGSectionsDial open do (
					--showEvents  shifter
					--showProperties shifter
					setProperty shifter "text" " drag <>"
				)
			)
			
			createDialog PGSectionsDial
		)
		
	)

	PGSections = pgsects()
	PGSections.run()
	"Sections Auto Update"
)