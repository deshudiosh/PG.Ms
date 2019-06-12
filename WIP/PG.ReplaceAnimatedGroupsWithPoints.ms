fn replace_group_with_point grp = (
	pnt = point size:50
	pnt.wirecolor = color 14 255 2
	pnt.transform.track = copy grp.transform.track
	pnt.transform = grp.transform
	pnt.pos.z = 0
)

fn pop_group_from_hierarchy grp = (
	parent = grp.parent
	print parent
	for i = 1 to grp.children.count do (
		child = grp.children[i]
		print child.name
	)
)

fn gogogo = (
	groups = for obj in selection where isGroupHead obj collect obj
	
	--REPLACE
	for grp in groups do replace_group_with_point grp
	--POP GROUP OUT FOM HIERARCHY
	--for grp in groups do pop_group_from_hierarchy grp
)


gogogo()