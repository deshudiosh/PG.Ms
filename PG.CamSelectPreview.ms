-- TODO:
-- * orthographic views are not restored properly ( getViewFOV ???  viewport.setTM ????)
-- * select current camera on initialization -- init()

try (destroyDialog PGCamSelect) catch()

rollout PGCamSelect "PG Camera Select"  width:200 height:280 (
		
	local initViewType, initCamera, initViewTM, initViewFOV
	local restoreOnClose = true
	
	listbox list height:18 width:190 align:#center
	
	button btnNext "?" width:25 pos:[5, 250]
	button btnPrev "^" width:25 pos:[30, 250]
	button btnCancel "Cancel" width:60 pos:[75, 250]
	button btnApply "Apply" width:60 pos:[135, 250]
	
	fn getCameras onlyNames = (
		cams = (for c in cameras where classof c != Targetobject collect c)
		if onlyNames do cams = (for c in cams collect c.name)
		cams
	)
	
	-- wrapper for listbox 'on selected' event handler
	fn list_on_selected idx = (
		list.selection = idx
		viewport.setCamera (getCameras false)[idx]
	)
	
	fn init = (
		initViewType = viewport.getType()
		initCamera = getActiveCamera()
		initViewTM = getViewTM()
		
		list.items = getCameras true
	)
	
	fn next = (
		list_on_selected (if list.selection + 1 > list.items.count then 1 else list.selection + 1)
	)
	
	fn prev = (
		list_on_selected (if list.selection - 1 < 1 then list.items.count else list.selection - 1)
	)
	
	fn cancel = (
		if restoreOnClose do (
			if initViewType == #view_camera then viewport.setCamera initCamera
			else (
				viewport.setType initViewType
				viewport.setTM initViewTM
			)
		)
		
		try (destroyDialog PGCamSelect) catch()
	)
	
	fn apply = (
		restoreOnClose = false
		try (destroyDialog PGCamSelect) catch()
	)
	
	on btnNext pressed do next()
	on btnPrev pressed do prev()
	on btnApply pressed do apply()
	on btnCancel pressed do cancel()
	on list selected idx do list_on_selected idx
	on list doubleClicked itm do apply()
	on PGCamSelect open do init()
	on PGCamSelect close do cancel()
)

clearlistener()
createDialog PGCamSelect modal:True
-- createDialog PGCamSelect

