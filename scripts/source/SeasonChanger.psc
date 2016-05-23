ScriptName SeasonChanger extends ObjectReference Hidden

float Function ChangeSeasonLodDirectory(int newSeason, string installLocation, string dataLocation) global native

Function changeSeason(int newSeason) global

	; 1 = Spring
	; 2 = Summer
	; 3 = Autumn
	; 4 = Winter
	
	if (newSeason == 0)
		debug.notification("Season is 0. This should not be possible!")
	endif 

	String ChangeListFile = "../SkyrimSeasons/ChangeLists/ChangeList"
	String[] List = new String[4]
	List[0] = "TextureSetList"
	List[1] = "WorldModelList"
	List[2] = "LodList"

	int i = 0
	int StringListCount
	while (i < 3)
		
		String[] Season = new String[4]
		Season[0] = "Spring/"
		Season[1] = "Summer/"
		Season[2] = "Autumn/"
		Season[3] = "Winter/"
		StringListCount = JsonUtil.StringListCount(ChangeListFile, List[i])
		;debug.Notification(List[i])
		;debug.Notification(StringListCount)

		while (StringListCount)
			
			StringListCount -= 1
			String currentObjectString = JsonUtil.StringListGet(ChangeListFile, List[i], StringListCount)
			;debug.Notification(currentObjectString)

			if (i == 0) ;TextureSetList
				
				; esm/esp path 	;	formID 		: 	Diffuse path 			| 	Normal/Gloss path
				; Skyrim.esm	;	0x00000C0E	:	Landscape/Dirt01.dds	|	Landscape/Dirt01_n.dds

				Form currentObject

				String sourceFilePath = StringUtil.SubString(currentObjectString, 0, StringUtil.find(currentObjectString, ";", 0))
				String formID = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ";", 0) + 1, StringUtil.find(currentObjectString, ":", 0) - (StringUtil.find(currentObjectString, ";", 0) + 1))
				String diffusePath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ":", 0) + 1, StringUtil.find(currentObjectString, "|", 0) - (StringUtil.find(currentObjectString, ":", 0) + 1))
				String normalPath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, "|", 0) + 1, 0)

				currentObject = Game.GetFormFromFile(formID as int, sourceFilePath)
				if(currentObject)
					(currentObject as TextureSet).SetNthTexturePath(0, Season[newSeason - 1] + diffusePath)
					(currentObject as TextureSet).SetNthTexturePath(1, Season[newSeason - 1] + normalPath)
				Else
					debug.Notification("currentobject is null")
				Endif

			elseif (i == 1) ;WorldModelList
				
				; esm/esp path ; formID : model path
				; Skyrim.esm ; 0004FBB0 : Landscape\Trees\TreePineForest04.nif

				ObjectReference currentObject

				String sourceFilePath = StringUtil.SubString(currentObjectString, 0 , StringUtil.find(currentObjectString, ";"))
				int formID = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ";") + 1, StringUtil.find(currentObjectString, ":") - (StringUtil.find(currentObjectString, ";") + 1)) as int
				String modelPath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ":") + 1, 0)
				int cellFormID = 0x00009732
				;debug.Notification(cellFormID)

				;int test = JsonUtil.FormListCount(ChangeListFile, "test")
				;debug.Notification(test)
				Cell currentCell = Game.GetFormFromFile(0x00009731, "Skyrim.esm") as cell
				;debug.Notification(currentCell.GetFormID())
				if(currentcell)
					int refObjects = currentCell.GetNumRefs()
					debug.Notification(refObjects)
					while(refObjects)

						refObjects -= 1
						currentObject = currentCell.GetNthRef(refObjects, 0)
						Form baseObject = currentObject.GetBaseObject()
						if (baseObject.GetFormID() == 0x0004FBB0)

							debug.notification(currentObject.GetFormID())
							if(currentObject)

							currentObject.Disable(false)
							currentObject.SetWorldModelPath("Summer/landscape/trees/treepineforest04.nif")
							currentObject.Enable(false)

							JsonUtil.FormListAdd(ChangeListFile, "objRefList", currentObject as form, true)
							JsonUtil.Save(ChangeListFile, false)

							endif

						endif

					EndWhile
				Else
					debug.Notification("cell does not exist")
				endif 
				;debug.Notification(sourceFilePath)
				;debug.Notification(formID)
				;debug.Notification(modelPath)

				;currentObject = Game.GetFormFromFile(102435, sourceFilePath) as ObjectReference
				;Utility.Wait(0.25)
				;if(currentObject)
					;currentObject.SetWorldModelPath(Season[newSeason - 1] + modelPath)
				;	currentObject.disable()
				;	currentObject.SetWorldModelPath("Summer/landscape/trees/treepineforest04.nif")
				;	currentObject.enable()
				;Else
				;	debug.Notification("currentobject is null")
				;endif
				
			else ;LodList
				
				; install path ; directory path
				String installPath = StringUtil.SubString(currentObjectString, 0, StringUtil.find(currentObjectString, ";"))
				String directoryPath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ";") + 1, 0)
				float f = ChangeSeasonLodDirectory(newSeason, installPath, directoryPath)
				
			endif
			
		EndWhile
		
		i += 1
		
	EndWhile

EndFunction 

Function changeCells(Actor playerRef, int newSeason) global

	String ChangeListFile = "../SkyrimSeasons/ChangeLists/ChangeList"

	int cellFormID = playerRef.GetParentCell().GetFormID()
	String xy = JsonUtil.GetStringValue(ChangeListFile, IntToHex(cellFormID), "")
	int xCoord
	int yCoord
	if (xy != "")

		int xCenterCoord = StringUtil.Substring(xy, 0, StringUtil.Find(xy, ":", 0)) as int
		xCoord = xCenterCoord - 5
		int yCenterCoord = StringUtil.Substring(xy, StringUtil.Find(xy, ":", 0), 0) as int
		yCoord = yCenterCoord - 5

		while (xCoord <= xCenterCoord + 5)

			while(yCoord <= yCenterCoord + 5)

				String currentCellFormID = "0x" + JsonUtil.GetStringValue(ChangeListFile, xCoord + ":" + yCoord, "")
				Cell currentCell = Game.GetFormFromFile(StringUtil.Substring(currentCellFormID, 0, StringUtil.find(currentCellFormID, ":", 0)) as int, StringUtil.Substring(currentCellFormID, StringUtil.Find(currentCellFormID, ":", 0) + 1, 0)) as Cell
				yCoord += 1

			EndWhile
			yCoord = yCenterCoord - 5
			xCoord += 1

		EndWhile

	EndIf

EndFunction

String function IntToHex (int num) global
    int remainder
    String result = ""
    ;String[] hex = ["0","1","2","3,"4","5","6","7","8","9","A","B","C","D","E","F"]
    String[] hex = new String[16]
    ;Assign the individual parts of hex[] since we can't do it all at once.
    int i = 0
    while (i < 10)
        hex[i] = ""+i
        i+=1
    endWhile
    hex[10] = "A"
    hex[11] = "B"
    hex[12] = "C"
    hex[13] = "D"
    hex[14] = "E"
    hex[15] = "F"
    
    ;The actual conversion from int to hex string.
    while (num > 0)
        remainder = num % 16
        result = hex[remainder] + result
        num = num/16
    endWhile
    return result
endFunction