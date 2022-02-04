Scriptname MoLeg:AddSpellOnBlockMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

Spell Property SpellToApply Auto Const Mandatory
{The spell that should be applied to the target of the attack}

float Property SpellChance Auto Const
{An actor value that governs the chance that the spell will be added when the target is hit - overrides SpellChance if provided}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForHitEvent(akTarget)
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	Actor targetActor = akTarget as Actor
	if abhitBlocked && Utility.RandomFloat(0, 100) <= SpellChance
		debug.trace(targetActor + " blocked a hit, adding spell " + SpellToApply + " to " + akAggressor)
		SpellToApply.Cast(akTarget, akAggressor)
	endIf
	
	if IsBoundGameObjectAvailable()
		RegisterForHitEvent(akTarget)
	endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnregisterForHitEvent(akTarget)
EndEvent
