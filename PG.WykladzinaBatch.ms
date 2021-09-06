global wykladzinaBatch
(
	try(destroyDialog wykladzinaBatch)catch()
	
	rollout wykladzinaBatch "Wykladzina batch" (
		fn renderujTexture = (
			fp = maxFilePath + (getFilenameFile maxFileName) + ".jpg"
			render outputfile:fp vfb:false camera:cameras[1]
		)
		
		fn renderujWykladzine f = (
			
			if selection.count < 1 do (
				messagebox "zanzacz podloge"
				return undefined
			)
			
			mtl = selection[1].material
			
			diffmap = mtl.texmap_diffuse.map1
			
			if f != undefined then diffmap.fileName = f
			else f = diffmap.fileName
			
			fname = getFilenameFile f
			ext = getFilenameType f
			pth = getFilenamePath f
				
			fp = pth + fname + "a" + ext
			render outputfile:fp vfb:false camera:cameras[1]
		
			fp = pth + fname + "b" + ext
			render outputfile:fp vfb:false camera:cameras[3]
		)
		
		button btnTxt "Texture" across:2
		button btnCurrent "Current"
		dotNetControl pb "System.Windows.Forms.Label" pos:[10,40] width:160 height:100
		
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
		
		on wykladzinaBatch open do ( 
			pb.AllowDrop = on
			pb.TextAlign = pb.TextAlign.MiddleCenter
			pb.Text = "Drop textures here \nto batch render...";
		)
	)
	
	createDialog wykladzinaBatch 180 150
	"Wykladzina Batch"
)
