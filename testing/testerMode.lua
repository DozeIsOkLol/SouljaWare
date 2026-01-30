local TesterMode = {}

TesterMode.TESTER_MODE = false -- set true for tester builds

TesterMode.Whitelist = {
    158212026,
    10041780182,
    2990059374,
}

function TesterMode.check(userId)
    for _, id in ipairs(TesterMode.Whitelist) do
        if id == userId then
            return true
        end
    end
    return false
end

return TesterMode
