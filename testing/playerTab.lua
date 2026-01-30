-- playerTab.lua
local function initPlayerTab(UI, lp, ReplicatedStorage)
    local PlayerTab = UI:AddTab('Player', UI.Icons.Combat)
    
    local upgStat = ReplicatedStorage:WaitForChild('upgStat', 5)
    local ResetPoints = ReplicatedStorage:WaitForChild('ResetPoints', 5)
    local DEF_MAX = 50
    local GOLD_MAX = 100 -- default; change if gamepass check is needed
    local autoFlags = { HPUP = false, PHYSUP = false, DEFUP = false, GOLDUP = false }

    PlayerTab:AddSection('Upgrade Stats')
    PlayerTab:AddToggle('Auto Health (HPUP)', {Default = false}, function(v) autoFlags.HPUP = v end)
    PlayerTab:AddToggle('Auto Physical Damage (PHYSUP)', {Default = false}, function(v) autoFlags.PHYSUP = v end)
    PlayerTab:AddToggle('Auto Defense (DEFUP)', {Default = false}, function(v) autoFlags.DEFUP = v end)
    PlayerTab:AddToggle('Auto Gold Gained (GOLDUP)', {Default = false}, function(v) autoFlags.GOLDUP = v end)

    local function isMaxed(statName)
        local statObj = lp:FindFirstChild(statName)
        if not statObj then return true end
        if statName == 'DEFUP' then return statObj.Value >= DEF_MAX end
        if statName == 'GOLDUP' then return statObj.Value >= GOLD_MAX end
        return false
    end

    local function getEnabledStats()
        local enabled = {}
        for statName, flag in pairs(autoFlags) do
            if flag and not isMaxed(statName) then
                table.insert(enabled, statName)
            end
        end
        return enabled
    end

    PlayerTab:AddButton('Max Upgrade (selected stats)', function()
        local statPoints = lp:FindFirstChild('StatPoints')
        if not statPoints or statPoints.Value <= 0 then return UI.Warning('No Stat Points!', 'You have no points to spend') end

        local enabledStats = getEnabledStats()
        if #enabledStats == 0 then return UI.Warning('No Stats Selected!', 'Toggle some non-maxed stats') end

        local pointsPerStat = math.floor(statPoints.Value / #enabledStats)
        local remainder = statPoints.Value % #enabledStats

        for i, statName in ipairs(enabledStats) do
            local pointsToSpend = pointsPerStat + ((i <= remainder) and 1 or 0)
            local statObj = lp:FindFirstChild(statName)
            if statObj then
                for _ = 1, pointsToSpend do
                    if isMaxed(statName) then break end
                    upgStat:FireServer(statObj)
                end
            end
        end

        UI.Success('Upgraded!', 'Spent all points equally on selected stats')
    end)

    if ResetPoints then
        PlayerTab:AddDangerButton('Reset All Points', function()
            ResetPoints:FireServer(lp)
        end)
    end

    PlayerTab:AddSection('Automation')
    local autoEquipEnabled = false
    PlayerTab:AddToggle('Auto Equip Best Weapon', {Default = false}, function(value)
        autoEquipEnabled = value
        if value then
            task.spawn(function()
                while autoEquipEnabled do
                    task.wait(1)
                    local char = lp.Character or lp.CharacterAdded:Wait()
                    local Humanoid, Backpack = char:FindFirstChild('Humanoid'), lp:FindFirstChild('Backpack')
                    if not (Humanoid and Backpack) then continue end

                    local BestTool = char:FindFirstChildOfClass('Tool') or Backpack:FindFirstChildOfClass('Tool')
                    local BestDmg = BestTool and BestTool:FindFirstChild('Conf') and BestTool.Conf:FindFirstChild('MaxDmg')
                    for _, v in ipairs(Backpack:GetChildren()) do
                        local MaxDmg = v:FindFirstChild('Conf') and v.Conf:FindFirstChild('MaxDmg')
                        if MaxDmg and BestDmg and BestDmg.Value < MaxDmg.Value then
                            BestTool, BestDmg = v, MaxDmg
                        end
                    end

                    if BestTool and Humanoid then
                        Humanoid:UnequipTools()
                        Humanoid:EquipTool(BestTool)
                    end
                end
            end)
        end
    end)

    -- Auto Clicker
    PlayerTab:AddSection('Movement & Click')
    local autoClickerEnabled, clickConnection = false, nil
    local RunService = game:GetService('RunService')
    PlayerTab:AddKeybind('Auto Clicker Toggle', { Default = Enum.KeyCode.E }, function()
        autoClickerEnabled = not autoClickerEnabled
        if autoClickerEnabled then
            UI.Success('Auto Clicker', 'ON - spamming left click')
            clickConnection = RunService.RenderStepped:Connect(function()
                if autoClickerEnabled then
                    mouse1click()
                    task.wait(0.035)
                end
            end)
        else
            UI.Info('Auto Clicker', 'OFF')
            if clickConnection then clickConnection:Disconnect() clickConnection = nil end
        end
    end)

    return PlayerTab
end

return initPlayerTab
