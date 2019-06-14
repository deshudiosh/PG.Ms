macroScript PG_CamSelect
	category:"Pawel Grzelak"
	tooltip:"Camera Select"
	buttonText:"CamSelect"
(
	on execute do (
		struct pgcamselect (
			cams,
			
			-- this sorting doesnt work lol
			fn sortCamerasByName c1 c2 = (
				which = c1.name > c2.name
				case of (
					(which): 1
					default: 0
				)
			),
				
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
				
				cams = for cam in cameras where (superclassof cam == Camera ) collect cam
				--qsort cams sortCamerasByName
				
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
							destroydialog pgcsdial
						)
						
						on pgcsdial open do (
							list_init list
							list_populate list
							list.refresh()
							list.focus()
							
							pgcsdial.height = list.height
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
