macroScript PG_CamSelect
	category:"Pawel Grzelak"
	tooltip:"Camera Select"
	buttonText:"CamSelect"
(
	on execute do (
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
				list.multiColumn = false
				myColor = (dotNetClass "System.Drawing.Color").fromArgb 160 160 160
				list.backColor = mycolor
			),
			
			fn list_populate list = (
				for i =  1 to cams.count do
				(
					label_item = cams[i].name
					list.Items.add label_item
				)
				
				current_cam_index = findItem cams (viewport.getcamera())
				list.SelectedIndex = current_cam_index - 1
				
				dialog_size_update list
			),
			
			fn list_scroll list delta = (
				num_items = list.items.count
				idx = list.SelectedIndex + delta
				
				if idx > num_items - 1 do idx = num_items - 1
				if idx < 0 do idx = 0
				
				list.selectedindex = idx
				viewport.setCamera cams[idx+1]
			),
			
			fn run = (
				try (destroydialog pgcsdial) catch()
				
				cams = for cam in cameras where (superclassof cam == Camera ) collect cam
				qsort cams compareNames
				
				if cams.count > 0 do (			
					rollout pgcsdial "boardless dialog" width:200 height:200
					(
						
						dotNetControl list "System.Windows.Forms.ListBox" align:#center height:200 width:200 pos:[0, 0]
						timer t interval:1 active:True
						
						on t tick do (
							mp = mouse.screenpos - [pgcsdial.width-3, pgcsdial.height/2]
							SetDialogPos pgcsdial mp
						)
						
						on list mousewheel evnt do (
							delta = if evnt.delta > 0 then -1 else 1
							list_scroll list delta
						)
						
						on list mousedown evnt do (
							-- if rightclick, select camera and activate modify panel
							active_cam = getActiveCamera()
							if evnt.button == evnt.button.right and active_cam != undefined do (
								select active_cam
								max modify mode
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
							
							pgcsdial.height = list.height
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

		pgcs = pgcamselect()
		pgcs.run()
	)
)
