--AutoEdge Selected v. 0.2 for 3DS MAX
--by Jon Seagull
--
--Performs auto edge on all selected Editable Meshes, 
--making imported AutoCAD meshes easier on the eyes
--please send bug reports, suggestions, or feature requests to scripts@jonseagull.com

(
	disablesceneredraw()
	original_selection = getcurrentselection()
	count = selection.count
	max modify mode

	-- Running Autoedge on grouped objects breaks Max very badly and unrecoverably on some systems.
	-- (Something to do with UI enables code).  This loop traps for it.

	for i in selection where isgroupmember i == true do (
		messagebox "At least one selected object is a group member.\nObjects must be ungrouped before being AutoEdge-d.\nPress OK to process non-grouped objects."
		new_selection = #()
		for j in selection where (isgroupmember j == false) and (isgrouphead j == false) do append new_selection j
		count = new_selection.count
		original_selection = new_selection
		select new_selection
		exit
	)

	-- Takes care of Acad 'Mesh' objects
	for i in selection where classof i.baseobject == trimeshgeometry do (
		AddModifier i (Turn_to_Mesh())
		convertToMesh i
	)

	max modify mode

	for i in 1 to count where ((classof selection[i] == Editable_Mesh) and (isgroupmember selection[i] == false)) do try (
		select selection[i]
		modpanel.setCurrentObject selection[1].baseobject
		subobjectLevel = 2
		max select all
		meshops.autoedge $
		subobjectLevel = 0
		select original_selection
	)
	catch (
		enablesceneredraw()
		redrawviews()
	)
	
	enablesceneredraw()
	redrawviews()

)
	