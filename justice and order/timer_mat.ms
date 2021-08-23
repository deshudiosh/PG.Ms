(
	global t
	
	local TimerStruct

	struct TimerStruct (
		PRIVATE
		
		tm = dotnetobject "system.timers.timer",
		
		fn TimerTick source args = (
			try (filein "X:\!Bloki 3d max!\3dsMax_UPGRADY\justice and order\exec_mat.ms") catch()
		),
		
		PUBLIC
		
		fn Start = ( tm.start() ),
		
		fn Stop = ( tm.stop() ),
		
		fn SetInterval i = tm.Interval = i,
			
		on Create do (
			tm.Interval = 10000
			tm.Enabled = false -- Disable the timer. It will then be enabled with the Start() function.
			dotnet.addeventhandler tm "Elapsed" TimerTick
		)
		
	)
	
	if t != undefined do t.Stop()
	t = TimerStruct()
	t.Start()
)