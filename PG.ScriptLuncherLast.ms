try (
	-- load PGLib
	fileIn (pathConfig.removePathLeaf (getThisScriptFilename()) + "\\PG.Lib.ms")
	filein PGlib.cons.last_script
)
catch()