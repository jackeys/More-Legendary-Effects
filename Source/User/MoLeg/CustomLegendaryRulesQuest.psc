Scriptname MoLeg:CustomLegendaryRulesQuest extends Quest
{Manages which custom legendary effects are present in the pool of possible legendaries that the main game has}

LegendaryItemQuestScript Property LegendaryItemQuest const auto mandatory
{Autofill}

Struct NamingRuleMerge
	InstanceNamingRules Source
	InstanceNamingRules Destination
EndStruct

NamingRuleMerge[] Property NamingRules Const Auto Mandatory

bool Property AristocratsEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property AristocratsModRule Const Auto Mandatory

bool Property DissipatingEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property DissipatingModRule Const Auto Mandatory

bool Property DoctorsEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property DoctorsModRule Const Auto Mandatory

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
EndFunction

Function UpdateLegendaryModRules()
	UpdateModRule("Aristocrat's", AristocratsEnabled, AristocratsModRule)
	UpdateModRule("Dissipating", DissipatingEnabled, DissipatingModRule)
	UpdateModRule("Doctors", DoctorsEnabled, DoctorsModRule)
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
EndFunction

Function UpdateModRule(string asName, bool abEnabled, LegendaryItemQuestScript:LegendaryModRule akRule)
	int index = FindLegendaryRule(akRule)
	if abEnabled
		if index >= 0
			debug.trace(self + " No action needed - found enabled rule " + asName + " at index " + index)
		else
			debug.trace(self + " Adding enabled legendary " + asName + " | Rule: " + akRule)
			LegendaryItemQuest.LegendaryModRules.add(akRule)
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