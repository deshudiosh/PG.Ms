rollout CamToObject "Align Camera to Object"  width:220 (
	
	local space = 10
	local separator = bitmap 210 1 color:[128,128,128]
	
	group "Pick camera:" (
		pickbutton pickerCamera "..."
	)

	group "Pick object to align camera to:" (
		pickbutton pickerObj "..."
	)
	
	imgTag s0 bitmap:separator align:#center offset:[0, space]
	spinner spinnerDistance "Distance:" range:[1,10000,100] width:100 offset:[20, space/2+3] across:2
	button buttonRefresh "Update" offset:[0, space/2]
	button buttonUpdateRenderRatio "Update + adjust output height" tooltip:"Sets render output height\nto match objects bounding box ratio"
	
	imgTag s1 bitmap:separator align:#center offset:[0, space]
	
	label labelAccuracy "Area coverage: " align:#center offset:[0, space/2]
	

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
	
	fn round val n = 	(
		local mult = 10.0 ^ n
		(floor ((val * mult) + 0.5)) / mult
	)
	
	fn updateAccuracy = (
		objRatio = getRectLength() / getRectWidth()
		renderRatio = renderHeight as float / renderWidth as float
		coverage = (renderRatio/objRatio) * 100
		labelAccuracy.text = "Area Covarage: " + coverage as String + "%"
	)
	
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
		
		updateAccuracy()
	)
	
	fn checkIfBothPicked = (
		both = false
		if getCam() != null do ( if getObj() != null do (
			both = true
		))
		both
	)
	
	fn tryUpdate = (
		if checkIfBothPicked() do updateCamera()
	)
	
	on pickerCamera picked cam do (
			pickerCamera.text = cam.name
			tryUpdate()
	)
	
	on pickerObj picked obj do (
			pickerObj.text = obj.name
			tryUpdate()
	)
	
	on spinnerDistance changed val do (
		tryUpdate()
	)
	
	on buttonRefresh pressed do (
		tryUpdate()
	)
	
	on buttonUpdateRenderRatio pressed do (
		if checkIfBothPicked() do (
			newHeight = renderWidth * getRectLength() / getRectWidth()
			roundedNewHeight = round newHeight 0
			
			renderHeight = roundedNewHeight
			renderSceneDialog.update()
			
			updateCamera()
		)
	)
			
	on CamToObject open do(
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
			if ((classof cam) == Freecamera) then (
				cam.type = #target
				spinnerDistance.value = cam.targetDistance as float
			)
		)
		
		if checkIfBothPicked() do updateCamera()
	)
	
	on CamToObject close do(
	)
	
	imgTag s2 bitmap:separator align:#center offset:[0, space/2]

	label theLabel3 "by Pawel Grzelak" offset:[0, space]
	hyperlink www "www.pawelgrzelak.com" align:#center address:"http://pawelgrzelak.com" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
)
	
createDialog CamToObject