try (destroydialog boardless) catch()
rollout boardless "boardless dialog" width:300 height:300
(
	
	timer themoverollouttimer interval:1 active:True
	dotNetControl lv "System.Windows.Forms.ListView" align:#center
	
	on lv mousewheel evnt do (
		print evnt.delta
	)
	
	on themoverollouttimer tick do
	(
		origmousepos = mouse.screenpos - [boardless.width*.9, boardless.height/2]
		if (GetDialogPos boardless) != origmousepos do SetDialogPos boardless origmousepos
	)
	
	on boardless open do (
		lv.focus()
	)
)
createdialog boardless style:#() modal:True