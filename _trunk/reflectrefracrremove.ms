maps = getClassInstances Reflect_Refract asTrackViewPick:on
for map in maps do
	for ref = 1 to refs.getNumRefs map.client where refs.getReference map.client ref == map.anim do
	(
		refs.replaceReference map.client ref undefined
		notifyDependents map.client
	)