-- WebhookLogger.lua
-- Soulja-Ware Execution Logger Module
-- Sends Discord webhook when script runs
-- Requires: WEBHOOK_URL defined somewhere (preferably in Config)

local WebhookLogger = {}

-- Dependencies (passed in or assumed available)
-- You must provide these when calling .Send() or set them globally

-- Default fallback request methods (executor-agnostic)
local function getRequestFunction()
    return
        (syn and syn.request) or
        http_request or
        request or
        (fluxus and fluxus.request) or
        (http and http.request) or
        nil
end

-- Main send function
-- @param config table { webhookUrl, avatarUrl?, username?, executionData? }
function WebhookLogger.Send(config)
    config = config or {}
    
    local WEBHOOK_URL = config.webhookUrl or _G.SOULJAWARE_WEBHOOK_URL
    if not WEBHOOK_URL or WEBHOOK_URL == "" then
        warn("[WebhookLogger] No webhook URL provided — logging skipped")
        return false
    end
    
    local Players            = game:GetService("Players")
    local HttpService        = game:GetService("HttpService")
    local MarketplaceService = game:GetService("MarketplaceService")
    
    local player = Players.LocalPlayer
    if not player then return false end
    
    -- Get execution context (from loader or fallback)
    local execution = _G.SOULJAWARE_EXECUTION or config.executionData or {
        ScriptName   = "Unknown",
        IsUniversal  = false,
        ScriptURL    = "Unknown"
    }
    
    -- Try to get game name safely
    local gameName = "Unknown Game"
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId)
        gameName = info and info.Name or "Unknown"
    end)
    
    -- Build embed payload
    local payload = {
        username    = config.username    or "Soulja-Ware Logger",
        avatar_url  = config.avatarUrl   or "https://i.pinimg.com/736x/7c/e1/63/7ce163ca67f16209bc7fc4de716fde0c.jpg",
        embeds      = {{
            title   = "🛠 Soulja-Ware Executed",
            color   = 16711701,  -- red-orange
            fields  = {
                {
                    name  = "👤 User",
                    value = string.format(
                        "**Username:** %s\n**Display Name:** %s\n**UserID:** %d",
                        player.Name,
                        player.DisplayName,
                        player.UserId
                    ),
                    inline = false
                },
                {
                    name  = "💻 Executor",
                    value = WebhookLogger.GetExecutorName() or "Unknown Executor",
                    inline = true
                },
                {
                    name  = "📜 Script Executed",
                    value = string.format(
                        "**Name:** %s\n**Type:** %s",
                        execution.ScriptName,
                        execution.IsUniversal and "Universal" or "Game-Specific"
                    ),
                    inline = true
                },
                {
                    name  = "🔗 Script URL",
                    value = execution.ScriptURL or "Unknown",
                    inline = false
                },
                {
                    name  = "🎮 Game",
                    value = string.format(
                        "**Name:** %s\n**PlaceId:** %d",
                        gameName,
                        game.PlaceId
                    ),
                    inline = false
                }
            },
            footer = {
                text = "Soulja-Ware • Auto Logger • " .. os.date("%Y-%m-%d %H:%M UTC")
            },
            timestamp = DateTime.now():ToIsoDate()
        }}
    }
    
    local json = HttpService:JSONEncode(payload)
    local requestFunc = getRequestFunction()
    
    if not requestFunc then
        warn("[WebhookLogger] No compatible HTTP request function found")
        return false
    end
    
    local success, err = pcall(function()
        requestFunc({
            Url     = WEBHOOK_URL,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = json
        })
    end)
    
    if not success then
        warn("[WebhookLogger] Failed to send webhook: " .. tostring(err))
        return false
    end
    
    print("[WebhookLogger] Execution logged to Discord")
    return true
end

-- Helper: simple executor name (can be replaced with full ExecutorDetection module later)
function WebhookLogger.GetExecutorName()
    if identifyexecutor then
        local raw = identifyexecutor()
        return tostring(raw)
    elseif getexecutorname then
        return tostring(getexecutorname())
    elseif syn then
        return "Synapse X"
    elseif KRNL_LOADED then
        return "KRNL"
    elseif fluxus then
        return "Fluxus"
    else
        return "Unknown Executor"
    end
end

-- Optional: wait for execution context from loader (like in your original)
function WebhookLogger.WaitForExecutionContext(timeout)
    timeout = timeout or 5  -- seconds
    local attempts = timeout * 10
    
    for i = 1, attempts do
        if _G.SOULJAWARE_EXECUTION then
            return _G.SOULJAWARE_EXECUTION
        end
        task.wait(0.1)
    end
    
    return {
        ScriptName  = "Unknown (timeout)",
        IsUniversal = false,
        ScriptURL   = "Unknown"
    }
end

return WebhookLogger
