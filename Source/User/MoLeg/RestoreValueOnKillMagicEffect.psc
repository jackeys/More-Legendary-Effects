Scriptname MoLeg:RestoreValueOnKillMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

ActorValue Property Value Auto Const Mandatory
{Which actor value to change}

float Property AmountToRestore Auto Const
{How much to heal the actor value}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForRemoteEvent(akTarget, "OnKill")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnregisterForRemoteEvent(akTarget, "OnKill")
EndEvent

Event Actor.OnKill(Actor akKiller, Actor akVictim)
	debug.trace(akKiller + " killed " + akVictim + " - restoring " + AmountToRestore + " " + Value)
	akKiller.RestoreValue(Value, AmountToRestore)
EndEvent

