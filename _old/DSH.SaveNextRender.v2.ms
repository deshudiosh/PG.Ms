fn saveImage filepath = (
	local theBitmap = getLastRenderedImage()
	--local theBitmap = vrayVFBGetChannelBitmap 1
	theBitmap.filename = filepath
	save theBitmap
)

rollout dial "Render Saver" width:250
(
	local separator = bitmap 180 1 color:[128,128,128], space = 10
	local choosenPath
	
	local nextNumber = 1
	
	label theLabel1 ""	
	
	button btnChooseFolder "Choose Folder [...]"
	dropdownlist fileList 
	local pathColor = color 255 255 255
	hyperlink hyperPath "C:/" address:"C:/" align:#center color:pathColor visitedColor:pathColor hoverColor:pathColor	
	button btnSaveLast "Override Last"	
	button btnSaveNext "Save Next +"
	
	imgTag s1 bitmap:separator align:#center offset:[0, space]

	label theLabel3 "by Pawel Grzelak" offset:[0, space]
	hyperlink www "pawelgrzelak.com" align:#center address:"http://pawelgrzelak.com" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
		
	on dial open do (
	)
	
	on btnChooseFolder pressed do (
		--TRY ALREADY CHOOSEN PATH
		local pathToOpen = choosenPath
		
		--TRY CURENT MAX FILE PATH (may be saved since opening the script)
		if pathToOpen == undefined do (if maxfilepath != undefined do pathToOpen = maxfilepath)
		--if newPath == undefined and maxfilepath != undefined do newPath = getSavePath caption:"2" initialDir:maxfilepath
		
		--IF STILL UNDEFINED USE DEFAULT LOCATION
		if pathToOpen == undefined do pathToOpen = GetDir #Scene
		
		local newPath = getSavePath initialDir:pathToOpen
		
		if newPath != undefined do choosenPath = newPath
	)
	
	on btnSaveLast pressed do (
		if lastpath != undefined then saveImage lastpath
		else messagebox "Use \"Save As...\" at least once." title:"Override Last"
	)
	
	on btnSaveNext pressed do (
		if lastpath != undefined then (
			filepath = getFilenamePath lastpath
			filename = getFilenameFile lastpath
			fileext = getFilenameType lastpath
			
			-----MOŻE  kropka ZAMIAST UNDERSCORE?
			newpath = filepath + filename + "_" + nextNumber as String + fileext
			saveImage newpath
			nextNumber += 1
		)
		else messagebox "Use \"Save As...\" at least once." title:"Save Next"
	)
)

clearlistener()
createDialog dial