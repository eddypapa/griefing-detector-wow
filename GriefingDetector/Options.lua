-- Options.lua
local L = GriefingDetector.L

function GriefingDetector:CreateOptionsPanel()
    -- Fő panel
    local optionsPanel = CreateFrame("Frame", "GriefingDetectorOptions", InterfaceOptionsFramePanelContainer)
    optionsPanel.name = L["ADDON_NAME"]

    -- Cím
    local title = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(L["ADDON_NAME"] .. " " .. L["OPTIONS"])

    -- Engedélyezés/letiltás checkbox
    local enableCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    enableCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    enableCheckbox.Text:SetText(L["ENABLED"])
    enableCheckbox:SetChecked(GriefingDetectorDB.enabled)

    enableCheckbox:SetScript("OnClick", function(self)
        GriefingDetectorDB.enabled = self:GetChecked()
        if GriefingDetectorDB.enabled then
            GriefingDetector.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        else
            GriefingDetector.frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
    end)

    -- Hangjelzések checkbox
    local playSoundCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    playSoundCheckbox:SetPoint("TOPLEFT", enableCheckbox, "BOTTOMLEFT", 0, -10)
    playSoundCheckbox.Text:SetText(L["PLAY_SOUND"])
    playSoundCheckbox:SetChecked(GriefingDetectorDB.playSound)
    playSoundCheckbox:SetScript("OnClick", function(self)
        GriefingDetectorDB.playSound = self:GetChecked()
    end)

    -- Értesítés pull esetén
    local notifyOnPullCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    notifyOnPullCheckbox:SetPoint("TOPLEFT", playSoundCheckbox, "BOTTOMLEFT", 0, -10)
    notifyOnPullCheckbox.Text:SetText(L["NOTIFY_ON_PULL"])
    notifyOnPullCheckbox:SetChecked(GriefingDetectorDB.notifyOnPull)
    notifyOnPullCheckbox:SetScript("OnClick", function(self)
        GriefingDetectorDB.notifyOnPull = self:GetChecked()
    end)

    -- Értesítés aggro esetén
    local notifyOnAggroCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    notifyOnAggroCheckbox:SetPoint("TOPLEFT", notifyOnPullCheckbox, "BOTTOMLEFT", 0, -10)
    notifyOnAggroCheckbox.Text:SetText(L["NOTIFY_ON_AGGRO"])
    notifyOnAggroCheckbox:SetChecked(GriefingDetectorDB.notifyOnAggro)
    notifyOnAggroCheckbox:SetScript("OnClick", function(self)
        GriefingDetectorDB.notifyOnAggro = self:GetChecked()
    end)

    -- Pull üzenet szerkesztőmező
    local pullMessageEditBox = CreateFrame("EditBox", nil, optionsPanel, "InputBoxTemplate")
    pullMessageEditBox:SetSize(300, 25)
    pullMessageEditBox:SetPoint("TOPLEFT", notifyOnAggroCheckbox, "BOTTOMLEFT", 0, -30)
    pullMessageEditBox:SetAutoFocus(false)
    pullMessageEditBox:SetText(GriefingDetectorDB.pullMessage)

    local pullMessageLabel = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    pullMessageLabel:SetPoint("BOTTOMLEFT", pullMessageEditBox, "TOPLEFT", 0, 5)
    pullMessageLabel:SetText(L["PULL_MESSAGE"])

    pullMessageEditBox:SetScript("OnEnterPressed", function(self)
        GriefingDetectorDB.pullMessage = self:GetText()
        self:ClearFocus()
    end)

    -- Aggro üzenet szerkesztőmező
    local aggroMessageEditBox = CreateFrame("EditBox", nil, optionsPanel, "InputBoxTemplate")
    aggroMessageEditBox:SetSize(300, 25)
    aggroMessageEditBox:SetPoint("TOPLEFT", pullMessageEditBox, "BOTTOMLEFT", 0, -30)
    aggroMessageEditBox:SetAutoFocus(false)
    aggroMessageEditBox:SetText(GriefingDetectorDB.aggroMessage)

    local aggroMessageLabel = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    aggroMessageLabel:SetPoint("BOTTOMLEFT", aggroMessageEditBox, "TOPLEFT", 0, 5)
    aggroMessageLabel:SetText(L["AGGRO_MESSAGE"])

    aggroMessageEditBox:SetScript("OnEnterPressed", function(self)
        GriefingDetectorDB.aggroMessage = self:GetText()
        self:ClearFocus()
    end)

    -- Alaphelyzetbe állítás gomb
    local resetButton = CreateFrame("Button", nil, optionsPanel, "UIPanelButtonTemplate")
    resetButton:SetSize(120, 25)
    resetButton:SetPoint("TOPLEFT", aggroMessageEditBox, "BOTTOMLEFT", 0, -20)
    resetButton:SetText(L["DEFAULT"])
    resetButton:SetScript("OnClick", function()
        -- Beállítások visszaállítása
        GriefingDetectorDB = CopyTable(GriefingDetector.defaults)
        -- Frissítjük az opciós panel elemeit
        enableCheckbox:SetChecked(GriefingDetectorDB.enabled)
        playSoundCheckbox:SetChecked(GriefingDetectorDB.playSound)
        notifyOnPullCheckbox:SetChecked(GriefingDetectorDB.notifyOnPull)
        notifyOnAggroCheckbox:SetChecked(GriefingDetectorDB.notifyOnAggro)
        pullMessageEditBox:SetText(GriefingDetectorDB.pullMessage)
        aggroMessageEditBox:SetText(GriefingDetectorDB.aggroMessage)
        -- Üzenet a felhasználónak
        print(L["SETTINGS_RESET"])
    end)

    -- Fül létrehozása az Impresszumnak
    local impressumPanel = CreateFrame("Frame", "GriefingDetectorImpressum", InterfaceOptionsFramePanelContainer)
    impressumPanel.name = L["IMPRESSUM"]
    impressumPanel.parent = L["ADDON_NAME"]

    local impressumTitle = impressumPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    impressumTitle:SetPoint("TOPLEFT", 16, -16)
    impressumTitle:SetText(L["ADDON_NAME"] .. " " .. L["IMPRESSUM"])

    local impressumText = impressumPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    impressumText:SetPoint("TOPLEFT", impressumTitle, "BOTTOMLEFT", 0, -8)
    impressumText:SetWidth(600)
    impressumText:SetJustifyH("LEFT")
    impressumText:SetText(L["IMPRESSUM_TEXT"])

    -- Regisztráljuk a paneleket
    InterfaceOptions_AddCategory(optionsPanel)
    InterfaceOptions_AddCategory(impressumPanel)
end
