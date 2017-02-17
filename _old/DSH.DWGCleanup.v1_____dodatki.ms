fn wireColorFromLayer objs = (
		for obj in objs do (
			obj.colorbylayer = false
			obj.wirecolor = obj.layer.wireColor
		)
)

fn removeMaterial objs = (objs.material = undefined)

fn moveToLayer layerName objs = (
	layer = LayerManager.getLayerFromName layerName
	if layer == undefined do layer = LayerManager.newLayerFromName layerName
	
	for obj in objs do layer.addnode obj
)

fn removeEmptyLayers = (
	layersToDelete = #()
	
	for i = 0 to LayerManager.count - 1 do (
		ilayer = LayerManager.getLayer i
		layerName = ilayer.name
		layer = ILayerManager.getLayerObject i
		layerNodes = refs.dependents layer
		if layerNodes.count <= 2 do append layersToDelete layerName
	)
	
	for ln in layersToDelete do LayerManager.deleteLayerByName ln
)

fn removeBlocks objs = (
	blocks = for obj in objs where (classof obj == LinkComposite) collect obj
		
	progressstart "Cleaning - removing blocks..."
	for i = 1 to blocks.count do (
		progressupdate (100.0 * i / blocks.count)
		blocks[i].parent = undefined
		delete blocks[i]
	)
	progressend()
)

clearlistener()
removeBlocks selection
--wireColorFromLayer selection
--removeMaterial selection
--moveToLayer "_DWG" selection
--removeEmptyLayers()





