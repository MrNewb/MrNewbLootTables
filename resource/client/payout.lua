local cachedJobPayouts = {}

local allowedPayTiers = {
    low = true,
    mid = true,
    high = true,
}

local function getJobPayout(jobName, payTier)
    if type(jobName) ~= 'string' or jobName == '' then return 0 end

    local selectedTier = payTier or 'low'
    if not allowedPayTiers[selectedTier] then return 0 end

    local payoutAmounts = cachedJobPayouts[jobName]
    if not payoutAmounts then
        payoutAmounts = lib.callback.await('MrNewbLootTables:Callback:GetInitialJobPayouts', false, jobName)
        if not payoutAmounts then return 0 end
        cachedJobPayouts[jobName] = payoutAmounts
    end

    return tonumber(payoutAmounts[selectedTier]) or 0
end

exports('GetJobPayout', getJobPayout)
