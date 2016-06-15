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

				String sourceFilePath = StringUtil.SubString(currentObjectString, 0 , StringUtil.find(currentObjectString, ";"))
				int formID = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ";") + 1, StringUtil.find(currentObjectString, ":") - (StringUtil.find(currentObjectString, ";") + 1)) as int
				String modelPath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ":") + 1, 0)
			
				debug.Notification(sourceFilePath)
				debug.Notification(formID)
				debug.Notification(modelPath)

				Form currentObject = Game.GetFormFromFile(formID, sourceFilePath)
				Utility.Wait(0.25)
				if(currentObject)

					currentObject.SetWorldModelPath(Season[newSeason - 1] + modelPath)

				Else

					debug.Notification("currentobject is null")

				endif
				
			else ;LodList //TODO 
				
				bool test = true

				; install path ; directory path
				String installPath = StringUtil.SubString(currentObjectString, 0, StringUtil.find(currentObjectString, ";"))
				String directoryPath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ";") + 1, 0)
				;float f = ChangeSeasonLodDirectory(newSeason, installPath, directoryPath)
				if (test == true)
					;float f = ChangeSeasonLodDirectory(2, installPath, directoryPath)
					test = false
				Else
					;float f = ChangeSeasonLodDirectory(3, installPath, directoryPath)
				EndIf

			endif
			
		EndWhile
		
		i += 1
		
	EndWhile

EndFunction 
