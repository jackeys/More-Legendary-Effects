Scriptname MoLeg:CustomLegendaryRulesQuest extends Quest
{Manages which custom legendary effects are present in the pool of possible legendaries that the main game has}

LegendaryItemQuestScript Property LegendaryItemQuest const auto mandatory
{Autofill}

Struct NamingRuleMerge
	InstanceNamingRules Source
	InstanceNamingRules Destination
EndStruct

NamingRuleMerge[] Property NamingRules Const Auto Mandatory

InstanceNamingRules Property ArmorNamingRules Auto Const Mandatory

Message Property RemoveNukaWorldRulesMessage Auto Const Mandatory
Message Property ArrayExpansionMessage Auto Const Mandatory

bool Property AllowArrayExpansion = false Auto
{Whether or not LL_FourPlay can be used to expand the array size for all arrays in the game, if it is available}

; Armor

bool Property AristocratsEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property AristocratsModRule Const Auto Mandatory

bool Property DissipatingEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property DissipatingModRule Const Auto Mandatory

bool Property DoctorsEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property DoctorsModRule Const Auto Mandatory

bool Property ElectrifiedEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property ElectrifiedModRule Const Auto Mandatory

bool Property HardyEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property HardyModRule Const Auto Mandatory

bool Property HazmatEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property HazmatModRule Const Auto Mandatory

bool Property HoardersEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property HoardersModRule Const Auto Mandatory

bool Property NocturnalEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property NocturnalModRule Const Auto Mandatory

bool Property RegeneratingEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property RegeneratingModRule Const Auto Mandatory

bool Property SneakingEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property SneakingModRule Const Auto Mandatory

bool Property ToxicEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property ToxicModRule Const Auto Mandatory

bool Property TravelersEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property TravelersModRule Const Auto Mandatory

bool Property VanguardsEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property VanguardsModRule Const Auto Mandatory

bool Property WeightlessEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property WeightlessModRule Const Auto Mandatory

bool Property BracingEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property BracingModRule Const Auto Mandatory

; Weapons

bool Property LightweightEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property LightweightModRule Const Auto Mandatory

; Disabled by default because it currently doesn't work
bool Property SwiftEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property SwiftModRule Const Auto Mandatory

bool Property AristocratsWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property AristocratsWeaponModRule Const Auto Mandatory

bool Property BashersWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property BashersWeaponModRule Const Auto Mandatory

bool Property ExecutionersWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property ExecutionersWeaponModRule Const Auto Mandatory

bool Property JuggernautsWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property JuggernautsWeaponModRule Const Auto Mandatory

bool Property HoardersWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property HoardersWeaponModRule Const Auto Mandatory

bool Property SteadyWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property SteadyWeaponModRule Const Auto Mandatory

bool Property OverpoweringWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property OverpoweringWeaponModRule Const Auto Mandatory

bool Property UndeterredWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property UndeterredWeaponModRule Const Auto Mandatory

bool Property RipostingWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property RipostingWeaponModRule Const Auto Mandatory

bool Property InfuriatingWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property InfuriatingWeaponModRule Const Auto Mandatory

bool Property InertialWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property InertialWeaponModRule Const Auto Mandatory

bool Property VampiresWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property VampiresWeaponModRule Const Auto Mandatory

bool Property GhostsWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property GhostsWeaponModRule Const Auto Mandatory

bool Property SuppressorsWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property SuppressorsWeaponModRule Const Auto Mandatory

bool Property MedicsWeaponEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property MedicsWeaponModRule Const Auto Mandatory

bool Property TravelersGunEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property TravelersGunModRule Const Auto Mandatory

bool Property TravelersMeleeEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property TravelersMeleeModRule Const Auto Mandatory

Event OnQuestInit()
	MergeNamingRules()
	UpdateLegendaryModRules()
EndEvent

Function MergeNamingRules()
	int i = 0
	while i < NamingRules.Length
		debug.trace(self + " merging naming rules - Source: " + NamingRules[i].Source + " | Destination: " + NamingRules[i].Destination)
		NamingRules[i].Destination.MergeWith(NamingRules[i].Source)
		i += 1
	EndWhile

	if !MergeNamingRulesForPAttP()
		debug.trace(self + " could not find Power Armor to the People - registering for game load event until we can")
		RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	endIf
EndFunction

bool Function MergeNamingRulesForPAttP()
	InstanceNamingRules PAttPNamingRules = Game.GetFormFromFile(0x0000088F, "Power Armor to the People.esp") as InstanceNamingRules
	Quest PAttPTriggerMergeQuest = Game.GetFormFromFile(0x00000B6B, "Power Armor to the People.esp") as Quest

	if PAttPNamingRules && PAttPTriggerMergeQuest
		debug.trace(self + " injecting armor naming rules into Power Armor to the People")
		PAttPNamingRules.MergeWith(ArmorNamingRules)
		PAttPTriggerMergeQuest.Start()
		return true
	endIf

	return false
