(
	getActiveViewSME = sme.GetView (sme.activeView)
	viewNodeCount = getActiveViewSME.GetNumNodes()
 
	smeViewMaterials = for n = 1 to viewNodeCount where isProperty trackViewNodes[#sme][sme.activeView][n] "reference" do
	(
		maxObj = trackViewNodes[#sme][(sme.activeView)][n].reference -- collect entire curent views: materials, maps, etc.
		b = getActiveViewSME.GetNodeByRef maxObj -- GetNodeByRef of entire current view
	 
		if b.selected == true do (
			if classof maxobj == Bitmaptexture do (
				fname = getFilenameFile maxobj.fileName
				if fname != "" do (
					
					ext = getFilenameType maxobj.fileName
					pth = getFilenamePath maxobj.fileName
					
					fp = pth + fname + "a" + ext
 					render outputfile:fp vfb:false camera:cameras[1]
					
					fp = pth + fname + "b" + ext
					render outputfile:fp vfb:false camera:cameras[3]
				)
			)
		)
	)
)