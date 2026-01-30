
local HttpService = game:GetService("HttpService")

-- Load Xan UI library
local success, UI = pcall(function()
    return loadstring(game:HttpGet('https://xan.bar/init.lua'))()
end)

if not success or not UI then
    warn("Failed to load XanBar UI library!")
    return nil
end

-- Create main window
local Window = UI.New({
    Title    = "Soulja-Ware",
    Subtitle = "LSRPG:R",  
    Theme    = "Rose",
    Size     = UDim2.new(0, 580, 0, 420),
    ShowUserInfo = true,
})

local Tabs = {
    Player     = Window:AddTab('Player',     UI.Icons.Combat),
    AutoFarm   = Window:AddTab('Auto Farm',  UI.Icons.Target),
    Teleports  = Window:AddTab('Teleports',  UI.Icons.World),
    Misc       = Window:AddTab('Misc',       UI.Icons.Gear),
    Settings   = Window:AddTab('Settings',   UI.Icons.Plugins),
    Credits    = Window:AddTab('Credits',    UI.Icons.Check),
}

return {
    Library = UI,
    Window  = Window,
    Tabs    = Tabs,
}
