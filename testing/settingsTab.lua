-- settingsTab.lua
local function initSettingsTab(UI)
    local SettingsTab = UI:AddTab('Settings', UI.Icons.Settings)

    SettingsTab:AddSection('UI Settings')
    SettingsTab:AddToggle('Dark Mode', { Default = true }, function(v)
        if v then
            UI:SetTheme('Dark')
        else
            UI:SetTheme('Default')
        end
    end)
    SettingsTab:AddSlider('UI Scale', { Min = 0.5, Max = 2, Default = 1, Suffix = 'x' }, function(v)
        UI:SetScale(v)
    end)

    SettingsTab:AddSection('Performance')
    SettingsTab:AddToggle('Hide UI', { Default = false }, function(v)
        UI:ToggleVisibility(not v)
    end)

    return SettingsTab
end

return initSettingsTab
