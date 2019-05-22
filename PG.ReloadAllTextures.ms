fn GetBitmapTextures theObjects =
(
	texMaps = #()
	for obj in theObjects do
	(
		join texMaps (getClassInstances bitmapTexture target:obj asTrackViewPick:off)
	)
	makeUniqueArray texMaps
)
texMaps = (GetBitmapTextures geometry)
for texMap in texMaps do (
	texMap.reload()
)