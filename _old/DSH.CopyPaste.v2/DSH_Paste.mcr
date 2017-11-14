macroScript Paste_from_file
	category:"Pawel Grzelak"
	toolTip:"Paste from file: LMB = main location, SHIFT + LMB = alternative location"
	buttonText:"Paste"
(	
	on isEnabled return (doesFileExist (DSH_filePathNetwork + DSH_fileName) or doesFileExist (DSH_filePathLocal + DSH_fileName) )
	
	on execute do (
		--network
		if keyboard.shiftPressed then (
			mergemaxfile (DSH_filePathNetwork + DSH_fileName) #select
		)
		--local
		else (
			mergemaxfile (DSH_filePathLocal + DSH_fileName) #select
		)
		
		local promptString = ("Pasted " + selection.count as string + " obejcts from ")
		if keyboard.shiftPressed then promptString += DSH_filePathNetwork else promptString += DSH_filePathLocal
		
		print promptString
		pushPrompt promptString
	)
)
