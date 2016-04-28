ScriptName SeasonChanger extends ObjectReference 

float Function ChangeSeasonLodDirectory(int, int, string, string) global native

Function changeSeason(int newSeason)
	
	String ChangeListFile = "../SkyrimSeasons/ChangeLists/ChangeList.json"
	String[] List = new String[4]
	List[0] = "TreeList"
	List[1] = "GrassList"
	List[2] = "LodList"
	List[3] = "GroundList"
	
	int i = 0
	while (i < 4)
		
		String[] Season = new String[4]
		Season[0] = "Spring/"
		Season[1] = "Summer/"
		Season[2] = "Autumn/"
		Season[3] = "Winter/"
		int StringListCount = (ChangeListFile, List[i])
		int iterator = 1
		while (iterator < StringListCount)
			
			String currentObjectString = JsonUtil.StringListGet(ChangeListFile, List[i], iterator)
			Form currentObject
			if (i == 0) ;TreeList
				
				; esm/esp path ; formID : model path
				Form currentObject = Game.GetFormFromFile(StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ";")+1, StringUtil.find(currentObjectString, ":") as int, StringUtil.Substring(currentObjectString, 0, StringUtil.Find(currentOnjectString, ";", 0))) as ObjectReference
				String ModelPath = StringUtil.SubString(currentObjectString, StringUtil.find(currentObjectString, ":")+1 as int, 0)
				currentObject.SetWorldModelPath(Season[i] + ModelPath)
				
			elseif (i == 1) ;GrassList
				
				
				
			elseif (i == 2) ;LodList
				
				
				
			else ;i == 3 GroundList
				
				
				
			endIf
			
			iterator += 1
			
		EndWhile
		
		i += 1
		
	EndWhile
	
EndFunction 

bool Function changeTree()
	
	
	
EndFunction 

bool Function changeGrass()
	
	
	
EndFunction 

bool Function changeLod()



EndFunction

bool Function changeGround()
	
	
	
EndFunction 