-- Kivételkezelés
function BossPullNotifier:IsPlayerException(playerName, roleCheck)
    if UnitIsGroupLeader(playerName) or UnitIsAssistant(playerName) then
        return true
    end

    if roleCheck then
        local role = UnitGroupRolesAssigned(playerName)
        if role == "TANK" then
            return true
        end
    end

    return false
end