EndFunction

Event Actor.OnPlayerLoadGame(Actor akSender)
    if MergeNamingRulesForPAttP()
		debug.trace(self + " unregistering for game load event")
		UnregisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	endIf
EndEvent

Function UpdateLegendaryModRules()
	; Armor
	UpdateModRule("Aristocrat's (Armor)", AristocratsEnabled, AristocratsModRule)
	UpdateModRule("Dissipating", DissipatingEnabled, DissipatingModRule)
	UpdateModRule("Doctor's", DoctorsEnabled, DoctorsModRule)
	UpdateModRule("Electrified", ElectrifiedEnabled, ElectrifiedModRule)
	UpdateModRule("Hardy", HardyEnabled, HardyModRule)
	UpdateModRule("Hazmat", HazmatEnabled, HazmatModRule)
	UpdateModRule("Hoarder's", HoardersEnabled, HoardersModRule)
	UpdateModRule("Nocturnal", NocturnalEnabled, NocturnalModRule)
	UpdateModRule("Regenerating", RegeneratingEnabled, RegeneratingModRule)
	UpdateModRule("Sneaking", SneakingEnabled, SneakingModRule)
	UpdateModRule("Toxic", ToxicEnabled, ToxicModRule)
	UpdateModRule("Traveler's", TravelersEnabled, TravelersModRule)
	UpdateModRule("Vanguard's", VanguardsEnabled, VanguardsModRule)
	UpdateModRule("Weightless", WeightlessEnabled, WeightlessModRule)
	UpdateModRule("Bracing", BracingEnabled, BracingModRule)
	
	; Weapons
	UpdateModRule("Lightweight", LightweightEnabled, LightweightModRule)
	UpdateModRule("Swift", SwiftEnabled, SwiftModRule)
	UpdateModRule("Aristocrat's (Weapon)", AristocratsWeaponEnabled, AristocratsWeaponModRule)
	UpdateModRule("Basher's (Weapon)", BashersWeaponEnabled, BashersWeaponModRule)
	UpdateModRule("Executioner's (Weapon)", ExecutionersWeaponEnabled, ExecutionersWeaponModRule)
	UpdateModRule("Juggernaut's (Weapon)", JuggernautsWeaponEnabled, JuggernautsWeaponModRule)
	UpdateModRule("Hoarder's (Weapon)", HoardersWeaponEnabled, HoardersWeaponModRule)
	UpdateModRule("Vampire's (Weapon)", VampiresWeaponEnabled, VampiresWeaponModRule)
	UpdateModRule("Ghost's (Weapon)", GhostsWeaponEnabled, GhostsWeaponModRule)
	UpdateModRule("Suppressor's (Weapon)", SuppressorsWeaponEnabled, SuppressorsWeaponModRule)
	UpdateModRule("Medic's (Weapon)", MedicsWeaponEnabled, MedicsWeaponModRule)
	UpdateModRule("Traveler's (Gun)", TravelersGunEnabled, TravelersGunModRule)
	UpdateModRule("Traveler's (Melee)", TravelersMeleeEnabled, TravelersMeleeModRule)
	UpdateModRule("Steady (Weapon)", SteadyWeaponEnabled, SteadyWeaponModRule)
	UpdateModRule("Overpowering (Weapon)", OverpoweringWeaponEnabled, OverpoweringWeaponModRule)
	UpdateModRule("Undeterred (Weapon)", UndeterredWeaponEnabled, UndeterredWeaponModRule)
	UpdateModRule("Riposting (Weapon)", RipostingWeaponEnabled, RipostingWeaponModRule)
	UpdateModRule("Infuriating (Weapon)", InfuriatingWeaponEnabled, InfuriatingWeaponModRule)
	UpdateModRule("Inertial (Weapon)", InertialWeaponEnabled, InertialWeaponModRule)
EndFunction

Function UpdateModRule(string asName, bool abEnabled, LegendaryItemQuestScript:LegendaryModRule akRule)
	int index = FindLegendaryRule(akRule)
	if abEnabled
		if index >= 0
			debug.trace(self + " No action needed - found enabled rule " + asName + " at index " + index)
		else
			debug.trace(self + " Adding enabled legendary " + asName + " | Rule: " + akRule)
			LegendaryItemQuest.LegendaryModRules.add(akRule)
			
			; If the array is full, our insertion may not have worked
			while FindLegendaryRule(akRule) < 0 && MakeRoomInLegendaryArray()
				debug.trace(self + " Could not find enabled legendary " + asName + " after insertion - trying again | Rule: " + akRule)
				LegendaryItemQuest.LegendaryModRules.add(akRule)
			endWhile
		endIf
	else
		if index < 0
			debug.trace(self + " No action needed - disabled rule " + asName + " not found")
		else
			debug.trace(self + " Removing disabled rule " + asName + " from index " + index + " | Rule: " + akRule)
			LegendaryItemQuest.LegendaryModRules.remove(index)
		endIf
	EndIf
