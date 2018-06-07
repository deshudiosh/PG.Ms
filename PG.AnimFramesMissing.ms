try (destroyDialog PGFramesMissing) catch()

rollout PGFramesMissing "PG Frames Missing" width:200 (
	fn getWildcardedSavepath = (
		--VRAY separate render channels
		filepath = renderers.current.output_splitfilename
		dir = getFilenamePath filepath
		namebase = getFilenameFile filepath
		ext = getFilenameType filepath
		if renderers.current.output_separatefolders then
			wildcarded = dir + "RGB_color\*" + namebase + "*" + ext
		else wildcarded = dir + "*" + namebase + "*" + ext
		wildcarded
	)
	
	fn extractFrameNum f = (
		f = getFilenameFile f
		f = filterString f "_."
		framenum = f[f.count] as integer
	)
	
	fn extractDoneFrames p = (
		framenums = for f in (getfiles p) collect (extractFrameNum f)
		(sort framenums)
	)
		
	spinner frame_start type:#integer across:2 fieldwidth:70
	spinner frame_end type:#integer fieldwidth:70
	
	on PGFramesMissing open do (
-- 		p = getWildcardedSavepath()
-- 		doneFrames = extractDoneFrames p
		
		--http://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_51429B01_2FC6_4746_9E88_5EB5D93056CC_htm
	)
)

createDialog PGFramesMissing