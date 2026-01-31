-- PlayerSpy.lua
-- Soulja-Ware Misc Tab: Player Spy (stats + backpack viewer)
-- Modularized for easy GitHub updates

local PlayerSpy = {}

-- Internal state (private)
local selectedPlayer = nil
local statsParagraph = nil
local backpackParagraph = nil
local playerDropdown = nil

-- Helpers
local function getPlayerStatsString(p)
    if not p or not p.Parent then
        return 'No player selected'
    end
    
    local ls = p:FindFirstChild('leaderstats')
    local rb = p:FindFirstChild('Rebirth')
    
    local function val(obj)
        return obj and tostring(obj.Value) or '?'
    end
    
    return ("%s's Stats:\nLvl: %s\nRebirth: %s\nGold: %s\nXP: %s"):format(
        p.Name,
        val(ls and ls.Lvl),
        val(rb),
        val(ls and ls.Gold),
        val(ls and ls.XP)
    )
end

local function getBackpackString(p)
    if not p or not p.Parent then
        return 'Player not available'
    end
    
    local backpack = p:FindFirstChild('Backpack')
    if not backpack then
        return p.Name .. ' has no Backpack.'
    end
    
    local lines = {p.Name .. "'s Backpack:"}
    local count = 0
    
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA('Tool') then
            count += 1
            table.insert(lines, '- ' .. tool.Name)
        end
    end
    
    if count == 0 then
        table.insert(lines, '(Empty)')
    end
    
    return table.concat(lines, '\n')
end

local function getPlayerNames()
    local names = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        table.insert(names, p.Name)
    end
    table.sort(names)
    return names
end

-- Refresh dropdown values
local function refreshDropdown()
    if playerDropdown and playerDropdown.SetValues then
        playerDropdown:SetValues(getPlayerNames())
    end
end

-- Periodic update for selected player
local function startPeriodicUpdate()
    task.spawn(function()
        while task.wait(3) do
            if selectedPlayer and selectedPlayer.Parent then
                if statsParagraph then
                    statsParagraph:SetText(getPlayerStatsString(selectedPlayer))
                end
                if backpackParagraph then
                    backpackParagraph:SetText(getBackpackString(selectedPlayer))
                end
            end
        end
    end)
end

-- Main setup function: adds everything to MiscTab
function PlayerSpy.Setup(MiscTab)
    if not MiscTab then
        warn("[PlayerSpy] MiscTab not provided")
        return
    end
    
    MiscTab:AddSection('Player Spy')
    
    statsParagraph = MiscTab:AddParagraph('Selected Player Stats', 'Select a player...')
    backpackParagraph = MiscTab:AddParagraph('Backpack Contents', 'Loading...')
    
    playerDropdown = MiscTab:AddDropdown('Select Player', getPlayerNames(), function(name)
        selectedPlayer = game.Players:FindFirstChild(name)
        if selectedPlayer then
            statsParagraph:SetText(getPlayerStatsString(selectedPlayer))
            backpackParagraph:SetText(getBackpackString(selectedPlayer))
        else
            statsParagraph:SetText('Player not found')
            backpackParagraph:SetText('Player not found')
        end
    end)
    
    -- Refresh on player join/leave
    game.Players.PlayerAdded:Connect(refreshDropdown)
    game.Players.PlayerRemoving:Connect(refreshDropdown)
    
    -- Start live refresh loop
    startPeriodicUpdate()
    
    -- Initial refresh
    refreshDropdown()
    
    print("[PlayerSpy] Setup complete in Misc Tab")
end

return PlayerSpy
