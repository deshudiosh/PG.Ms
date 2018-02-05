-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * *                                                                                                   * *
-- * *  3D VORONOI CELLS script (for 3ds max 9 and higher)                                               * *
-- * *                                                                                                   * *
-- * *  This script creates a specified number of Voronoi cells from a Bounding Volume and Cell Centers. * *
-- * *  Several options are proposed to define the BV and CCs and can be reused as many times as needed  * *
-- * *  before creating the cells. The objects used are hidden, not deleted.                             * *
-- * *                                                                                                   * *
-- * *  The bounding cage and cell points visible in the viewport are just visual helpers: they are not  * *
-- * *  interactive. Changing them does not update the values in memory.                                 * *
-- * *  To use already created cell points, adjust their positions, reselect them all and click on From  * *
-- * *  Selection to update their new coordinates.                                                       * *
-- * *                                                                                                   * *
-- * *  Cell centers can be defined from a text file, with one set of XYZ coordinates per line of text,  * *
-- * *  separated by whitespaces. Extra characters can be added at the end of each line and are ignored  * *
-- * *  by the code. This can be used to append comments to the coordinates.                             * *
-- * *                                                                                                   * *
-- * *  The volume divided is always in the shape of a box. When Pick Object is used, the created cells  * *
-- * *  will fill its bounding box, NOT the object's actual geometry.                                    * *
-- * *  For that, you can try my Fracture script.                                                        * *
-- * *                                                                                                   * *
-- * *  The method employed being very simple and not optimized whatsoever, large amounts of cells need  * *
-- * *  a very long time to be created because the number of operations performed grows exponentially.   * *
-- * *                                                                                                   * *
-- * *  Feel free to share and modify at will...                                                         * *
-- * *                                                                                                   * *
-- * *  GARP - 2008                                                                                      * *
-- * *                                                                                                   * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *





