local UIStruct = {}

function UIStruct.create(TESTER_MODE)
    local UI = loadstring(game:HttpGet('https://xan.bar/init.lua'))()
    local Window = UI.New({
        Title = "Soulja-Ware",
        Subtitle = TESTER_MODE and "LSRPG:R (TESTER BUILD)" or "LSRPG:R (RELEASE)",
        Theme = "Rose",
        Size = UDim2.new(0,580,0,420),
        ShowUserInfo=true
    })

    loadstring(game:HttpGet('https://raw.githubusercontent.com/DozeIsOkLol/LibWare/refs/heads/main/games/Misc/DiscordInvter.lua'))()

    local Tabs = {
        PlayerTab = Window:AddTab('Player', UI.Icons.Combat),
        AutoFarmTab = Window:AddTab('Auto Farm', UI.Icons.Target),
        TeleportsTab = Window:AddTab('Teleports', UI.Icons.World),
        MiscTab = Window:AddTab('Misc', UI.Icons.Gear),
        SettingsTab = Window:AddTab('Settings', UI.Icons.Plugins),
        CreditsTab = Window:AddTab('Credits', UI.Icons.Check)
    }

    return UI, Window, Tabs
end

return UIStruct
