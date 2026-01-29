--[[
    Universal Loader - v1.0 (Bulletproof & GUI-Less)

    - A minimal, production-grade, and highly resilient multi-game loader.
    - UPGRADED: Now supports mirrored/fallback URLs for maximum reliability.
    - UPGRADED: Retry logic now uses exponential backoff to handle struggling servers gracefully.
    - UPGRADED: Implemented a configurable, event-driven timeout for HttpGet to prevent infinite hangs.
    - UPGRADED: Error logging now aggregates failures from all attempts for comprehensive diagnostics.
    - UPGRADED: A new 'Verbose' mode can be toggled for silent operation.
]]

--================================================================================--
--[[ CONFIGURATION ]]
--================================================================================--

local CONFIG = {
    RetryCount = 2, -- The number of times to retry *each* URL after the first failure.
    BaseRetryDelay = 0.5, -- The initial wait time in seconds before the first retry.
    HttpGetTimeout = 5, -- The maximum time in seconds to wait for a script download.
    Verbose = true -- Set to false to hide all non-critical print/warn messages.
}

--[[ 
    CONFIGURE SUPPORTED GAMES HERE
    - `PlaceIDs` can be a single ID or a table of multiple IDs.
    - `ScriptURLs` can be a single URL or a table of multiple fallback URLs.
]]
local SUPPORTED_GAMES = {
    {
        Name = "The Legendary Swords RPG: Restored",
        PlaceIDs = {129119196465909},
        ScriptURLs = {"https://raw.githubusercontent.com/DozeIsOkLol/SouljaWare/refs/heads/main/129119196465909/Main.lua"}
    },
    {
        Name = "Universal",
        IsUniversal = true,
        ScriptURLs = {"https://raw.githubusercontent.com/DozeIsOkLol/SouljaWare/refs/heads/main/Universal/Main.lua"}
    }
}

--================================================================================--
--[[ CORE LOADER FUNCTIONS ]]
--================================================================================--

-- Safely fetches a script from a list of URLs with advanced retry and timeout logic.
local function fetchScript(urls, retries, timeout, baseDelay)
    local allErrors = {}
    
    for i, url in ipairs(urls) do
        if CONFIG.Verbose then
            print(("➡️ Attempting to download from URL #%d: %s"):format(i, url))
        end
        
        for attempt = 1, retries + 1 do
            local resultContainer = {}
            local httpThread = task.spawn(function()
                local success, result = pcall(game.HttpGet, game, url)
                resultContainer.Success = success
                resultContainer.Result = result
            end)
            
            local timeoutThread = task.delay(timeout, function()
                if task.getStatus(httpThread) ~= "dead" then
                    task.cancel(httpThread)
                    resultContainer.Success = false
                    resultContainer.Result = "Request timed out after " .. timeout .. " seconds."
                end
            end)

            while not resultContainer.Success and task.getStatus(httpThread) ~= "dead" do
                task.wait()
            end
            task.cancel(timeoutThread)

            if resultContainer.Success then
                return resultContainer.Result -- Success! Return the script content.
            else
                local errorMsg = tostring(resultContainer.Result)
                table.insert(allErrors, ("Attempt %d on URL #%d failed: %s"):format(attempt, i, errorMsg))
                
                if attempt <= retries then
                    local waitTime = baseDelay * (2 ^ (attempt - 1)) -- Exponential backoff
                    if CONFIG.Verbose then
                        warn(("⚠️ Download attempt %d failed. Retrying in %.1fs..."):format(attempt, waitTime))
                    end
                    task.wait(waitTime)
                end
            end
        end
        if CONFIG.Verbose then
            warn(("❌ All attempts for URL #%d failed."):format(i))
        end
    end
    
    return nil, table.concat(allErrors, "\n")
end

-- Helper function to find the correct game data based on the current PlaceId.
local function findGameByPlaceId(placeId)
    local universalGame = nil

    for _, gameData in ipairs(SUPPORTED_GAMES) do
        if gameData.IsUniversal then
            universalGame = gameData
        else
            local placeIds = typeof(gameData.PlaceIDs) == "table" and gameData.PlaceIDs or {gameData.PlaceIDs}
            for _, id in ipairs(placeIds) do
                if id == placeId then
                    return gameData 
                end
            end
        end
    end

    return universalGame 
end


-- Main function to find and load the script for the current game.
local function loadScript()
    local placeId = game.PlaceId
    local gameData = findGameByPlaceId(placeId)

    if gameData then
        if CONFIG.Verbose then
            print("✅ Supported Game Found: " .. gameData.Name)
        end
        
        local scriptUrls = typeof(gameData.ScriptURLs) == "table" and gameData.ScriptURLs or {gameData.ScriptURLs}
        local scriptContent, fetchError = fetchScript(scriptUrls, CONFIG.RetryCount, CONFIG.HttpGetTimeout, CONFIG.BaseRetryDelay)

        if scriptContent then
            local execSuccess, execError = pcall(loadstring(scriptContent))
            if execSuccess then
                if CONFIG.Verbose then
                    print("✔️ Script executed successfully!")
                end
                return true
            else
                local finalError = ("Script execution for %s failed: %s"):format(gameData.Name, tostring(execError))
                warn("❌ " .. finalError)
                return false, finalError
            end
        else
            local finalError = ("Failed to download script for %s. All errors:\n%s"):format(gameData.Name, tostring(fetchError))
            warn("❌ " .. finalError)
            return false, finalError
        end
    else
        if CONFIG.Verbose then
            print(("🔹 No script available for this game (Place ID: %s)"):format(tostring(placeId)))
        end
        return false, "Unsupported game"
    end
end

--================================================================================--
--[[ EXECUTION ]]
--================================================================================--

task.spawn(loadScript)
