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
	)
)