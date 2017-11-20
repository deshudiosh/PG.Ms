-- 	#("General", "Geometry", "Material", "Output", "Optimize")
-- 	General [1] #("UseLogging", "Preset", "MapSearchPath")
--	Geometry [2] #("FlipZyAxis", "Shapes", "ExportHiddenObjects", "FaceType", "TextureCoords", "Normals", "SmoothingGroups", "ObjScale")
-- 	Material [3] #("UseMaterial", "CreateMatLibrary", "ForceBlackAmbient", "UseMapPath", "MapPath", "AutoMapChannel", "MapChannel", "ExtendedParams", "ConvertBitmaps", "RenderProcedural", "ResizeMaps", "ResizeMaps2n", "MapFormat", "MapSizeX", "MapSizeY")
-- 	Output [4] #("RelativeIndex", "Target", "Precision")
-- 	Optimize [5] #("optVertex", "optNormals", "optTextureCoords")
	
function exportSilent = (
	i = objexp.getIniName()

	setIniSetting i "General" "Preset" "0"
	setIniSetting i "Geometry" "FlipZyAxis" "0"
	setIniSetting i "Material" "UseMaterial" "0"
	setIniSetting i "Material" "CreateMatLibrary" "0"
	setIniSetting i "Optimize" "optVertex" "0"
	setIniSetting i "Optimize" "optNormals" "0"
	setIniSetting i "Optimize" "optTextureCoords" "0"
	
	file = "X:\\!Bloki 3d max!\\SWAP\\silent_export.obj"
	exportFile file #noPrompt selectedOnly:true
-- 	exportFile file selectedOnly:true
)

exportSilent()