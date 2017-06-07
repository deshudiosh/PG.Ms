PGSaveVersion = 2014
try (destroyDialog PGSave) catch()

fn saveAsVersion filepath version = (
	saveMaxFile filepath saveAsVersion:version useNewFile:true
	print (maxFileName + " saved as 2014")
)

rollout PGSave ("Save as max " + PGSaveVersion as String) width:200 (
	button saveOld "Save" across:2 width:80 height:30
	button saveAs "Save As..." width:80 height:30

	on saveOld pressed do (
		saveAsVersion (maxFilePath + maxFileName) PGSaveVersion
		destroyDialog PGSave
	)
	
	on saveAs pressed do (
		newpath = (getSaveFileName filename:(maxFilePath + maxFileName))
		
		if newpath != undefined do (
			print "xxx"
			--check if extension == .max
			if not ((substring newpath (newpath.count-3) newpath.count) == ".max") do newpath += ".max"
			saveAsVersion newpath PGSaveVersion
		)
		destroyDialog PGSave
	)

	on PGSave open do (
		-- if scane not saved, disable save override option
		if maxFileName.count == 0 do saveOld.enabled = false 
	)
)

CreateDialog PGSave