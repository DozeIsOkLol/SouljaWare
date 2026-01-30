local Webhook = {}
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

Webhook.URL = "https://discordapp.com/api/webhooks/..."

function Webhook.send(execution)
    local lp = Players.LocalPlayer
    if not lp then return end

    local gameName = "Unknown"
    pcall(function()
        gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)

    local payload = {
        username = "Soulja-Ware Logger",
        embeds = {{
            title = "🛠 Soulja-Ware Executed",
            color = 16711701,
            fields = {
                {name="User", value=lp.Name, inline=false},
                {name="Executor", value=_G.ExecutorDetected or "Unknown", inline=true},
                {name="Game", value=gameName, inline=false},
            },
            timestamp = DateTime.now():ToIsoDate()
        }}
    }

    local json = HttpService:JSONEncode(payload)
    local request = syn and syn.request or http_request or request
    if request then
        pcall(function()
            request({Url = Webhook.URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=json})
        end)
    end
end

return Webhook
