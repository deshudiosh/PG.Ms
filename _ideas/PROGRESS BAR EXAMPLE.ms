if superclassof $[1] == shape then (
with undo off (
theObj=$[1]
Nsplines=theObj.numsplines
progressStart "Exploding"
for spl = 1 to Nsplines do 
(
	ns=splineShape ()
	addnewspline ns
	for k = 1 to (numKnots TheObj spl) do(
		
		knotpos = getKnotPoint TheObj spl k
		segtype=getSegmentType TheObj spl k
		knottype= getKnotType TheObj spl k
			
		if knottype == #bezier or knottype== #bezierCorner then 
		(
		addknot ns 1 knottype segtype knotpos (getInVec TheObj spl k) (getOutVec TheObj spl k)
		)
		 else
		(
			 addknot ns 1 knottype segtype knotpos
		 )
		
		
	)
	if (isClosed theobj spl) then close ns 1
	updateshape ns
	progressUpdate (100.0*spl/Nsplines)
)
progressEnd()
)
) else messagebox "Splines Only"