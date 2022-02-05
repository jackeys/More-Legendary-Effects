Scriptname MoLeg:AddSpellWhenTargetHitListener extends LegendaryMagicEffectEventListenScript 

;Reminder there are properties and variables defined on the parent script

float Property SpellChance = 100.0 Auto Const

;Reminder - Parent script manages making sure the Magic Effect and Caster are the ones we are interested in.
Function HandleEvent(MagicEffect EventMagicEffect, Actor TargetActor, Actor CasterActor, int EventType, Var EventArg1, Var EventArg2, Var EventArg3)
	debug.trace(self + " received event type " + EventType + " with keyword " + EventArg1)

	;EventArg1 = Legendary Keyword
	;EventArg2 = Spell to Cast
	;EventArg3 = unset

	Spell spellToCast = EventArg2 as Spell
	Actor myActor = GetTargetActor()

	if EventType == LegendaryItemQuest.iEventType_OnHit && Utility.RandomFloat(0, 100) <= SpellChance
        debug.trace(self + " casting " + spellToCast + " on " + myActor)
		spellToCast.Cast(myActor, myActor)
	endif
EndFunction


