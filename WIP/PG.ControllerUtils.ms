rollout PGControllerUtils "PG Controller Utils" width:400(
	button copybtn "COPY" height:40
	button pastebtn "PASTE" height:40
	
	button copy_z_btn "COPY_Z_ROT" height:40
	button paste_z_btn "PASTE_Z_ROT" height:40
	
	button new_euler_xyz_btn "Assign New EULER_XYZ to rotation" height:40
	
	local controller
	local ctrl_rot_z
	
	fn copy_rotation_controller = (
		fromobj = selection[1]
		controller = fromobj.rotation.controller
		copybtn.text = "COPIED > " + fromobj.name + "." + controller as string
	)
	
	fn paste_rotation_controller = (
		for toobj in selection where superclassof toobj == GeometryClass do (
			toobj.rotation.controller = copy controller
		)
	)
	
	fn copy_z_rotation_controller = (
		fromobj = selection[1]
		ctrl_rot_z = fromobj.rotation.z_rotation.controller
		copy_z_btn.text = "COPIED_Z_ROT> " + fromobj.name + "." + ctrl_rot_z as string
	)
	
	fn paste_z_rotation_controller = (
		for toobj in selection where superclassof toobj == GeometryClass do (
			toobj.rotation.z_rotation.controller = ctrl_rot_z
		)
	)
	
	
	
	fn new_euler_xyz = (
		for o in selection do (
			o.rotation.controller = Euler_XYZ()
			o.rotation.x_rotation.controller = Bezier_Float()
			o.rotation.y_rotation.controller = Bezier_Float()
			o.rotation.z_rotation.controller = Bezier_Float()
		)
	)
	
	on copybtn pressed do copy_rotation_controller()
	on pastebtn pressed do paste_rotation_controller()
	
	on copy_z_btn pressed do copy_z_rotation_controller()
	on paste_z_btn pressed do paste_z_rotation_controller()
	
	on new_euler_xyz_btn pressed do new_euler_xyz()
)

createdialog pgcontrollerutils
