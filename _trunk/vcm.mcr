/*
VRay Camera Manager 1.0.02
(c) Dan Brew 2013
Feature Requests and Bug Reports Please Post on: www.scriptspot.com/3ds-max/scripts/vray-camera-manager
*/
macroScript VCM
buttonText:"VCM"
category:"VRay"
internalCategory:"VRay"
tooltip:"VRay Camera Manager"
Icon:#("Cameras" ,3)
(
	try(vrcMan.vrcForm.close()) catch()
	
	struct vrcManStr
	(
		vrcForm, --the MaxForm
		vrcDGV,
		rcMen,
		rcItems,
		ccRoll, --column chooser rollout
		handle, -- handle of current camera
		cList = #("Camera Name", "Targeted", "Targ. Dst.", "F. Length", "FOV", "Exposure", "F-Number", "FLk", "Shutter", "SLk", "Film ISO", "ILk", "Vignetting", "Vig. Amt.", "WB", "Dof","Mo-blur", "Subdivs", "Clipping", "Clip Near", "Clip Far"), --array of column headers
		cnCol = findItem cList "Camera Name",
		tgCol = findItem cList "Targeted",
		tdCol = findItem cList "Targ. Dst.",
		flCol = findItem cList "F. Length",
		fovCol = findItem cList "FOV",
		exCol = findItem cList "Exposure",
		fnCol = findItem cList "F-Number",
		fnLCol = findItem cList "FLk",
		shCol = findItem cList "Shutter",
		shLCol = findItem cList "SLk",
		isoCol = findItem cList "Film ISO",
		isoLCol = findItem cList "ILk",
		vigCol = findItem cList "Vignetting",
		vigACol = findItem cList "Vig. Amt.",
		wbCol = findItem cList "WB",
		dofCol = findItem cList "Dof",
		mbCol = findItem cList "Mo-blur",
		sdivCol = findItem cList "Subdivs",
		clipCol = findItem cList "Clipping",
		clipnCol = findItem cList "Clip Near",
		clipfCol = findItem cList "Clip Far",
		
		cVis,
		camCallback,
		lockImage,
		unlockImage,
		lockRedB64 = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAALEAAACxABrSO9dQAAACt0RVh0Q3JlYXRpb24gVGltZQBXZWQgNiBGZWIgMjAxMyAxNjowMzoyNSAtMDAwMEIlrmIAAAAHdElNRQfdAgYQBR0/iJIBAAAAk0lEQVQ4T2NggIITQBoJGwDZF4D4PxQ/ANIByGpg+uA0mmaYRnQaZDDYInwGbIDaCnKBAhALAPEBqNgCYgyA2Qq3DWoQSPwDKQYghwmIDTOYoBdQFCKFDe0NQI42XLEAE7+ALRYIaUKRp5sBoHhvQIoBuCuIdQEoURVQYgDFLgAZMIESF+CMGWxhAErnxEblB5gBAAVxHYdureS6AAAAAElFTkSuQmCC",
		lockGreyB64 = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAALEAAACxABrSO9dQAAAAd0SU1FB90CBhAGDQkS0aYAAADeSURBVDhPlc/rDYIwFAVgRnAERmAUh2AAR2AADWB8EQw24hODIMH41xEYwRHY4HqbtIT0lgAkXwrntofUMMRj27Yhle+PhSoEwg/XaXuPPNesclgUpYWggyX3dRZk2StHgCpkogn6ioz1FqTpE4Tmb/htiqzuLUiSB3Dt+/J3Ne+8wu16B04tUPPOgvPpApxaoOakID7GFYKBKlLADgzGIAXRPoIxSEEYhKDBMHN0M1IQbHegkWM2081IwWa1Bg2GmaObkYKVvwQNhpmnm5EC3/VgDFLgzhc1goFqWfAHsonNB5m4wXkAAAAASUVORK5CYII=",
		camProps,
		copySet,
		newSet,
		
		fn onFormClosed s e =
		(
			vrcMan.rcMen.Dispose()
			vrcMan.vrcDGV.Dispose()
			vrcMan.vrcForm.Dispose()
			if vrcMan.camCallback != undefined then vrcMan.camCallback = undefined
			else print "Callback not cleared!"
			vrcMan = undefined
			gc light:true
			updateToolbarButtons()
		),
		
		fn cellClick s e =
		(
			local rowI = e.RowIndex
			
			case rowI of
			(
				(-1):(if e.button == e.button.right do vrcMan.columnChooser())
				default:
				(
					local row = s.rows.item[rowI]
					local cell = row.cells.item[e.columnIndex]
					vrcMan.handle = s.rows.item[rowI].cells.item[0].value
					
					case e.button of
					(
						(e.button.right):
						(
							local cursor = dotnetclass "System.Windows.Forms.Cursor"
							local mPt = cursor.Position
							vrcMan.rcMen.Show mPt.x (mPt.y+5)
							cell.selected = true
						)
						(e.button.left):
						(
							case (s.columns.item[e.ColumnIndex]).name of
							(
								"FLk":
								(
									cell.selected = false
									if cell.value == vrcMan.lockImage then
									(
										cell.value = vrcMan.unlockImage
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.fnCol false
										row.tag = "none"
									)
									else
									(
										cell.value = vrcMan.lockImage
										row.cells.item[vrcMan.shLCol].value = vrcMan.unlockImage
										row.cells.item[vrcMan.isoLCol].value = vrcMan.unlockImage
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.fnCol true
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.shCol false
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.isoCol false
										row.tag = "aperture"
									)
								)
								"SLk":
								(
									cell.selected = false
									if cell.value == vrcMan.lockImage then
									(
										cell.value = vrcMan.unlockImage
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.shCol false
										row.tag = "none"
									)
									else
									(
										cell.value = vrcMan.lockImage
										row.cells.item[vrcMan.fnLCol].value = vrcMan.unlockImage
										row.cells.item[vrcMan.isoLCol].value = vrcMan.unlockImage
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.fnCol false
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.shCol true
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.isoCol false
										row.tag = "shutter"
									)
								)
								"ILk":
								(
									cell.selected = false
									if cell.value == vrcMan.lockImage then
									(
										cell.value = vrcMan.unlockImage
										if isoCol != 0 do vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.isoCol false
										row.tag = "none"
									)
									else
									(
										cell.value = vrcMan.lockImage
										row.cells.item[vrcMan.fnLCol].value = vrcMan.unlockImage
										row.cells.item[vrcMan.shLCol].value = vrcMan.unlockImage
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.fnCol false
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.shCol false
										vrcMan.cellrw (vrcMan.vrcDGV) row.index vrcMan.isoCol true
										row.tag = "iso"
									)
								)
								"WB":
								(
									cell.selected = false
									local currentCam = GetAnimByHandle vrcMan.handle
									local newWB = colorPickerDlg currentCam.whiteBalance "White Balance" alpha:false
									if newWB != undefined do currentCam.whiteBalance = newWB
									vrcMan.vrcDGV.rows.item[e.RowIndex].SetValues (vrcMan.createRow currentCam)
									vrcMan.formatRow (vrcMan.vrcDGV) currentCam e.RowIndex
								)
							)
							vrcMan.vrcDGV.InvalidateRow row.index
						)
					)
				)
			)
		),
		
		fn rcMenuHandler s e =
		(
			local currentCam = GetAnimByHandle vrcMan.handle
			
			case e.ClickedItem.Text of
			(
				"Select Camera":(select currentCam)
				"Send to Camera VP":( vrcMan.camToCamVP currentCam)
				"Send to Current VP":(viewport.setCamera currentCam;select currentCam)
				"Copy Settings":(vrcMan.getCamSettings currentCam #copy)
				"Paste Settings":(vrcMan.setCamSettings currentCam #copy)
				"Convert VP/non VRay Cam":(if viewport.getType index:(viewport.activeViewport) == #view_persp_user or viewport.getType index:(viewport.activeViewport) == #view_camera do vrcMan.convertVP currentCam)
				"Delete Camera":(if (queryBox "Detete Camera?" title:"Confirm Deletion") do with undo "delete camera" on delete currentCam)
			)
		),
		
		fn CBColChanged s e =
		(
			if e.RowIndex != -1 do
			(
				s.commitEdit (dotNetClass "DataGridViewDataErrorContexts").commit
				
				local row = e.RowIndex
				local column = e.ColumnIndex
				local t = s.rows.item[row].cells.item[column].value
				local currentCam = GetAnimByHandle (s.rows.item[row].cells.item[0].value)
				
				case (s.columns.item[column]).headerText of
				(
					"Targeted":
					(
						with undo "change camera settings" on (currentCam.targeted = t)
						vrcMan.cellrw s row vrcMan.tdCol t
					)
					"Vignetting":
					(
						with undo "change camera settings" on (currentCam.vignetting = t)
						vrcMan.cellrw s row vrcMan.vigACol (not t)
					)
					"Clipping":
					(
						with undo "change camera settings" on (currentCam.clip_on = t)
						vrcMan.cellrw s row vrcMan.clipnCol (not t)
						vrcMan.cellrw s row vrcMan.clipfCol (not t)
					)
					"Exposure":(with undo "change camera settings" on (currentCam.exposure = t))
					"Dof":(with undo "change camera settings" on (currentCam.use_dof = t))
					"Mo-Blur":(with undo "change camera settings" on (currentCam.use_moblur = t))
				)
			)
		),
		
		fn textColChanged s e =
		(
			local currentCam = GetAnimByHandle (s.rows.item[e.RowIndex].cells.item[0].value)
			local newVal = s.rows.item[e.RowIndex].cells.item[e.ColumnIndex].value
			if newVal != (dotNetClass "System.DBNull").value then with undo "change camera settings" on
			(
				case (s.columns.item[e.ColumnIndex]).headerText of
				(
					"Camera Name":
					(
						if newVal != undefined then currentCam.name = newVal
						else
						(
							vrcMan.vrcDGV.rows.item[e.RowIndex].SetValues (vrcMan.createRow currentCam)
							vrcMan.formatRow (vrcMan.vrcDGV) currentCam e.RowIndex
						)
					)
					"Targ. Dst.":(currentCam.target_distance = newVal)
					"F. Length":
					(
						currentCam.specify_fov = false
						currentCam.focal_length = newVal
					)
					"FOV":
					(
						currentCam.specify_fov = true
						currentCam.fov = newVal
					)
					"F-Number":
					(
						case s.rows.item[e.RowIndex].tag of
						(
							"shutter":(currentCam.iso = currentCam.iso*((newVal/currentCam.f_number)^2))
							"iso":(currentCam.shutter_speed = currentCam.shutter_speed*((currentCam.f_number/newVal)^2))
						)
						currentCam.f_number = newVal
					)
					"Shutter":
					(
						case s.rows.item[e.RowIndex].tag of
						(
							"aperture":(currentCam.iso = currentCam.iso*(newVal/currentCam.shutter_speed))
							"iso":(currentCam.f_number = currentCam.f_number*(1/(sqrt(newVal/currentCam.shutter_speed))))
						)
						currentCam.shutter_speed = newVal
					)
					"Film ISO":
					(
						case s.rows.item[e.RowIndex].tag of
						(
							"aperture":(currentCam.shutter_speed = currentCam.shutter_speed*(newVal/currentCam.iso))
							"shutter":(currentCam.f_number = currentCam.f_number*(sqrt(newVal/currentCam.iso)))
						)
						currentCam.iso = newVal
					)
					"Vig. Amt.":(currentCam.vignetting_amount = newVal)
					"Subdivs":(currentCam.subdivs = newVal)
					"Clip Near":(currentCam.clip_near = newVal)
					"Clip Far":(currentCam.clip_far = newVal)
				)
			)
			else
			(
				vrcMan.vrcDGV.rows.item[e.RowIndex].SetValues (vrcMan.createRow currentCam)
				vrcMan.formatRow (vrcMan.vrcDGV) currentCam e.RowIndex
			)
		),
		
		fn onCellPainting s e = --Thanks denisT
		(
			if e.RowIndex !=-1 and (s.columns.item[e.ColumnIndex]).ValueType == (dotNET.getType "Single") do
			(
				local cell = s.rows.item[e.RowIndex].cells.item[e.ColumnIndex]
				cell.Style = if cell.ReadOnly then s.DefaultCellStyle else s.RowsDefaultCellStyle
			)
		),
		
		fn ConvertBase64StringToImage string = --thanks Pete Addington (loneRobot)
		(
			local byteArr = (dotnetclass "system.convert").FromBase64String string
			memstream = dotnetobject "System.IO.MemoryStream" byteArr
			decodedImg = (dotnetclass "system.drawing.image").fromstream memstream
			memstream.close()
			decodedImg
		),
		
		fn getCamSettings c dest =
		(
			camProps = getPropNames c
			case dest of
			(
				#copy:(copySet = for n in camProps collect (getProperty c n))
				#new:(newSet = for n in camProps collect (getProperty c n))
			)
		),
		
		fn setCamSettings c source =
		(
			case source of
			(
				#copy:(cSet = copySet)
				#new:(cSet = newSet)
			)
			
			if cSet != undefined do
			(
				for p = 1 to cSet.count do
				(
					if cSet[p] != undefined then
					(
						setProperty c camProps[p] cSet[p]
					)
					else
					(
						if camProps[p] == #lens_file then setProperty c camProps[p] "" else setProperty c camProps[p] undefined
					)
				)
			)
			if c.whiteBalance_preset != 7 do
			(
				setProperty c #whiteBalance cSet[findItem camProps #whiteBalance]
			)
		),
		
		fn camToCamVP c =
		(
			local nVP = viewport.numViews
			local cVP = 1
			do
			(
				local cvpType = viewport.getType index:cVP
				if cvpType == #view_camera or cvpType == #view_persp_user do
				(
					viewport.activeViewport = cVP
					viewport.setCamera c
					select c
				)
				cVP+=1
			)
			while (cvpType != #view_camera or cvpType != #view_persp_user) and cVP <= nVP
		),
		
		fn convertVP oldCam =
		(
			getCamSettings oldCam #new
			local newCam = vrayPhysicalCamera wirecolor:(color 87 120 204)
			newCam.transform = Inverse(getViewTM())
			
			if (local maxCam = viewport.getCamera()) != undefined do
			(
				viewport.setType #view_persp_user
				if queryBox ("Copy animation from " + maxCam.name + "?") title:"Animation" beep:false do newCam.controller = copy maxCam.controller
			)
			
			setCamSettings newCam #new
			local sfov = newCam.specify_fov
			newCam.specify_fov = true
			newCam.fov = getViewFOV()
			newCam.specify_fov = sfov
			viewport.setCamera newCam
			select newCam
		),
		
		fn cellrw dgv rowI colI t = dgv.rows.item[rowI].cells.item[colI].readonly = t,

		fn getWB vrCam =
		(
			local wbCol = vrCam.whiteBalance
			local wbImage = dotnetObject "System.Drawing.Bitmap" 15 15
			local wbGraphic = ((dotNetClass "System.Drawing.Graphics").FromImage wbImage)
			wbGraphic.clear ((dotNetClass "System.Drawing.Color").fromARGB wbCol.r wbCol.g wbCol.b)
			wbGraphic.dispose()
			wbImage
		),
		
		fn formatRow tab cam row =
		(
			case cam.targeted of
			(
				true:(cellrw tab row tdCol true)
				false:(cellrw tab row tdCol false)
			)
			
			case cam.vignetting of
			(
				true:(cellrw tab row vigACol false)
				false:(cellrw tab row vigACol true)
			)
			
			case cam.clip_on of
			(
				true:(cellrw tab row clipnCol false)
				false:(cellrw tab row clipnCol true)
			)
			
			case cam.clip_on of
			(
				true:(cellrw tab row clipfCol false)
				false:(cellrw tab row clipfCol true)
			)
			
			case tab.rows.item[row].tag of
			(
				"aperture":(tab.rows.item[row].cells.item[fnLCol].value = lockImage)
				"shutter":(tab.rows.item[row].cells.item[shLCol].value = lockImage)
				"iso":(tab.rows.item[row].cells.item[isoLCol].value = lockImage)
			)
			tab.InvalidateRow row
		),
		
		fn createRow cam =
		(
			local row = #(getHandleByAnim cam, cam.name, cam.targeted, cam.target_distance, cam.focal_length, cam.fov, cam.exposure, cam.f_number)
			join row #(unlockImage, cam.shutter_speed, unlockImage, cam.ISO, unlockImage, cam.vignetting, cam.vignetting_amount, (getWB cam), cam.use_dof)
			join row #(cam.use_moblur, cam.subdivs, cam.clip_on, cam.clip_near, cam.clip_far)
			row
		),
		
		fn onCamChanged e s =
		(
			case e of
			(
				(#renderPropertiesChanged):
				(
					for cHand in s where isKindOf (GetAnimByHandle cHand) VRayPhysicalCamera do
					(
						local cam = GetAnimByHandle cHand
						for row = 0 to vrcMan.vrcDGV.RowCount-1 do
						(
							if vrcMan.vrcDGV.rows.item[row].cells.item[0].value == cHand do
							(
								vrcMan.vrcDGV.rows.item[row].SetValues (vrcMan.createRow cam)
								vrcMan.formatRow (vrcMan.vrcDGV) cam row
							)
						)
					)
				)
				#nameChanged:
				(
					for cHand in s where isKindOf (cam = GetAnimByHandle cHand) VRayPhysicalCamera do
					(
						for row = 0 to vrcMan.vrcDGV.RowCount-1 do
						(
							if vrcMan.vrcDGV.rows.item[row].cells.item[0].value == cHand do
							(
								vrcMan.vrcDGV.rows.item[row].cells.item[1].value = cam.name
							)
						)
					)
				)
				#added:
				(
					local camCount = (getClassInstances VRayPhysicalCamera).count
					local cHandArr = for cHand in s where isKindOf (GetAnimByHandle cHand) VRayPhysicalCamera collect cHand
					if cHandArr.count != 0 do
					(
						for cHand in cHandArr do
						(
							local cam = GetAnimByHandle cHand
							vrcMan.vrcDGV.rows.add (vrcMan.createRow cam)
							vrcMan.formatRow vrcMan.vrcDGV cam (vrcMan.vrcDGV.RowCount-1)
							vrcMan.vrcDGV.rows.item[vrcMan.vrcDGV.RowCount-1].tag = "none"
							camCount += 1
						)
						vrcMan.vrcForm.size = dotnetobject "System.Drawing.Size" (vrcMan.vrcForm.size.width) ((camCount * 20)+63)
					)
				)
				#deleted:
				(
					for cHand in s do
					(
						local row = 0
						do
						(
							if vrcMan.vrcDGV.rows.item[row].cells.item[0].value == cHand do local found = true
							row+=1
						)
						while found != true and row < vrcMan.vrcDGV.RowCount 
						if found  == true do vrcMan.vrcDGV.rows.RemoveAt (row-1)
					)
					local camCount = (getClassInstances VRayPhysicalCamera).count
					vrcMan.vrcForm.size = dotnetobject "System.Drawing.Size" (vrcMan.vrcForm.size.width) ((camCount * 20)+63)
				)
			)
		),
		
		fn alphaSortFn cam1 cam2 =
		(
			case of
			(
				(cam1.name < cam2.name):-1
				(cam1.name > cam2.name):1
				default:0
			)
		),
		
		fn columnChooser =
		(
			try (destroyDialog ccRoll);catch ()
			ccRoll = rollout cc "Column Chooser" width:105 height:300
			(
				on cc open do
				(
					cc.owner = this
					cc.cbTargeted.checked = cc.owner.cVis[cc.owner.tgCol]
					cc.cbTargetDist.checked = cc.owner.cVis[cc.owner.tdCol]
					cc.cbfLength.checked = cc.owner.cVis[cc.owner.flCol]
					cc.cbFOV.checked = cc.owner.cVis[cc.owner.fovCol]
					cc.cbExposure.checked = cc.owner.cVis[cc.owner.exCol]
					cc.cbfNumber.checked = cc.owner.cVis[cc.owner.fnCol]
					cc.cbShutter.checked = cc.owner.cVis[cc.owner.shCol]
					cc.cbISO.checked = cc.owner.cVis[cc.owner.isoCol]
					cc.cbVignetting.checked = cc.owner.cVis[cc.owner.vigCol]
					cc.cbWB.checked = cc.owner.cVis[cc.owner.wbCol]
					cc.cbDof.checked = cc.owner.cVis[cc.owner.dofCol]
					cc.cbMo_blur.checked = cc.owner.cVis[cc.owner.mbCol]
					cc.cbSamples.checked = cc.owner.cVis[cc.owner.sdivCol]
					cc.cbClipping.checked = cc.owner.cVis[cc.owner.clipCol]
				)
				
				local owner
				
				fn formatCol cnArr vis =
				(
					for cn in cnArr do
					(
						owner.cVis[cn] = vis
						owner.vrcDGV.columns.item[cn].visible = vis
						owner.vrcForm.width = owner.calcWidth()
					)
				)
				
				checkBox cbTargeted "Targeted" pos:[10,10]
				checkBox cbTargetDist "Targ. Dst." pos:[10,30]
				checkBox cbfLength "F. Length" pos:[10,50]
				checkBox cbFOV "FOV" pos:[10,70]
				checkBox cbExposure "Exposure" pos:[10,90]
				checkBox cbfNumber "F-Number" pos:[10,110]
				checkBox cbShutter "Shutter" pos:[10,130]
				checkBox cbISO "Film ISO" pos:[10,150]
				checkBox cbVignetting "Vignetting" pos:[10,170]
				checkBox cbWB "White Balance" pos:[10,190]
				checkBox cbDof "Dof" pos:[10,210]
				checkBox cbMo_blur "Mo-blur" pos:[10,230]
				checkBox cbSamples "Samples" pos:[10,250]
				checkBox cbClipping "Clipping" pos:[10,270]
				
				on cbTargeted changed state do formatCol #(owner.tgCol) state
				on cbTargetDist changed state do formatCol #(owner.tdCol) state
				on cbfLength changed state do formatCol #(owner.flCol) state
				on cbFOV changed state do formatCol #(owner.fovCol) state
				on cbExposure changed state do formatCol #(owner.exCol) state
				on cbfNumber changed state do formatCol #(owner.fnCol,owner.fnLCol) state
				on cbShutter changed state do formatCol #(owner.shCol,owner.shLCol) state
				on cbISO changed state do formatCol #(owner.isoCol,owner.isoLCol) state
				on cbVignetting changed state do formatCol #(owner.vigCol,owner.vigACol) state
				on cbWB changed state do formatCol #(owner.wbCol) state
				on cbDof changed state do formatCol #(owner.dofCol) state
				on cbMo_blur changed state do formatCol #(owner.mbCol) state
				on cbSamples changed state do formatCol #(owner.sdivCol) state
				on cbClipping changed state do formatCol #(owner.clipCol,owner.clipnCol,owner.clipfCol) state
			)
			createDialog cc parent:(windows.getchildhwnd 0 "VRay Camera Manager")[1] pos:(mouse.screenpos)
		),
		
		fn populateDGV tab =
		(
			local cl = (for c in (getClassInstances VRayPhysicalCamera  asTrackViewPick:on) collect c.client)
			qsort cl alphaSortFn
			
			for cam in cl do
			(
				tab.rows.add (createRow cam)
				local row = tab.RowCount-1
				formatRow tab cam row
				(tab.rows.item[row]).tag = "none"
			)
		),
		
		fn addCA =
		(
			vrCamCADef = attributes vrCamCol version:1 attribID:#(0x5273394c, 0x6e006699)
			(
				parameters main
				(
					cVis type:#boolTab tabSize:21 tabSizeVariable:true
				)
			)
			CustAttributes.add rootnode vrCamCADef
			if rootnode.cVis[1] == false do rootnode.cVis = #(true,true,true,false,true,true,true,true,true,true,true,true,true,true,true,false,false,false,true,true,true)
		),
		
		fn calcWidth =
		(
			local width = 200
			for col = 1 to cVis.count do
			(
				case col of
				(
					2:(if cVis[col] do width+= 60)
					3:(if cVis[col] do width+= 60)
					4:(if cVis[col] do width+= 60)
					5:(if cVis[col] do width+= 60)
					6:(if cVis[col] do width+= 60)
					7:(if cVis[col] do width+= 60)
					8:(if cVis[col] do width+= 30)
					9:(if cVis[col] do width+= 60)
					10:(if cVis[col] do width+= 30)
					11:(if cVis[col] do width+= 60)
					12:(if cVis[col] do width+= 30)
					13:(if cVis[col] do width+= 60)
					14:(if cVis[col] do width+= 60)
					15:(if cVis[col] do width+= 30)
					16:(if cVis[col] do width+= 60)
					17:(if cVis[col] do width+= 60)
					18:(if cVis[col] do width+= 60)
					19:(if cVis[col] do width+= 60)
					20:(if cVis[col] do width+= 60)
					21:(if cVis[col] do width+= 60)
				)
			)
			width
		),
		
		fn defMaxForm =
		(
			local mf = dotNetObject "MaxCustomControls.MaxForm"
			local fc = dotnetclass "System.Drawing.Color"
			mf.BackColor = fc.fromARGB 60 60 60
			mf.text = "VRay Camera Manager"
			mf.size = dotnetobject "System.Drawing.Size" (calcWidth()) (((getClassInstances VRayPhysicalCamera).count * 20)+63)
			mf
		),
		
		fn defDGV =
		(
			local dg = dotNetObject "System.Windows.Forms.DataGridView"
			local cc = dotnetclass "System.Drawing.Color"
			
			--DataDridView Properties
			dg.Location = dotNetObject "Drawing.Point" 10 10
			dg.Dock = dg.Dock.Fill
			dg.MaximumSize = dotnetobject "System.Drawing.Size" 1920 600
			dg.Visible = true
			dg.AllowUserToAddRows = dg.AllowUserToDeleteRows = false
			dg.AllowUserToOrderColumns = false
			dg.MultiSelect = off
			dg.AutoSize = on
			dg.SelectionMode = dg.SelectionMode.CellSelect
			dg.AutoSizeRowsMode = dg.AutoSizeRowsMode.AllCells
			dg.RowHeadersWidthSizeMode = dg.RowHeadersWidthSizeMode.EnableResizing
			dg.RowHeadersVisible = false
			dg.EditMode = dg.EditMode.EditOnKeystroke
			
			--Column Header Style
			dg.ColumnHeadersDefaultCellStyle.BackColor = cc.fromARGB 60 60 60
			dg.ColumnHeadersDefaultCellStyle.ForeColor = cc.fromARGB 160 160 160
			dg.ColumnHeadersBorderStyle = dg.ColumnHeadersBorderStyle.single
			
			--Cell Style
			dg.RowsDefaultCellStyle.BackColor = cc.fromARGB 60 60 60
			dg.RowsDefaultCellStyle.SelectionBackColor = cc.MidnightBlue
			dg.RowsDefaultCellStyle.ForeColor = cc.fromARGB 225 225 225
			dg.RowsDefaultCellStyle.SelectionForeColor = cc.White
			
			--Cell Style 'Greyed Out'
			dg.DefaultCellStyle.BackColor = cc.fromARGB 60 60 60
			dg.DefaultCellStyle.SelectionBackColor = cc.fromARGB 60 60 60
			dg.DefaultCellStyle.ForeColor = cc.fromARGB 100 100 100
			dg.DefaultCellStyle.SelectionForeColor = cc.fromARGB 100 100 100
			dg.DefaultCellStyle.Alignment = dg.DefaultCellStyle.Alignment.MiddleRight
			dg
		),
		
		fn textColumn cn visible =
		(
			local col = dotNetObject "DataGridViewTextBoxColumn"
			col.headerText = cn
			col.readOnly = false
			col.Visible = visible
			col.minimumWidth = 175
			col.AutoSizeMode = (col.AutoSizeMode).fill
			col.DefaultCellStyle.Alignment = col.DefaultCellStyle.Alignment.MiddleLeft
			col
		),
		
		fn fvColumn cn visible =
		(
			local col = dotNetObject "DataGridViewTextBoxColumn"
			col.headerText = cn
			col.readOnly = false
			col.Visible = visible
			col.resizable = (dotNetClass "DataGridViewTriState").false
			col.width = 60
			col.ValueType = (dotNET.getType "single")
			col.DefaultCellStyle.Alignment = col.DefaultCellStyle.Alignment.MiddleRight
			col
		),
		
		fn cbColumn cn visible =
		(
			local col = dotNetObject "DataGridViewCheckBoxColumn"
			col.headerText = cn
			col.readOnly = false
			col.Visible = visible
			col.resizable = (dotNetClass "DataGridViewTriState").false
			col.width = 60
			col
		),
		
		fn colColumn cn visible =
		(
			local col = dotNetObject "DataGridViewImageColumn"
			col.name = cn
			col.headerText = cn
			col.readOnly = true
			col.Visible = visible
			col.resizable = (dotNetClass "DataGridViewTriState").false
			col.width = 30
			col
		),
		
		fn lockColumn cn visible =
		(
			local col = dotNetObject "DataGridViewImageColumn"
			col.name = cn
			col.headerText = "Lck"
			col.readOnly = false
			col.Visible = visible
			col.resizable = (dotNetClass "DataGridViewTriState").false
			col.width = 30
			col
		),
		
		fn contextM =
		(
			local men = dotNetObject "System.Windows.Forms.ContextMenuStrip"
			local mc = dotnetclass "System.Drawing.Color"
			local itemsArr = #("Select Camera", "Send to Camera VP", "Send to Current VP", "Copy Settings", "Paste Settings", "Convert VP/non VRay Cam", "Delete Camera")
			
			rcItems = #()
			for i = 1 to itemsArr.count do
			(
				men.Items.Add(itemsArr[i])
				append rcItems men.Items.item[i-1]
			)
			men
		),
		
		fn addColumns dgv =
		(
			dgv.columns.add (fvColumn "Handle" false)
			dgv.columns.add (textColumn "Camera Name" true)
			dgv.columns.add (cbColumn "Targeted" cVis[tgCol])
			dgv.columns.add (fvColumn "Targ. Dst." cVis[tdCol])
			dgv.columns.add (fvColumn "F. Length" cVis[flCol])
			dgv.columns.add (fvColumn "FOV" cVis[fovCol])
			dgv.columns.add (cbColumn "Exposure" cVis[exCol])
			dgv.columns.add (fvColumn "F-Number" cVis[fnCol])
			dgv.columns.add (LockColumn "FLk" cVis[fnLCol])
			dgv.columns.add (fvColumn "Shutter"  cVis[shCol])
			dgv.columns.add (LockColumn "SLk" cVis[shLCol])
			dgv.columns.add (fvColumn "Film ISO" cVis[isoCol])
			dgv.columns.add (LockColumn "ILk" cVis[isoLCol])
			dgv.columns.add (cbColumn "Vignetting" cVis[vigCol])
			dgv.columns.add (fvColumn "Vig. Amt." cVis[vigACol])
			dgv.columns.add (colColumn "WB" cVis[wbCol])
			dgv.columns.add (cbColumn "Dof" cVis[dofCol])
			dgv.columns.add (cbColumn "Mo-Blur" cVis[mbCol])
			dgv.columns.add (fvColumn "Subdivs" cVis[sdivCol])
			dgv.columns.add (cbColumn "Clipping" cVis[clipCol])
			dgv.columns.add (fvColumn "Clip Near" cVis[clipnCol])
			dgv.columns.add (fvColumn "Clip Far" cVis[clipfCol])
		),
		
		fn buildUI =
		(
			addCA()
			cVis = rootNode.cVis
			vrcForm = defMaxForm()
			vrcDGV = defDGV()
			rcMen = contextM()
			lockImage = ConvertBase64StringToImage lockRedB64
			unlockImage = ConvertBase64StringToImage lockGreyB64
			
			dotNet.addEventHandler vrcDGV "CellEndEdit" textColChanged
			dotNet.addEventHandler vrcDGV "CellContentClick" CBColChanged
			dotNet.addEventHandler vrcDGV "CellMouseClick" cellClick
			dotnet.addEventHandler vrcDGV "CellPainting" onCellPainting
			dotnet.addEventHandler vrcForm "FormClosed" onFormClosed
			dotnet.addEventHandler rcMen "ItemClicked" rcMenuHandler
			
			addColumns vrcDGV
			populateDGV vrcDGV
			vrcForm.controls.add vrcDGV
			vrcForm.showModeless()
			camCallback = NodeEventCallback mouseUp:true added:onCamChanged deleted:onCamChanged nameChanged:onCamChanged renderPropertiesChanged:onCamChanged
		),
		
		start = buildUI()
	)

	on isChecked do
	(
		if vrcMan == undefined then false
		else vrcMan.vrcForm.Visible
	)
	on execute do vrcMan = vrcManStr()
	on closeDialogs do
	(
		vrcMan.vrcForm.close()
		updateToolbarButtons()
	)
)