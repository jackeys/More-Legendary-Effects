Scriptname MoLeg:RestorePercentOfValueMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

ActorValue Property Value Auto Const Mandatory
{Which actor value to change}

float Property PercentToRestore Auto Const Mandatory
{What percentage of the base value should be restored per tick}

float Property IntervalInSeconds = 1.0 Auto Const
{The number of real world seconds between each restoration tick, provided the effect is still active. A 0 means this will only happen once.}

bool Property RestoreToCasterInstead = false Auto Const
{By default, the value will be restored for the target. Set this to true for the caster to instead receive it.}

FormList Property EquippedWeaponKeywordMultiplierList Auto Const
{A list of keywords for the caster's equipped weapon that, if found, will apply the multiplier to the total amount to be restored}

float Property EquippedWeaponKeywordMultiplier = 1.0 Auto Const
{The amount to multiply the amount to be restored by if the equipped weapon has a keyword from the multiplier list}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Restore()

	if IntervalInSeconds > 0 && IsBoundGameObjectAvailable()
		StartTimer(IntervalInSeconds)
	endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer()
EndEvent

Function Restore()
	Actor target = GetTargetActor()
	Actor caster = GetCasterActor()

	if RestoreToCasterInstead
		target = caster
	endIf

	float amountToAdd = target.GetBaseValue(Value) * (PercentToRestore / 100.0)
	debug.trace(self + " adding " + amountToAdd + " " + Value + " (" + PercentToRestore + "%) to " + target)

	if EquippedWeaponKeywordMultiplierList && caster.GetEquippedWeapon().HasKeywordInFormList(EquippedWeaponKeywordMultiplierList)
		debug.trace(self + " multiplying value by " + EquippedWeaponKeywordMultiplier + " because " + caster + " weapon has keyword from list " + EquippedWeaponKeywordMultiplierList)
		amountToAdd = amountToAdd * EquippedWeaponKeywordMultiplier
	endIf

	target.RestoreValue(Value, amountToAdd)
EndFunction

Event OnTimer(int aiTimerID)
	if IsBoundGameObjectAvailable()
		Restore()

		StartTimer(IntervalInSeconds)
	endIf
EndEvent