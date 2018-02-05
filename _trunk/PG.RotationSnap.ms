fn round_to val step = (
	print ("round_to " + val as string + " " + step as string)
	modulo = mod val step
	is_closer_to_floor = modulo < step/2.0
	if is_closer_to_floor then val - modulo else (val + (step - modulo))
)

-- round_to TESTS
-- clearlistener()
-- round_to .89 .011

for obj in selection do (
	rot = obj.rotation.controller[3].controller.value
	obj.rotation.controller[3].controller.value = round_to rot 15
)