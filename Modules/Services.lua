-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Soulja-Ware / Common Services & Globals 
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local TweenService       = game:GetService("TweenService")
local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local Workspace          = game:GetService("Workspace")
local GuiService         = game:GetService("GuiService")
local VirtualUser        = game:GetService("VirtualUser")
local HttpService        = game:GetService("HttpService")
local StarterGui         = game:GetService("StarterGui")
local StarterPlayer      = game:GetService("StarterPlayer")
local Lighting           = game:GetService("Lighting")
local Debris             = game:GetService("Debris")
local SoundService       = game:GetService("SoundService")
local ContentProvider    = game:GetService("ContentProvider")
local TeleportService    = game:GetService("TeleportService")
local ContextActionService = game:GetService("ContextActionService")
local TextService        = game:GetService("TextService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local lp          = LocalPlayer  
local PlayerGui   = lp:WaitForChild("PlayerGui", 10)
local Backpack    = lp:WaitForChild("Backpack", 8)
local Character   = lp.Character or lp.CharacterAdded:Wait()
local Humanoid    = Character:WaitForChild("Humanoid", 5)
local HRP         = Character:WaitForChild("HumanoidRootPart", 5) 
local Mouse       = lp:GetMouse()

local Camera      = Workspace.CurrentCamera
local CurrentCam  = Camera 

local is_krnl     = KRNL_LOADED and true or false
local is_fluxus   = fluxus  and true or false
local has_rconsole= rconsoleprint and true or false
local has_http    = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)

local UDim2_new   = UDim2.new
local Vector2_new = Vector2.new
local Vector3_new = Vector3.new
local CFrame_new  = CFrame.new
local Color3_new  = Color3.new
local BrickColor_new = BrickColor.new
local Instance_new = Instance.new
local task        = task  
local table       = table 
local math        = math
local string      = string
local pairs       = pairs
local ipairs      = ipairs
local pcall       = pcall
local tick        = tick     
local wait        = task.wait 

local fireclickdetector = fireclickdetector or function(...) end 
local fireproximityprompt = fireproximityprompt or function(...) end
local firesignal    = firesignal    or function(...) end
local firetouchinterest = firetouchinterest or function(...) end


-- Anti-idle 
if UserInputService then
    task.spawn(function()
        while true do
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new()) 
            task.wait(240) 
        end
    end)
end
