try (destroyDialog PGCamSelect) catch()

rollout PGCamSelect "PG Camera Select"  width:220 (
	
	listbox list 
	
	on objectToKill selected nameIndex do (
		select (getNodeByName objectToKill.items[nameIndex])
	)
	on objectToKill doubleClicked itm do (
	)
			
	on PGCamSelect open do(
		names = (for cam in cameras collect cam.name)
		list.items = names
	)
	
	on PGCamSelect close do(
	)
)

clearlistener()
createDialog PGCamSelect