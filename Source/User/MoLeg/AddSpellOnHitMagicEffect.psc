Scriptname MoLeg:AddSpellOnHitMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

Spell Property SpellToApply Auto Const Mandatory
{The spell that should be applied to the target of the attack}

ActorValue Property SpellChanceAV Auto Const
{An actor value that governs the chance that the spell will be added when the target is hit - if omitted, the chance is 100%}

float Property AutomaticWeaponChanceModifier = 1.0 Auto Const
{Multiplier for spell chance if the weapon is an automatic weapon}

Keyword Property WeaponTypeAutomatic Auto Const Mandatory
{AUTOFILL}

FormList Property IncludedWeaponKeywords Auto Const
{A weapon must have a keyword from this list for its hit to add the spell. If excluded, all weapons are valid unless they are on the ExcludedWeaponKeywords list}

FormList Property ExcludedWeaponKeywords Auto Const
{A weapon cannot have a keyword from this list for its hit to add the spell}

bool Property ApplySpellToAggressor = false Auto Const
{If true, the spell will apply to whoever attacks the one with this magic effect - if false, the spell will apply to the one with this magic effect}

bool Property IgnoreMeleeAttacks = false Auto Const

bool Property OnlyRegisterHitsFromCaster = false Auto Const

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if OnlyRegisterHitsFromCaster
		RegisterForHitEvent(akTarget, akAggressorFilter = akCaster)
	else
		RegisterForHitEvent(akTarget)
	endIf
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	if !IsBoundGameObjectAvailable()
		return
	endIf
	
	Weapon sourceWeapon = akSource as Weapon
	Actor targetActor = akTarget as Actor
	if (!IgnoreMeleeAttacks || akProjectile) && sourceWeapon && targetActor && WeaponShouldBeIncluded(sourceWeapon) && Utility.RandomFloat(0, 100) <= GetSpellChance(akTarget, sourceWeapon)
		ObjectReference spellTarget = targetActor
		if ApplySpellToAggressor
			spellTarget = akAggressor
		endIf

		debug.trace(targetActor + " was hit, adding spell " + SpellToApply + " to " + spellTarget)
		SpellToApply.Cast(akTarget, spellTarget)
	endIf
	
	if OnlyRegisterHitsFromCaster
		RegisterForHitEvent(akTarget, akAggressorFilter = GetCasterActor())
	else
		RegisterForHitEvent(akTarget)
	endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Actor targetActor = akTarget as Actor
	if targetActor && !ApplySpellToAggressor
		targetActor.RemoveSpell(SpellToApply)
	endIf

	UnregisterForAllHitEvents()
EndEvent

float Function GetSpellChance(ObjectReference akTarget, Weapon akSourceWeapon)
	if !SpellChanceAV
		return 100.0
	endIf

	float adjustedSpellChance = akTarget.GetValue(SpellChanceAV)

	if akSourceWeapon.HasKeyword(WeaponTypeAutomatic)
		adjustedSpellChance *= AutomaticWeaponChanceModifier
	EndIf

	return adjustedSpellChance
EndFunction

bool Function WeaponShouldBeIncluded(Weapon akWeapon)
	return WeaponIsOnInclusionList(akWeapon) && !WeaponIsOnExclusionList(akWeapon)
EndFunction

bool Function WeaponIsOnInclusionList(Weapon akWeapon)
	if !IncludedWeaponKeywords
		return true
	endif

	int i = 0
	while i < IncludedWeaponKeywords.GetSize()
		Keyword InclusionKeyword = IncludedWeaponKeywords.GetAt(i) as Keyword
		if akWeapon.HasKeyword(InclusionKeyword)
			return true
		endIf
		
		i += 1
		endWhile
		
	debug.trace(self + ": Weapon " + akWeapon + " does not have a keyword from " + IncludedWeaponKeywords + " and cannot be used to apply a spell")
	return false
EndFunction

bool Function WeaponIsOnExclusionList(Weapon akWeapon)
	if !ExcludedWeaponKeywords
		return false
	endif

	int i = 0
	while i < ExcludedWeaponKeywords.GetSize()
		Keyword ExclusionKeyword = ExcludedWeaponKeywords.GetAt(i) as Keyword
		if akWeapon.HasKeyword(ExclusionKeyword)
			debug.trace(self + ": Weapon " + akWeapon + " does has keyword " + ExclusionKeyword + " from " + ExcludedWeaponKeywords + " and cannot be used to apply a spell")
			return true
		endIf
		
		i += 1
		endWhile
		
	return false
EndFunction