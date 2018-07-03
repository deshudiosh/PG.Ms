try (destroyDialog PGBatchRender) catch()

rollout PGBatchRender "PG Batch Render" width:600 (
	-- load from file on open
	local dir = maxFilePath
	local prefix = (getFilenameFile maxFileName)
	
	fn closeBRdialog = (
		t=windows.getChildHWND 0 "Batch Render" 
		if t != undefined do windows.sendMessage t[1] 0x0112 0xF060 0
	)

	fn openBRdialog = (
		actionMan.executeAction -43434444 "4096"
	)

	fn compareNames str1 str2 = stricmp str1.name str2.name

	fn removeViews = ( while batchRenderMgr.numviews > 0 do ( batchRenderMgr.deleteview 1 ) )

	fn createBatchViews dir prefix = (
		
		cams = for cam in Cameras where (classof cam != Targetobject) collect cam
		qSort cams compareNames
		
		for cam in cams do ( 
			view = batchRenderMgr.createview cam
			view.camera = cam
			view.outputFilename = (dir + "/" + prefix + "." + cam.name + ".jpg")
			view.name = cam.name
		)
	)

	fn br dir prefix = (
		closeBRDialog()
		removeViews()
		createBatchViews dir prefix
		openBRdialog()
	)

	
	---------------------------------------------------------------------------------------
	
			
	group "Save path:" (
	dotNetControl dirLabel "Windows.Forms.Label" height:18
	)

	group "Prefix"(
	dotNetControl prefixLabel "Windows.Forms.Label" height:20
	)
	
	group "Cameras" (
	radiobuttons camradio labels:#("ALL", "LIST:") columns:1 across:2
	multilistbox camlist
	)
	group "Create Batch Jobs" (
	button createJobs "Create !!!" width:160 height:35
	)
	
	on dirLabel mouseclick s e do (
		if e.button == e.button.left do (print "left")
		if e.button == e.button.right do (print "right")
	)
	
	on prefixLabel mouseclick s e do (
		prefix = (PGLib.askForStringWithDefault prefix)
		prefixLabel.text = prefix
	)
	
	on createJobs pressed do ( br dir prefix )
	
	fn dotNetUpdate = (
		local font = dotnetobject "System.Drawing.Font" "Arial" 12
		local bkgCol = (colorman.getcolor #background * 255) as color
		local textalign = (dotNetClass "System.Drawing.ContentAlignment").MiddleLeft
		local backColor = (dotNetClass "System.Drawing.Color").fromArgb bkgCol.r bkgCol.g bkgCol.b
		local foreColor = (dotNetClass "System.Drawing.Color").fromArgb 255 255 255

		dirLabel.font = prefixLabel.font = font
		dirLabel.textalign = prefixLabel.textalign = textAlign
		dirLabel.backColor = prefixLabel.backColor = backColor
		dirLabel.foreColor = prefixLabel.foreColor = foreColor
		
		dirLabel.text = dir
		prefixLabel.text = prefix
	)
	
	on PGBatchRender open do (
		filein "PG.Lib.ms"
		dotNetUpdate()
	)
	
)

createdialog PGBatchRender