-- teleportsTab.lua
local function initTeleportsTab(UI, lp, Workspace)
    local TeleportsTab = UI:AddTab('Teleports', UI.Icons.Teleport)

    -- Example Teleport Locations
    local teleportLocations = {
        ["Spawn"] = Vector3.new(0, 5, 0),
        ["Dungeon"] = Vector3.new(100, 5, -50),
        ["Boss Room"] = Vector3.new(250, 10, 150)
    }

    TeleportsTab:AddSection('Teleport to Location')
    for name, position in pairs(teleportLocations) do
        TeleportsTab:AddButton(name, function()
            local char = lp.Character
            if char and char:FindFirstChild('HumanoidRootPart') then
                char.HumanoidRootPart.CFrame = CFrame.new(position)
                UI.Success('Teleported', 'Moved to '..name)
            end
        end)
    end

    -- Waypoint Teleport (using Mouse)
    TeleportsTab:AddSection('Custom Teleport')
    local mouse = lp:GetMouse()
    TeleportsTab:AddButton('Teleport to Mouse', function()
        local char = lp.Character
        if char and char:FindFirstChild('HumanoidRootPart') then
            char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            UI.Success('Teleported', 'Moved to mouse location')
        end
    end)

    return TeleportsTab
end

return initTeleportsTab
