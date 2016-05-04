ScriptName SeasonHandler extends ActiveMagicEffect

Actor property playerRef auto
ObjectReference property invisObject auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	debug.notification("player changed cells")
	Utility.Wait(0.1)
	invisibleObject.MoveTo(playerRef)
	
EndEvent 

