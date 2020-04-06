struct pgcamselect (
	--used to store camera array
	cams,
	previous_camera,
		
	fn compareNames obj1 obj2 = stricmp obj1.name obj2.name,
		
	fn dialog_size_update list = (
		num_items = list.items.count
		list.height = list.itemheight * (num_items+1)
	),
	
	fn list_init list = (
		--show list
		list.multiColumn = false
  		--list.drawmode = list.drawmode.OwnerDrawFixed
  		myColor = (dotNetClass "System.Drawing.Color").fromArgb 160 160 160
  		list.backColor = mycolor
	),
	
	fn list_populate list = (
		for i =  1 to cams.count do
  		(
  			--label_item = dotNetObject "System.Windows.Forms.Label"
  			--label_item.text = i as string
			label_item = cams[i].name
  			list.Items.add label_item
  		)
		
		current_cam_index = findItem cams (viewport.getcamera())
		list.SelectedIndex = current_cam_index - 1
		
		dialog_size_update list
	),
	
	fn list_scroll list delta = (
		--show list
		num_items = list.items.count
		idx = list.SelectedIndex + delta
		
		if idx > num_items - 1 do idx = num_items - 1
		if idx < 0 do idx = 0
		
		list.selectedindex = idx
		viewport.setCamera cams[idx+1]
	),
		
	fn run = (
		try (destroydialog pgcsdial) catch()
		
		-- If selected object is camera apply default 3ds max behaviour
		if superclassof selection[1] == Camera do (
			viewport.setCamera selection[1]
			return ""
		)
		
		cams = for cam in cameras where (superclassof cam == Camera ) collect cam
		qsort cams compareNames
		
		if cams.count > 0 do (			
			rollout pgcsdial "boardless dialog" width:200 height:200
			(
				label lb1 "- Scroll to change camera"
				label lb2 "- Left click to accept"
				label lb3 "- Right click to select camera object"
				label lb4 "- Shift + Right click to select cam target"
				label lb5 "- Esc to cancel"
				dotNetControl list "System.Windows.Forms.ListBox" align:#center height:200 width:200 pos:[000, 0]
				timer t interval:1 active:True
				
				on t tick do (
					mp = mouse.screenpos - [pgcsdial.width-10, 10]
					SetDialogPos pgcsdial mp
				)
				
				on list mousewheel evnt do (
					delta = if evnt.delta > 0 then -1 else 1
					list_scroll list delta
				)
				
				on list mousedown evnt do (
					active_cam = getActiveCamera()
					
					if superclassof active_cam == Camera do (
						active_cam_target = if active_cam != undefined then active_cam.target else undefined
						-- if rightclick
						if evnt.button == evnt.button.right and active_cam != undefined do (
							-- if SHIFT try selecting target instead
							if keyboard.shiftPressed and active_cam_target != undefined then (
								select active_cam_target
							)
							-- select camera and activate modify panel
							else (
								select active_cam
								max modify mode
							)
						)
					)
					
					-- any mouse key closes dialog
					destroydialog pgcsdial
				)
				
				on list keydown evnt do (
					if evnt.keycode == evnt.keycode.c do destroydialog pgcsdial
				)
				
				on pgcsdial open do (
					previous_camera = getActiveCamera()
					
					list_init list
					list_populate list
					list.refresh()
					list.focus()
					
					-- update dialog height (seems circular, but works)
					pgcsdial.height = list.height + 80
					dialog_size_update list
					
					lb1.pos = [3, list.height+2]
					lb2.pos = [3, list.height+17]
					lb3.pos = [3, list.height+32]
					lb4.pos = [3, list.height+47]
					lb5.pos = [3, list.height+62]
				)
				
				-- executed on ESC due to modal:True
				-- intercepts ESC keystrokes so escape-key logic gotta be coded here
				on pgcsdial close do (
					-- revert previous camera if there was one
					if keyboard.escPressed and previous_camera != undefined do viewport.setCamera previous_camera
				)
			)
			createdialog pgcsdial style:#() modal:True
		)
	)
	
)

clearlistener()
pgcs = pgcamselect()
pgcs.run()



