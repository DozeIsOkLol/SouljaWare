-- StaffDetection.lua
-- Soulja-Ware Staff & Script Team Detection Module
-- Features: UserId lists, group rank fallback, UI warnings, auto-disable farm, script team online list

local StaffDetection = {}

-- Default config (can be overridden when calling .Init())
StaffDetection.Config = {
    Enabled = true,
    AutoDisableAutoFarm = true,

    -- Core lists (UserIds)
    Devs = {559650993},
    ScriptDevs = {
        129119196465909,
        158212026,
        2958922478,
    },
    Admins = {
        2600490198,
        7102715584,
        559650993,
    },
    Mods = {},
    Testers = {50500, 2440498083},
    ScriptTesters = {},

    -- Group rank fallback (optional)
    GroupId = nil,
    MinAdminRank = 200,
}

-- Internal helpers
local function inTable(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

local function getStaffRole(player, cfg)
    cfg = cfg or StaffDetection.Config

    if inTable(cfg.Devs, player.UserId)           then return "Developer" end
    if inTable(cfg.ScriptDevs, player.UserId)     then return "Script Developer" end
    if inTable(cfg.Admins, player.UserId)         then return "Admin" end
    if inTable(cfg.Mods, player.UserId)           then return "Moderator" end
    if inTable(cfg.Testers, player.UserId)        then return "Tester" end
    if inTable(cfg.ScriptTesters, player.UserId)  then return "Script Tester" end

    if cfg.GroupId then
        local ok, rank = pcall(player.GetRankInGroup, player, cfg.GroupId)
        if ok and rank >= cfg.MinAdminRank then
            return "Staff"
        end
    end

    return nil
end

local function onStaffDetected(player, role, UI, flags)
    if not UI or not player or not role then return end

    local title = "STAFF DETECTED"
    local msg = player.Name .. " joined (" .. role .. ")"
    local color = Color3.fromRGB(255, 75, 85)

    if role == "Script Developer" then
        color = Color3.fromRGB(75, 200, 255)
        title = "SCRIPT DEVELOPER DETECTED"
    elseif role == "Script Tester" then
        color = Color3.fromRGB(255, 200, 0)
        title = "SCRIPT TESTER DETECTED"
    end

    UI.Warning(title, msg)

    -- Auto-disable only non-dev/tester staff
    if flags and cfg.AutoDisableAutoFarm and
       not (role == "Script Developer" or role == "Script Tester") then
        flags.AutoFarm          = false
        flags.TeleportMode      = false
        flags.AutoAttack        = false
        flags.autoEquipEnabled  = false
        -- You can add more flags here later (KillAura, etc.)
    end
end

-- Main initialization function
function StaffDetection.Init(UI, flags, customConfig)
    if not UI then
        warn("[StaffDetection] UI object required")
        return
    end

    local cfg = customConfig or StaffDetection.Config
    if not cfg.Enabled then return end

    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer

    -- Scan already connected players
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            local role = getStaffRole(p, cfg)
            if role then
                onStaffDetected(p, role, UI, flags)
            end
        end
    end

    -- New player joins
    Players.PlayerAdded:Connect(function(p)
        task.wait(1.2) -- slightly longer delay for data to load
        if not cfg.Enabled or p == lp then return end

        local role = getStaffRole(p, cfg)
        if role then
            onStaffDetected(p, role, UI, flags)
        end
    end)

    print("[StaffDetection] Active")
end

-- Settings tab integration (toggle + script team paragraph)
function StaffDetection.AddToSettingsTab(SettingsTab, UI)
    if not SettingsTab or not UI then return end

    SettingsTab:AddSection("Safety")

    SettingsTab:AddToggle("Staff Detection", {Default = StaffDetection.Config.Enabled}, function(v)
        StaffDetection.Config.Enabled = v
    end)

    SettingsTab:AddToggle("Disable Auto Farm on Staff", {Default = StaffDetection.Config.AutoDisableAutoFarm}, function(v)
        StaffDetection.Config.AutoDisableAutoFarm = v
    end)

    -- Script team online paragraph
    local teamPara = SettingsTab:AddParagraph("Script Team Online", "None")

    local function updateTeamList()
        local devs = {}
        local testers = {}

        for _, p in ipairs(game.Players:GetPlayers()) do
            local role = getStaffRole(p)
            if role == "Script Developer" then
                table.insert(devs, p.Name)
            elseif role == "Script Tester" then
                table.insert(testers, p.Name)
            end
        end

        local text = ""
        if #devs > 0 then
            text = text .. "Developers:\n" .. table.concat(devs, ", ") .. "\n"
        end
        if #testers > 0 then
            text = text .. "Testers:\n" .. table.concat(testers, ", ") .. "\n"
        end
        teamPara:SetText(text == "" and "None" or text)
    end

    -- Connections
    game.Players.PlayerAdded:Connect(updateTeamList)
    game.Players.PlayerRemoving:Connect(updateTeamList)

    -- Periodic refresh (in case roles change somehow)
    task.spawn(function()
        while task.wait(4) do
            updateTeamList()
        end
    end)

    -- Initial update
    updateTeamList()
end

-- Public helpers
StaffDetection.GetRole = getStaffRole
StaffDetection.IsStaff = function(player) return getStaffRole(player) ~= nil end

return StaffDetection
