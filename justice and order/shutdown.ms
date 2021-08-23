(
	fn shutdown = (
		p = pathConfig.removePathLeaf (getSourceFileName())
		shutdown_file = p + "\SHUTDOWN"
		
		if doesFileExist shutdown_file == true then (
			deletefile shutdown_file
			DOSCommand "shutdown /s /t 60 /c \"Nie jedz przy biurku. Komputer wylaczy sie za 60 sekund, wiec lepiej szybko zapisuj sceny.\""
		)	
	) 
	shutdown()
)