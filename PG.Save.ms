global PGS
global PGSaveRollout

struct PGSave(
	-- get max version as integer which can be used in saveMaxFile -> saveAsVersion parameter
	-- this is the ugliest shit I've ever written
	fn maxVer = (
		("20" + ((maxVersion())[1]/1000-2) as String) as Number
	),

	fn saveFn old chooseDir:false = (
		if chooseDir == false then filepath = (maxFilePath + maxFileName)
		else (
			filepath = (getSaveFileName filename:(maxFilePath + maxFileName))
		)
		
		if filepath != undefined do (		
			if old == true then (
				saveMaxFile filepath useNewFile:true saveAsVersion:(maxVer() - 3)
			) else (
				saveMaxFile filepath useNewFile:true
			)
			pushPrompt (filepath + " SAVED!" + (if old then " (" + (maxVer() - 3) as String  + ")" else ""))
		)
		destroyDialog PGSaveRollout
	),

	fn run = (
		try (destroyDialog PGSaveRollout) catch()
				
		rollout PGSaveRollout "PG.Save" width:141 (
			local vers = "old 3ds Max "
			--vers +=  + (PGS.maxver() - 3) as String  -- why it errors?
			
			button saveBtn "Save" across:2 width:80 height:30 pos:[10,5]
			button saveAsBtn "as..." width:40 height:30 pos:[91,5]
			checkbox old vers align:#center

			on saveBtn pressed do (PGS.saveFn old.state)
			on saveAsBtn pressed do (PGS.saveFn old.state chooseDir:True)

			on PGSaveRollout open do (
				-- if scane not saved, disable save override option
				if maxFileName.count == 0 do saveBtn.enabled = false 
			)
		)
	
		CreateDialog PGSaveRollout
	)
)

global PGS = PGSave()
PGS.run()


