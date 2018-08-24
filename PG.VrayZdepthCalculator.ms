fn renderSamplerPass = (
	re = maxOps.GetCurRenderElementMgr()

	-- clear all render elements
	for i = 1 to re.NumRenderElements() do (
		re.RemoveRenderElement (re.GetRenderElement (i-1))
	)
	
	passname = "PG.VrayDepthCalculator"
	
	re.addRenderElement (VRaySamplerInfo elementname:passname type:0 coord_system:2 filterOn:false)

	max quick render
	vfbControl #setchannel 2
	vfbcontrol #savemultiimage PGLib.cons.vray_depth_exr
)

fn calculateWithPyMs = (
	command = "PyMs.exe vray_depth -o1 \"" + PGLib.cons.vray_depth_exr + "\" -o2 \"" + PGLib.cons.vray_depth_results + "\""
	hiddendoscommand command startpath:PGLib.cons.pgscripts exitCode:&exitcode prompt:""
)

fn renderFinalZdepth = (
	passname = "PG.VrayZdepthCalc"
	
	re = maxOps.GetCurRenderElementMgr()
	re.RemoveAllRenderElements() 
	re.addRenderElement (VRayZdepth elementname:passname \
		zdepth_min:(PGLib.vrayDepthMin()) \
		zdepth_max:(PGLib.vrayDepthMax()) \
		filterOn:false)
-- 	
-- 	  .enabled : boolean
--   .filterOn : boolean
--   .atmosphereOn : boolean
--   .shadowOn : boolean
--   .elementName : string
--   .bitmap : bitmap
--   .vrayVFB : boolean
--   .deep_output : boolean
--   .zdepth_use_camera_clip_boudaries : boolean
--   .zdepth_min : worldUnits
--   .zdepth_max : worldUni
--   .clamp_zdepth : boolean
--   .invert_zdepth : boolean

	max quick render
	vfbControl #setchannel 2
)

fn vrayZdepthCalculator cam = (
	-- save current render settings
	-- setup for fast sampler info pass render
	renderSamplerPass()
	calculateWithPyMs()
	renderFinalZdepth()
	-- go back to previous render setup
	-- cleanup

)

clearlistener()
filein "PG.Lib.ms"
vrayZdepthCalculator $
