--vr = renderers.current
--show vr

--renderers.current = RendererClass.classes[2]()

fn checkIfVrayAvailable = (
	rc = RendererClass.classes
	
	for i = 1 to rc.count do (
		if (findString (rc[i] as String) "V_Ray_Adv" != undefined) do (
			print "vray available"
			renderers.current = rc[i]()
		)
	)
)

checkIfVrayAvailable()




rdr = render camera:$VRayPhysicalCamera001 \
vfb:false \
system_vrayLog_show:false \
system_region_x:10 \
system_region_lockSize:true \
gi_on:false \
output_force32bit_3dsmax_vfb:true \
output_on: false \
channels:#(#zdepth) \
progressbar:true \

--display rdr
getChannel rdr [256,256] #zDepth
display (getChannelAsMask rdr #zDepth)