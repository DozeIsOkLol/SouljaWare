-- CreditsTab.lua
local function initCreditsTab(Window, lp, Workspace, TweenService)  -- Accept extras safely
    -- Use UI.Icons here — UI is the global from the main script
    local CreditsTab = Window:AddTab('Credits', UI.Icons.Info)

    CreditsTab:AddSection('Developers')
    CreditsTab:AddLabel('Script & GUI: SouljaWitchSrc')
    CreditsTab:AddLabel('Tester: Aspire')

    CreditsTab:AddSection('Libraries & Assets')
    CreditsTab:AddLabel('UI Library: XanBar')
    CreditsTab:AddLabel('Icons: XanBar')

    CreditsTab:AddSection('Thanks For Using')
    CreditsTab:AddLabel('Thanks for supporting this script!')

    return CreditsTab  -- optional
end

return initCreditsTab
