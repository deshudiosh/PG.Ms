(
	try(destroyDialog wykladzinaBatch)catch()
	
	rollout wykladzinaBatch "Wykladzina batch" (
		fn renderujWykladzine f = (
			
			
			
			fname = getFilenameFile f
			ext = getFilenameType f
			pth = getFilenamePath f
				
			fp = pth + fname + "a" + ext
			--render outputfile:fp vfb:false camera:cameras[1]
			print fp			
			fp = pth + fname + "b" + ext
			--render outputfile:fp vfb:false camera:cameras[3]
			print fp
			
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
