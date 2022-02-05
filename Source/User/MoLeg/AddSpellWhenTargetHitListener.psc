Scriptname MoLeg:AddSpellWhenTargetHitListener extends LegendaryMagicEffectEventListenScript 

;Reminder there are properties and variables defined on the parent script

;Reminder - Parent script manages making sure the Magic Effect and Caster are the ones we are interested in.
Function HandleEvent(MagicEffect EventMagicEffect, Actor TargetActor, Actor CasterActor, int EventType, Var EventArg1, Var EventArg2, Var EventArg3)
	debug.trace(self + "HandleEvent()")
	debug.trace(self + "EventMagicEffect: " + EventMagicEffect)
	debug.trace(self + "TargetActor: " + TargetActor)
	debug.trace(self + "CasterActor: " + CasterActor)
	debug.trace(self + "EventType: " + EventType)
	debug.trace(self + "EventArg1: " + EventArg1)
	debug.trace(self + "EventArg2: " + EventArg2)
	debug.trace(self + "EventArg3: " + EventArg3)

	;EventArg1 = Legendary Keyword
	;EventArg2 = Spell to Cast
	;EventArg3 = unset

	Spell spellToCast = EventArg2 as Spell

	Actor myActor = GetTargetActor()

	if EventType == LegendaryItemQuest.iEventType_OnHit
		spellToCast.Cast(myActor, myActor)
	endif
EndFunction


