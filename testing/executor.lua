local Executor = {}

function Executor.detect()
    if identifyexecutor then
        local id = tostring(identifyexecutor()):lower()
        if id:find("volt") then return "Volt" end
        if id:find("seliware") then return "Seliware" end
        if id:find("potassium") then return "Potassium" end
        if id:find("wave") then return "Wave" end
        if id:find("volcano") then return "Volcano" end
        if id:find("cryptic") then return "Cryptic" end
        if id:find("bunni") then return "Bunni.fun" end
        if id:find("velocity") or id:find("verloc") then return "Verlocity" end
        if id:find("solara") then return "Solara" end
        if id:find("xeno") then return "Xeno" end
        if id:find("macsploit") then return "Macsploit" end
        if id:find("hydrogen") then return "Hydrogen" end
        if id:find("delta") then return "Delta" end
        if id:find("vega") then return "Vega X" end
        if id:find("codex") then return "Codex" end
        if id:find("serotonin") then return "Serotonin" end
        if id:find("severe") then return "Severe" end
        if id:find("rbxcli") then return "RbxCli" end
        if id:find("ronin") then return "Ronin" end
        if id:find("melatonin") then return "Melatonin" end
        if id:find("matcha") then return "Matcha" end
        if id:find("isabelle") then return "Isabelle" end
        if id:find("matric") then return "Matric Hub" end
        if id:find("photon") then return "Photon" end
        if id:find("dx9ware") then return "DX9WARE V2" end
        return identifyexecutor()
    elseif getexecutorname then
        return getexecutorname()
    elseif syn then
        return "Synapse X"
    elseif KRNL_LOADED then
        return "KRNL"
    end
    return "Unknown Executor"
end

return Executor
