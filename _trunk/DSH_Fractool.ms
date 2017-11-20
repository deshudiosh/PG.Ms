plugin SimpleMod FractoolCtrl
name:"Fractool Controll"
classID:#(0x53d0300d, 0x516d5d2b)
version:1
(
	parameters main rollout:params
	(
		refObj type:#node ui:pickerRefObj
		copies type:#integer ui:spinnerCopies default:15
		
		twistEnable type:#boolean ui:cbTwist default:false
		twistX type:#float ui:spTwistX
		twistY type:#float ui:spTwistY
		twistZ type:#float ui:spTwistZ
		
		mirrored type:#boolean ui:cbMirrored default:false
		mirrorX type:#boolean ui:cbMirrorX default:true
		mirrorY type:#boolean ui:cbMirrorY default:true
		mirrorZ type:#boolean ui:cbMirrorZ default:true
		
		offsetEnable type:#boolean ui:chbOffset default:false
		offsetX type:#float ui:spOffsetX
		offsetY type:#float ui:spOffsetY
		offsetZ type:#float ui:spOffsetZ
		
		prevEnable type:#boolean ui:chbPrevEnable default:false
		prevPercent type:#integer ui:sldPrevPercent default:50
		prevHideOption type:#integer ui:rbPrevHideOption default:1
	)
	rollout params "Fractool Controlls"
	(
		group "Reference Geometry" (
			pickbutton pickerRefObj "Pick Ref. Geo" width:120
		)
		group "Complexity" (
			spinner spinnerCopies "Num. copies " range:[1, 9999, 3] type:#integer align:#center
		)
		group "Scale" (
			button btnScaleReset "Reset" 
				on btnScaleReset pressed do ( 
					this.Gizmo.transform *=inverse (scaleMatrix this.Gizmo.transform.scalepart) )
			button btnAutoShrink "Auto Shrink"
				on btnAutoShrink pressed do (
					local mx = copy this.gizmo.transform
					mx *= inverse (scaleMatrix mx.scalePart)
					local s = 1.0 - 1.0 / copies * 4 --last element is still too big
					mx *= scaleMatrix [s, s, s]
					this.gizmo.transform = mx
				)
		)
		
		group "Twist" (
			checkbox cbTwist "Enable Twist" align:#center
			spinner spTwistX "X: " range:[-9999, 9999, 0] width:120 align:#center
			spinner spTwistY "Y: " range:[-9999, 9999, 0] width:120 align:#center
			spinner spTwistZ "Z: " range:[-9999, 9999, 0] width:120 align:#center
			on cbTwist changed val do 
				spTwistX.enabled = spTwistY.enabled = spTwistZ.enabled = val
		)

		group "Mirror" (
			checkbox cbMirrored "Enable Mirror" align:#center
			checkbox cbMirrorX "X" align:#center across:3
			checkbox cbMirrorY "Y" align:#center
			checkbox cbMirrorZ "Z" align:#center
			on cbMirrored changed val do 
				cbMirrorX.enabled = cbMirrorY.enabled = cbMirrorZ.enabled = val
		)
		
		group "Offset" (
			checkbox chbOffset "Enable Offset" align:#center
			spinner spOffsetX "X: " range:[-9999, 9999, 0] width:120 align:#center
			spinner spOffsetY "Y: " range:[-9999, 9999, 0] width:120 align:#center
			spinner spOffsetZ "Z: " range:[-9999, 9999, 0] width:120 align:#center
			on chbOffset changed val do 
				spOffsetX.enabled = spOffsetY.enabled = spOffsetZ.enabled = val
		)
		
		group "Element Visibility" (
			checkbox chbPrevEnable "Enable" align:#center
			spinner sldPrevPercent "% visible:" range:[1, 100, 50] type:#integer fieldwidth:50 align:#center
			label x "hide:" align:#center
			radiobuttons rbPrevHideOption labels:#("end / tip", "random", "regular") columns:2
		)

	)
	on map i p do	(	)
)



