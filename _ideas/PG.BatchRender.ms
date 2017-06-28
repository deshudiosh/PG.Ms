fn closeBRdialog = (
	t=windows.getChildHWND 0 "Batch Render" 
	if t != undefined do windows.sendMessage t[1] 0x0112 0xF060 0
)

fn openBRdialog = (
	actionMan.executeAction -43434444 "4096"
)

fn removeViews brm = (
	print brm.numviews
	for i = 1 to brm.numviews do ( brm.deleteview i )
)

fn createViewPerCam brm = (
	for cam in Cameras do (
		if classof cam != Targetobject do (  
			view = brm.createview cam
		)
	)
)

fn br = (
	brm = batchRenderMgr
	
	removeViews brm
	closeBRDialog()
	createViewPerCam brm
	openBRdialog()
)

clearlistener()
br()