(	-- start script

global rltVoronoiCells
global rltVorCheckFile
try destroydialog rltVoronoiCells catch()
try destroydialog rltVorCheckFile catch()

local theLines		-- used in both rollouts
local useFile		-- for testing validity
local lineNb		-- of data in text file



-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * *                                                                               * *
-- * *   X   X    X    X  X   X    XXXX    XXX   X      X       XXX   X   X  XXXXX   * *
-- * *   XX XX   X X   X  X X X    X   X  X   X  X      X      X   X  X   X    X     * *
-- * *   X X X  XXXXX  X  X  XX    XXXX   X   X  X      X      X   X  X   X    X     * *
-- * *   X   X  X   X  X  X   X    X  X   X   X  X      X      X   X  X   X    X     * *
-- * *   X   X  X   X  X  X   X    X   X   XXX   XXXXX  XXXXX   XXX    XXX     X     * *
-- * *                                                                               * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

rollout rltVoronoiCells "Voronoi Cells" width:259 height:365
(

	-- Bounding Volume group
	GroupBox BV_box "Bounding Volume" pos:[5,5] width:120 height:123
	fn geometryFilter obj = superClassOf obj == GeometryClass
	pickbutton btnBVfromObj "Pick Object" pos:[15,30] width:100 height:25 filter: geometryFilter tooltip:"uses bounding box of picked object"
	button btnBVfromCC "From Cell Centers" pos:[15,71] width:100 height:25 enabled:false tooltip:"only if cell centers already defined"
	spinner spnBVoffset "Offset:  " pos:[37,101] width:78 height:16 range:[0,10000,0] enabled:false
	GroupBox BV_subbox "" pos:[10,60] width:110 height:63

	-- Cell Centers group
	GroupBox CC_box "Cell Centers" pos:[134,5] width:120 height:180
	button btnCCfromSel "From Selection" pos:[144,30] width:100 height:25 tooltip:"uses positions of selected objects"
	button btnCCfromFile "From Text File" pos:[144,65] width:100 height:25 tooltip:"in the form of: xxx yyy zzz per line"
	button btnCCrnd "Randomize" pos:[144,106] width:100 height:25 enabled:false tooltip:"only if bounding volume already defined"
	spinner spnCCnb "Nb of Cells: " pos:[186,136] width:58 height:16 range:[2,1000,10] type:#integer enabled:false
	spinner spnCCoffset "Offset :  " pos:[169,158] width:75 height:16 range:[0,10000,0] enabled:false
	GroupBox CC_subbox "" pos:[139,95] width:110 height:85

	-- Creation group
	GroupBox Creat_box "Creation" pos:[5,133] width:120 height:52
	button btnCREATE "Create Cells" pos:[15,155] width:100 height:25 enabled:false tooltip:"here you go"

	-- Extras group
	GroupBox Xtra_box "Extras" pos:[5,190] width:249 height:97
	radiobuttons rdoBV "" pos:[15,232] width:95 height:48 labels:#("As Spline Cage", "As Box", "Dont' Keep") default:3 columns:1
	radiobuttons rdoCC "" pos:[160,232] width:72 height:32 labels:#("Uniform", "Multi Color") default:2 columns:1
	colorPicker cpCC "" pos:[220,232] fieldWidth:20 height:15 color:[0,160,240]
	label lblXtraBV "Keep Bounding Volume" pos:[15,212] width:116 height:20
	label lblXtraCC "Cell Color" pos:[160,212] width:48 height:20

	-- Progression group
	GroupBox Prog_box "Progression" pos:[5,292] width:249 height:68
	progressBar pbProgress "" pos:[15,315] width:229 height:15  value:0 color:[0,96,0]
	label lblProStatus "" pos:[15,338] width:229 height:17



	local BVexists = false
	local BVcorners = #()		-- stores min and max coordinates
	local BVcage				-- stores spline cage for visualization
	local MaxDist				-- greatest diagonal length in bounding volume

	local CCexists = false
	local CCcoords = #()		-- stores cell centers coordinates
	local CCpoints = #()		-- stores cell points for visualization



-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- *                                                                                                   *
-- *   XXX     XXX   X   X  XX  X  XXXX   X  XX  X   XXX    X   X   XXX   X      X   X  XX XX  XXXXX   *
-- *   X  X   X   X  X   X  X X X  X   X  X  X X X  X       X   X  X   X  X      X   X  X X X  X       *
-- *   XXXX   X   X  X   X  X  XX  X   X  X  X  XX  X  XX   X   X  X   X  X      X   X  X   X  XXX     *
-- *   X   X  X   X  X   X  X   X  X   X  X  X   X  X   X    X X   X   X  X      X   X  X   X  X       *
-- *   XXXX    XXX    XXX   X   X  XXXX   X  X   X   XXX      X     XXX   XXXXX   XXX   X   X  XXXXX   *
-- *                                                                                                   *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * Function that builds a spline cage from two sets of   *
-- * coordinates. Only for visualization in the viewports. *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	fn DispBV twoCoords =
	(
		-- clears previous bounding cage
		if BVcage != undefined do if not BVcage.isDeleted do delete BVcage

		-- builds new bounding cage
		local BVpts = #()

		for i=1 to 2 do for j=1 to 2 do for k=1 to 2 do
			append BVpts [twoCoords[i][1],twoCoords[j][2],twoCoords[k][3]]

		BVcage = splineShape name:"Voronoi Bounding Cage" pos:((twoCoords[1] + twoCoords[2]) / 2) wireColor:[128,128,255]
		addNewSpline BVcage
		addKnot BVcage 1 #corner #line BVpts[1]
		addKnot BVcage 1 #corner #line BVpts[3]
		addKnot BVcage 1 #corner #line BVpts[7]
		addKnot BVcage 1 #corner #line BVpts[5]
		addKnot BVcage 1 #corner #line BVpts[1]
		addNewSpline BVcage
		addKnot BVcage 2 #corner #line BVpts[2]
		addKnot BVcage 2 #corner #line BVpts[4]
		addKnot BVcage 2 #corner #line BVpts[8]
		addKnot BVcage 2 #corner #line BVpts[6]
		addKnot BVcage 2 #corner #line BVpts[2]
		addNewSpline BVcage
		addKnot BVcage 3 #corner #line BVpts[1]
		addKnot BVcage 3 #corner #line BVpts[2]
		addNewSpline BVcage
		addKnot BVcage 4 #corner #line BVpts[3]
		addKnot BVcage 4 #corner #line BVpts[4]
		addNewSpline BVcage
		addKnot BVcage 5 #corner #line BVpts[7]
		addKnot BVcage 5 #corner #line BVpts[8]
		addNewSpline BVcage
		addKnot BVcage 6 #corner #line BVpts[5]
		addKnot BVcage 6 #corner #line BVpts[6]

		-- various updates
		BVexists = true
		btnCCrnd.enabled = true
		spnCCnb.enabled = true
		spnCCoffset.enabled = true
		MaxDist = distance twoCoords[1] twoCoords[2]
		if CCexists do btnCREATE.enabled = true

	)	-- end fn DispBV

	

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * Uses the world-oriented bounding box of the picked object.  *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	on btnBVfromObj picked obj do
	(
		BVcorners = #(obj.min,obj.max)
		obj.isHidden = true
		cpCC.color = obj.wireColor
		clearSelection()

		DispBV BVcorners

	)	-- end on btnBVfromObj picked



-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * Uses existing cell centers and adds an offset (outward).  *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	on btnBVfromCC pressed do
	(
		-- prevents null bounding volume
		if CCcoords.count == 1 and spnBVoffset.value == 0 then
			messageBox "Bounding Volume is null. Either define more\n  than one cell center or add some offset." beep:false

		else
		(
			local xTemp=#()
			local yTemp=#()
			local zTemp=#()

			for val in CCcoords do
			(
				append xTemp val[1]
				append yTemp val[2]
				append zTemp val[3]

			)	-- end for val in CCcoords

			BVcorners = #([(amin xTemp)-spnBVoffset.value,(amin yTemp)-spnBVoffset.value,(amin zTemp)-spnBVoffset.value]\
						,[(amax xTemp)+spnBVoffset.value,(amax yTemp)+spnBVoffset.value,(amax zTemp)+spnBVoffset.value])

			DispBV BVcorners

		)	-- end else (if CCcoord.count == 1)

	)	-- end on btnBVfromCC pressed



-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- *                                                                                   *
-- *    XXX   XXXXX  X      X         XXX   XXXXX  XX  X  XXXXX  XXXXX  XXXX    XXX    *
-- *   X   X  X      X      X        X   X  X      X X X    X    X      X   X  X       *
-- *   X      XXX    X      X        X      XXX    X  XX    X    XXX    XXXX    XXX    *
-- *   X   X  X      X      X        X   X  X      X   X    X    X      X  X       X   *
-- *    XXX   XXXXX  XXXXX  XXXXX     XXX   XXXXX  X   X    X    XXXXX  X   X  XXXX    *
-- *                                                                                   *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * Function that builds a cloud of points from an array of *
-- * coordinates. Only for visualization in the viewports.   *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	fn DispCC arrCoords =
	(
		-- clears previous cell points
		if CCpoints.count != 0 do for obj in CCpoints do if not obj.isDeleted do delete obj
		CCpoints = #()

		-- builds new cell points
		for i = 1 to arrCoords.count do
			append CCpoints (point name:(uniqueName "Voronoi Cell Point ") pos:arrCoords[i] wireColor:green \
							 centerMarker:true cross:false box:false constantscreensize:true drawOnTop:true)

		-- various updates
		CCexists = true
		btnBVfromCC.enabled = true
		spnBVoffset.enabled = true
		if BVexists do btnCREATE.enabled = true

	)	-- end fn DispCC



-- * * * * * * * * * * * * * * * * * * * * * * * * *
-- * Uses the coordinates of the selected objects. *
-- * * * * * * * * * * * * * * * * * * * * * * * * *

	on btnCCfromSel pressed do
	(
		if selection.count != 0 then
		(
			CCcoords = #()
			for obj in selection do
			(
				append CCcoords obj.pos
				obj.isHidden = true

			)	-- end for obj in selection

			clearSelection()
			DispCC CCcoords

		)	-- end if selection.count != 0

		else messageBox "Selection is empty.\nSelect objects first." beep:false

	)	-- end on btnCCfromSel pressed



--	* * * * * * * * * * * * * * * * * * * * * * * * * * *
--	* Creates cell centers from a text file. Expected   *
--	* data format should be one set of coordinates per  *
--	* line, XYZ values being separated by whitespaces.  *
--	* * * * * * * * * * * * * * * * * * * * * * * * * * *

-- very messy part...

	on btnCCfromFile pressed do
	(
		theName = getOpenFileName types:"Text file (*.txt)|*.txt|All (*.*)|*.*"
		if theName != undefined do
		(
			theFile = openFile theName
			if theFile != undefined do
			(
				theLines = #()
				try (while not eof theFile do append theLines (readLine theFile))
				catch theLines = #()
				close theFile

				-- checks the file for errors and allows corrections if needed
				if theLines.count != 0 then
				(
					useFile = true
					errorInFile = false

					for i = 1 to theLines.count while useFile do
					(
						oneLine = theLines[i] as stringStream
						try for j = 1 to 3 while useFile do ((readToken oneLine) as integer) + 0	-- + 0 triggers an error if undefined
						catch
						(
							useFile = false
							errorInFile = true
							lineNb = i

							createDialog rltVorCheckFile 259 90 pos:(getDialogPos rltVoronoiCells + [0,393]) modal:true

						)	-- end catch

					)	-- end for i = 1 to theLines.count

					if useFile and errorInFile do
					(
						choice = yesNoCancelBox ("Do you want to:\nYES: save corrections to file and proceed?\n" \
												+ "NO: proceed without saving?\nCANCEL: Abort creation?") beep:false
						if choice == #cancel then useFile = false
						else if choice == #yes do
						(
							theName = getSaveFileName fileName:theName types:"Text file (*.txt)|*.txt|All (*.*)|*.*"
							if theName != undefined do
							(
								theFile = createFile theName
								for i = 1 to theLines.count do format "%\n" theLines[i] to:theFile
								close theFile

							)	-- end if theName != undefined

						)	-- end else if choice == #yes

					)	-- end if useFile and errorInFile

					-- fills the array of coordinates for the cell centers
					if useFile do
					(
						CCcoords = #()
						for i = 1 to theLines.count do
						(
							oneLine = theLines[i] as stringStream
							append CCcoords [readValue oneLine,readValue oneLine,readValue oneLine]

						)	-- end for i = 1 to theLines.count

						DispCC CCcoords

					)	-- end if useFile

				)	-- end if theLines.count != 0

				else messageBox "Invalid or empty file." beep:false

			)	-- end if theFile != undefined

		)	-- end if theName != undefined

	)	-- end on btnCCfromFile pressed



--	* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
--	* Creates randomly positionned cell centers inside the  *
--	* defined bounding volume. The offset value reduces it. *
--	* * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	on btnCCrnd pressed do
	(
		-- ensures the offset value leaves some volume for cell centers
		local BVdims = #()
		for i = 1 to 3 do append BVdims (BVcorners[2][i] - BVcorners[1][i])
		if spnCCoffset.value >= (amax BVdims) / 2 then
			messageBox "No volume left for cell centers.\nPlease lower the offset value." beep:false

		else
		(
			CCcoords = #()
			for i = 1 to spnCCnb.value do
			(
				append CCcoords (random (BVcorners[1] + spnCCoffset.value) (BVcorners[2] - spnCCoffset.value))

			)	-- end for i = 1 to spnCCnb.value

			DispCC CCcoords

		)	-- end else (if spnCCoffset.value >= (amax BVdims))

	)	-- end on btnCCrnd pressed



-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- *                                                         *
-- *     XXX   XXXX   XXXXX    X    XXXXX  X   XXX   X   X   *
-- *    X   X  X   X  X       X X     X    X  X   X  X X X   *
-- *    X      XXXX   XXX    XXXXX    X    X  X   X  X  XX   *
-- *    X   X  X  X   X      X   X    X    X  X   X  X   X   *
-- *     XXX   X   X  XXXXX  X   X    X    X   XXX   X   X   *
-- *                                                         *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * For each cell center, an empty mesh is created and a copy of the    *
-- * bounding volume is attached to it. Then a slice modifier is set at  *
-- * the bissecting plane to remove the part further away from the cell  *
-- * center and a cap holes modifier is applied. The object is finally   *
-- * collapsed as an editable poly.                                      *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	on btnCREATE pressed do
	(
		CCinBV = #()

		-- tests for valid CC in BV
		BVcenter = (BVcorners[1] + BVcorners[2]) / 2
		BVextent = (BVcorners[2] - BVcorners[1]) / 2

		-- changes the color of CC outside BV
		for i = 1 to CCcoords.count do
			if abs(CCcoords[i][1] - BVcenter[1]) > BVextent[1] or \
		 	   abs(CCcoords[i][2] - BVcenter[2]) > BVextent[2] or \
		 	   abs(CCcoords[i][3] - BVcenter[3]) > BVextent[3] then
				CCpoints[i].wireColor = [255,96,0]
			else 
			(
				append CCinBV CCcoords[i]
				CCpoints[i].wireColor = green
			)

		-- forces the update of the wireColor changes (just above) BEFORE any messageBox is displayed
		redrawViews()	-- without it, color changes are updated only once the messageBox is closed (!?)

		msg = "Only " + CCinBV.count as string + " cell centers out of " + CCcoords.count \
						as string + "\nwithin bounding volume.\nDo you want to proceed?"

		-- last tests during which the user can intervene
		if CCinBV.count == 0 then messageBox "No cell centers in bounding volume.\nNeeds at least two to proceed." beep:false
			else if CCinBV.count == 1 then messageBox "Only one cell center in bounding volume.\nNeeds at least two to proceed." beep:false
				else if CCinBV.count == CCcoords.count or (queryBox msg beep:false) then
				(
					-- gets rid of the visual helpers
					if not BVcage.isDeleted do BVcage.isHidden = true
					for obj in CCpoints while not obj.isDeleted do delete obj

					-- bounding volume to make copies from to create the cells
					-- (*) baseBV CAN BE ANY MESH instead of a box - for another script!
					baseBV = plane pos:BVcenter width:(BVextent[1] * 2) length:(BVextent[2] * 2) \
							widthSegs:1 lengthSegs:1 wireColor:[128,128,255] isHidden:true
					addModifier baseBV (shell innerAmount:BVextent[3] outerAmount:BVextent[3] segments:1)

					-- plane used to determine the rotation as a quaternion value for the slice modifier
					rotPlane = plane pos:BVcenter isHidden:true

					start = timeStamp()

					-- where the cells are created
					for i = 1 to CCinBV.count do
					(
						-- mesh object that holds the cell
						theCell = editable_mesh name:(uniqueName "Voronoi Cell ") pos:CCinBV[i] isHidden:true
						theCell.wireColor = case rdoCC.state of
											(
												1: cpCC.color
												2: random black white
											)	-- end case rdoCC.state
						attach theCell (copy baseBV)

						-- creates a cell around the current cell center
						for j = 1 to CCinBV.count where j != i do
						(
							theVec = CCinBV[j] - CCinBV[i]
							rotPlane.dir = theVec
							mSlice = sliceModifier slice_type:2
							addModifier theCell mSlice
							mSlice.slice_plane.rotation = rotPlane.rotation
							mSlice.slice_plane.pos = theVec / 2
							addModifier theCell (cap_holes())
							collapseStack theCell			

						)	-- end for j = 1 to CCinBV.count

						theCell.isHidden = false
						redrawViews()
						end = timeStamp()

						-- progression update
						prog = 100 * i / CCinBV.count
						pbProgress.value = prog
						pbProgress.color = [200 - prog * 2,prog * 2,0]
						lblProStatus.caption = (i as string + " cells created in " + \
							(formattedPrint ((end - start) / 1000.0) format:".2f")+ " seconds")

					)	-- end for i = 1 to CCinBV.count

					delete rotPlane

					-- bounding volume options
					case rdoBV.state of
					(
						1:	(	-- keep as spline cage
								delete baseBV
								BVcage.name = "Voronoi Bounding Volume"
								BVcage.isHidden = false
							)
						2:	(	-- keep as box
								delete BVcage
								convertTo baseBV editable_poly
								baseBV.name = "Voronoi Bounding Volume"
								baseBV.isHidden = false
							)
						3:	(	-- don't keep
								delete BVcage
								delete baseBV
							)

					)	-- end case rdoBV.state

				-- resets the interface
				BVexists = false
				CCexists = false
				btnBVfromCC.enabled = false
				spnBVoffset.enabled = false
				btnCCrnd.enabled = false
				spnCCnb.enabled = false
				spnCCoffset.enabled = false
				btnCREATE.enabled = false

				)	-- end if CCinBV.count == CCcoords.count or (queryBox msg beep:false)

	)	-- end on btnCREATE pressed



-- * * * * * * * * * * * * * * * * * * * * * * *
-- * Changes name and color of visual helpers  *
-- * if the rollout is closed before creation. *
-- * * * * * * * * * * * * * * * * * * * * * * *

	on rltVoronoiCells close do
	(
		if (BVcage != undefined) and (not BVcage.isDeleted) do
		(
			BVcage.name = uniqueName "Vor_BC_"
			BVcage.wireColor = [160,128,128]
		)

		if CCpoints.count != 0 do
			for obj in CCpoints do if not obj.isDeleted do 
				(
					obj.name = uniqueName "Vor_CP_"
					obj.wireColor = [160,128,128]
				)

	)	-- end on rltVoronoiCells close



)	-- end rollout rltVoronoiCells



