-- Üzenetküldés
function BossPullNotifier:SendMessage(playerName, action)
    if not BossPullNotifierDB.enabled then return end

    local chatType = (IsInRaid() and "RAID") or (IsInGroup() and "PARTY") or "SAY"

    local message = string.format("%s felhívta a boss figyelmét! (%s)", playerName, action)
    SendChatMessage(message, chatType)

    -- Figyelmeztetés a képernyő közepén
    local roleException = (action == "pull") and self:IsPlayerException(playerName, true) or self:IsPlayerException(playerName, false)
    if not roleException then
        RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo["RAID_WARNING"])
    end
end