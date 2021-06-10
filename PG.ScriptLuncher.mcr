macroScript PG_SL
	category:"Pawel Grzelak"
	toolTip:"PG Script Lister"
	buttonText:"PGSL"
(
	on execute do (
		--usualy C:\Users\username\AppData\Local\Autodesk\3dsMax\2017 - 64bit\ENU\usermacros\
		usermacros = pathConfig.GetDir #userMacros
		pgscripts = (getINIsetting (usermacros + "\\PG.ini") "PG" "pgscripts")
		
		if not keyboard.shiftPressed then ( filein (pgscripts + "PG.ScriptLuncher.ms") )
		--else if keyboard.controlPressed then ( shellLaunch "explorer.exe" usermacros ) -- open usermacros folder
		else ( filein (pgscripts + "PG.ScriptLuncherLast.ms") )
		
		--if keyboard.shiftPressed do print "shift"
		--if keyboard.escPressed do print "esc"
		--if keyboard.controlPressed do print "ctrl"
		--if keyboard.altPressed do print "alt"
	)
)

