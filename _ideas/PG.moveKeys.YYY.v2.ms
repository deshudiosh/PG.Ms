fn ruszKlucze k1idx k2idx moveBy = (
	for obj in selection do (
		
		local key1 = obj.pos.controller.y_position.keys[k1idx]
		local key2 = obj.pos.controller.y_position.keys[k2idx]
		
		-- ADD CHECK FOR NON-EXISTENT KEYS
		if ( key1 != undefined and key2 != undefined) do (
			
			local timeOfKey1 = key1.time
			local timeOfKey2 = key2.time
			local timeToMoveTo = timeOfKey2 + moveBy
			
			-- zeby nie zjebalo indexow, to nie moze 1 klucza ruszyc za 2 itd
			local dobreWartosci = false;
			
			if (timeOfKey1 < timeOfKey2 and timeToMoveTo < timeOfKey2) do ( dobreWartosci = true)
			if (timeOfKey1 > timeOfKey2 and timeToMoveTo > timeOfKey2) do ( dobreWartosci = true)
			
			if dobreWartosci then ( 
				obj.pos.controller.y_position.keys[k1idx].time = timeToMoveTo
			)
		)
	)
)

rollout dial "Move Keys Relatively" width:320
(
	
	spinner key1idx "klucz ktory ma sie ustawic" range:[1,99999,1] type:#integer
	spinner key2idx "... wzgledem klucza" range:[1,99999,2] type:#integer
	spinner moveBy "... o ile klatek?" range:[-99999,99999,-25] type:#integer
		
	button apply "apply"
	on apply pressed do ( ruszKlucze key1idx.value key2idx.value moveBy.value)
)

createDialog dial