plugin SimpleObject Fractool
name:"Fractool"
category:"Deshu"
classID:#(1517193714, -2120603211)
(
	
	local thisNode, storedTempMesh, ctrlModifier, whenHandler
	
	parameters main rollout:params (
		refObj type:#node
		transObj type:#node
		transMX type:#matrix3
		copies type:#integer
		twisted type:#boolean
		twistValue type:#point3
		mirrored type:#boolean
		mirrorAxes type:#point3
		offsetEnable type:#boolean
		offsetValue type:#point3
		prevEnable type:#boolean
		prevPercent type:#integer
		prevHideOption type:#integer
	)
	
-- 	on create do (
-- 		print ("thisNode: " + thisNode as String)
-- 		print ("storedTempMesh: " + storedTempMesh as String)
-- 		print ("ctrlModifier: " + ctrlModifier as String)
-- 		print ("whenHandler: " + whenHandler as String)
-- 	)
	
	fn getInsCount = (
		local instanceNumber = (getClassInstances Fractool).count
		instanceNumber as String
	)
	
	fn getVisibilityForIteration i = (
		visible = true
		if prevEnable do (
			case prevHideOption of (
				1: if (i > copies*prevPercent/100) do visible = false
				2: if random 0 100 > prevPercent do visible = false
				3: (
					nth = (100 / prevPercent)
					if mod i nth != 0 do visible = false
				)
			)
		)
		visible --return
	)
	
	fn applyMatrixToMesh msh mx times:1 = (
		for k = 1 to getNumVerts msh do (
				v = getVert msh k
				for i = 1 to times do 
					v *= mx
				setVert msh k v
		)
		msh -- return
	)
	
	fn mirrorMesh msh = (
		for k = 1 to getNumVerts msh do (
			v = getVert msh k
			if mirrorAxes.x == 1 do v.x *= -1	
			if mirrorAxes.y == 1 do v.y *= -1
			if mirrorAxes.z == 1 do v.z *= -1
			setVert msh k v
		)
		msh -- return
	)
	
	fn applyOffsetToMesh msh = (
		if offsetEnable do (
			for k = 1 to getNumVerts msh do (
				v = getVert msh k
				v += offsetValue
				setVert msh k v
			)
		)
		msh -- return
	)
	
	fn applyTwistToMesh msh = (
		if twisted do (
			for k = 1 to getNumVerts msh do (
				v = getVert msh k
				v *= eulerToQuat( eulerAngles twistValue.x twistValue.y twistValue.z)
				setVert msh k v
			)
		)
		msh -- return
	)
	
	on buildMesh do (
		undo off ( 
			if refObj != undefined then (
				delete mesh

				local curMesh -- store previous iteration mesh (high performance gain!)
				
				for i = 0 to (copies - 1) do (
					visible = true

					-- initial iteration stuff
					if i == 0 then (
						curMesh = copy refObj.mesh
						
						--just attach one initial mesh without any changes
						meshop.attach mesh (applyOffsetToMesh (copy curMesh))
						
						if mirrored do
							meshop.attach mesh (mirrorMesh (applyOffsetToMesh (copy curMesh)))
					)
					-- transformed copies
					else (
						--//optimalization: apply matrix only when visible
						--//it will need multiple applies if previous iterations were invisible
						--//use "times" argument in applyMAtrixToMesh for that
						
						applyMatrixToMesh curMesh transMX
						applyTwistToMesh curMesh
						
						-- attach mesh only if this element is visible
						if visible do (
							local offsetMesh = copy curMesh
							applyOffsetToMesh offsetMesh
							
							meshop.attach mesh offsetMesh
							if mirrored do
								meshop.attach mesh (mirrorMesh (copy offsetMesh))
						)						
					)
					
				)	
			)
			-- if no ref mesh selected
			else (if storedTempMesh != undefiend do mesh = copy storedTempMesh)
		)
	)
	
	
	fn updateParams = (
		if ctrlModifier != undefined do (
-- 			print "updateParams()"
			copies = ctrlModifier.copies
			refObj = ctrlModifier.refObj
			transMX = ctrlModifier.gizmo.transform
			twisted = ctrlModifier.twistEnable
			twistValue.x = ctrlModifier.twistX
			twistValue.y = ctrlModifier.twistY
			twistValue.z = ctrlModifier.twistZ
			mirrored = ctrlModifier.mirrored
			mirrorAxes.x = if ctrlModifier.mirrorX then 1 else 0
			mirrorAxes.y = if ctrlModifier.mirrorY then 1 else 0
			mirrorAxes.z = if ctrlModifier.mirrorZ then 1 else 0
			offsetEnable = ctrlModifier.offsetEnable
			offsetValue.x = ctrlModifier.offsetX
			offsetValue.y = ctrlModifier.offsetY
			offsetValue.z = ctrlModifier.offsetZ
			prevEnable = ctrlModifier.prevEnable
			prevPercent = ctrlModifier.prevPercent
			prevHideOption = ctrlModifier.prevHideOption
		)
	)
	
	fn up = updateParams()
	
	on attachedToNode nd do (
		thisNode = nd
		
		registerTimeCallback up
	)
	
	fn getTempMesh = (			
		local txt = Text size:4 text:("Fractool_" + getInsCount())
		addmodifier txt (Extrude amount:1)
		rotate txt (eulerAngles 90 0 0)
		local tempMesh = copy txt.mesh
		applyMatrixToMesh tempMesh txt.transform
		delete txt
		tempMesh
	)
	
	fn createTempMesh gridPoint = (
		storedTempMesh = getTempMesh()
		move thisNode gridPoint
		setMesh mesh storedTempMesh
	)
	
	tool create (
		on mousePoint click do (
			case click of (
				1: (
-- 					coordsys grid (nodeTM.translation = gridPoint)
					thisNode.name = "Fractool_" + getInsCount()
					createTempMesh gridPoint
				)
				2: (#stop)
			)
		)
	)
	
	fn addWhenHandler = (
		whenHandler = when parameters ctrlModifier changes do ( updateParams() )
	)
	
	fn addControlModifier = (
		if ctrlModifier == undefined do (	
			ctrlModifier = FractoolCtrl()
			ctrlModifier.gizmo.transform = (transMatrix [0, 0, 5])
			addmodifier thisNode ctrlModifier
			
			addWhenHandler()
		)
	)

	fn getNode =	(
		local theNode = undefined
		local con = true -- continue loop
		for obj in refs.dependents this where con and isValidNode obj and obj.baseobject == this do (
			theNode = obj
			con = false
		)
		theNode -- return
	)
	
	on load do (
		thisNode = getNode()
		
		for i = 1 to thisNode.modifiers.count do (
			if ClassOf thisNode.modifiers[i] == FractoolCtrl do (
				ctrlModifier = thisNode.modifiers[i]
			)
		)
	)
	
	on postLoad do (
		addWhenHandler()
		
		registerTimeCallback up
	)
	
	rollout params "Fractool" (
		group "Fractool Controlls" (
			button btnAddCtrl "Apply"
				on btnAddCtrl pressed do (  addControlModifier() )
		)
	)
)