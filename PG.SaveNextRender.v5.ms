--TODO:


fn saveImage filepath = (
	local theBitmap
	local engine = renderers.current
	
	
	--IF CORONA
	if (substring (engine as string) 1 6) == "Corona" then (
		theBitmap= CoronaRenderer.CoronaFp.getVfbContent 0 true false
	)
	--IF SCANLINE OR VRAY
	else (
		theBitmap= getLastRenderedImage()
	)
	
	--local theBitmap = vrayVFBGetChannelBitmap 1
	theBitmap.filename = filepath
	save theBitmap
)

fn slashCheck p = (
	if (substring p p.count 1) != "\\" do p += "\\"
	p
)

rollout dial "Render Saver" width:300
(
	local separator = bitmap 270 1 color:[128,128,128], space = 10
	local pathColor = color 255 255 255
	
	local choosenPath
	local lastFilename
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
		edittext etNextFile across:3 width:186 height:20 
		button btnNextFileRefresh "R" offset:[65, 0]
		button btnSaveNext "Save" align:#right width:58
	)
	
	imgTag s1 bitmap:separator align:#center offset:[0, space]

	label theLabel3 "by Pawel Grzelak" offset:[-10, space] across:2
	hyperlink www "WWW.PAWELGRZELAK.COM" align:#center address:"http://pawelgrzelak.com" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255) \
		offset:[-20, space]
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
	
	
	
	fn refreshNextFilename = (
		if lastFilename != undefined then (
			local filename = getFilenameFile lastFilename
			local fileext = getFilenameType lastFilename
			
			--COUNT NUMBERS FROM BACK TO BEGINING
			local numberLength = 0
			for i = fileName.count to 1 by -1 do if fileName[i] as number != undefined then numberLength += 1 else exit

			local nameBase
			local curNum 

			if numberLength > 0 then (
				nameBase = substring filename 1 (filename.count - numberLength)
				curNum = ( substring filename (nameBase.count + 1) numberLength ) as number
			)else(
				nameBase = filename
				numberLength = 3 
				curNum = 0
			)

			local nextNum = (curNum + 1) as string
			while nextNum.count < numberLength do nextNum = "0" + nextNum
			
			etNextFile.text = nameBase + nextNum + fileext
		)
		else (
			etNextFile.text = (getFilenameFile maxfilename) + ".jpg"
		)
	)
	
	fn refreshFileList = (
		files = getFiles (choosenPath + "*.jpg")
		join files (getFiles (choosenPath + "*.png"))
		
		fileNames = #()
		for file in files do (append fileNames (filenameFromPath file))
		
		sort fileNames
			
		--INVERT
		fileNames = for i = fileNames.count to 1 by -1 collect fileNames[i]
			
		fileList.items = fileNames
		
		lastFilename = filelist.selected
		
		refreshNextFilename()
	)
	
	fn overrideLast = (
		filePath = choosenPath + "\\" + lastFilename
		
		if doesFileExist filePath do (
			msg = "Override " + (filenamefrompath filepath) + "?"
			if queryBox msg title:"Override" == true do saveImage filePath
		)
	)
	
	fn pastePath = (
		clipboard = getclipboardText()
		if isDirectoryWriteable clipboard do 
			choosenPath = slashCheck clipboard
		
		refreshPath()
		refreshFileList()
		refreshNextFilename()
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
		
		if newPath != undefined do choosenPath = slashCheck newPath
		
		refreshPath()
		refreshFileList()
		refreshNextFilename()
	)
	
	on btnPastePath pressed do (pastePath())
	
	on fileList selected idx do (
		lastFilename = fileList.selected
		refreshNextFilename()
	)
	on btnRefreshList pressed do (refreshFileList())
	on btnOverride pressed do (overrideLast())
		
	on btnNextFileRefresh pressed do (refreshNextFilename())
	on btnSaveNext pressed do (
		saveImage (choosenPath+etNextFile.text)
		refreshFileList()
	)
)

clearlistener()
createDialog dial