--Roadkill 3ds Max frontend, by Stefan Kamoda
/*
Notes:
The variables EdgeFilePath, OBJFilePath and RoadKillApp will need to be modified where required. If roadkill is installed in the
default program files directory you only have to list it's exe name. If the RoadKill exe is in another folder make sure there
are no spaces in the path name. 

Currently the script only operates on collapsed editable mesh objects.


Instructions:
1> Select the editable mesh object you wish to unwrap, making sure the edges you wish to slice along are selected.

2> Run this script and press the Unwrap button. A window will appear whilst RoadKill works it's magic. Max will
	be unresponsive until roadkill is finished. If you have selected the live option, you will have to manually close the
	RoadKill window before max will respond. Once roadkill is finished the UV's will be imported and applied to the
	selected mesh object.
*/

rollout RoadKill "RoadKill v1.1" width:160 height:152
(
	GroupBox grpMain "RoadKill Parameters" pos:[8,8] width:144 height:136
	checkbox chkLSCM "LSCM" pos:[16,24] width:56 height:24
	checkbox chkLive "Live" pos:[16,48] width:40 height:24
	checkbox chkHoles "Fill holes" pos:[16,72] width:64 height:24
	button btnUnwrap "Unwrap" pos:[16,114] width:128 height:24
	checkbox chkShowExportOptions "Export/Import Options" pos:[16,96] width:128 height:16
	
	local EdgeFilePath = "C:\\Program Files\\Autodesk\\3dsMax8\\meshes\\edgList.edg"
	local OBJFilePath = "C:\\Program Files\\Autodesk\\3dsMax8\\meshes\\roadkillOBJ.obj"
	--local RoadKillApp = "F:/rk/RoadKill/RoadKill1_1.exe"
	local RoadKillApp = "RoadKill1_1.exe"

	local exportNode = undefined
	
	fn GetLSCM = 
	(
	if chkLSCM.state then
		(
		return ",-lscm"
		)
	else
		(
		return ",-abf"
		)
	)
	
	fn GetHoles = 
	(
	if chkHoles.state then
		(
		return ",-fillholes"
		)
	else
		(
		return ",-nofillholes"
		)
	)
	
	fn GetLive = 
	(
	if chkLive.state then
		(
		return ",-live"
		)
	else
		(
		return ",-notlive"
		)
	)
	
	fn writeEdgeList = 
		(
		binFile = fOpen EdgeFilePath "wb"
		totalEdges = getEdgeSelection exportNode
		--Write edge file
		WriteShort binFile totalEdges.count #unsigned
		WriteShort binFile 0 #signed -- seperator.
		for e in totalEdges do
			(
			vertList = meshop.getVertsUsingEdge exportNode e
			for v in vertList do
				(
				writeString binFile ((v-1) as string)
				)
			)
		fClose binFile
		)
		
	fn exportObj = 
		(
		oldName = exportNode.name
		exportNode.name = "RoadKillOutput"
		
		if chkShowExportOptions.state then exportFile OBJFilePath selectedOnly:true
		else exportFile OBJFilePath #noPrompt selectedOnly:true
		
		exportNode.name = oldName
		
		--Launch RoadKill
		commandstring = (" \"" + OBJFilePath + "," + EdgeFilePath + GetLSCM() + GetHoles() + GetLive()+"\"")
		print "Please wait..."
		print (Roadkillapp+commandstring)
		val = DOSCommand (Roadkillapp+commandstring)
		print val
		)
		
	fn importObj = 
		(
		print "importing....."
		
		if chkShowExportOptions.state then importFile OBJFilePath
		else importFile OBJFilePath #noPrompt
		
		if IsValidNode $RoadKillOutput then
			(
			print "Apply UV's"
			addModifier $RoadKillOutput (Unwrap_UVW())
			uvData = (copy $RoadKillOutput.modifiers[1])
			addModifier exportNode uvData
			collapseStack exportNode
			delete $RoadKillOutput
			)
		)
	/*	
	on RoadKill open do
	(
	if ((doesFileExist RoadKillApp) == false) then
		(
		messageBox "Could not find RoadKill application at specified location.\nThis script will now close." title:"Unable to locate RoadKill exe."
		DestroyDialog RoadKill
		)
	)	
	*/

	on btnUnwrap pressed do
	(
	exportNode = $
	if ((exportNode != undefined) and ((classOf exportNode) == Editable_mesh))  then
		(
		writeEdgeList()
		exportObj()
		importObj()
		)
	else messagebox "Unable to process the selected geometry. Check selection is an editable mesh."
	)
)

createDialog RoadKill 160 152