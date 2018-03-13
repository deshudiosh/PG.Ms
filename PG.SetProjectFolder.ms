fn setProjectFolder = (
	p = "C:/3dsMaxProjectFolder"
	p = pathConfig.normalizePath p
	
	if doesFileExist p == false do (
		yesno = queryBox ("Path:\n" + p + "\ndoes not exist.\n\nCreate it?")
		if yesno == true do makeDir p all:true
	)
	
	if (doesFileExist p) then (
		--pathConfig.doProjectSetupStepsUsingDirectory p
		pathConfig.setCurrentProjectFolder p
		txt = "Project Folder Set to: " + p
		replacePrompt txt
		print txt
	) else (
		txt = "Path:\n\n" + p + "\n\nis is not correct!"
		messageBox txt
		replacePrompt txt
		print txt
	)
)

setProjectFolder()