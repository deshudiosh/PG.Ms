-- fn scalePointAboutAnchor scaledPoint anchorPoint scaleValue = (
-- 	local p1 = point()
-- 	local p2 = point()
-- 	p1.pos = anchorPoint
-- 	p2.pos = scaledPoint
-- 	p2.parent = p1
-- 	in coordsys local scale p1 [scaleValue, scaleValue, scaleValue]
-- 	local scaledPoint = p2.pos
-- 	delete p1
-- 	delete p2
-- 	
-- 	scaledPoint
-- )

fn scalePointAboutAnchor scaledPoint anchorPoint scaleValue = (
	((scaledPoint - anchorPoint) * scaleValue) + anchorPoint
)

scalePointAboutAnchor [-5, 0, 0] [1, -1, -1] 0.551915024494