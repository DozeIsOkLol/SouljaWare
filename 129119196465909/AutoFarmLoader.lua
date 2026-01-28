local src
local success, err = pcall(function()
    src = game:HttpGet("https://raw.githubusercontent.com/DozeIsOkLol/SouljaWare/refs/heads/main/129119196465909/AutoFarmDemo.lua")
end)

if not success or not src or #src < 100 then
    warn("Failed to load script source")
    return
end

loadstring(src)()
