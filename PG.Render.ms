struct PGRenderDef (
	uiInstance,	startF, endF, outputFile, nextFrame,
		
	fn existFile fname = ((getfiles fname).count != 0),
	
	fn findNextFrame = (
		this.nextFrame = undefined
		for i = this.startF to this.endF do (
			folder = getFilenamePath rendOutputFilename
			file = getFilenameFile rendOutputFilename
			ext = getFilenameType rendOutputFilename
			
			root = folder + file + i as string
			this.outputFile =  root + ext
			
			available = (existFile (root + "*")) == false-- check if image or *.lock file exists
				
			if available == true then (
				this.nextFrame = i
				exit 
			)
		)
	),
	
	fn createLock = (
	),
	
	fn actualRender = (
		render \
			frame:PGRender.nextFrame \
			outputfile:PGRender.outputFile \
			vfb:false
	),
	
	fn preRender = (
		print ">> #preRender"
	),
	
	fn postRender = (
		print ">> #postRender"
		
		this.findNextFrame()
		
		if this.nextFrame != undefined then (
			this.createLock()
			
			fn perform sender evt = (
				sender.stop() -- one tick only
				dotnet.removeAllEventHandlers sender
				PGRender.actualRender()
			)
			
			delay= dotnetobject "Windows.Forms.Timer"
			delay.Interval=500
			dotnet.AddEventHandler delay "Tick" perform
			delay.start()
		)
		else messageBox "No frames to render :)"
	),
	
	fn registerCallbacks = (
		callbacks.addScript #preRender "PGRender.preRender()" id:#PGCallbackId
		callbacks.addScript #postRender "PGRender.postRender()" id:#PGCallbackId
	),
	
	fn unRegisterCallbacks = ( callbacks.removeScripts id:#PGCallbackId ),
	
	fn ui = (
		rollout PGRenderUi "PG Render" width:240 (
			spinner start "Range:" type:#integer width:100 across:2 range:[-99999, 99999, animationRange.start] 
			spinner end "To:" type:#integer width:80 range:[-99999, 99999, animationRange.end]
			button renderBtn "Render!" width:200 height:60
			
			on renderBtn pressed do (
				PGRender.startF = start.value
				PGRender.endF = end.value
				
				PGRender.registerCallbacks()
				PGRender.postRender() --	initailize render loop
			)
			
			on PGRenderUi open do ()
			
			on PGRenderUi close do (
				PGRender.unRegisterCallbacks()
			)
		)
		uiInstance = createDialog PGRenderUi --pos:[1200, (random 300 1200)]
		uiInstance = PGRenderUi
	),
	
	fn open = ( ui() ),
	fn close = ( if uiInstance != undefined do (
		destroyDialog uiInstance
		uiInstance = undefined
	))
)

clearListener()

try( PGRender.close() )catch()
global PGRender = PGRenderDef()
PGRender.open()