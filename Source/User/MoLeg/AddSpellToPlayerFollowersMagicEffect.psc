Scriptname MoLeg:AddSpellToPlayerFollowersMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

Spell Property SpellToApply Auto Const Mandatory
{The spell that should be applied to the target of the attack}

Faction Property RequiredFaction Auto Const Mandatory
{The caster must be a part of this faction (or the player) for this effect to work}

RefCollectionAlias Property ActiveCompanions Auto Const Mandatory

ReferenceAlias Property DogmeatCompanion Auto Const

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; We only want to apply the spell if the caster is the player or someone allied to the player
	if akCaster == Game.GetPlayer() || akCaster.IsInFaction(RequiredFaction)
		int i = 0
		Actor[] playerFollowers = Game.GetPlayerFollowers()

		debug.trace(self + " going to add spell to " + playerFollowers.length + " player followers")

		while i < playerFollowers.Length
			Actor follower = playerFollowers[i]
			debug.trace(self + " casting " + SpellToApply + " on player follower " + follower)
			SpellToApply.Cast(akTarget, follower)
			i += 1
		endWhile
		
		int numCompanions = ActiveCompanions.GetCount()
		debug.trace(self + " going to add spell to " + numCompanions + " companions")
		
		i = 0
		while i < numCompanions
			Actor companion = ActiveCompanions.GetAt(i) as Actor
			debug.trace(self + " casting " + SpellToApply + " on player companion " + companion)
			SpellToApply.Cast(akTarget, companion)
			i += 1
		endWhile
		
		ObjectReference dogmeat = DogmeatCompanion.GetReference()
			
		if dogmeat
			debug.trace(self + " casting " + SpellToApply + " on dog companion " + dogmeat)
			SpellToApply.Cast(akTarget, dogmeat)
		endIf
	else
		debug.trace(self + " is not casting a spell on player followers because " + akCaster + " is not in the faction " + RequiredFaction)
	endIf
EndEvent