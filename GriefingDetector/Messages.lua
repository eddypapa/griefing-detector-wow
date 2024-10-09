-- Üzenetküldés
function GriefingDetector:SendMessage(playerName, action)
    if not GriefingDetectorDB.enabled then return end

    if (action == "pull" and not GriefingDetectorDB.notifyOnPull) or
       (action == "aggro" and not GriefingDetectorDB.notifyOnAggro) then
        return
    end

    local chatType = (IsInRaid() and "RAID") or (IsInGroup() and "PARTY") or "SAY"

    local messageTemplate = action == "pull" and GriefingDetectorDB.pullMessage or GriefingDetectorDB.aggroMessage
    local message = string.format(messageTemplate, playerName)

    SendChatMessage(message, chatType)

    -- Figyelmeztetés a képernyő közepén
    local roleException = (action == "pull") and self:IsPlayerException(playerName, true) or self:IsPlayerException(playerName, false)
    if not roleException then
        RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo["RAID_WARNING"])
    end

    -- Hangjelzés lejátszása
    if GriefingDetectorDB.playSound then
        PlaySound(SOUNDKIT.RAID_WARNING, "Master")
    end
end
