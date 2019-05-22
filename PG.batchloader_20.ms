/*
Batch Loader v.2.0 [2009/2012] by Anubis [project3d.narod.ru]
	
Quick Merge/Import multiple files.
	
Features:
	- Merge multiple .MAX files
	- Import multiple .* files (ie all that can be imported)!
	- Log all files where failed to load to Listener (if any)
	- Multiple history for recent used paths available
	- Limit count of recent paths to keep in history added
	- Group option available
	- Layer option available
	- Attach option available
	- "Auto" option (if is checked no prompt for Merge/Import) *
	- Dialog window is resizeable
	- Auto rename duplicated objects on import

[*] If "Auto" is unchecked then default Max Merge/Import dialog appear for each file. 
It is slower alternative, but it is important and useful in some cases.

Version history:
	1.0 [2009-10-05] - initial version
	1.1 [2010-08-03] - minor code polish up
	1.2 [2010-08-30] - INI file previously saved to Scripts folder, now saved within script source file location
	1.3 [2010-09-02] - added minimal dialogue size when the dialogue is resized
	1.4 [2010-09-03] - suppress the name conflict dialogue when imports and "Auto" option is on (now auto rename)
	1.5 [2011-01-25] - create layer per file using it file name as label
	1.6 [2011-01-28] - minor fixes
	1.7 [2011-10-30] - added attach per file as mesh or poly
	1.8 [2011-11-13] - suppress additional imports dialogue; browse for folder dialogue start in recent path
	1.9 [2011-11-16] - auto renaming rewriten (as the auto suggested name is not always correct, now append count digits)
	2.0 [2012-10-26] - now check (by name) for existing layer and create new only if not exist

TodoList: Remove stored paths that no more exist
*/
global BL_Import_Counter = 0 -- need for renaming imported objects!
-- ( don't worry, its removed then the dialog is closed ;) )

fn RenameImported =
(
	local HWND = DialogMonitorOPS.GetWindowHandle()
	if ((UIAccessor.GetWindowText HWND) == "Import Name Conflict") do
	(
		::BL_Import_Counter += 1
		local oName = "_" + (formattedPrint ::BL_Import_Counter format:"4.4d")
		local cWND = UIAccessor.GetChildWindows HWND
		for cw in cWND where cw != 0 and (UIAccessor.GetWindowClassName cw) == "Edit" do
		(UIAccessor.SetWindowText cw (UIAccessor.GetWindowText cw + oName))
		UIAccessor.sendMessageID HWND #IDOK
	)
	true
)

if classOf ro_BatchLoad == RolloutClass do destroyDialog ro_BatchLoad
rollout ro_BatchLoad "Batch Loader v.2.0"
(
	local listFiles = #(), recentDir = #(), iniFile
	
	fn isDirectory str  = (doesFileExist str and getFileAttribute str #directory)
	
	button btn_directory "..." align:#left across:2
	edittext etx_LastPath "" bold:true readOnly:true pos:[40,8] fieldWidth:(ro_BatchLoad.width-60)
	spinner spn_Histrory "History #: " range:[1,100,5] type:#integer fieldWidth:40 pos:[345,30]
	dropdownlist ddl_LastPath "Recent Directories:" items:#() pos:[12,30]
	progressBar pgb_load
	
	label lbl01 "Select Files:" pos:[12,92]
	button btn_none "None" pos:[12,108] width:35 height:16
	button btn_all "All" pos:[48,108] width:35 height:16
	
	radiobuttons rbt_LType labels:#("Merge","Import") pos:[100,94] columns:1
	checkbox chb_group "Group" height:15 pos:[166,94]
	checkbox chb_layer "Layer" height:15 pos:[166,110]
	
	checkbox chb_attach "Attach As:" pos:[230,94]
	radiobuttons rbt_AType labels:#("Mesh","Poly") default:2 pos:[230,110] enabled:off
	
	checkbox chb_auto "Auto" height:15 pos:[388,92] checked:true
	button btn_go "GO" pos:[388,108] width:60 height:16
	multilistbox mlb_files "" height:15 width:435 pos:[12,130]
	
	on ro_BatchLoad open do (
		local me = getSourceFileName() -- Max9+
		dir = getFilenamePath me
		iniFile = dir + "BatchLoader.ini" -- save INI to the MS file location
		
		if (doesFileExist iniFile) then (
			LP = getINISetting iniFile "Saved" "LastPaths"
			if LP != "" do (
				recentDir = filterString LP ","
				ddl_LastPath.items = recentDir
			)
			
			RS = getINISetting iniFile "Saved" "RecSave"
			if RS != "" do spn_Histrory.value = (RS as integer)
		)
		else (
			setINISetting iniFile "Saved" "LastPaths" ""
			setINISetting iniFile "Saved" "RecSave" "5"
		)
		
		if ddl_LastPath.items.count > 0 then (
			etx_LastPath.text = ddl_LastPath.selected
			ddl_LastPath.enabled = true
		)
		else ddl_LastPath.enabled = false
	)
	
	on ro_BatchLoad close do (
		setINISetting iniFile "Saved" "RecSave" (spn_Histrory.value as string)
		if recentDir.count > spn_Histrory.value do (
			while recentDir.count > spn_Histrory.value do deleteItem recentDir 1
		)
		local str = ""
		for i in recentDir do append str (i + ",")
		setINISetting iniFile "Saved" "LastPaths" str
		-- remove the temp counter variable from the global space:
		if globalVars.isglobal #BL_Import_Counter do globalVars.remove #BL_Import_Counter
	)
	
	on ddl_LastPath selected i do (
		etx_LastPath.text = ddl_LastPath.items[i]
		case rbt_LType.state of (
			1: listFiles = getFiles (ddl_LastPath.items[i] + "/*.max")
			2: listFiles = getFiles (ddl_LastPath.items[i] + "/*.*")
		)
		mlb_files.items = for f in listFiles collect (filenameFromPath f)
	)
	
	on btn_directory pressed do (
		local selDir = etx_LastPath.text
		local intDir = (if isDirectory selDir then selDir else (GetDir #import))
		if (dir = getSavePath caption:"Select the directory" initialDir:intDir) != undefined do (
			etx_LastPath.text = dir
			ddl_LastPath.enabled = true
			if findItem recentDir dir == 0 do
			(
				append recentDir dir
				ddl_LastPath.items = recentDir
			)
			ddl_LastPath.selection = findItem recentDir dir
			case rbt_LType.state of (
				1: listFiles = getFiles (dir+"/*.max")
				2: listFiles = getFiles (dir+"/*.*")
			)
			mlb_files.items = for f in listFiles collect (filenameFromPath f)
		)
	)
	
	on rbt_LType changed state do (
		if etx_LastPath.text != "" do (
			case state of (
				1: listFiles = getFiles (etx_LastPath.text+"/*.max")
				2: listFiles = getFiles (etx_LastPath.text+"/*.*")
			)
		)
		mlb_files.items = for f in listFiles collect (filenameFromPath f)
	)
	
	on btn_none pressed do ( mlb_files.selection = #{} )
	
	on btn_all pressed do (
		mlb_files.selection = #{1..(mlb_files.items.count)}
	)
	
	on chb_attach changed stt do (rbt_AType.enabled = stt)
	
	on btn_go pressed do (
		local seqFiles = #()
		local sel = (mlb_files.selection as array)
		for i = 1 to sel.count do append seqFiles listFiles[sel[i]]
		
		max create mode -- speed up process
		local failToLoad = #() -- for debug log
		
		if rbt_LType.state == 2 and chb_auto.checked == true do (
			DialogMonitorOPS.unRegisterNotification id:#autoRaname
			DialogMonitorOPS.RegisterNotification RenameImported id:#autoRaname
			DialogMonitorOPS.Enabled = true
		)
		
		if heapSize < 80000000L do heapSize = 80000000L -- set 80MB
		local oldAB = autoBackup.enabled
		autoBackup.enabled = false
		clearUndoBuffer()
		set undo off
		
		for i=1 to seqFiles.count do (
			local ObjsCount = objects.count -- need for FBX importer
			local done = false -- import process
			
			case rbt_LType.state of (
				1: (
					if chb_auto.checked then (
						if not (done = mergeMAXFile seqFiles[i] #noRedraw #select #mergeDups #renameMtlDups #neverReparent quiet:true) do
						append failToLoad seqFiles[i]
					)
					else (
						if not (done = mergeMAXFile seqFiles[i] #prompt #select) do
						append failToLoad seqFiles[i]
					)
				)
				2: (
					if chb_auto.checked then (
						if not (done = importFile seqFiles[i] #noPrompt) do
						append failToLoad seqFiles[i]
					)
					else (
						if not (done = importFile seqFiles[i]) do
						append failToLoad seqFiles[i]
					)
				)
			)
			
			if done do -- if import successful
			(
				local loadedObjects = #()
				local FName = (filterString (getFilenameFile seqFiles[i]) ".")[1]
				
				case rbt_LType.state of (
					1: loadedObjects = getCurrentSelection()
					2: ( -- then import FBX not select the new obj's, so collect them
						loadedObjects = for i = (ObjsCount+1) to objects.count collect objects[i]
						ObjsCount = objects.count
						PRINT loadedObjects
					)
				)
				
				if chb_group.checked do (-- if group is checked
					local g = group loadedObjects name:FName
					append loadedObjects g
				)
				
				if chb_layer.checked do ( -- if create new layer is checked
					layer = LayerManager.getLayerFromName FName
					if layer == undefined do
						layer = LayerManager.newLayerFromName FName
					for obj in loadedObjects do layer.addNode obj
				)
				
				if chb_attach.checked do ( -- if attach is checked
					local mObjs = for i in loadedObjects where canConvertTo i Editable_Mesh collect i
					if mObjs.count == 1 do case rbt_AType.state of (
						1: convertToMesh mObjs[1]
						2: convertTo mObjs[1] Editable_Poly
					)
					if mObjs.count > 1 do (
						local main = convertToMesh mObjs[1]
						deleteItem mObjs 1
						for obj in mObjs do (meshop.attach main obj attachMat:#IDToMat condenseMat:true)
						main.name = FName
						centerPivot main
						if rbt_AType.state == 2 do convertTo main Editable_Poly
					)
				)
			)
			
			pgb_load.value = 100.*i/seqFiles.count -- Update ProgressBar
		)
		
		set undo on
		pgb_load.value = 0
		DialogMonitorOPS.Enabled = false
		DialogMonitorOPS.unRegisterNotification id:#autoRaname
		autoBackup.enabled = oldAB
		
		if failToLoad.count > 0 do ( -- log failed files to Listener
			clearListener()
			actionMan.executeAction 0 "40472"  -- open Listener
			format "The following files were not loaded:\n"
			for i in failToLoad do format "%\n" i
		)
	)
	
	on ro_BatchLoad resized Point2 do
	(
		local ro_size = GetDialogSize ro_BatchLoad
		ddl_LastPath.width = ro_size[1] - 20
		mlb_files.width = ro_size[1] - 20
		mlb_files.height = ro_size[2] - 140
		etx_LastPath.width = ro_size[1] - 54
		if ro_BatchLoad.width < 460 do ro_BatchLoad.width = 460
		if ro_BatchLoad.height < 340 do ro_BatchLoad.height = 340
	)
)
createDialog ro_BatchLoad 460 340 \
style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox, #style_maximizebox, #style_resizing)
