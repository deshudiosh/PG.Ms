rollout CamToRect "Camera to Object Align by Grzelu"  width:260 (
	group "Pick camera:" (
		pickbutton pickerCamera "..."
	)

	group "Pick object to align camera to:" (
		pickbutton pickerObj "..."
	)
	group "" (
		button buttonRefresh "Refresh" across:2
		spinner spinnerDistance "Distance:" range:[1,10000,100] width:100
	)
	group "" (
		button buttonUpdateRenderRatio "Update render output ratio" tooltip:"Sets render output height\nto match rectangle ratio"
	)

	fn getRectFromObject obj= (
		storedRot = obj.rotation
		obj.dir = [0,0,1]
		wid = (obj.max.x - obj.min.x)
		len = (obj.max.y - obj.min.y)
		rect = Rectangle length:len width:wid
		rect.pos.z = obj.pos.z
		rect.pos.x = obj.min.x + wid/2
		rect.pos.y = obj.min.y + len/2
		rect.parent = obj
		in coordsys local obj.rotation = storedRot
		rect
	)
	
	fn getRectWidth = ( 
		rect = getRectFromObject pickerObj.object
		width = rect.width as float 
		delete rect
		width
	)
	fn getRectLength= ( 
		rect = getRectFromObject pickerObj.object
		len = rect.length as float 
		delete rect
		len
	)
	fn getRectTransform = (
		rect = getRectFromObject pickerObj.object
		trans = rect.transform 
		delete rect
		trans
	)
	fn getObj = ( pickerObj.object )
	fn getCam = ( pickerCamera.object )
	fn getDistance = (spinnerDistance.value as float)
	fn getFov =  ((atan( (getRectWidth() / 2) / getDistance() ) * 2) as float)
	
	fn updateCamera = (
		cam = getCam()
		if ((classof cam) == VRayPhysicalCamera) then (
			cam.targeted = false
			cam.target_distance = getDistance()
			cam.specify_fov = true
			cam.fov = getFov()
			cam.specify_focus = true
			cam.focus_distance = getDistance()
		)
		else (
			cam.type = #free
			cam.showCone = true
			cam.baseObject.targetDistance = getDistance()
			cam.fov = getFov()
		)
		
		cam.transform = getRectTransform()
		in coordsys local move cam  [0, 0, getDistance()]
	)
	
	fn checkIfBothPicked = (
		both = false
		if getCam() != null do ( if getObj() != null do (
			both = true
		))
		both
	)
	
	on pickerCamera picked cam do (
			pickerCamera.text = cam.name
			if checkIfBothPicked() do updateCamera()
	)
	
	on pickerObj picked obj do (
			pickerObj.text = obj.name
			if checkIfBothPicked() do updateCamera()
	)
	
	on spinnerDistance changed val do (
		if checkIfBothPicked() do updateCamera()
	)
	
	on buttonRefresh pressed do (
		if checkIfBothPicked() do updateCamera()
	)
	
	on buttonUpdateRenderRatio pressed do (
		renderHeight = floor(renderWidth * getRectLength() / getRectWidth())
	)
			
	on CamToRect open do(
		-- CHECK SELECTION FOR RECTANGLES AND CAMERAS ON SCRIPT OPENING
		for i = 1 to selection.count do (
			obj = selection[i]

			if superclassof obj == shape or superclassof obj == GeometryClass do ( 
				pickerObj.object = obj
				pickerObj.text = obj.name
			)
			if superclassof obj == camera do (
				pickerCamera.object = obj
				pickerCamera.text = obj.name
			)
		)
		
		if getCam() != null do (
			--GET DISTANCE FROM CAMERA
			cam = getCam()
			if ((classof cam) == VRayPhysicalCamera) then (
				spinnerDistance.value = cam.target_distance
			)
			if ((classof cam) == Targetcamera) then (
				spinnerDistance.value = cam.targetDistance as float
			)
		)
		
		if checkIfBothPicked() do updateCamera()
	)
	
	on CamToRect close do(
	)
)
	
createDialog CamToRect