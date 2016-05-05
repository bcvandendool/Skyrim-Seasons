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
	
	
	
EndFunction