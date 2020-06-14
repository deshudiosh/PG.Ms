macroScript PG_SL
	category:"Pawel Grzelak"
	toolTip:"PG Cam Select"
	buttonText:"PGCamSelect"
(
	on execute do (
		--usualy C:\Users\username\AppData\Local\Autodesk\3dsMax\2017 - 64bit\ENU\usermacros\
		pgscripts = (getINIsetting ((pathConfig.GetDir #userMacros) + "\\PG.ini") "PG" "pgscripts")
		
		filein (pgscripts + "PG.CamSelect.ms")
	)
)