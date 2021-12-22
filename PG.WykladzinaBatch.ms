global wykladzinaBatch
(	
	try(destroyDialog wykladzinaBatch)catch()
	
	rollout wykladzinaBatch "Wykladzina batch" (
		local suffix = "", suffixScale = 1, suffixAdd = false
		
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
				
			fp = pth + fname + scalestr + "_a" + ext
			render outputfile:fp vfb:false camera:cameras[1]
		
			fp = pth + fname + scalestr + "_b" + ext
			render outputfile:fp vfb:false camera:cameras[3]
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
				
				for f in files where maxOps.canImportBitmap f and doesFileExist f do (
					renderujWykladzine f
				)
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
