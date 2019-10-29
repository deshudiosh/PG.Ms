struct pgscriptluncher (
	uiInst = undefined,
	fn ui = 	(
		rollout pgsldial "PG Script Luncher"	width:200 height:400 (
			dotNetControl splitCon "system.windows.forms.splitContainer" 
		)
		createDialog pgsldial
		uiInst = pgsldial
	),
	
	fn run = (
		if uiInst == undefined then (
			ui()
		)
		else (
			destroyDialog uiInst
			uiInst = undefined
			global pgsl = undefined
		)
	)
)

clearlistener()
if pgsl == undefined do pgsl = pgscriptluncher()
pgsl.run()