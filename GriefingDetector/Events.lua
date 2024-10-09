-- Eseménykezelő függvény
function BossPullNotifier:OnEvent(event, ...)
    if event == "PLAYER_LOGIN" then
        self:LoadSettings()
        if BossPullNotifierDB.enabled then
            self.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        else
            self.frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
        self:CreateOptionsPanel()
    elseif event == "ENCOUNTER_START" then
        self.bossEncounter = true
        table.wipe(self.bossIDs)
    elseif event == "ENCOUNTER_END" then
        self.bossEncounter = false
        table.wipe(self.bossIDs)
    else
        self:OnCombatLogEvent(...)
    end
end

-- Harci napló esemény kezelése
function BossPullNotifier:OnCombatLogEvent(...)
    if not BossPullNotifierDB.enabled then return end

    local timestamp, subevent, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID = CombatLogGetCurrentEventInfo()

    if not self.bossEncounter then return end

    -- Ellenőrizzük, hogy a célpont egy boss-e
    if destGUID and not self.bossIDs[destGUID] then
        local unitType, _, _, _, _, npcID = strsplit("-", destGUID)
        npcID = tonumber(npcID)
        if unitType == "Creature" then
            self.bossIDs[destGUID] = true
        end
    end

    -- Pull detektálása
    if self.bossIDs[destGUID] and sourceName then
        if (subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_DAMAGE") and self.pullSpells[spellID] then
            self:SendMessage(sourceName, "pull")
        elseif subevent == "SWING_DAMAGE" or subevent == "RANGE_DAMAGE" then
            self:SendMessage(sourceName, "pull")
        elseif subevent == "SPELL_AURA_APPLIED" and bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
            self:SendMessage(sourceName, "aggro")
        end
    end
end

-- Eseménykezelő hozzárendelése
BossPullNotifier.frame:SetScript("OnEvent", function(self, event, ...)
    BossPullNotifier:OnEvent(event, ...)
end)