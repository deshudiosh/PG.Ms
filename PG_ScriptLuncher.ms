fn getScripts = (
	scripts = getFiles (PGLib.cons.pgscripts + "\\PG.*.ms")
)

fn btnHandler scriptFile rightclick= (
	-- try lunching script and catch errors if any
	try (
		fileIn scriptFile
		
		PGLib.setLastScript scriptFile
	) 
	catch ( 
		messagebox ("Error thrown:\n\n" + (getCurrentException()) + "\n\nIn Script:\n\n" + filenameFromPath scriptUrl) title:"Error Occurred"
	)
			
	--close PGSL dialog if leftclick
	if not rightclick do try (destroyDialog PGSL) catch()
)

fn getRollout = (
	try (destroyDialog PGSL) catch()
	
	-- load PGLib
	fileIn (pathConfig.removePathLeaf (getThisScriptFilename()) + "\\PG.Lib.ms")
	
	rci = rolloutCreator "PGSL" "PG Scripts Lister"
	rci.begin()

	local scripts = getScripts()
	
	--calculate btn width based on longest name
	local maxWidth = 0
	for s in scripts do (
		local n = (filterString s ".")
		maxWidth = amax #((GetTextExtent (n[2] + " " + n[3])).x + 20, maxWidth)
	)
	
	-- add buttons
	for i = 1 to scripts.count do (
		
		sNameArr = (filterString scripts[i] ".")
		
		btnLabel = sNameArr[2] + " " + sNameArr[3]
				
		controlname = ("btn" + i as string)
		widthStr = "width:" + maxWidth as string
		
		rci.addControl #button controlname btnLabel paramStr:widthStr

		handlerStr = "btnHandler @" + scripts[i] + "@ "
		rci.addHandler controlname #pressed codestr:(handlerStr + "false") filter:on
		rci.addHandler controlname #rightclick codestr:(handlerStr + "true") filter:on
	)
	
	rci.end()
)

global PGSL = getRollout()
createDialog PGSL



