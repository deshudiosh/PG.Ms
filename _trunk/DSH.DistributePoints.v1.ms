rollout dial "distribute"
(	
	struct objdist (movable, pusher, dist)

	fn sortObjDists a b = (
		d = a.dist - b.dist
		case of (
			(d < 0.): -1
			(d > 0.): 1
			default: 0
		)
	)

	fn step movable stable stepdist previousMovable = (
		-- find distances between objects
		local distances = #()
		
		local pushers = stable as array + movable as array
		
		for m in movable do (
			if m != previousMovable do (			
				for p in pushers do (
					if m != p do (
-- 						dist = sqrt( (pow(p.pos.x - m.pos.x) 2) + (pow(p.pos.y - m.pos.y) 2) )
 						dist = ( sqrt( (pow(p.pos.x - m.pos.x) 2) + (pow(p.pos.y - m.pos.y) 2) ) ) - p.radius - m.radius
						append distances (objdist movable:m pusher:p dist:dist)
					)
				)
			)
		)
		
		-- sort distances and get nearest one
		qsort distances sortObjDists
		
		m = distances[1].movable
		p = distances[1].pusher
		
		-- find vector
		v = p.pos - m.pos

		-- normalize (set length to 1.00)
		v = normalize v
		
		-- invert direction 
		v *= -1
		
		-- apply stepsize
		v *= stepdist
		
		-- move in oposite dir
		move	m v
		
		m
	)

	edittext txtMovable "movable:" text:"$c*"
	edittext txtStable "stable:" text:"$d*"
	spinner spnStepDist "step size:" range:[0.1, 100, 5]
	spinner iters "iterations:" type:#integer align:#center range:[1, 10000, 100]
	
	button apply "apply"
	on apply pressed do (
		
		local previousMovable
		
		movable = execute txtMovable.text
		stable = execute txtStable.text
		stepdist = spnStepDist.value

		for i = 1 to iters.value while NOT keyboard.escPressed do (
			previousMovable  = step movable stable stepdist previousMovable
			--max views redraw
			--redrawViews()
		)
	)
)

createdialog dial


