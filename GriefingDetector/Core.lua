-- Alapértelmezett beállítások
BossPullNotifier = {}
BossPullNotifier.defaults = {
    enabled = true,
}

-- Beállítások betöltése
function BossPullNotifier:LoadSettings()
    if not BossPullNotifierDB then
        BossPullNotifierDB = {}
    end
    -- Alapértelmezett beállítások alkalmazása
    for k, v in pairs(self.defaults) do
        if BossPullNotifierDB[k] == nil then
            BossPullNotifierDB[k] = v
        end
    end
end

-- Frame létrehozása
BossPullNotifier.frame = CreateFrame("Frame")
BossPullNotifier.frame:RegisterEvent("PLAYER_LOGIN")
BossPullNotifier.frame:RegisterEvent("ENCOUNTER_START")
BossPullNotifier.frame:RegisterEvent("ENCOUNTER_END")

BossPullNotifier.bossEncounter = false
BossPullNotifier.bossIDs = {}