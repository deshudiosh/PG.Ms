fn getScripts = (
	
	-- gather script files
	-- start looking in default location
	scripts = getFiles ((getdir #userScripts) + "\\PGScripts\\PG.*.ms")
	
	scripts += (getFiles "C:\GitHub\PG.Mxs\PG.*.ms")
	
	-- and add scripts from custom locations
	for url in (getINISetting ((getdir #userScripts) + @"\PGScripts\PG_SL.ini")) do (
		scripts += (getFiles (url + "PG.*.ms"))
	)
	
	--url = ((getdir #userScripts) + "\\PGScripts\\PG.*.ms")
	--scripts = getFiles url
	scripts
)

fn btnHandler scriptUrl rightclick= (
	-- try lunching script and catch errors if any
	try (
		fileIn scriptUrl
		
		-- store last lunched script
		url = ((getdir #userScripts) + @"\PGScripts\PG_SL_LAST.ini")
		try (deleteFile url) catch()
		setINISetting url scriptUrl "empty" "value"
	) 
	catch ( 
		messagebox ("Error thrown:\n\n" + (getCurrentException()) + "\n\nIn Script:\n\n" + filenameFromPath scriptUrl) title:"Error Occurred"
	)
			
	--close PGSL dialog if leftclick
	if not rightclick do try (destroyDialog PGSL) catch()
)

fn getRollout = (
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

clearListener()
try (destroyDialog PGSL) catch()
global PGSL = getRollout()
createDialog PGSL



