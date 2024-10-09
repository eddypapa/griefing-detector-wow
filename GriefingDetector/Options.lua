function BossPullNotifier:CreateOptionsPanel()
    -- Fő panel
    local optionsPanel = CreateFrame("Frame", "BossPullNotifierOptions", InterfaceOptionsFramePanelContainer)
    optionsPanel.name = "Boss Pull Notifier"

    -- Cím
    local title = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Boss Pull Notifier Beállítások")

    -- Engedélyezés/letiltás checkbox
    local enableCheckbox = CreateFrame("CheckButton", "BossPullNotifierEnableCheckbox", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    enableCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    enableCheckbox.Text:SetText("AddOn engedélyezése")
    enableCheckbox:SetChecked(BossPullNotifierDB.enabled)

    enableCheckbox:SetScript("OnClick", function(self)
        BossPullNotifierDB.enabled = self:GetChecked()
        if BossPullNotifierDB.enabled then
            BossPullNotifier.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        else
            BossPullNotifier.frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
    end)

    -- Impresszum panel
    local impressumPanel = CreateFrame("Frame", "BossPullNotifierImpressum", InterfaceOptionsFramePanelContainer)
    impressumPanel.name = "Impresszum"
    impressumPanel.parent = "Boss Pull Notifier"

    local impressumTitle = impressumPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    impressumTitle:SetPoint("TOPLEFT", 16, -16)
    impressumTitle:SetText("Boss Pull Notifier Impresszum")

    local impressumText = impressumPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    impressumText:SetPoint("TOPLEFT", impressumTitle, "BOTTOMLEFT", 0, -8)
    impressumText:SetWidth(600)
    impressumText:SetJustifyH("LEFT")
    impressumText:SetText("Az AddOn készítője: YourName\nVerzió: 1.2\nLeírás: Ez az AddOn értesít, ha valaki pullolja vagy aggrózza a bosst.")

    -- Regisztráljuk a paneleket
    InterfaceOptions_AddCategory(optionsPanel)
    InterfaceOptions_AddCategory(impressumPanel)
end