Scriptname MoLeg:RestorePercentOfValueMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

ActorValue Property Value Auto Const Mandatory
{Which actor value to change}

float Property PercentToRestore Auto Const Mandatory
{What percentage of the base value should be restored per tick}

float Property IntervalInSeconds = 1.0 Auto Const Mandatory
{The number of real world seconds between each restoration tick, provided the effect is still active}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Restore()
	StartTimer(IntervalInSeconds)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer()
EndEvent

Function Restore()
	Actor target = GetTargetActor()
	float amountToAdd = target.GetBaseValue(Value) * (PercentToRestore / 100.0)
	debug.trace(self + " adding " + amountToAdd + " " + Value + " (" + PercentToRestore + "%)")
	target.RestoreValue(Value, amountToAdd)
EndFunction

Event OnTimer(int aiTimerID)
	if IsBoundGameObjectAvailable()
		Restore()

		StartTimer(IntervalInSeconds)
	endIf
EndEvent