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
	start = timeStamp()
	
	command = "PyMs.exe vray_depth -o1 \"" + PGLib.cons.vray_depth_exr + "\" -o2 \"" + PGLib.cons.vray_depth_results + "\""
	hiddendoscommand command startpath:PGLib.cons.pgscripts exitCode:&exitcode prompt:""
	
	end = timeStamp()
	format "Finding zdepth min/max took % seconds\n" ((end - start) / 1000.0)
)

fn renderFinalZdepth = (
	passname = "PG.VrayZdepthCalc"
	
	re = maxOps.GetCurRenderElementMgr()
	re.RemoveAllRenderElements() 
	zdepthpass = re.addRenderElement (VRayZdepth elementname:passname \
		zdepth_min:(PGLib.vrayDepthMin()) \
		zdepth_max:(PGLib.vrayDepthMax()) \
		deep_output: true \
		clamp_zdepth: false \
		filterOn:false)

	max quick render
	vfbControl #setchannel 2
)

fn setupFastRender = (
	vr = renderers.current
	
	vr.gi_on = false
	vr.imageSampler_type_new = 0
	vr.twoLevel_baseSubdivs = 1
	vr.twoLevel_fineSubdivs = 1
	
	vfbControl #bloom false
	vfbControl #glare false
)

fn vrayZdepthCalculator cam = (
	-- save current render settings
	renderpresets.saveall 0 PGLib.cons.vray_depth_renderpreset
	-- setup for fast sampler info pass render
	setupFastRender()
	renderSamplerPass()
	calculateWithPyMs()
	renderFinalZdepth()
	-- go back to previous render setup
-- 	renderpresets.loadall 0 PGLib.cons.vray_depth_renderpreset
	-- cleanup
)

clearlistener()
filein "PG.Lib.ms"
vrayZdepthCalculator $
