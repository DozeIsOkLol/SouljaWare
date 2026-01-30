-- CreditsTab.lua
local function initCreditsTab(Window, lp, Workspace, TweenService) -- Accept extras safely
    -- Use UI.Icons here — 'UI' is the global from the main script's loadstring
    local CreditsTab = Window:AddTab('Credits', UI.Icons.Info)

CreditsTab:AddParagraph('Developers', 'Script: SouljaWitchSrc\nTester: Aspire\nTesters: Aspire\nKill Aura and Telepots from Neutral (Ive updated them) Make sure to check his script out')
CreditsTab:AddParagraph('Libraries & Asset', 'UI Library: XanBar\nIcons: XanBar')
CreditsTab:AddParagraph('Thanks For Using', 'Thanks for supporting this script!')


    return CreditsTab -- optional, but good practice
end

return initCreditsTab
