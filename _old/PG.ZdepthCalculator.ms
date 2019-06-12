-- Written by Pawel Grzelak 
-- 2016

global resMult, dial

fn calcResolution = (
	resx = renderWidth
	resy = renderHeight
		
	mult = dial.resMult.value
	resx *= mult
	resy *= mult
		
	dial.resolution.text = (resx as integer) as String + "x" + (resy as integer) as String
	
	#(resx, resy)
)

fn getZdepthMinMax cam = (
	res = calcResolution()
	resx = res[1]
	resy = res[2]
	
	rbmp = render camera:cam outputsize:[resx, resy] channels:#(#zdepth) vfb:off progressbar:true
	
	distances = #()
	
	progressstart "Calculating distances..."
		
	for y = 0 to resy-1 do (
		progressupdate (100.0 * y / resy)
		
		for x = 0 to resx-1 do (
			val = (getchannel rbmp [x, y] #zdepth)[1]
						
			-- check if sampled zdepth pixel hit any object at all, if so, add value to array
			nonHitVal = 1e+030
			if val * -1 < nonHitVal do append distances val 
		)
	)
	
	progressend()
	
	sort distances
	
	-- if no distances found, use defaults to omit errors
	if distances.count < 2 do distances = #(-100, 0)
	
	minmax = [distances[distances.count]*-1, distances[1]*-1]
	minmax
)

fn calcForCamera cam = (	
	minmax = getZdepthMinMax cam
	
	cam.nearrange = minmax[1]
	cam.farrange = minmax[2]
	cam.showRanges = true
	
	dial.stats.text = minmax[1] as String + "   " + minmax[2] as String
)

fn renderZdepth cam = (
	zname = "Z_Depth_Calculated"
	
	re = maxOps.GetCurRenderElementMgr()
	
	--remove old zdepth pass if its there
	for i = 1 to re.NumRenderElements() do (
		element = re.GetRenderElement (i-1)
		if element.elementName == zname do re.RemoveRenderElement element
	)
		
	--add zdepth render element with proper zmin and zmax
	re.addRenderElement (Z_Depth elementname:zname zMin:cam.nearRange zMax:cam.farRange filterOn:false)

	-- render view from camera and display only zdepth channel
	elementsArray = #()
	render camera:cam vfb:off renderElementBitmaps:&elementsArray progressbar:true
	display elementsArray[elementsArray.count]
)
	
rollout dial "Zdepth Calculator" width:250
(
	label theLabel ""
	group "Pick camera:" ( pickbutton pickerCamera "..." )
	label theLabel1 ""
	group "Calculate:" (
		button buttonCalc "Calculate"
		spinner resMult "Accuracy:" range:[.1, 10.0, 1.0] align:#center width:80 offset:[13,0]
		edittext resolution "Calculations resolution:" readonly:true text:(renderWidth as String + "x" + renderHeight as String)
		edittext stats "Near / Far:" readonly:true
	)
	label theLabel1b ""
	group "Render:" (
-- 		label labelFiltering "Enable Filtering" across:3 offset:[10,4]
-- 		checkbox chbFiltering  checked:false offset:[15,4]
-- 		button buttonRender "Render Zdepth" offset:[-10,-1]
		
		button buttonRender "Render Zdepth"
	)
	
	on buttonCalc pressed do (
		cam = pickerCamera.object
		if cam != undefined do calcForCamera cam
	)
	
	on buttonRender pressed do (
		cam = pickerCamera.object
		--filtering = chbFiltering.checked
		if cam != undefined do renderZdepth cam
	)	
	
	on pickerCamera picked cam do ( pickerCamera.text = cam.name )
	on resMult changed val do ( calcResolution() )
	
	fn selectCamera cam = (
		pickerCamera.object = cam
		pickerCamera.text = cam.name
	)
	
	on dial open do(
		-- CHECK SELECTION FOR CAMERA ON SCRIPT OPENING
		for i = 1 to selection.count do (
			obj = selection[i]

			if superclassof obj == camera do (
				pickerCamera.object = obj
				pickerCamera.text = obj.name
			)
		)
		-- OR, IF NO CAMERA SELECTED, CHECK IF THERE IS ONLY ONE CAMERA IN SCENE
		if pickerCamera.object == undefined \
		AND cameras.count == 1 \
		AND superclassof cameras[1] == camera \
			do selectCamera cameras[1]
	)
	
	on dial close do(
	)
	
	label theLabel2 ""
	label theLabel3 "by Pawel Grzelak"
	hyperlink www "be.net/pawelgrzelak" address:"http://be.net/pawelgrzelak" offset:[64,2] \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
)

createDialog dial