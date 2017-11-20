fn getVrayZdepth = (
	
vr=renderers.current
	
-- SAVE PRESET HERE


-- SET SETTINGS
res = 2000
renderwidth = res
renderheight = res
	
vr.output_width = renderwidth
vr.output_height = renderheight
vr.output_on = true

--vfbControl()

-- RENDER ELEMENT CONSTS	
vraysamplername = "DSH.Distances"
re = maxOps.GetCurRenderElementMgr()

--REMOVE OLD RENDER ELEMENT IF IT THERE
for i = 1 to re.NumRenderElements() do (
	element = re.GetRenderElement (i-1)
	if element.elementName == vraysamplername do re.RemoveRenderElement element
)

-- ADD VRAYSAMPLER ELEMENT
-- type:0 - Point
-- coord_system:2 - Camera
re.addRenderElement (VRaySamplerInfo elementname:vraysamplername type:0 coord_system:2 filterOn:false)

--bm = bitmap vr.output_width vr.output_height
--render camera:$Camera001 vfb:false progressbar:true to:bm

max quick render

vraysamplerbitmap

for i = 1 to vrayVFBGetNumChannels() do (
	if (vrayVFBGetChannelName i) == vraysamplername do (
		vraysamplerbitmap = vrayVFBGetChannelBitmap i
	)
)
	
distances = #()
	
progressstart "Calculating distances..."
	
for y = 0 to vr.output_height-1 do (
	progressupdate (100.0 * y / vr.output_height)
	
	for x = 0 to vr.output_width-1 do (
		val = (getPixels vraysamplerbitmap [y, x] 1 linear:true)[1]
		
		valz = val.blue *-1.0 / 256.0
		--print ("x: " + x as string + " y: " + y as string + " valz: " + valz as string)
		
		if valz > 0.0 do append distances valz
	)
)

progressend()

sort distances
$Camera001.nearrange = distances[1]
$Camera001.farrange = distances[distances.count]


-- RENDER DISPLACEMENT
-- zname = "DSH.Displacement"
-- for i = 1 to re.NumRenderElements() do (
-- 	element = re.GetRenderElement (i-1)
-- 	if element.elementName == zname do re.RemoveRenderElement element
-- )
-- re.addRenderElement (VRayZdepth elementname:zname zdepth_min:distances[1] zdepth_max:distances[distances.count] clamp_zdepth:false filterOn:false)

-- LOAD PRESET HERE

)


clearlistener()
getVrayZdepth()

