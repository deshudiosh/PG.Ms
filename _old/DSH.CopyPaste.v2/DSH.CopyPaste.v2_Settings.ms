fn createConfigFile = (
	local configpath =((getdir #maxroot) + "stdplugs\stdscripts\\DSH_Shared.ms")

	file = createFile configPath
	format ("global DSH_fileName = \"Copypaste_temp.max\"") to:file
	format ("\nglobal DSH_filePathLocal = \"" + DSH_filePathLocal + "\\\"") to:file
	format ("\nglobal DSH_filePathNetwork = \"" + DSH_filePathNetwork + "\\\"") to:file
	close file
	
	messageBox "Paths saved!" title:"Copy/Paste settings"
)

rollout EditSavePaths "Copy/Paste settings by Pawel Grzelak" width:300 (
	
	local space = 10
	local separator = bitmap 300 1 color:[128,128,128]
	
	group "Primary path:" (
		button buttonPrimary "..."
	)

	group "Secondary (shift+click) path:" (
		button buttonSecondary "..."
	)
		
	on buttonPrimary pressed do (
		savepath = getSavePath caption:"Pick primary path for Copy\Paste by Grzelu:" initialDir:DSH_filePathLocal
		if savepath[savepath.count] != "\\" do savepath += "\\"
		global DSH_filePathLocal = savepath
		buttonPrimary.text = DSH_filePathLocal
	)
	
	on buttonSecondary pressed do (
		savepath = getSavePath caption:"Pick secondary path for Copy\Paste by Grzelu:" initialDir:DSH_filePathNetwork
		if savepath[savepath.count] != "\\" do savepath += "\\"
		global DSH_filePathNetwork = savepath
		buttonSecondary.text = DSH_filePathNetwork
	)
	
	
	imgTag s1 bitmap:separator align:#center offset:[0, space/2]
	
	button btnApply "Apply" width:120 height:25 offset:[0, space/2]
	on btnApply pressed do createConfigFile()
	
	imgTag s2 bitmap:separator align:#center offset:[0, space/2]

	label theLabel3 "by Pawel Grzelak" offset:[0, space]
	hyperlink www "www.pawelgrzelak.com" align:#center address:"http://pawelgrzelak.com" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255)
	label theLabel4 ""
	
	
	
	on EditSavePaths open do(
		if DSH_filePathLocal != undefined do buttonPrimary.text = DSH_filePathLocal
		if DSH_filePathNetwork != undefined do buttonSecondary.text = DSH_filePathNetwork
	)
	
	on EditSavePaths close do(
		--createConfigFile()
	)
)
	
createDialog EditSavePaths