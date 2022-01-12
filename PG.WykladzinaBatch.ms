global wykladzinaBatch
(	
	try(destroyDialog wykladzinaBatch)catch()
	
	rollout wykladzinaBatch "Wykladzina batch" (
		local suffix = "", suffixScale = 1, suffixAdd = false, files
		
		-- DISABLE 50%%%%%@@@@@
		
		fn renderujTexture = (		
			fp = maxFilePath + (getFilenameFile maxFileName) + ".jpg"
 			render outputfile:fp vfb:false camera:cameras[1]
			
			-- if there is VrayNormalBump render element, save it too
			for n = 1 to vrayVFBGetNumChannels() do (
				if vrayVFBGetChannelName n == "VRayBumpNormals" do (
					b = vrayVFBGetChannelBitmap n
					b.filename = maxFilePath + (getFilenameFile maxFileName) + "_normal.png"
					save b gamma:1.0
				)
			)
		)
		
		fn renderujWykladzine f = (
			
			if selection.count < 1 do (
				messagebox "zanzacz podloge"
				return undefined
			)
			
			mtl = selection[1].material
			
			-- DOES THIS EVEN WORK?
			diffmap
			if (hasProperty mtl.texmap_diffuse "map1") == true then (
				diffmap = mtl.texmap_diffuse.map1
			)else(
				diffmap = mtl.texmap_diffuse
			)
			
			if f != undefined then diffmap.fileName = f
			else f = diffmap.fileName
			
			fname = getFilenameFile f
			ext = getFilenameType f
			pth = getFilenamePath f
			
			--add scale only if checked
			scalestr = if suffixAdd == True then suffix else ""
			
			wasCancelled = false
			for cam in cameras where classof cam != TargetObject do (
				res = getUserProp cam "pgres"
				suffix = getUserProp cam "pgsuffix"
				if res != undefined and suffix != undefined do (
					resx = (filterString res "x")[1] as Number
					resy = (filterString res "x")[2] as Number
					fp = pth + fname + scalestr + "_" + suffix + ext
					render outputfile:fp vfb:false camera:cam outputwidth:resx outputheight:resy cancelled:&wasCancelled
				)
				
				if wasCancelled do break
			)
		)
		
				
		fn delayedExecFiles sender evt = (
			sender.enabled = false
			dotnet.RemoveEventHandler sender "Elapsed" PerformDelayedTasks 
			---------
			
			for f in files where maxOps.canImportBitmap f and doesFileExist f do (
				renderujWykladzine f
			)
		)
		
		fn updateSuffix = (
			suffix = "_scale" + suffixScale as String
		)
		
		button btnTxt "Flat texture" across:2 pos:[10, 10]
		button btnCurrent "Current Floor" pos:[90, 10] width:80
		dotNetControl pb "System.Windows.Forms.Label" pos:[10,40] width:160 height:50
		
		checkbox chbSuffix "\"_scale\" suffix:" pos:[10, 110] checked:suffixAdd
		spinner spnScaleNum "" range:[1, 1000, suffixScale] type:#integer width:40 pos:[120, 110]
		
		on btnTxt pressed do ( renderujTexture() )
		
		on btnCurrent pressed do ( renderujWykladzine undefined )
		
		on pb DragOver s e do ( e.Effect = if e.data.ContainsFileDropList() then e.Effect.Move else e.Effect.None )
		
		on pb DragDrop s e do (
			if e.data.ContainsFileDropList() do (
								
				data = e.data.GetFileDropList()
				files = for k=0 to data.count-1 collect data.item[k]
				
				-- delayed execution to prevent win Explorer hand during the process
				delayTimer= dotnetobject "Windows.Forms.Timer"
				delayTimer.Interval=1000
				dotnet.AddEventHandler delayTimer "Tick" delayedExecFiles
				delayTimer.enabled = true
			)
		)
		
		on chbSuffix changed v do ( 
			suffixAdd = v
			updateSuffix()
		)
		
		on spnScaleNum changed v do ( 
			suffixScale = v
			updateSuffix() 
		)
		
		on wykladzinaBatch open do ( 
			pb.AllowDrop = on
			pb.TextAlign = pb.TextAlign.MiddleCenter
			pb.Text = "Drop textures here \nto batch render...";
			
			updateSuffix()
		)
	)
	
	createDialog wykladzinaBatch 180 140
	"Wykladzina Batch"
)
