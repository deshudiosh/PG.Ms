--shit's usefull for revit-made fbx's imported to max 
--in multimaterials consider only first material (when importing from revit, first mat in multimat is most prominent, at least i think so)

fn LayersByMaterial = (
	for mat in sceneMaterials do (
	
		if classof mat == Multimaterial do mat = mat[1]
	
		layer = LayerManager.getLayerFromName mat.name
		if layer == undefined do layer = LayerManager.newLayerFromName mat.name
		
		objs = (for o in Geometry where o.material == mat collect o)
		
		for obj in objs do layer.addnode obj
	)
)

clearListener()
layersByMaterial()
