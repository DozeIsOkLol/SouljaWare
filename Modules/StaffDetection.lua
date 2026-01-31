-- StaffDetection.lua

local StaffDetection = {}

-- Config table (edit here or override when calling .Init())
StaffDetection.Config = {
    Enabled = true,
    AutoDisableAutoFarm = true,
    
    -- UserId lists (fastest & most reliable method)
    Devs = {
        559650993,  -- example dev
    },
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
    Mods = { -- add mods here
    },
    Testers = {
        50500,
        2440498083,
    },
    ScriptTesters = { -- add script testers here
    },
    
    -- Optional group rank check (slower, rate-limited by Roblox)
    GroupId = nil,          -- set to your group ID or nil to disable
    MinAdminRank = 200,     -- minimum rank to count as staff
}

-- Helper: check if value exists in table
local function inTable(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

-- Get staff role for a player
local function getStaffRole(player, config)
    config = config or StaffDetection.Config
    
    if inTable(config.Devs, player.UserId) then
        return "Developer"
    end
    if inTable(config.ScriptDevs, player.UserId) then
        return "Script Developer"
    end
    if inTable(config.Admins, player.UserId) then
        return "Admin"
    end
    if inTable(config.Mods, player.UserId) then
        return "Moderator"
    end
    if inTable(config.Testers, player.UserId) then
        return "Tester"
    end
    if inTable(config.ScriptTesters, player.UserId) then
        return "Script Tester"
    end
    
    -- Group rank fallback (only if GroupId set)
    if config.GroupId then
        local success, rank = pcall(function()
            return player:GetRankInGroup(config.GroupId)
        end)
        if success and rank >= config.MinAdminRank then
            return "Staff"
        end
    end
    
    return nil
end

-- Called when staff is detected
local function onStaffDetected(player, role, UI, flags)
    if not UI then return end  -- safety
    
    local title = "STAFF DETECTED"
    local msg   = player.Name .. " joined (" .. role .. ")"
    local color = Color3.fromRGB(255, 75, 85)  -- red default
    
    if role == "Script Developer" then
        color = Color3.fromRGB(75, 200, 255)  -- blue
        title = "SCRIPT DEVELOPER DETECTED"
    elseif role == "Script Tester" then
        color = Color3.fromRGB(255, 200, 0)   -- yellow
        title = "SCRIPT TESTER DETECTED"
    end
    
    -- Show UI notification (XanBar style)
    UI.Warning(title, msg)
    
    -- Auto-disable farming (only for non-dev/tester staff if enabled)
    if config.AutoDisableAutoFarm and not (role == "Script Developer" or role == "Script Tester") then
        if flags then
            flags.AutoFarm       = false
            flags.TeleportMode   = false
            flags.AutoAttack     = false
            flags.autoEquipEnabled = false
        end
        -- Optional: add more disables here (e.g. KillAura = false)
    end
end

-- Initialize detection: scan current players + listen for new ones
function StaffDetection.Init(UI, flags, customConfig)
    if not UI then
        warn("[StaffDetection] UI library required but not provided")
        return
    end
    
    local config = customConfig or StaffDetection.Config
    if not config.Enabled then return end
    
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    
    -- Scan existing players
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            local role = getStaffRole(p, config)
            if role then
                onStaffDetected(p, role, UI, flags)
            end
        end
    end
    
    -- Listen for new players
    Players.PlayerAdded:Connect(function(p)
        task.wait(1)  -- small delay to ensure player data loaded
        if not config.Enabled or p == lp then return end
        
        local role = getStaffRole(p, config)
        if role then
            onStaffDetected(p, role, UI, flags)
        end
    end)
    
    print("[StaffDetection] Initialized – monitoring for staff")
end

-- Public API
StaffDetection.GetRole = getStaffRole          -- for manual checks
StaffDetection.IsStaff = function(player) return getStaffRole(player) ~= nil end

return StaffDetection
