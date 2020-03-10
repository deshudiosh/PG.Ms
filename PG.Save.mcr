macroScript PG_Save
	category:"Pawel Grzelak"
	toolTip:"PG Save"
	buttonText:"Save"
(
	on execute do (
		pgscripts = (getINIsetting ((pathConfig.GetDir #userMacros) + "\\PG.ini") "PG" "pgscripts")
		
		if not keyboard.shiftPressed then ( filein (pgscripts + "PG.Save.ms") )
		else ()
		
		--if keyboard.shiftPressed do print "shift"
		--if keyboard.escPressed do print "esc"
		--if keyboard.controlPressed do print "ctrl"
		--if keyboard.altPressed do print "alt"
	)
)