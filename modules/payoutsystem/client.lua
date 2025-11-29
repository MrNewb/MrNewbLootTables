local CurrentPayout = {}

local function getCachedPayouts(jobName)
    local cbResults = Bridge.Callback.Trigger('MrNewbLootTables:Callback:GetInitialJobPayouts', jobName)
    if not cbResults then return end
    CurrentPayout[jobName] = cbResults
end

--- Retrieves the payout amount for a specific job type
--- If the job payout data is not cached, it will fetch it from the server
--- @param jobName string The name of the job to get payout for
--- @param _type string|nil The payout type (e.g., "low", "medium", "high"). Defaults to "low" if not provided
--- @return number The payout amount for the specified job and type, or 0 if not found
function GetJobPayout(jobName, _type)
    local payType = _type or "low"
    local payout = CurrentPayout[jobName]
    if not payout then getCachedPayouts(jobName) end
    return CurrentPayout[jobName][payType] or 0
end

exports('GetJobPayout', GetJobPayout)