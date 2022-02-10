Scriptname MoLeg:AddSpellToPlayerFollowersMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

Spell Property SpellToApply Auto Const Mandatory
{The spell that should be applied to the target of the attack}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	int i = 0
	Actor[] playerFollowers = Game.GetPlayerFollowers()

	while i < playerFollowers.Length
		Actor follower = playerFollowers[i]
		debug.trace(self + " casting " + SpellToApply + " on player follower " + follower)
		SpellToApply.Cast(akTarget, follower)
		i += 1
	endWhile
EndEvent