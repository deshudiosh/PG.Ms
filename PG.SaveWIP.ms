struct PGSave(
	PGSaveRollout, cur_version, old_version, saveOldStr, saveOldAsStr, saveCurStr, saveCurAsStr,

	-- get max version as integer which can be used in saveMaxFile -> saveAsVersion parameter
	-- this is the ugliest shit I've ever written
	fn maxVer = (
		("20" + ((maxVersion())[1]/1000-2) as String) as Number
	),

	fn saveAsVersion filepath version = (
		saveMaxFile filepath saveAsVersion:version useNewFile:true
		print (maxFileName + " saved as 2014")
	),
	
	fn savefn chooselocation version = (
		if chooselocation then (
			newpath = (getSaveFileName filename:(maxFilePath + maxFileName))
					
			if newpath != undefined do (
				--check if extension == .max
				if not ((substring newpath (newpath.count-3) newpath.count) == ".max") do newpath += ".max"
				
				saveAsVersion newpath version
			)
			
			destroyDialog PGSaveRollout
		)
		else (
				saveAsVersion (maxFilePath + maxFileName) version
				destroyDialog PGSaveRollout
		)		
	),

	fn run = (	
		cur_version = maxver()
		old_version = cur_version - 3
		
		saveOldStr = old_version as String + " Save"
		saveOldAsStr = old_version as String + " Save as..." 
		saveCurStr = cur_version as String + " Save"
		saveCurAsStr = cur_version as String + " Save as..."
		
		try (destroyDialog PGSaveRollout) catch()
		
		rollout PGSaveRollout "PG.Save" width:240 (
			button saveOld saveOldStr across:2 width:100 height:30
			button saveOldAs saveOldAsStr width:100 height:30
			button saveCur saveCurStr across:2 width:100 height:30
			button saveCurAs saveCurAsStr width:100 height:30

			on saveOld pressed do (PGS.savefn false PGS.old_version)
			on saveOldAs pressed do (PGS.savefn true PGS.old_version)
			on saveCur pressed do (PGS.savefn false PGS.cur_version)
			on saveCurAs pressed do (PGS.savefn true PGS.cur_version)

			on PGSaveRollout open do (
				-- if scane not saved, disable save override option
				if maxFileName.count == 0 do saveOld.enabled = false 
			)
		)
	
		CreateDialog PGSaveRollout
	)
)


PGS = PGSave()
PGS.run()


