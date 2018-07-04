try (destroyDialog PGBatchRender) catch()

rollout PGBatchRender "PG Batch Render" width:600 (
	
	local savepath
	
	struct pathbuilder (
		dir, filename, ext,
		fn parse p = (
			print "yyy"
			print p
		),
		fn getDisplayPath = (dir+filename+".###"+ext)
	)
	
	---------------------------------------------------------------------------------------
	
	group "Save path:" (
	dotNetControl pathLabel "Windows.Forms.Label" height:18
	)
	
	group "Cameras" (
	radiobuttons camradio labels:#("ALL", "LIST:") columns:1 across:2
	multilistbox camlist
	)
	group "Create Batch Jobs" (
	button createJobs "Create !!!" width:160 height:35
	)
	
	on pathLabel mouseclick s e do (
		if e.button == e.button.left do (
			r = PGLib.saveFileDialog()
			if r != undefined do savepath.parse r
		)
		if e.button == e.button.right do (print "right")
	)
	
	on createJobs pressed do ( )
	
	fn dotNetUpdate = (
		local font = dotnetobject "System.Drawing.Font" "Arial" 12
		local bkgCol = (colorman.getcolor #background * 255) as color
		local textalign = (dotNetClass "System.Drawing.ContentAlignment").MiddleLeft
		local backColor = (dotNetClass "System.Drawing.Color").fromArgb bkgCol.r bkgCol.g bkgCol.b
		local foreColor = (dotNetClass "System.Drawing.Color").fromArgb 255 255 255

		pathLabel.font = font
		pathLabel.textalign = textAlign
		pathLabel.backColor = backColor
		pathLabel.foreColor = foreColor
		
 		pathLabel.text = savepath.getDisplayPath()
	)
	
	on PGBatchRender open do (
		filein "PG.Lib.ms"
				
		savepath = pathbuilder()
		savepath.dir = maxFilePath
 	 	savepath.filename = getFilenameFile maxFileName
	 	savepath.ext = ".jpg"
		
		print savepath
		
		dotNetUpdate()
	)
	
)

createdialog PGBatchRender