local Staff = {}
local Players = game:GetService("Players")

Staff.Config = {
    Enabled = true,
    AutoDisableAutoFarm = true,
    Devs = {559650993},
    ScriptDevs = {129119196465909,158212026,2958922478},
    Admins = {2600490198,7102715584,559650993},
    Testers = {50500,2440498083},
    ScriptTesters = {},
    Mods = {},
    GroupId = nil,
    MinAdminRank = 200,
}

local function inTable(tbl,val)
    for _,v in ipairs(tbl) do if v==val then return true end end
    return false
end

function Staff.getRole(player)
    local c = Staff.Config
    if inTable(c.Devs,player.UserId) then return "Developer" end
    if inTable(c.ScriptDevs,player.UserId) then return "Script Developer" end
    if inTable(c.Admins,player.UserId) then return "Admin" end
    if inTable(c.Mods,player.UserId) then return "Moderator" end
    if inTable(c.Testers,player.UserId) then return "Tester" end
    if inTable(c.ScriptTesters,player.UserId) then return "Script Tester" end
    if c.GroupId then
        local ok, rank = pcall(function() return player:GetRankInGroup(c.GroupId) end)
        if ok and rank >= c.MinAdminRank then return "Staff" end
    end
    return nil
end

function Staff.onDetected(player,role,UI)
    UI.Warning(role.." Detected", player.Name.." joined ("..role..")")
    if Staff.Config.AutoDisableAutoFarm and not (role=="Script Developer" or role=="Script Tester") then
        _G.AutoFarm=false
        _G.TeleportMode=false
        _G.AutoAttack=false
        _G.autoEquipEnabled=false
    end
end

function Staff.init(UI)
    local lp = Players.LocalPlayer
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=lp then
            local role = Staff.getRole(p)
            if role then Staff.onDetected(p,role,UI) end
        end
    end
    Players.PlayerAdded:Connect(function(p)
        task.wait(1)
        if not Staff.Config.Enabled or p==lp then return end
        local role = Staff.getRole(p)
        if role then Staff.onDetected(p,role,UI) end
    end)
end

return Staff
