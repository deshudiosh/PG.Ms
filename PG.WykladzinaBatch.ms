(
	try(destroyDialog wykladzinaBatch)catch()
	
	rollout wykladzinaBatch "Wykladzina batch" (
		fn renderujWykladzine f = (
			
			if selection.count < 1 do (
				messagebox "zanzacz podloge"
				return undefined
			)
			
			mtl = selection[1].material
			
			diffmap = mtl.texmap_diffuse.map1
			diffmap.fileName = f
			
			fname = getFilenameFile f
			ext = getFilenameType f
			pth = getFilenamePath f
				
			fp = pth + fname + "a" + ext
			render outputfile:fp vfb:false camera:cameras[1]
		
			fp = pth + fname + "b" + ext
			render outputfile:fp vfb:false camera:cameras[3]
		)
		
		dotNetControl pb "System.Windows.Forms.PictureBox" pos:[0,30] width:180 height:120
			
		on wykladzinaBatch open do ( pb.AllowDrop = on)
		
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
	)
	
	createDialog wykladzinaBatch 180 150
	"Wykladzina Batch"
)
