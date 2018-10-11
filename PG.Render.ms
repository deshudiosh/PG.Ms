struct PGRenderDef (
	uiInstance = undefined,
	id = #PGCallbackId,
	
	startF, endF, outputFile, nextFrame,
	
	fn preRender = (
		print ">> prerender"
		--rendOutputFilename = nextFilePath
	),
	
	fn postRender = (
		print ">> postrender"
		this.nextFrame = this.nextFileToRender()
		print (format "Next to render: %\n" this.outputFile)
		
		execute ("render frame:" + this.nextFrame as string)
		render frame:nextFrame outputfile:outputFile
-- 		max quick render
	),
	
	fn existFile fname = ((getfiles fname).count != 0),
	
	fn nextFileToRender = (		
		for i = this.startF to this.endF do (
			folder = getFilenamePath rendOutputFilename
			file = getFilenameFile rendOutputFilename
			ext = getFilenameType rendOutputFilename
			
			root = folder + file + i as string
			this.outputFile =  root + ext
			
			available = (existFile (root + "*")) == false-- check if image or *.lock file exists
			
			if available == true do exit with i --return
		)
	),
		
	fn startRender start end = (	
		this.startF = start
		this.endF = end
		
		this.register()
		
		this.postRender() --	initailize render loop
	),
	
	fn register = (
		callbacks.addScript #preRender "PGRender.preRender()" id:id
		callbacks.addScript #postRender "PGRender.postRender()" id:id
	),
	
	fn unRegister = ( callbacks.removeScripts id:id ),
	
	fn ui = (
		rollout PGRenderUi "PG Render" width:240 (
			spinner startSpinner "Range:" type:#integer width:100 across:2 range:[-99999, 99999, animationRange.start] 
			spinner endSpinner "To:" type:#integer width:80 range:[-99999, 99999, animationRange.end]
			button renderBtn "Render!" width:200 height:60
			
			on renderBtn pressed do (
				PGRender.startRender (startSpinner.value) (endSpinner.value) 
			)
			
			on PGRenderUi open do ()
			
			on PGRenderUi close do (
				PGRender.unRegister()
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