EndFunction

int Function FindLegendaryRule(LegendaryItemQuestScript:LegendaryModRule akRule)
	; Look for the rule using the object mod, then double-check the other fields to make sure it actually matches
	int index = LegendaryItemQuest.LegendaryModRules.RFindStruct("LegendaryObjectMod", akRule.LegendaryObjectMod)
	
	while index > -1 && LegendaryItemQuest.LegendaryModRules[index] != akRule
		if index > 0
			index = LegendaryItemQuest.LegendaryModRules.RFindStruct("LegendaryObjectMod", akRule.LegendaryObjectMod, index - 1)
		else
			; We just checked the last element of the array - it's not here
			index = -1
		EndIf
	EndWhile

	return index
EndFunction

int BUTTON_ALLOW_ACTION = 0 const
int BUTTON_DISALLOW_ACTION = 1 const

bool NukaWorldRemovalMessageShown = false
bool ArrayExpansionMessageShown = false

int MaxArraySize = 128
int ARRAY_SIZE_LIMIT = 256 const

bool Function MakeRoomInLegendaryArray()
	bool madeRoom = false

	; We can make room by deleting Nuka-World's unused legendary rules, if they are present
	if NukaWorldLegendaryRulesPresent() && !NukaWorldRemovalMessageShown
		NukaWorldRemovalMessageShown = true
		if RemoveNukaWorldRulesMessage.Show() == BUTTON_ALLOW_ACTION
			debug.trace(self + " removing Nuka-World legendary rules")
			RemoveNukaWorldLegendaryRulesByFormID()
			madeRoom = true
		endIf
	endIf
	
	if !madeRoom && ArrayExpansionAvailable()
		if !ArrayExpansionMessageShown
			ArrayExpansionMessageShown = true
			AllowArrayExpansion = ArrayExpansionMessage.Show() == BUTTON_ALLOW_ACTION
		endIf

		if AllowArrayExpansion && MaxArraySize < ARRAY_SIZE_LIMIT
			MaxArraySize += 8
			debug.trace(self + " increasing the maximum array size to " + MaxArraySize)
			LL_FourPlay.SetMinimalMaxArraySize(MaxArraySize)
			madeRoom = true
		endIf
	endIf

	return madeRoom
EndFunction

bool Function ArrayExpansionAvailable()
	; This will be None (treated as a 0 with an error in the logs) if LL_FourPlay is not installed
	return (LL_FourPlay.GetLLFPPluginVersion() >= 34.0)
EndFunction

bool Function NukaWorldLegendaryRulesPresent()
	; Arbitrary rule from the list - if one is present, all of them should be
	FormList allowedKeywords = Game.GetFormFromFile(0x06048FC4, "DLCNukaWorld.esm") as FormList
    ObjectMod legendaryMod = Game.GetFormFromFile(0x060346FB, "DLCNukaWorld.esm") as ObjectMod

	if legendaryMod
        LegendaryItemQuestScript:LegendaryModRule legendaryRule = new LegendaryItemQuestScript:LegendaryModRule
        legendaryRule.AllowedKeywords = allowedKeywords
        legendaryRule.AllowGrenades = true
        legendaryRule.LegendaryObjectMod = legendaryMod

        return (FindLegendaryRule(legendaryRule) > -1)
    endIf

	return false
EndFunction

Function RemoveNukaWorldLegendaryRulesByFormID()
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x060346FB)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBB)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBC)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBD)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBE)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBF)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FC0)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FC1)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FC2)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FC3)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06033906)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCB)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCC)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCD)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCE)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCF)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FD0)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FD1)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FD2)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FD3)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FC9)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD4)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD5)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD6)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD7)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD8)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD9)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FDA)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FDB)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FDC)
EndFunction

Function RemoveNukaWorldRuleByFormIDs(int aiAllowedKeywords, int aiLegendaryMod)
    FormList allowedKeywords = Game.GetFormFromFile(aiAllowedKeywords, "DLCNukaWorld.esm") as FormList
    ObjectMod legendaryMod = Game.GetFormFromFile(aiLegendaryMod, "DLCNukaWorld.esm") as ObjectMod

    if legendaryMod
        LegendaryItemQuestScript:LegendaryModRule legendaryRule = new LegendaryItemQuestScript:LegendaryModRule
        legendaryRule.AllowedKeywords = allowedKeywords
        legendaryRule.AllowGrenades = true
        legendaryRule.LegendaryObjectMod = legendaryMod

        UpdateModRule("Nuka-World Rule", false, legendaryRule)
    endIf
EndFunction