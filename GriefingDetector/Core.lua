-- Globális táblázat létrehozása
GriefingDetector = {}

-- Alapértelmezett beállítások
GriefingDetector.defaults = {
    enabled = true,
    playSound = true,
    notifyOnPull = true,
    notifyOnAggro = true,
    pullMessage = "%s pullolta a bosst!",
    aggroMessage = "%s aggrózta a bosst!",
}

-- Lokalizáció betöltése
local locale = GetLocale()
local L = {}

if locale == "deDE" then
    -- Német
    GriefingDetector.L = L
elseif locale == "frFR" then
    -- Francia
    GriefingDetector.L = L
elseif locale == "esES" or locale == "esMX" then
    -- Spanyol
    GriefingDetector.L = L
elseif locale == "huHU" then
    -- Magyar
    GriefingDetector.L = L
else
    -- Alapértelmezett (angol)
    GriefingDetector.L = L
end

-- Beállítások betöltése
function GriefingDetector:LoadSettings()
    if not GriefingDetectorDB then
        GriefingDetectorDB = {}
    end
    -- Alapértelmezett beállítások alkalmazása
    for k, v in pairs(self.defaults) do
        if GriefingDetectorDB[k] == nil then
            GriefingDetectorDB[k] = v
        end
    end
end

-- Frame létrehozása
GriefingDetector.frame = CreateFrame("Frame")
GriefingDetector.frame:RegisterEvent("PLAYER_LOGIN")
GriefingDetector.frame:RegisterEvent("ENCOUNTER_START")
GriefingDetector.frame:RegisterEvent("ENCOUNTER_END")

GriefingDetector.bossEncounter = false
GriefingDetector.bossIDs = {}
