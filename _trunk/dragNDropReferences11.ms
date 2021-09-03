/**
	This script sets up reference planes in the viewport according to the image
	files you drag&dropped onto the marked area. They will have correct dimensions
	and a twosided material applied to them. They will also be lined up on the x axis
	and you can specifiy whether to align height or width of all images.
	
	written by Christoph Bülter 11/09/2012
	www.cbuelter.de
	
	22/08/13: Added scaling option for planes; Script now remembers its settings
	03/01/13: Set plane segments to 1 on creation
	05/12/12: Removed axis checkboxes, added option to align width or length of the planes, updated image, tightened UI
	18/11/12: Removed self-illumination from Standard material. which made things too bright (thanks to DeaDog)
	13/10/12: Added option to choose the material type (mr arch&design, standard & vraymtl)
	06/10/12: Disabled Real World Scale for maps, added Gamma correction option using a color correction map (thanks to miauu, Kinofaya)
	29/09/12: UI checkbutton fix, thanks to Anubis
	27/09/2012: image from Base64 string (method by LoneRobot.net, thanks to barigazy); now uses "maxOps.canImportBitmap" thanks to Anubis
**/

macroscript dragNDropReferences
category:"Buelter"
(
	try(destroyDialog roDragNDropReferences)catch()
	rollout roDragNDropReferences "Reference Planes" width:150 height:136
	(
		/************************************
				VARIABLES
		************************************/
		local bmLogoBase64String = "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"
		local AXIS = "x" -- axis to align planes on
		local mode = "none" 
		local mat = "standard"
		local planes = #() -- filled with planes for sorting
		
		/************************************
				FUNCTIONS
		************************************/

		/**
			Converts a given Base64 string to a dotnet image. Useful for including smaller images
			to a single script file, like logos. Faster conversion and smaller filesize compared to
			simple pixel array to image methods.
		**/
		fn base64str_to_dotnet_image str = -- http://lonerobot.net/ & barigazy
		(
			ConvertClass = dotNetClass "System.Convert"
			ImageClass = dotNetClass "System.Drawing.Image"
			
			byteArr = ConvertClass.FromBase64String str
			memstream = dotnetobject "System.IO.MemoryStream" byteArr
			DecodedImg = ImageClass.fromstream memstream
			memstream.close() ; 
			
			DecodedImg --return
		)--end fn

		/**
			Align all planes to have the same length or width as the last plane
			mode can either be "length" or "width" or "none"
		**/
		fn alignPlaneDimensions planes mode =
		(
			local ref = planes[planes.count]
			for i = 1 to (planes.count-1) do
			(
				if mode == "height" then
				(
					local ratio = planes[i].width / planes[i].length as float
					planes[i].length = ref.length
					planes[i].width = ref.length * ratio
				)
				else if mode == "width" then
				(
					local ratio = planes[i].length / planes[i].width as float
					planes[i].width = ref.width
					planes[i].length = ref.width * ratio
				)
			)--end for
		)--end fn
		
		/**
			Sorts objects on an axis with a given gap between.
				planes = array of objects
				axis = string "x", "y", or "z"
				gap = integer number
		**/
		fn sort_objects_in_a_row objs axis gap size=
		(
			local w, h, d
			local oldW, oldH, oldD
			local oldObject 
			
			for o in objs do
			(
				bb = nodeGetBoundingBox o o.transform
				in coordsys o
				(
					-- GET WIDTH
					if bb[1][1] >= bb[2][1] then
					(
						biggerW = bb[1][1]
						smallerW = bb[2][1]
					)
					else
					(
						biggerW = bb[2][1]
						smallerW = bb[1][1]
					)
					w = biggerW - smallerW
					
					-- GET HEIGHT
					if bb[1][2] >= bb[2][2] then
					(
						biggerH = bb[1][2]
						smallerH = bb[2][2]
					)
					else
					(
						biggerH = bb[2][2]
						smallerH = bb[1][2]
					)
					h = biggerH - smallerH
					
					-- GET DEPTH
					if bb[1][3] >= bb[2][3] then
					(
						biggerD = bb[1][3]
						smallerD = bb[2][3]
					)
					else
					(
						biggerD = bb[2][3]
						smallerD = bb[1][3]
					)
					d = biggerD - smallerD
				)--end coordsys	
				
				-- PLACEMENT
				if oldObject != undefined do
				(
					o.position = oldObject.position
					case axis of 
					(
						"x":
						(
							dist = oldW/2 + w/2 + (gap*size)
							move o [dist, 0, 0]
						)
						"y":
						(
							dist = oldH/2 + h/2 + (gap*size)
							move o [0, 0, dist]
						)
						"z":
						(
							dist = oldD/2 + d/2 + (gap*size)
							move o [0, dist, 0]					
						)
					)--end case
				)--end if
				oldObject = o
				oldW = w
				oldH = h
				oldD = d
			)--end for
		)--end fn

		/************************************
				GUI
		************************************/
		
		checkbutton ckbStandard "Standard" pos:[0,0] width:50 height:16 enabled:false highlightColor:(color 50 100 200) checked:true
		checkbutton ckbMrAD "mr A&D" pos:[50,0] width:50 height:16 highlightColor:(color 50 100 200)
		checkbutton ckbVRay "VRay" pos:[100,0] width:50 height:16 highlightColor:(color 50 100 200)
		
		checkbutton ckbGamma "Gamma:" pos:[1,17] width:43 height:16 highlightColor:(color 200 150 70) toolTip:"Uses a color correction map to adjust gamma"
		spinner spnGamma "" pos:[44,17] width:40 height:16 enabled:false range:[0.1,5,0.4545] type:#float scale:0.1
		
		label lblAlign "Align: " pos:[3,34] width:27 height:14
		checkbutton ckbNone "None" pos:[32,33] width:34 height:16 enabled:false highlightColor:(color 115 115 115) checked:true
		checkbutton ckbHeight "Height" pos:[66,33] width:42 height:16 enabled:true highlightColor:(color 30 160 30) checked:false
		checkbutton ckbWidth "Width" pos:[108,33] width:42 height:16 enabled:true highlightColor:(color 160 30 30) checked:false
		dotNetControl pb "System.Windows.Forms.PictureBox" pos:[0,50] width:150 height:120 
		spinner spnSize "Size:" pos:[95,17] width:55 height:16 range:[0.01,999,1.0] type:#float scale:0.01

		
		/************************************
				PERSISTENCE
		************************************/

		fn save_to_INI=
		(
			local pth = (getDir #userscripts) + "\\dragNDropReferences.ini"
			setINISetting pth "Settings" "mode" mode
			setINISetting pth "Settings" "mat" mat
			setINISetting pth "Settings" "gammaChecked" (ckbGamma.checked as String)
			setINISetting pth "Settings" "gammaValue" (spnGamma.value as String)
			setINISetting pth "Settings" "size" (spnSize.value as String)
		)--end fn
		
		fn load_from_INI=
		(
			local pth = (getDir #userscripts) + "\\dragNDropReferences.ini"
			if doesFileExist pth do
			(
				mode = getINISetting pth "Settings" "mode" 
				if mode == "none" then (
					ckbNone.checked = True; ckbWidth.checked = ckbHeight.checked = False
					ckbNone.enabled = False; ckbWidth.enabled = ckbHeight.enabled = True
				)
				else if mode == "width" then (
					ckbWidth.checked = True; ckbNone.checked = ckbHeight.checked = False
					ckbWidth.enabled = False; ckbNone.enabled = ckbHeight.enabled = True
				)
				else if mode == "height" then (
					ckbHeight.checked = True; ckbWidth.checked = ckbNone.checked = False
					ckbHeight.enabled = False; ckbWidth.enabled = ckbNone.enabled = True
				)
					
				mat = getINISetting pth "Settings" "mat" 
				if mat == "standard" then (
					ckbStandard.checked = True; ckbMrAD.checked = ckbVRay.checked = False
					ckbStandard.enabled = False; ckbMrAD.enabled = ckbVRay.enabled = True
					)
				else if mat == "mrAD" then (
					ckbMrAD.checked = True; ckbStandard.checked = ckbVRay.checked = False
					ckbMrAD.enabled = False; ckbStandard.enabled = ckbVRay.enabled = True
					)
				else if mat == "vray" then (
					ckbVRay.checked = True; ckbMrAD.checked = ckbStandard.checked = False
					ckbVRay.enabled = False; ckbMrAD.enabled = ckbStandard.enabled = True
					)
					
				ckbGamma.checked = (getINISetting pth "Settings" "gammaChecked") as BooleanClass
				spnGamma.enabled = (getINISetting pth "Settings" "gammaChecked") as BooleanClass
				spnGamma.value = (getINISetting pth "Settings" "gammaValue") as Float
				spnSize.value = (getINISetting pth "Settings" "size") as Float 
			)--end if
		)--end fn
		
	
		/************************************
				EVENTS
		************************************/

		on roDragNDropReferences open do
		(
			load_from_INI()
			
			pb.AllowDrop = on
				
			-- IMAGE CREATION
			
			-- THIS IS OLD STUFF (USING LOGOTOOLS TO GET THE IMAGE)
		-- 			-- to see the image, we need to convert from a MXS bitmap to a dotNet Systems.Drawing.Bitmap using the clipboard!
		-- 			bm = (CreateImage Pixels)
		-- 			setClipboardBitmap bm
		-- 			-- now get from clipboard as dotNet object
		-- 			dotNetCB = dotNetClass "System.Windows.Forms.Clipboard"
		-- 			dotNetBM = dotNetCB.GetImage()
		-- 			pb.image = dotNetBM
			
			pb.image = base64str_to_dotnet_image bmLogoBase64String
		)--end on
		
		on roDragNDropReferences close do
		(
			save_to_INI()
		)--end on
		
		-- HANDLE CHECKBUTTONS (LIKE RADIOBUTTONS)
		on ckbStandard changed state do
		(
			ckbStandard.enabled = not state
			ckbMrAD.enabled = ckbVRay.enabled = state
			ckbMrAD.checked = ckbVRay.checked = not state
			mat = "standard"
		)--end on
		on ckbMrAD changed state do
		(
			ckbMrAD.enabled = not state
			ckbStandard.enabled = ckbVRay.enabled = state
			ckbStandard.checked = ckbVRay.checked = not state
			mat = "mrAD"
		)--end on
		on ckbVRay changed state do
		(
			ckbVRay.enabled = not state
			ckbMrAD.enabled = ckbStandard.enabled = state
			ckbMrAD.checked = ckbStandard.checked = not state
			mat = "vray"
		)--end on
		on ckbGamma changed state do
		(
			spnGamma.enabled = state
		)--end on
		
		on ckbHeight changed state do
		(
			ckbHeight.enabled = not state
			ckbNone.enabled = ckbWidth.enabled = state
			ckbNone.checked = ckbWidth.checked = not state
			
			if state do mode = "height"
		)--end on
		on ckbWidth changed state do
		(
			ckbWidth.enabled = not state
			ckbNone.enabled = ckbHeight.enabled = state
			ckbNone.checked = ckbHeight.checked = not state
			
			if state do mode = "width"
		)--end on
		on ckbNone changed state do
		(
			ckbNone.enabled = not state
			ckbHeight.enabled = ckbWidth.enabled = state
			ckbHeight.checked = ckbWidth.checked = not state
			
			if state do mode = "none"
		)--end on
		
		-- DRAG AND DROP FUNCTIONALITY
		on pb DragOver s e do
		(
			e.Effect = if e.data.ContainsFileDropList() then e.Effect.Move else e.Effect.None
		)--end on
		on pb DragDrop s e do
		(
			if e.data.ContainsFileDropList() do
			(
				data = e.data.GetFileDropList()
				files = for k=0 to data.count-1 collect data.item[k]
				
				-- FILTER BY FILE TYPE
				for f in files where maxOps.canImportBitmap f do
				(
					if (doesFileExist f) do
					(
						-- CREATE DIFFUSE MAP						
						bmt = BitmapTexture filename:f
						bmt.coords.realWorldScale = false -- requested
						if ckbGamma.checked then
						(
							cc = Color_Correction map:bmt gammaRGB:spnGamma.value
							cc.lightnessmode = 1 -- enables "Advanced" options, so gamma setting has an effect
							difMap = cc
						)--end if
						else
						(
							difMap = bmt
						)--end else
						
						-- CREATE MATERIAL
						case mat of
						(
							"standard":
							(
								theMat = Standard  twosided:true name:(uniqueName "Ref_Plane_Mat") showInViewport:true --selfIllumAmount:100
								theMat.diffuseMap = difMap
							)
							"mrAD":
							(
								theMat = Arch___Design__mi name:(uniqueName "Ref_Plane_Mat") showInViewport:true
								theMat.diff_color_map = difMap
							)
							"vray":
							(
								theMat = VRayMtl name:(uniqueName "Ref_Plane_Mat") showInViewport:true
								theMat.texmap_diffuse = difMap
							)
						)--end case
						
						-- CREATE PLANE
						pln = Plane width:(bmt.bitmap.width*spnSize.value) length:(bmt.bitmap.height*spnSize.value) material:theMat lengthsegs:1 widthsegs:1
						append planes pln
						rotate pln (angleaxis 90 [1,0,0]) -- make sure its rotated correctly, facing the front viewport
					)--end if
				)--end for
				
				-- SORTING THE PLANES 
				alignPlaneDimensions planes mode
				print mode
				sort_objects_in_a_row planes AXIS 20 spnSize.value
				select planes
				max zoomext sel all
				completeRedraw()
				
				-- CLEAN UP
				planes = #()
			)--end if
		)--end on
	)
	createdialog roDragNDropReferences
)
-- run script
macros.run "Buelter" "dragNDropReferences"