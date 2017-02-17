global DWGCleanupDwgLayerName = "_DWG"
global DWGCleanupBlocksLayerName = "_BLOCKS"

fn unlinkObjects objs = (
	print "DWGCleanup - Unlinking..."

	progressstart "DWGCleanup - Unlinking..."
	
	for i = 1 to objs.count do (
		progressupdate (100.0 * i / objs.count)
				
		obj = objs[i]
		obj.transform.controller = prs()
		obj.parent == undefined
	)
	
	progressend()
	
	"done"
)

fn removeMaterial objs = (
	print "DWGCleanup - Removing Materials..."
	objs.material = undefined
	"done"
)

fn wireColorFromLayer objs = (
	print "DWGCleanup - Applying wire colors..."
	
	progressstart "DWGCleanup - Applying wire colors..."
	for i = 1 to objs.count do (
		progressupdate (100.0 * i / objs.count)
		
		obj = objs[i]
		obj.colorbylayer = false
		obj.wirecolor = obj.layer.wireColor
	)
	progressend()
	
	"done"
)

fn moveToLayer layerName objs = (
	print "DWGCleanup - Moving elements to one layer..."
	layer = LayerManager.getLayerFromName layerName
	if layer == undefined do layer = LayerManager.newLayerFromName layerName
	
	for obj in objs do layer.addnode obj
	"done"
)

fn moveBlocksToLayer layerName objs = (
	print "DWGCleanup - Moving blocks to one layer..."
	
	blocks = for obj in objs where (classof obj == LinkComposite) collect obj
	
	layer = LayerManager.getLayerFromName layerName
	if layer == undefined do layer = LayerManager.newLayerFromName layerName
		
	for obj in blocks do layer.addnode obj
	
	layer.isHidden = true
	layer.isFrozen = true
	
	"done"
)

fn removeLayers deleteEmpty deleteHidden = (
	print "DWGCleanup - Removing layers..."
	
	layersToDelete = #()
	

	for i = 0 to LayerManager.count - 1 do (		
		ilayer = LayerManager.getLayer i
		layerName = ilayer.name
		layer = ILayerManager.getLayerObject i
		layer.nodes &nodes
			
		-- if is empty 
		if deleteEmpty AND nodes.count == 0 do (append layersToDelete #(layerName, nodes))
			
		-- if is hidden
		if deleteHidden AND layer.isHidden AND layer.name != DWGCleanupBlocksLayerName do (
--			delete nodes
			append layersToDelete #(layerName, nodes)
		)
	)
	
	progressstart "DWGCleanup - Removing layers..."
	for i = 1 to layersToDelete.count do (
		progressupdate (100.0 * i / layersToDelete.count)
		layerName = layersToDelete[i][1]
		layerNodes = layersToDelete[i][2]
		
		delete layerNodes
		LayerManager.deleteLayerByName layerName
	)
	progressend()
		
	"done"
)

fn collectVisibleElementsExceptBlocks = (
	collected = for obj in objects where ( \
		classof obj != LinkComposite AND obj.layer.isHidden == false AND obj.layer.name != DWGCleanupDwgLayerName \
		) collect obj
)

clearlistener()

objs = collectVisibleElementsExceptBlocks()
unlinkObjects objs
removeMaterial objs
wireColorFromLayer objs
moveToLayer DWGCleanupDwgLayerName objs
moveBlocksToLayer DWGCleanupBlocksLayerName objects
removeLayers true true





