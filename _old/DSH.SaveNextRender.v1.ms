fn saveImage filepath = (
	local theBitmap = getLastRenderedImage()
	--local theBitmap = vrayVFBGetChannelBitmap 1
	theBitmap.filename = filepath
	save theBitmap
)

rollout dial "Render Saver" width:200
(
	local separator = bitmap 180 1 color:[128,128,128], space = 10
	local lastpath
	
	local nextNumber = 1
	
	label theLabel1 ""	
	
	button btnSaveAs "Save As..."
	on btnSaveAs pressed do (
		local p = lastpath
		if p == undefined do p = maxfilepath
		
		filepath = getSaveFileName filename:p types:"JPEG(*.jpg)|*.jpg|PNG(*.png)|*.png|All|*.*|"
		
		if filepath != undefined do (
			lastPath = filepath
			
			saveImage filepath
		)
	)
	
	button btnSaveLast "Override Last"
	on btnSaveLast pressed do (
		if lastpath != undefined then saveImage lastpath
		else messagebox "Use \"Save As...\" at least once." title:"Override Last"
	)
	
	button btnSaveNext "Save Next +"
	on btnSaveNext pressed do (
		if lastpath != undefined then (
			filepath = getFilenamePath lastpath
			filename = getFilenameFile lastpath
			fileext = getFilenameType lastpath
			
			-----MOŻE  kropka ZAMIAST UNDERSCORE?
			newpath = filepath + filename + "_" + nextNumber as String + fileext
			saveImage newpath
			nextNumber += 1
		)
		else messagebox "Use \"Save As...\" at least once." title:"Save Next"
	)
	
	imgTag s1 bitmap:separator align:#center offset:[0, space]

	label theLabel3 "by Pawel Grzelak" offset:[0, space]
	hyperlink www "pawelgrzelak.com" align:#center address:"http://pawelgrzelak.com" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
	
	on dial close do ( deleteTopoHandlers() ) 
)

clearlistener()
createDialog dial