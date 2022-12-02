Scriptname MoLeg:UpdateLegendaryRules extends Quest
{Update the rules in the main quest. Used for updates.}

MoLeg:CustomLegendaryRulesQuest Property RulesQuest const auto mandatory

Event OnQuestInit()
    if RulesQuest.HasRunBefore
        debug.trace(self + " Updating legendary rules")
        RulesQuest.UpdateLegendaryModRules()
    EndIf
    Stop()
EndEvent