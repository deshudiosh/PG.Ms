plugin simpleMod DSHProject
name:"DSH Project"
classID:#(0x6607af59, 0x55548f47)
version:1
(
  parameters main rollout:params
  (
    --amount type:#integer ui:amtSpin default:20
	objMatrix type:#matrix3 
  )
  rollout params "Parameters"
  (
    --spinner amtSpin "Amount: " type:#integer range:[0,1000,20]
	button updatebtn "Update"
	on updateBtn pressed do (
		objMatrix = $.transform
		print  (intersectray $plane005 (ray $.pos [0,0,-1])).pos
	)
  )
  on map i p do
  (	 
	  
	pos = (intersectray $plane005 (ray p [0,0,-1])).pos
	pos *= inverse objMatrix
	
	
    pos

  )
)

clearlistener()