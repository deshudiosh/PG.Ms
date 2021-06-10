macroScript PG_SL
	category:"Pawel Grzelak"
	toolTip:"PG Script Lister"
	buttonText:"PGSL"
(
	on execute do (
		--usualy C:\Users\username\AppData\Local\Autodesk\3dsMax\2021 - 64bit\ENU\usermacros\
		pgscripts = (getINIsetting ((pathConfig.GetDir #userMacros) + "\\PG.ini") "PG" "pgscripts")
		
		if not keyboard.shiftPressed then ( filein (pgscripts + "PG_ScriptLuncher.ms") )
		else ( filein (pgscripts + "PG_ScriptLuncherLast.ms") )
		
		--if keyboard.shiftPressed do print "shift"
		--if keyboard.escPressed do print "esc"
		--if keyboard.controlPressed do print "ctrl"
		--if keyboard.altPressed do print "alt"
	)
)