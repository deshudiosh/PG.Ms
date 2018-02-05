fn closeBRdialog = (
	t=windows.getChildHWND 0 "Batch Render" 
	if t != undefined do windows.sendMessage t[1] 0x0112 0xF060 0
)

fn openBRdialog = (
	actionMan.executeAction -43434444 "4096"
)

fn compareNames str1 str2 = stricmp str1.name str2.name

fn removeViews = ( while batchRenderMgr.numviews > 0 do ( batchRenderMgr.deleteview 1 ) )

fn createViewPerCam = (
	
	cams = for cam in Cameras where (classof cam != Targetobject) collect cam
	qSort cams compareNames
	
	for cam in cams do ( 
		view = batchRenderMgr.createview cam
		view.camera = cam
		view.outputFilename = (maxFilePath + "/" + cam.name + ".jpg")
		--view.name = cam.name
	)
)

fn br = (
	closeBRDialog()
	removeViews()
	createViewPerCam()
	openBRdialog()
)

clearlistener()
br()