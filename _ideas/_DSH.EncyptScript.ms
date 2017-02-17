fn chooseFile = (
	f = getOpenFileName types:"Maxscript(*.ms)|*.ms"
	if f != undefined do encryptScript f
)
chooseFile()
