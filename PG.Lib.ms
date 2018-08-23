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
	
	fn tempFile filename = (
		p = pathConfig.GetDir #temp
		p + "\\" + filename
	)
)

global PGLib = PGLib()

-- clearlistener()