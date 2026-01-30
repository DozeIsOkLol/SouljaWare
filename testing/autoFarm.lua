-- autoFarm.lua
local function initAutoFarmTab(UI, lp, Workspace, TweenService)
    local AutoFarmTab = UI:AddTab('Auto Farm', UI.Icons.Target)

    -- Variables
    local AutoFarm, TeleportMode, AutoAttack, ShowCircle, ShowHighlights, UseTweenTeleport = false, false, false, false, false, true
    local FollowBehindDistance, VerticalOffset, DetectRange, StopDistance = 4, 1.5, 25, 3.5
    local KillAura, KillAuraRange, KillAuraDelay, KillAuraTimer = false, 25, 0.05, 0
    local MinDelay, MaxDelay, LastAttack = 0.1, 0.3, 0
    local ActiveTween

    local VirtualUser = game:GetService('VirtualUser')
    local RunService = game:GetService('RunService')

    -- Range Part
    local RangePart = Instance.new('Part')
    RangePart.Name = "SW_Range"
    RangePart.Anchored = true
    RangePart.CanCollide = false
    RangePart.Transparency = 0.6
    RangePart.Material = Enum.Material.Neon
    RangePart.Color = Color3.fromRGB(255, 75, 85)
    RangePart.Shape = Enum.PartType.Cylinder
    RangePart.Size = Vector3.new(0.2, DetectRange * 2, DetectRange * 2)
    RangePart.Parent = workspace

    -- AutoFarm Tab UI
    AutoFarmTab:AddSection("Combat")
    AutoFarmTab:AddToggle("Auto Farm", {Default = false}, function(v) AutoFarm = v end)
    AutoFarmTab:AddToggle("Teleport Mode", {Default = false}, function(v) TeleportMode = v end)
    AutoFarmTab:AddToggle("Auto Attack", {Default = false}, function(v) AutoAttack = v end)

    AutoFarmTab:AddSection("Kill Aura")
    AutoFarmTab:AddToggle("Kill Aura", { Default = false }, function(v) KillAura = v end)
    AutoFarmTab:AddSlider("Kill Aura Range", { Min = 5, Max = 60, Default = KillAuraRange, Suffix = " studs" }, function(v) KillAuraRange = v end)

    AutoFarmTab:AddSection("Visual")
    AutoFarmTab:AddToggle("Show Range Circle", {Default = false}, function(v) ShowCircle = v end)
    AutoFarmTab:AddToggle("Enemy Highlight", {Default = false}, function(v) ShowHighlights = v end)
    AutoFarmTab:AddSlider("Range Circle Size", { Min = 10, Max = 100, Default = DetectRange, Suffix = " studs" }, function(v) DetectRange = v end)

    AutoFarmTab:AddSection("Teleport Safety")
    AutoFarmTab:AddToggle("Tween Teleport (Safe)", {Default = true}, function(v) UseTweenTeleport = v end)
    AutoFarmTab:AddSlider("Teleport Speed", { Min = 40, Max = 150, Default = 80, Suffix = " studs/s" }, function(v) end)
    AutoFarmTab:AddSlider("Behind Distance", { Min = 1, Max = 15, Default = FollowBehindDistance, Suffix = " studs" }, function(v) FollowBehindDistance = v end)

    AutoFarmTab:AddSection("Targeting")
    AutoFarmTab:AddDropdown("Target Mode", {"Nearest","Lowest HP","Strongest"}, function(v) end)

    return AutoFarmTab
end

return initAutoFarmTab
