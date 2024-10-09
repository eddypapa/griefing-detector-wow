-- BossPullNotifier.lua

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("ENCOUNTER_START")
frame:RegisterEvent("ENCOUNTER_END")

local bossEncounter = false
local bossIDs = {}

local function IsPlayerException(playerName, roleCheck)
    -- Ellenőrzi, hogy a játékos raid leader vagy assistant
    if UnitIsGroupLeader(playerName) or UnitIsAssistant(playerName) then
        return true
    end

    -- Ellenőrzi, hogy a játékos tank-e
    if roleCheck then
        local role = UnitGroupRolesAssigned(playerName)
        if role == "TANK" then
            return true
        end
    end

    return false
end

local function SendMessage(playerName, action)
    local chatType = (IsInRaid() and "RAID") or (IsInGroup() and "PARTY") or "SAY"

    local message = string.format("%s felhívta a boss figyelmét! (%s)", playerName, action)
    SendChatMessage(message, chatType)

    -- Figyelmeztetés a képernyő közepén
    local roleException = (action == "pull") and IsPlayerException(playerName, true) or IsPlayerException(playerName, false)
    if not roleException then
        RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo["RAID_WARNING"])
    end
end

-- Pull varázslatok spell ID-i
local pullSpells = {
    [75] = true,     -- Auto Shot
    [5019] = true,   -- Shoot
    [6673] = true,   -- Battle Shout
    [100] = true,    -- Charge
    [172] = true,    -- Corruption
    -- Add hozzá a listához a további spell ID-kat
}

local function OnEvent(self, event, ...)
    if event == "ENCOUNTER_START" then
        bossEncounter = true
        table.wipe(bossIDs)
    elseif event == "ENCOUNTER_END" then
        bossEncounter = false
        table.wipe(bossIDs)
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subevent, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID = CombatLogGetCurrentEventInfo()

        if not bossEncounter then return end

        -- Ellenőrizzük, hogy a célpont egy boss-e
        if destGUID and not bossIDs[destGUID] then
            local unitType, _, _, _, _, npcID = strsplit("-", destGUID)
            npcID = tonumber(npcID)
            if unitType == "Creature" then
                bossIDs[destGUID] = true
            end
        end

        -- Pull detektálása
        if bossIDs[destGUID] and sourceName then
            if (subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_DAMAGE") and pullSpells[spellID] then
                SendMessage(sourceName, "pull")
            elseif subevent == "SWING_DAMAGE" or subevent == "RANGE_DAMAGE" then
                SendMessage(sourceName, "pull")
            elseif subevent == "SPELL_AURA_APPLIED" and bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
                SendMessage(sourceName, "aggro")
            end
        end
    end
end

frame:SetScript("OnEvent", OnEvent)