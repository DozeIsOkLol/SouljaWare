-- ExecutorDetection.lua
local ExecutorDetection = {}

-- Main detection function
local function detectExecutor()
    if identifyexecutor then
        local id = tostring(identifyexecutor()):lower()
        
        local patterns = {
            {"volt",        "Volt"},
            {"seliware",    "Seliware"},
            {"potassium",   "Potassium"},
            {"wave",        "Wave"},
            {"volcano",     "Volcano"},
            {"cryptic",     "Cryptic"},
            {"choco",       "ChocoSpolit"},
            {"sirhurt",     "SirHurt"},
            {"bunni",       "Bunni.fun"},
            {"velocity",    "Verlocity"},
            {"verloc",      "Verlocity"},
            {"solara",      "Solara"},
            {"xeno",        "Xeno"},
            {"macsploit",   "Macsploit"},
            {"hydrogen",    "Hydrogen"},
            {"delta",       "Delta"},
            {"vega",        "Vega X"},
            {"codex",       "Codex"},
            {"serotonin",   "Serotonin"},
            {"severe",      "Severe"},
            {"rbxcli",      "RbxCli"},
            {"ronin",       "Ronin"},
            {"melatonin",   "Melatonin"},
            {"matcha",      "Matcha"},
            {"isabelle",    "Isabelle"},
            {"matric",      "Matric Hub"},
            {"photon",      "Photon"},
            {"dx9ware",     "DX9WARE V2"},
        }
        
        for _, entry in ipairs(patterns) do
            if id:find(entry[1]) then
                return entry[2]
            end
        end
        
        -- fallback to raw name if no match
        return identifyexecutor()
    end

    if getexecutorname then
        local name = tostring(getexecutorname()):lower()
        
        local patterns = {
            {"volt",        "Volt"},
            {"seliware",    "Seliware"},
            {"potassium",   "Potassium"},
            {"wave",        "Wave"},
            {"volcano",     "Volcano"},
            {"cryptic",     "Cryptic"},
            {"bunni",       "Bunni.fun"},
            {"velocity",    "Verlocity"},
            {"verloc",      "Verlocity"},
            {"solara",      "Solara"},
            {"xeno",        "Xeno"},
            {"macsploit",   "Macsploit"},
            {"hydrogen",    "Hydrogen"},
            {"delta",       "Delta"},
            {"vega",        "Vega X"},
            {"codex",       "Codex"},
            {"serotonin",   "Serotonin"},
            {"severe",      "Severe"},
            {"rbxcli",      "RbxCli"},
            {"ronin",       "Ronin"},
            {"melatonin",   "Melatonin"},
            {"matcha",      "Matcha"},
            {"isabelle",    "Isabelle"},
            {"matric",      "Matric Hub"},
            {"photon",      "Photon"},
            {"dx9ware",     "DX9WARE V2"},
        }
        
        for _, entry in ipairs(patterns) do
            if name:find(entry[1]) then
                return entry[2]
            end
        end
        
        return getexecutorname()
    end
    
    if KRNL_LOADED then
        return "KRNL"
    end

    return "Unknown Executor"
end

-- Public API
function ExecutorDetection.GetName()
    return detectExecutor()
end

function ExecutorDetection.GetRaw()
    if identifyexecutor then
        return identifyexecutor()
    elseif getexecutorname then
        return getexecutorname()
    elseif KRNL_LOADED then
        return "KRNL (via KRNL_LOADED)"
    else
        return "Unknown"
    end
end

function ExecutorDetection.IsUnknown()
    local name = detectExecutor()
    return name == "Unknown Executor" or name == "Unknown"
end

function ExecutorDetection.Identify()
    local name = detectExecutor()
    local raw  = ExecutorDetection.GetRaw()
    return name, raw
end

return ExecutorDetection
