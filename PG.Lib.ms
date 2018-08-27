struct PGLib (
	fn askForStringWithDefault txt = (
		-- instantiate the object
		theObj = dotNetObject "MaxCustomControls.RenameInstanceDialog" txt
		theobj.text ="New prefix will be"
		DialogResult = theObj.Showmodal()

		insetedtext = theobj.InstanceName
		
		--test if the ok button was pressed, if not, return default
		okclicked = dotnet.compareenums TheObj.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK)
		if not okclicked do insetedtext = txt
		
		insetedtext		
	),
	
	--RETURN path or undefined
	fn saveFileDialog title:undefined = (
		dno = dotNetObject "System.Windows.Forms.SaveFileDialog"
		if title != undefined do dno.title = title
		r = dno.showdialog()
		
 		if (r != r.OK) then val = undefined
 		else val = dno.filename
		val
	),
	
	fn setData id data = (
		setAppData rootnode id data
	),
	
	fn getData id = (
		getAppData rootnode id
	),
		
	cons = (
			struct cons ( 
				pgscripts = (getINIsetting ((pathConfig.GetDir #userMacros) + "\\PG.ini") "PG" "pgscripts"),
				PyMsExe = this.pgscripts + "PyMs.exe",
				vray_depth_exr = (pathConfig.GetDir #temp) + "\\vray_depth.exr",
				vray_depth_results = (pathConfig.GetDir #temp) + "\\vray_depth.ini",
				vray_depth_renderpreset = (pathConfig.GetDir #temp) + "\\vray_depth.rps"
			)
	)(),
			
	fn vrayDepthMin = ((getINISetting this.cons.vray_depth_results "vray_depth" "min") as number ),
	fn vrayDepthMax =  ((getINISetting this.cons.vray_depth_results "vray_depth" "max") as number)
)

global PGLib = PGLib()
-- clearlistener()