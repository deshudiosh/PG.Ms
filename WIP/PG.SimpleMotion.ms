try (destroyDialog PGSimpleMotion) catch()

rollout PGSimpleMotion "PG SimpleMotion" width:250 (

	local xval = 0
	
	fn updateAnim = (
		c = Position_XYZ
		print $.position.controller.keys[1]
	)
	
	spinner xspn "x: " range:[-99999, 99999, xval]
	
	on xspn changed val do (
		xval = val
		updateAnim()
	)
	
		
)

clearlistener()
createDialog PGSimpleMotion