-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * *                                                                                           * *
-- * *   XXXX    XXX   XXXX   X    X  XXXX     XXXX    XXX   X      X       XXX   X   X  XXXXX   * *
-- * *   X   X  X   X  X   X  X    X  X   X    X   X  X   X  X      X      X   X  X   X    X     * *
-- * *   XXXX   X   X  XXXX   X    X  XXXX     XXXX   X   X  X      X      X   X  X   X    X     * *
-- * *   X      X   X  X      X   X   X        X  X   X   X  X      X      X   X  X   X    X     * *
-- * *   X       XXX   X       XXX    X        X   X   XXX   XXXXX  XXXXX   XXX    XXX     X     * *
-- * *                                                                                           * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- * * * * * * * * * * * * * * * * * * * * * * *
-- * Adds a small text editor to correct line  *
-- * by line eventual errors in the text file. *
-- * * * * * * * * * * * * * * * * * * * * * * *

rollout rltVorCheckFile "" width:259 height:90
(
	label lblCorrect "Missing or invalid coordinate(s) at line" pos:[15,5] width:196 height:20
	label lblLineNb "" pos:[195,5] width:34 height:20
	editText edtCorrect "" pos:[10,25] width:235 height:16
	button btnCorrect "Correct" pos:[64,55] width:50 height:25
	button btnDontCorrect "Abort" pos:[146,55] width:50 height:25

	on rltVorCheckFile moved newPos do setDialogPos rltVoronoiCells (newPos + [0,-393])

	on rltVorCheckFile open do
	(
		lblLineNb.text = lineNb as string
		edtCorrect.text = theLines[lineNb]

	)	-- end on rltVorCheckFile open

	on btnCorrect pressed do
	(
		-- checks if the correction IS correct
		oneLine = edtCorrect.text as stringStream
		try
		(
			for i = 1 to 3 do ((readToken oneLine) as integer) + 0
			useFile = true
			theLines[lineNb] = edtCorrect.text
			destroyDialog rltVorCheckFile

		)	-- end try

		catch messageBox ("Coordinates data still incorrect. Expected format is:\n" \
						+ "xxxx.xx  yyyyy.yy  zzzz.zz\nFurther characters on the same line" \
						+ " are ignored\nand can be used to add informations in the file.") beep:false

	)	-- end on btnCorrect pressed

	on btnDontCorrect pressed do destroyDialog rltVorCheckFile

)	-- end rollout rltVorCheckFile



createDialog rltVoronoiCells 259 365 100 200

)	-- end script

