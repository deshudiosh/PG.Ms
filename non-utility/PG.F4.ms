fn fix = (
	--disable show selected edges
	actionMan.executeAction 0 "59230"
			
	--recover original F4 functionality
	se = viewport.GetShowEdgeFaces()
	if se == True then viewport.SetShowEdgeFaces False
	else viewport.SetShowEdgeFaces True
)

fix()