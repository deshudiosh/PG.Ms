struct pgscriptluncher (
	uiInst = undefined,
	fn ui = 	(
		--global pgsldial
		rollout pgsldial "PG Script Luncher"	width:200 height:400 (
			dotNetControl splitCon "system.windows.forms.splitContainer"
			
			on pgsldial open do (
				print "otwarte"
			)
			
			on pgsldial close do ( 
				print "zamkniete"
				global pgsl = undefined 
			) 
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
		)
	)
)

clearlistener()
--try(if pgsldial.open == false do pgsl = undefined)catch()
if pgsl == undefined do pgsl = pgscriptluncher()
pgsl.run()

