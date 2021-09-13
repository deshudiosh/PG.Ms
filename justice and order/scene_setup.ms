(
	persistent global barSceneSetup
	(
	 	barSceneSetup = "IDisplayGamma.colorCorrectionMode = #gamma \n \
		IDisplayGamma.gamma = 2.2 \n \
		IDisplayGamma.affectColorPickers = On \n \
		IDisplayGamma.affectMEdit = On \n \
		\n \
		if findstring ((renderers.current) as string) \"V_Ray\" == 1 do ( \n \
			vr = renderers.current \n \
			vr.colorMapping_type = 0 \n \
			vr.colorMapping_darkMult = 1.0	\n \
			vr.colorMapping_brightMult = 1.0 \n \
			vr.colorMapping_gamma = 2.2 \n \
			vr.colorMapping_affectBackground = true \n \
			vr.colorMapping_clampOutput = false \n \
			vr.colorMapping_clampLevel = 1.0 \n \
			vr.colorMapping_subpixel = false \n \
			vr.colorMapping_adaptationOnly = 2 \n \
			vr.colorMapping_linearWorkflow = false \n \
			vr.current.output_on = true \n \
		) \n \
		"
		
		callbacks.removeScripts id:#barSceneSettings
		callbacks.addScript #nodePostMaterial "try(execute barSceneSetup)catch()" id:#barSceneSettings persistent:True
		
		OK
	)
	OK
)