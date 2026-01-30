-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Soulja-Ware / Common Services & Globals 
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Core Roblox Services (most used in exploits / UI / farming scripts)
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

-- Player & Character shortcuts (very common)
local LocalPlayer = Players.LocalPlayer
local lp          = LocalPlayer  -- short alias everyone uses
local PlayerGui   = lp:WaitForChild("PlayerGui", 10)
local Backpack    = lp:WaitForChild("Backpack", 8)
local Character   = lp.Character or lp.CharacterAdded:Wait()
local Humanoid    = Character:WaitForChild("Humanoid", 5)
local HRP         = Character:WaitForChild("HumanoidRootPart", 5)  -- RootPart shortcut
local Mouse       = lp:GetMouse()

-- Camera & rendering
local Camera      = Workspace.CurrentCamera
local CurrentCam  = Camera  -- alias

-- Useful exploit / script globals & checks (2025–2026 relevant)
local is_synapse  = syn     and true or false
local is_krnl     = KRNL_LOADED and true or false
local is_fluxus   = fluxus  and true or false
local has_rconsole= rconsoleprint and true or false
local has_http    = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)

-- Executor name quick guess (expand later if you want full detection module)
local ExecutorName = "Unknown"
if identifyexecutor then
    ExecutorName = identifyexecutor()
elseif getexecutorname then
    ExecutorName = getexecutorname()
elseif syn then
    ExecutorName = "Synapse X"
elseif KRNL_LOADED then
    ExecutorName = "Krnl"
elseif fluxus then
    ExecutorName = "Fluxus"
end

-- Some very useful Roblox globals / functions
local UDim2_new   = UDim2.new
local Vector2_new = Vector2.new
local Vector3_new = Vector3.new
local CFrame_new  = CFrame.new
local Color3_new  = Color3.new
local BrickColor_new = BrickColor.new
local Instance_new = Instance.new
local task        = task  -- task library (delay, spawn, defer, wait, etc.)
local table       = table -- just in case someone shadows it
local math        = math
local string      = string
local pairs       = pairs
local ipairs      = ipairs
local pcall       = pcall
local tick        = tick     -- or os.clock() in newer scripts
local wait        = task.wait -- prefer task.wait over wait()

-- Quick exploit-friendly functions / shorthands
local fireclickdetector = fireclickdetector or function(...) end -- fallback
local fireproximityprompt = fireproximityprompt or function(...) end
local firesignal    = firesignal    or function(...) end
local firetouchinterest = firetouchinterest or function(...) end

-- Print startup info
print(string.format(
    "[Soulja-Ware Init] Executor: %s | Player: %s (%d) | PlaceId: %d",
    ExecutorName,
    lp.Name,
    lp.UserId,
    game.PlaceId
))

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
