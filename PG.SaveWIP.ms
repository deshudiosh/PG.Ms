struct PGSave(
	PGSaveRollout, cur_version, old_version, saveOldStr, saveOldAsStr, saveCurStr, saveCurAsStr,

	-- get max version as integer which can be used in saveMaxFile -> saveAsVersion parameter
	-- this is the ugliest shit I've ever written
	fn maxVer = (
		("20" + ((maxVersion())[1]/1000-2) as String) as Number
	),

	fn saveAsVersion filepath version = (
		saveMaxFile filepath saveAsVersion:version useNewFile:true
		--print (maxFileName + " saved as 2014")
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
		
		saveOldStr = "Save as " + old_version as String
		saveCurStr = "Save"
		saveCurAsStr = " Save As..."
		
		try (destroyDialog PGSaveRollout) catch()
		
		rollout PGSaveRollout "PG.Save" width:110 (
			-- dot net control for getting custom shortcuts
			dotNetControl list "System.Windows.Forms.ListBox" height:0
			timer t interval:10 active:True
			
			button saveCur saveCurStr width:100 height:50
			button saveCurAs saveCurAsStr width:100 height:50
			
			checkbox saveOld saveOldStr align:#center height:20
			dotNetControl chkbx "System.Windows.Forms.CheckBox"
			
			fn saveFn bool = (
				destroyDialog PGSaveRollout
				print (if saveOld.checked then PGS.old_version else PGS.cur_version)
				PGS.savefn bool (if saveOld.checked then PGS.old_version else PGS.cur_version)
			)			
			
			on t tick do ( list.focus() )
			on list keydown evnt do (
				if evnt.keycode == evnt.keycode.s do saveFn false
				if evnt.keycode == evnt.keycode.a do saveFn true
			)
			
			on saveCur pressed do (saveFn false)
			on saveCurAs pressed do (saveFn true)

			on PGSaveRollout open do (
				-- if scane not saved, disable save override option
				if maxFileName.count == 0 do saveCur.enabled = false 
			)
		)
	
		CreateDialog PGSaveRollout modal:True 
	)
)


PGS = PGSave()
PGS.run()


