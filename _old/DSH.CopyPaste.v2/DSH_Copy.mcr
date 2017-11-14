macroScript Copy_to_file
	category:"Pawel Grzelak"
	toolTip:"Copy to file: LMB = main location, SHIFT + LMB = alternative location"
	buttonText:"Copy"
(
	on isEnabled return (selection.count > 0)
	
	on execute do (
		--network
		if keyboard.shiftPressed then (
			saveNodes selection (DSH_filePathNetwork + DSH_fileName)
		)
		--local
		else (
			saveNodes selection (DSH_filePathLocal + DSH_fileName)
		)
		
		local promptString = ("Copied " + selection.count as string + " obejcts to ")
		if keyboard.shiftPressed then promptString += DSH_filePathNetwork else promptString += DSH_filePathLocal
		
		print promptString
		pushPrompt promptString
	)
)
