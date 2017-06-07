macroScript PG_SL
	category:"Pawel Grzelak"
	toolTip:"PG Script Lister"
	buttonText:"PGSL"
(
	on execute do (
		if not keyboard.shiftPressed then ( filein ((getdir #userScripts) + @"\PG.Mxs\PG_SL.ms") )
		else ( filein ((getdir #userScripts) + @"\PG.Mxs\PG_SL_LAST.ms") )
	)
)
