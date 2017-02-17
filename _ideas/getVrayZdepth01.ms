fn getVrayZdepth = (
-- clearlistener()
-- rbmp = render camera:$Camera003 outputsize:[128, 128] channels:#(#zdepth) vfb:off progressbar:true
-- for i = 1 to vrayVFBGetNumChannels() do (
-- 	display (vrayVFBGetChannelBitmap i)
-- )

-- STORE VRAY VALUES
vr=renderers.current
-- print "----"
-- show vr
-- print "----"
savedValues = #()

-- SET SETTINGS
vr.output_width = 512
vr.output_height = 512
vr.output_on = true

--vfbControl()

zname = "Z_Depth_Calculated"
	
re = maxOps.GetCurRenderElementMgr()

--remove old zdepth pass if its there
for i = 1 to re.NumRenderElements() do (
	element = re.GetRenderElement (i-1)
	if element.elementName == zname do re.RemoveRenderElement element
)



zdepthbitmap = bitmap vr.output_width vr.output_height
--add zdepth render element with proper zmin and zmax
re.addRenderElement (VRayZDepth elementname:zname filterOn:false zdepth_min:0 zdepth_max:100 clamp_zdepth:false)



bm = bitmap vr.output_width vr.output_height
render camera:$Camera001 vfb:false progressbar:true to:bm


-- vfbControl #getchannelnames

for i = 1 to vrayVFBGetNumChannels() do (
	print (vrayVFBGetChannelType i)
	--if (vrayVFBGetChannelName i) == zname do (
		--display (vrayVFBGetChannelBitmap i)
	--)
)



)


clearlistener()
getVrayZdepth()

