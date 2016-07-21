ScriptName SeasonHandler extends ActiveMagicEffect

Actor property playerRef auto
ObjectReference property invisObject auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	RegisterForSingleUpdate(7)
	debug.notification("player changed cells")
	Utility.Wait(0.1)
	invisObject.MoveTo(playerRef)
	checkSeasonChange()
	
EndEvent 

Event OnUpdate()
	
	invisObject.MoveTo(playerRef)
	RegisterForSingleUpdate(4)

EndEvent

Function checkSeasonChange()
	
	int i = 0;
	String Month = StringUtil.Substring(Utility.GameTimeToString(Utility.GetCurrentGameTime()), 0, 2)
	if(Month == "03" || Month == "04" || Month == "05")
		i = 1
	elseif(Month == "06" || Month == "07" || Month == "08")
		i = 2
	elseif(Month == "09" || Month == "10" || Month == "11")
		i = 3
	elseif(Month == "12" || Month == "01" || Month == "02")
		i = 4
	else
		debug.notification("Month " + Month + "does not exist?!")
	endif

	String ChangeListFile = "../DynamicSeasons/ChangeLists/ChangeList"

	if (invisObject.IsInInterior() == true)

		Game.DisablePlayerControls(false, false, false, false, false, true, true, true, 0)
		SeasonChanger.changeSeason(i)
		JsonUtil.SetStringValue(ChangeListFile, "LODChange", "true")
		Game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)
		
	elseif (invisObject.IsInInterior() == false && JsonUtil.GetStringValue(ChangeListFile, "LODChange", "missing") == "true")

		Game.FadeOutGame(true, true, 0.0, 999)
		Game.DisablePlayerControls(true, true, true, true, true, true, true, true, 0)
		Game.saveGame("DyamicSeasonsSave")
		JsonUtil.Load(ChangeListFile)
		Debug.Notification(JsonUtil.GetStringValue(ChangeListFile, "LODChange", "missing"))
		Utility.Wait(10.0)
		Debug.Notification("after")
		if(JsonUtil.GetStringValue(ChangeListFile, "LODChange", "missing") == "true")

			JsonUtil.SetStringValue(ChangeListFile, "LODChange", "false")
			JsonUtil.Save(ChangeListFile)
			While(JsonUtil.IsPendingSave(ChangeListFile))
				Utility.Wait(0.1)
			EndWhile
			Game.QuitToMainMenu()

		Endif
		Game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)

	Endif
	
EndFunction