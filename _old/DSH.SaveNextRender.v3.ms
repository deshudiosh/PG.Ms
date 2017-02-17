fn saveImage filepath = (
	local theBitmap = getLastRenderedImage()
	--local theBitmap = vrayVFBGetChannelBitmap 1
	theBitmap.filename = filepath
	save theBitmap
)

rollout dial "Render Saver" width:300
(
	local separator = bitmap 180 1 color:[128,128,128], space = 10
	local pathColor = color 255 255 255
	
	local choosenPath
	local lastFilename
	local nextFilename
	local nextNumber = 1
	
	--label theLabel1 ""	
	
	group "Path to save renders: " (
		button btnChoosePath "Choose Path [...]" width:125 align:#left across:2
		button btnPastePath "Paste Path from Clipboard" align:#right
		hyperlink hyperPath "C:/" address:"C:/" align:#left color:pathColor visitedColor:pathColor hoverColor:pathColor	
	)
	
	group "Last File: " (
		dropdownlist fileList across:3 width:188
		button btnRefreshList "R" offset:[65, 0]
		button btnOverride "Override" align:#right
	)
	
	group "Next File: " (
		edittext etNextFile across:2
		button btnSaveNext "Save Next +"
	)
	
	imgTag s1 bitmap:separator align:#center offset:[0, space]

	label theLabel3 "by Pawel Grzelak" offset:[0, space]
	hyperlink www "pawelgrzelak.com" align:#center address:"http://pawelgrzelak.com" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
		
	fn setInitialFolder = (
		local pathToOpen
		if maxfilepath != undefined do pathToOpen = maxfilepath
		if pathToOpen == undefined do pathToOpen = GetDir #Scene
		choosenPath = pathToOpen
	)
	
	fn refreshPath = (
		hyperPath.text = choosenPath
		hyperPath.address = choosenPath
	)
	
	fn nextFilenameUpdate = (
		--local filename
		--local fileext = 
	)
	
	fn refreshFileList = (
		files = getFiles (choosenPath + "*.jpg")
		
		fileNames = #()
		for file in files do (append fileNames (filenameFromPath file))
		
		sort fileNames
			
		--INVERT
		fileNames = for i = fileNames.count to 1 by -1 collect fileNames[i]
			
		fileList.items = fileNames
		
		lastFilename = filelist.selected
		
		nextFilenameUpdate()
	)
	
	fn overrideLast = (
		filePath = choosenPath + "\\" + lastFilename
		
		if doesFileExist filePath do (
			msg = "Override " + (filenamefrompath filepath) + "?"
			if queryBox msg title:"Override" == true do saveImage filePath
		)
	)
	
	on dial open do (
		setInitialFolder()
		refreshPath()
		refreshFileList()
	)
	
	on btnChoosePath pressed do (
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
	
	on fileList selected idx do (nextFilenameUpdate())
	on btnRefreshList pressed do (refreshFileList())
	on btnOverride pressed do (overrideLast())
	
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