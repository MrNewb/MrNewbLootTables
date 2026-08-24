local allowedPayTiers = {
    low = true,
    mid = true,
    high = true,
}

local jobPayouts = {}

local function rollPayoutAmount(tierRange)
    if type(tierRange) ~= 'table' then return 0 end

    local minimumPay = math.floor(tonumber(tierRange.min) or 0)
    local maximumPay = math.floor(tonumber(tierRange.max) or minimumPay)
    if minimumPay < 0 then minimumPay = 0 end
    if maximumPay < minimumPay then maximumPay = minimumPay end
    return math.random(minimumPay, maximumPay)
end

local function getJobPayout(jobName, payTier)
    if type(jobName) ~= 'string' or jobName == '' then return 0 end
    local jobPayout = jobPayouts[jobName]
    if not jobPayout then return 0 end

    local selectedTier = payTier or 'low'
    if not allowedPayTiers[selectedTier] then return 0 end
    return jobPayout[selectedTier] or 0
end

local function registerPayoutTable(jobName, payoutTiers)
    if type(jobName) ~= 'string' or jobName == '' or type(payoutTiers) ~= 'table' then return false end
    if jobPayouts[jobName] then return true end

    jobPayouts[jobName] = {
        jobName = jobName,
        low = rollPayoutAmount(payoutTiers.low_tier),
        mid = rollPayoutAmount(payoutTiers.mid_tier),
        high = rollPayoutAmount(payoutTiers.high_tier),
    }
    return true
end

local configPayouts = Config.JobPayouts
if configPayouts then
    for jobName, payoutTiers in pairs(configPayouts) do
        registerPayoutTable(jobName, payoutTiers)
    end
else
    LootDebugPrint('No job payouts found in config.')
end

lib.callback.register('MrNewbLootTables:Callback:GetInitialJobPayouts', function(src, jobName)
    local ped = GetPlayerPed(src)
    if ped == 0 or not DoesEntityExist(ped) then return false end
    if type(jobName) ~= 'string' or jobName == '' then return false end

    local jobPayout = jobPayouts[jobName]
    if not jobPayout then return false end
    return {
        id = jobPayout.jobName,
        low = jobPayout.low,
        mid = jobPayout.mid,
        high = jobPayout.high,
    }
end)

exports('RegisterPayoutTable', registerPayoutTable)
exports('GetJobPayout', getJobPayout)
