for _, mod in ipairs(modules) do
    local success, result = pcall(function()
        local moduleFunc = loadstring(game:HttpGet(baseURL .. mod))()
        -- Pass Window, not UI
        moduleFunc(Window, lp, Workspace, TweenService)
    end)

    if not success then
        warn("Failed to load module:", mod, result)
    end
end

-- CreditsTab.lua
local function initCreditsTab(Window)
    local CreditsTab = Window:AddTab('Credits', Window.Icons.Info)

    CreditsTab:AddSection('Developers')
    CreditsTab:AddLabel('Script & GUI: SouljaWitchSrc')
    CreditsTab:AddLabel('Tester: Aspire')

    CreditsTab:AddSection('Libraries & Assets')
    CreditsTab:AddLabel('UI Library: XanBar')
    CreditsTab:AddLabel('Icons: XanBar')

    CreditsTab:AddSection('Thanks For Using')
    CreditsTab:AddLabel('Thanks for supporting this script!')

    return CreditsTab
end

return initCreditsTab

