macroScript PG_SL
	category:"Pawel Grzelak"
	toolTip:"PG Script Lister"
	buttonText:"PGSL"
(
	on execute do (
		if not keyboard.shiftPressed then ( filein @"D:\GitHub\PG.Ms\PGScriptLuncher\PG_SL.ms" )
		else ( filein @"D:\GitHub\PG.Ms\PGScriptLuncher\PG_SL_LAST.ms" )
	)
)
