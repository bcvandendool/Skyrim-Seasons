ScriptName SeasonHandler extends ActiveMagicEffect

Actor property playerRef auto
ObjectReference property invisObject auto
int property currentChangedSeason auto

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
	
	if (invisObject.IsInInterior() == true)

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

		debug.notification("Month is " + Month + ". Season is " + i)

		if(currentChangedSeason != i)
			Game.DisablePlayerControls(false, false, false, false, false, true, true, true, 0)
			SeasonChanger.changeSeason(i)
			Game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)
			currentChangedSeason = i
		else
			debug.notification("season wont change")
		endif
	endif 
	
EndFunction