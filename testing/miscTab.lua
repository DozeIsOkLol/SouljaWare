-- miscTab.lua
local function initMiscTab(UI, lp, RunService)
    local MiscTab = UI:AddTab('Misc', UI.Icons.Settings)

    MiscTab:AddSection('Character')
    local noclipEnabled = false
    MiscTab:AddToggle('Noclip', { Default = false }, function(v)
        noclipEnabled = v
        if v then
            local conn
            conn = RunService.Stepped:Connect(function()
                if noclipEnabled and lp.Character then
                    for _, part in ipairs(lp.Character:GetDescendants()) do
                        if part:IsA('BasePart') then
                            part.CanCollide = false
                        end
                    end
                else
                    conn:Disconnect()
                end
            end)
        end
    end)

    MiscTab:AddSection('Fun')
    MiscTab:AddButton('Jump High', function()
        if lp.Character and lp.Character:FindFirstChild('Humanoid') then
            lp.Character.Humanoid.JumpPower = 150
            UI.Info('Jump Boost', 'Jump Power set to 150')
        end
    end)
    MiscTab:AddButton('Reset Jump', function()
        if lp.Character and lp.Character:FindFirstChild('Humanoid') then
            lp.Character.Humanoid.JumpPower = 50
            UI.Info('Jump Reset', 'Jump Power reset to 50')
        end
    end)

    return MiscTab
end

return initMiscTab
