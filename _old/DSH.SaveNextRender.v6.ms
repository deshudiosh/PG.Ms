--TODO:
--nazwa ze spacja na koncu sie jebie np: "afryka 01.jpg"
--obrazek CI
-- jpegio.setQuality() + UI
-- Set path to maxfilepath



fn saveImage filepath = (
	local theBitmap
	local engine = renderers.current
	
	
	--IF CORONA
	if (substring (engine as string) 1 6) == "Corona" then (
		theBitmap= CoronaRenderer.CoronaFp.getVfbContent 0 true false
	)
	--IF SCANLINE OR VRAY
	else (
		theBitmap= getLastRenderedImage()
	)
	
	--local theBitmap = vrayVFBGetChannelBitmap 1
	theBitmap.filename = filepath
	save theBitmap
)

fn slashCheck p = (
	if (substring p p.count 1) != "\\" do p += "\\"
	p
)

rollout dial "Render Saver" width:300
(
	local separator = bitmap 270 1 color:[128,128,128], space = 10
	local pathColor = color 255 255 255
	
	local choosenPath
	local lastFilename
	local nextNumber = 1
	
	--label theLabel1 ""	
	
	group "Path to save renders: " (
		button btnChoosePath "Choose Path [...]" width:125 align:#left across:2
		button btnPastePath "Paste Path from Clipboard" align:#right
		hyperlink hyperPath "C:/" address:"C:/" align:#left color:pathColor visitedColor:pathColor hoverColor:pathColor	
	)
	
	group "Last File: " (
		dropdownlist fileList across:3 width:188
		button btnRefreshList "R" offset:[65, 0]
		button btnOverride "Override" align:#right
	)
	
	group "Next File: " (
		edittext etNextFile across:3 width:186 height:20 
		button btnNextFileRefresh "R" offset:[65, 0]
		button btnSaveNext "Save" align:#right width:58
	)
	
	imgTag s1 bitmap:separator align:#center offset:[0, space]

	label theLabel3 "by Pawel Grzelak" offset:[-10, space] across:2
	hyperlink www "WWW.PAWELGRZELAK.COM" align:#center address:"http://pawelgrzelak.com" \
		color:(color 128 128 255) visitedColor:(color 128 128 255) hoverColor:(color 128 128 255) \
		offset:[-20, space]
	label theLabel4 ""
	
	
	function EBdecodeIMG eb_1 = (local eb_1 = stringstream eb_1 ; local eb_3 = (readChars eb_1 4) as integer ; local eb_4 = (readChars eb_1 4) as integer ; local eb_5 = bitmap eb_3 eb_4 color:white ; local eb_6 = 0 ; local eb_7 = undefined ; for eb_10 = 0 to eb_4-1 do (eb_2 = #() ; for eb_11 = 0 to eb_3-1 do (if eb_6 == 0 do (eb_8 = readchar eb_1 ; if eb_8 != "&" then (eb_12=(bit.hexasint(eb_8+(readchar eb_1))) as integer ; eb_13=(bit.hexasint(readchars eb_1 2)) as integer ; eb_14=(bit.hexasint(readchars eb_1 2)) as integer ; eb_15=(bit.hexasint(readchars eb_1 2)) as integer ; eb_7 = color eb_12 eb_13 eb_14 eb_15) else (eb_9 = "" ; eb_6 = 0 ; while eb_6 == 0 do (eb_8 = readchar eb_1 ; if eb_8 != "&" then (eb_9 = eb_9 + eb_8) else (eb_6 = (eb_9 as integer))))) ; if eb_6 > 0 do (eb_6 -= 1) ; append eb_2 (eb_7 as color)) ; setpixels eb_5 [0,eb_10] eb_2) ; eb_5)
	local logo = EBdecodeIMG ("  36  36007045ff&1&007046ff007146ff&1&007247ff&2&007146ff007247ff&1&007348ff&1&007448ff&1&007549ff00764aff&1&00774aff00784bff00794aff&1&007a4bff00794bff007a4bff&1&007c4aff007d4bff007f4cff&2&007f4dff00814bff00824cff008149ff00824aff007045ff&1&007146ff007247ff&6&007348ff&2&007549ff&2&007649ff007749ff00784aff00794aff&1&007a4bff&1&007b4cff007d4bff&1&007d49ff007f4aff&1&007f4bff007f4dff007f4cff008249ff00834aff&1&00844bff007246ff007247ff&2&007348ff&2&007346ff007348ff&2&007549ff&1&007649ff&1&01774aff007848ff&1&007a49ff&1&007b4aff&2&017c4bff017e4aff007f4aff&1&007f4bff008149ff00814bff&2&00844bff00854cff00864bff00874cff007246ff007247ff&1&007348ff&2&007447ff&"+ \ 
	"1&007449ff007549ff&1&007649ff007749ff00784aff&1&00794bff007b48ff&1&017c49ff007d49ff007d4bff&1&017e4cff&1&007f4bff&1&008149ff00824aff&1&00844bff00834dff&1&00854cff00874cff&1&01894eff007247ff&2&007348ff007448ff007549ff007548ff&2&007649ff00784aff&1&007949ff007a49ff007b4aff&1&007d47ff&1&017e4aff007f4aff&1&007f4bff&2&00824cff&1&01834bff00844bff00854cff&1&00864dff&2&00884dff&1&008a4eff007348ff&1&007448ff&1&007549ff007649ff007749ff00784aff&1&007848ff007a49ff007b4aff007c48ff&1&007d49ff007e49ff007f48ff&1&007f49ff008149ff&1&008249ff&2&00854cff&1&01864cff&1&03874dff01884dff&1&03894eff01884dff01894eff008a4cff008b4dff007549ff&1&00764aff&1&00774aff00784aff"+ \ 
	"00794bff&1&007a49ff007b4aff&1&007d49ff&1&007f48ff&1&008149ff&2&00824aff008349ff00844aff008549ff&1&01864aff03874bff&1&03894aff058a4bff038a4bff&2&058b4eff038a4bff038c4cff008c4bff008e4aff00764aff&1&01774bff03784cff00784bff00784aff00794bff007949ff017c4bff017c49ff007d49ff017e4aff007f48ff&1&008148ff008249ff00824aff00834aff00844bff00864bff00874aff01884bff03894aff&1&038948ff058a49ff068b4aff&1&058c4aff&1&068d4bff&2&068f4bff038e4aff03904bff00784bff&3&007a4bff007b49ff007c4aff007d49ff007f4eff007d49ff017f47ff01814aff007f4dff007f4cff00834dff03834aff03824bff00844bff00864dff00874cff00884dff008b4dff018a4cff068b4cff078b49ff078c4aff078e4bff068d4aff098f4aff0c8f4bff078e49ff07904aff078f4cff07914dff07924eff06944cff00794cff&2&007a4dff007b4cff"+ \ 
	"007d4bff017e4cff007f4aff008147ff01814aff008149ff008248ff008347ff008448ff008649ff008448ff008645ff008846ff008745ff038a48ff068b49ff038b48ff038d47ff038f48ff058e4aff038f4bff03914cff05904cff0a914fff0b9250ff0a914fff099151ff0b914cff0b924dff0a934bff07944bff00784bff00794cff007a4dff007b4cff007c4dff007f4cff007f4bff&1&008147ff01814cff00834eff00854bff05854aff058747ff018a4aff03874dff068947ff078b47ff068c47ff038b46ff068c45ff0c8e46ff&1&0a9145ff0e9048ff0e9249ff0c9249ff0b9148ff0c9249ff0d934aff0c944aff0d974cff0d954bff&1&0c964bff&1&00794cff007b4dff007c4eff007c4dff007e4eff007f4cff00814bff00824cff018448ff038149ff00864bff00884aff068445ff058643ff038b48ff078a48ff018d49ff068d4aff038947ff07914bff0c944cff098f46ff0f9348ff0d9448ff0f9449ff0e9548ff&1&0e9546ff119647ff119645ff119643ff0f9542ff0e9749ff0f984aff"+ \ 
	"0f974bff&1&007b4dff007c4eff007e4fff007f4fff007f4dff&1&00824cff00834aff00834eff01834dff00864bff00894bff07894dff078a4eff038c4aff068b49ff018e47ff078e49ff0f8f4cff0f8e49ff0d9148ff0f9449ff119448ff149447ff159246ff179448ff1a974bff19984bff17974aff15984aff16994bff169949ff119a4aff&1&119a4cff&1&007d4eff007e4fff007f4fff&1&007f4dff00824cff00834aff00844bff00854dff01894eff018849ff008745ff038b4bff058d4dff058c49ff098f48ff0e9048ff0b9246ff0b9347ff0c9346ff0e9747ff0f9a47ff149845ff1f9646ff199b43ff&1&199944ff199a47ff189c49ff1a9e4bff1a9d4dff1a9b4bff179c49ff&1&149c4aff&1&007e4fff007f4fff&2&00824eff00824cff00844bff00864dff038846ff00833eff007d39ff017d3aff00873dff00893dff058339ff038338ff068239ff079747ff009642ff018d3aff038835ff038f38ff119c43ff189841ff069335ff069134ff0a9135ff0f953aff"+ \ 
	"169b3fff1d9f47ff21a049ff1f9c46ff1f9f4aff1d9f49ff1b9f4bff199f4aff007f50ff&1&008150ff008250ff00834fff00854eff00864dff03894eff00773fff07844eff2c9a6bff37a371ff17995bff119251ff2c9c62ff3bae75ff2fa25dff00883bff0f974aff37a25cff51ad6aff3dac5fff0f8f3aff159a41ff46a563ff4fae6aff53b46dff49b164ff33a452ff249c43ff249f44ff26a146ff24a048ff22a148ff1fa049ff1fa14bff008151ff&1&007f4fff008351ff00844fff008850ff05874bff007a3cff399b6cfff1f5f4fff7fffdfffcfbffff7ec29bff7ec79afffbfaffffd2dfd5ffe0efe8ff82c69fff61bd8afffafbffffdae0dcffe0eee1ffaadcb9ff5ab278fffcfbffffdbebdeffd3eae2ffe6ede6ff5cba70ff11942aff2ba244ff26a54aff28a348ff26a347ff24a447ff24a348ff007f4fff018252ff008150ff038654ff008651ff00864fff018247ff0d874afffbffffffb7ddceff2b9952ff259a66ff13873effb9decdfff4f9f3ff61ab6cffb2ddc2ffc7e7cfff7ec396fff7fdf9ff67b87dff"+ \ 
	"98d1a8ffe6f5eeff77c382fffefafbff92cd9fff78c68cff79c088ff2ea94eff29a13fff2ca546ff32a445ff2ea748ff2da649ff2aa648ff29a648ff008352ff008151ff018251ff008351ff018752ff038751ff007b41ff29a366fffafff9ff1a9664ff005a01ff06741eff006f0fffa7dcc2fff7f9f6ffa9d6b9ffdeebe4ff72c494ff5cb77afff8f9fdffd3ead8fff5fdf2ffa7d3afff47ad63fff9feffffc9e7cdffc3e0c1ffa3deb0ff1e9d42ff2fa63fff30aa45ff2fa63fff31a746ff2fa746ff2ea645ff2da647ff007f50ff008351ff008452ff038954ff008651ff01874eff008347ff068447ffe0f2e6fff0f2e7ff6fb488ff60b188ff319b5bffbae1c6fffcfff6ff57a569ffbddec9ffe8f2e9ff9cd4b1fff7fff4ff078e1fff6ebf7cfffffbffff92cd9dfffffdf9ff92c99fff6ac083ff81c989ff4aad53ff30a03aff33a746ff38ac4bff36aa47ff34a845ff32a847ff31a947ff008252ff008452ff018752ff008651ff00864eff008b50ff068e50ff007f41ff139358ffc5e3d9fff8fbfffff7fbfcff82cbaeff70b78bff"+ \ 
	"e5efe6ffebf5f7ffe1f1e6ff5cba7eff6dc289ffd6ece0ff008b1dff49aa5dffddede0ff78c57fffdceee2ffeef0efffeff3f6ffe7f8e8ff6abd75ff1fa031ff36ae3fff3aa942ff3aad48ff38ac49ff37ab48ff35ac48ff008151ff008351ff068b56ff00844cff008a52ff008b50ff00894cff059250ff008242ff007f36ff09924aff138d54ff0a914eff0b9849ff16984eff1b9a4bff199847ff009331ff259a42ff269e45ff2aa23eff2da247ff2fa342ff33a63fff37a743ff3caa47ff3fad4cff44ac4bff41aa45ff41aa43ff41ac44ff3dae46ff3dad47ff3aad46ff38ac47ff&1&008252ff018654ff018853ff008850ff&1&008b50ff039053ff008d4bff03904bff008b48ff008e43ff009045ff01964aff0a9446ff079338ff0e943fff0f973bff1fa145ff1c9f3fff159c36ff2ba749ff2ca53eff28a33bff2ea63aff2ea52fff2ca637ff30a53dff30a53cff3cac3fff43af42ff45b245ff44ad44ff3faf46ff3eaf45ff3dae46ff3aad45ff008554ff018654ff008651ff038a52ff008850ff038a50ff038b50ff"+ \ 
	"038e50ff03904cff03934eff03934dff0a9749ff0a9748ff14974bff179b48ff159e46ff1e9d4cff1fa33dff26a04dff2da544ff28a549ff32a645ff34a93fff39a748ff37aa45ff39ab4bff3ba946ff3ead44ff42ae41ff3fb243ff3eaf43ff4aae4bff44b146ff43b045ff3faf46ff3eaf45ff018752ff008752ff008951ff008a52ff008b52ff008c51ff038d4fff038f4cff059250ff07924eff07944bff0c964bff0f974bff14994aff179b48ff1c9d4aff1fa043ff21a144ff26a347ff2aa346ff2fa547ff32a645ff33a742ff37aa42ff3ba946ff3cab44ff3cab42ff3fad42ff42af44ff44af45ff46b044ff49b347ff48b447ff47b346ff45b144ff44b043ff008752ff&1&008951ff008b52ff&1&018d52ff038f50ff05904dff07924fff07934fff0b944cff0e964aff12994cff159a4bff1a9b49ff1d9f49ff21a144ff23a346ff28a348ff2ba447ff2fa545ff34a845ff36a944ff37aa43ff3ba946ff3dac45ff3ead44ff41ae43ff43b045ff46b147ff48b246ff4ab446ff49b347ff&1&48b246ff&"+ \ 
	"1&008752ff008953ff008a51ff008b52ff008b50ff018e51ff039051ff06934fff079350ff09954eff0c964bff0f984cff139a4bff189b4bff1c9d4aff1f9f48ff22a146ff27a448ff2aa648ff2da544ff30a645ff36aa45ff37aa45ff38ab44ff3cab45ff3fae47ff3faf43ff41ae43ff43b045ff46b245ff48b246ff49b345ff&2&4ab446ff&1&008953ff&1&008b52ff008b50ff008d51ff038f52ff059250ff079350ff0c9551ff0d964eff0f974bff12994cff179c4dff1b9c4aff1e9e49ff1fa049ff26a348ff29a449ff2ca546ff2ea644ff34a843ff38ab46ff&1&3bab47ff3cab45ff3ead44ff3faf43ff42af44ff45b046ff47b346ff49b345ff4cb445ff4db447ff&3&008953ff008b52ff008c51ff&1&018d52ff039053ff079251ff07934fff0d944fff0e964cff11984bff159a4bff199d4aff1c9d4aff1f9f48ff23a247ff28a348ff29a547ff2da544ff31a844ff36ab43ff38ab44ff3aaa44ff3cac46ff3ead46ff3fae45ff42af44ff44b144ff47b346ff49b347ff4cb346ff4eb645ff"+ \ 
	"4fb547ff&1&4eb446ff&1&008a54ff018b53ff018d52ff038f52ff039053ff069052ff0a9250ff0b944eff0d954dff0f974bff12994aff169b4aff1c9d4bff1f9f4aff22a148ff27a449ff2ca548ff2ca546ff2ea644ff35a944ff38ab44ff3aaa44ff3bab45ff3ead47ff41ae45ff42af44ff43b045ff46b245ff48b246ff4ab146ff4cb244ff4fb545ff4fb547ff&3&008a52ff018c51ff038d51ff058f53ff069052ff0a9252ff0b9450ff0d944fff0f954cff11984cff159a4bff199d4aff1d9e4bff21a049ff25a247ff28a549ff2ca546ff2fa746ff31a746ff35a944ff39ac45ff3bac44ff3ead46ff3fae47ff41ae45ff42af44ff44b043ff46b245ff49b347ff4cb346ff4eb446ff52b644ff52b646ff&3&038b53ff038d52ff038e52ff058f53ff079153ff0b9353ff0d9451ff0e964eff11974eff139a4dff179c4bff1a9e4bff1ea04aff21a049ff25a247ff29a547ff2ca544ff30a847ff32a847ff36aa45ff39ac45ff3cad45ff3fae47ff3fae45ff42af44ff45b046ff46b245ff47b145ff4bb247ff"+ \ 
	"4eb447ff51b447ff52b644ff53b747ff52b646ff&2&038d52ff068d52ff078e51ff0a9051ff0b9152ff0c9551ff0e9550ff0e964cff14984cff169b4cff189c49ff1c9d4aff219f4bff24a048ff28a446ff29a545ff2ea444ff31a746ff34ab45ff37ac44ff39ac44ff3ead44ff41ae43ff43af42ff45b142ff47b346ff48b246ff4bb245ff4db345ff4eb444ff52b644ff54b844ff53b743ff54b645ff&2&038d52ff078e53ff098f52ff0b9152ff0d9452ff0e9552ff0f964fff11974eff15994dff189b4dff1b9c4aff1f9f4aff22a14aff26a348ff29a547ff2da647ff30a646ff33aa46ff37ab46ff39ac45ff3cad45ff3fae45ff42af44ff43b043ff47b346ff49b347ff4cb346ff&1&4eb446ff51b545ff52b644ff54b844ff55b844ff&1&55b746ff&1&038d52ff078e53ff0a9051ff0d9251ff0e9351ff0f9550ff13974eff14984cff179a4eff199c4cff1c9d4aff1f9f48ff25a247ff28a348ff2ca548ff2ea645ff31a746ff35a946ff38ab44ff3cad45ff3ead46ff41ad47ff42af46ff42af44ff"+ \ 
	"47b145ff48b246ff4bb245ff4db345ff51b545ff52b644ff54b645ff55b746ff56b945ff&1&56b847ff57b847ff038e53ff078f54ff0b9152ff0e9352ff0f9452ff0f964fff13974cff16994dff1b9b50ff1d9e4eff1e9e49ff22a146ff27a448ff2ba447ff2ea547ff2fa746ff32a945ff36aa45ff39ac45ff3dac45ff3fac46ff43ad48ff43b047ff43b045ff48b148ff4cb348ff4db546ff4eb444ff52b644ff53b544ff54b645ff56b847ff57ba46ff56b945ff57b845ff58b948ff")
	imgTag logoImgTag bitmap:logo border:0
	on logoImgTag click do print "ciapa"
	on logoImgTag mouseover do ( (dotnetclass "System.Windows.Forms.Cursor").current = (dotNetClass "System.Windows.Forms.Cursors").hand )
	
	
		
	fn setInitialFolder = (
		local pathToOpen
		if maxfilepath != undefined do pathToOpen = maxfilepath
		if pathToOpen == undefined do pathToOpen = GetDir #Scene
		choosenPath = pathToOpen
	)
	
	fn refreshPath = (
		hyperPath.text = choosenPath
		hyperPath.address = choosenPath
	)
	
	
	
	fn refreshNextFilename = (
		if lastFilename != undefined then (
			local filename = getFilenameFile lastFilename
			local fileext = getFilenameType lastFilename
			
			--COUNT NUMBERS FROM BACK TO BEGINING
			local numberLength = 0
			for i = fileName.count to 1 by -1 do if fileName[i] as number != undefined then numberLength += 1 else exit

			local nameBase
			local curNum 

			if numberLength > 0 then (
				nameBase = substring filename 1 (filename.count - numberLength)
				curNum = ( substring filename (nameBase.count + 1) numberLength ) as number
			)else(
				nameBase = filename
				numberLength = 3 
				curNum = 0
			)

			local nextNum = (curNum + 1) as string
			while nextNum.count < numberLength do nextNum = "0" + nextNum
			
			etNextFile.text = nameBase + nextNum + fileext
		)
		else (
			etNextFile.text = (getFilenameFile maxfilename) + ".jpg"
		)
	)
	
	fn refreshFileList = (
		files = getFiles (choosenPath + "*.jpg")
		join files (getFiles (choosenPath + "*.png"))
		
		fileNames = #()
		for file in files do (append fileNames (filenameFromPath file))
		
		sort fileNames
			
		--INVERT
		fileNames = for i = fileNames.count to 1 by -1 collect fileNames[i]
			
		fileList.items = fileNames
		
		lastFilename = filelist.selected
		
		refreshNextFilename()
	)
	
	fn overrideLast = (
		filePath = choosenPath + "\\" + lastFilename
		
		if doesFileExist filePath do (
			msg = "Override " + (filenamefrompath filepath) + "?"
			if queryBox msg title:"Override" == true do saveImage filePath
		)
	)
	
	fn pastePath = (
		clipboard = getclipboardText()
		if isDirectoryWriteable clipboard do 
			choosenPath = slashCheck clipboard
		
		refreshPath()
		refreshFileList()
		refreshNextFilename()
	)
	
	on dial open do (
		setInitialFolder()
		refreshPath()
		refreshFileList()
	)
	
	on btnChoosePath pressed do (
		--TRY ALREADY CHOOSEN PATH
		local pathToOpen = choosenPath
		
		--TRY CURENT MAX FILE PATH (may be saved since opening the script)
		if pathToOpen == undefined do (if maxfilepath != undefined do pathToOpen = maxfilepath)
		--if newPath == undefined and maxfilepath != undefined do newPath = getSavePath caption:"2" initialDir:maxfilepath
		
		--IF STILL UNDEFINED USE DEFAULT LOCATION
		if pathToOpen == undefined do pathToOpen = GetDir #Scene
		
		local newPath = getSavePath initialDir:pathToOpen
		
		if newPath != undefined do choosenPath = slashCheck newPath
		
		refreshPath()
		refreshFileList()
		refreshNextFilename()
	)
	
	on btnPastePath pressed do (pastePath())
	
	on fileList selected idx do (
		lastFilename = fileList.selected
		refreshNextFilename()
	)
	on btnRefreshList pressed do (refreshFileList())
	on btnOverride pressed do (overrideLast())
		
	on btnNextFileRefresh pressed do (refreshNextFilename())
	on btnSaveNext pressed do (
		saveImage (choosenPath+etNextFile.text)
		refreshFileList()
	)
)

clearlistener()
createDialog dial