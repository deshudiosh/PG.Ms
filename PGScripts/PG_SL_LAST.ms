try (
	url = (getdir #userScripts) + @"\PGScripts\PG_SL_LAST.ini"
	script = (getINISetting url)[1]
	filein script
)
catch()