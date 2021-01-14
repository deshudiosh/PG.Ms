fn setBackupName = (
	-- IF AUTOBACKUP
	actoncode = (callbacks.notificationParam())[1]
	if actioncode == 3 do (
		-- IF there are more then one filename elements, it means filename was not empty
		nameArr = filterString maxFileName "."
		newname = if nameArr.count > 1 then nameArr[1] else "undefined"
		autosave.filename = newname
		print ("Autosave filename updated to: " + newname)
	)
)

callbacks.addScript #filePreSaveProcess "setBackupName()" id:#PG