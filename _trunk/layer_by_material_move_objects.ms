fn layer_by_material = (
	LayerManager.closeDialog() 
	for o in selection where o.material != undefined do (
		matname = o.material as string
		layer = LayerManager.getLayerFromName matname
		if layer == undefined do layer = LayerManager.newLayerFromName matname
		layer.addNode o
	)
)

layer_by_material()