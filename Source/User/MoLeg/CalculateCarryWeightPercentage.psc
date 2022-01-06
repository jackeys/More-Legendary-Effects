Scriptname MoLeg:CalculateCarryWeightPercentage extends ActiveMagicEffect const
{Periodically calculates the target's current carry weight as a percentage for use in other effects. Recommended for use in a perk ability so it only runs once per actor. Requires F4SE}

ActorValue Property CarryWeightPercentage Auto Const
{The actor value to update, where carry weight percentage will be a number like 97.1}

ActorValue Property CarryWeight Auto Const Mandatory
{AUTOFILL}

float Property IntervalInSeconds = 5.0 Auto Const Mandatory
{The number of real world seconds between each check}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	StartTimer(IntervalInSeconds)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer()
EndEvent

Event OnTimer(int aiTimerID)
	if IsBoundGameObjectAvailable()
		Actor target = GetTargetActor()		
		target.SetValue(CarryWeightPercentage, (target.GetInventoryWeight() / target.GetValue(CarryWeight)) * 100.0)

		StartTimer(IntervalInSeconds)
	endIf
EndEvent