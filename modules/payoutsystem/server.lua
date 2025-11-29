CurrentPayout = {}
PayoutClass = {}
PayoutClass.__index = PayoutClass

--- Creates a new PayoutClass instance with randomized tier values
--- @param id string The unique identifier for the payout table (e.g., "mining", "fishing", "hunting")
--- @param contents table Configuration table containing tier definitions with min/max values
--- @return table The created PayoutClass instance
--- @usage
--- local payout = PayoutClass:new("mining", {
---     low_tier = { min = 100, max = 200 },
---     mid_tier = { min = 300, max = 500 },
---     high_tier = { min = 600, max = 1000 }
--- })
function PayoutClass:new(id, contents)
    local obj = {
        id = id,
        low = math.random(contents.low_tier.min, contents.low_tier.max) or 0,
        mid = math.random(contents.mid_tier.min, contents.mid_tier.max) or 0,
        high = math.random(contents.high_tier.min, contents.high_tier.max) or 0,
    }
    setmetatable(obj, self)
    CurrentPayout[id] = obj
    return obj
end

--- Retrieves the payout amount for a specific tier type
--- @param _type string The tier type to retrieve (e.g., "low", "mid", "high")
--- @return number The payout amount for the specified tier, or 0 if not found
--- @usage
--- local payout = payoutInstance:GetJobPayout("mid") -- Returns mid tier value
--- local lowPayout = payoutInstance:GetJobPayout("low") -- Returns low tier value
function PayoutClass:GetJobPayout(_type)
    return self[_type] or 0
end

--- Gets the payout amount for a specific job and tier type
--- @param id string The job identifier (e.g., "mining", "fishing", "lumberjack")
--- @param _type string|nil Optional tier type ("low", "mid", "high"). Defaults to "low" if not provided
--- @return number The payout amount for the specified job and tier, or 0 if not found
--- @usage
--- local amount = GetJobPayout("mining", "high") -- Get high tier mining payout
--- local defaultAmount = GetJobPayout("fishing") -- Get low tier (default) fishing payout
--- local invalidJob = GetJobPayout("nonexistent", "mid") -- Returns 0
function GetJobPayout(id, _type)
    local payouts = CurrentPayout[id]
    if not payouts then return 0 end
    local payoutType = _type or "low"
    return payouts:GetJobPayout(payoutType) or 0
end

--- Registers a new payout table or returns existing one if already registered
--- @param id string The unique identifier for the payout table
--- @param contents table Configuration table with tier definitions containing min/max values
--- @return table The PayoutClass instance (existing or newly created)
--- @usage
--- local miningPayout = RegisterPayoutTable("mining", {
---     low_tier = { min = 50, max = 100 },
---     mid_tier = { min = 150, max = 250 },
---     high_tier = { min = 300, max = 500 }
--- })
--- -- Calling again with same id returns the existing instance
--- local samePayout = RegisterPayoutTable("mining", {...}) -- Returns original instance
function RegisterPayoutTable(id, contents)
    if CurrentPayout[id] then return CurrentPayout[id] end
    return PayoutClass:new(id, contents)
end

function BuildConfigPayoutTables()
    local jobPays = Config.JobPayouts
    if not jobPays then return print("[DEBUG] No job payouts found in config.") end
    for id, contents in pairs(jobPays) do
        PayoutClass:new(id, contents)
    end
end

Bridge.Callback.Register('MrNewbLootTables:Callback:GetInitialJobPayouts', function(src, jobName)
    local jobPayData = CurrentPayout[jobName]
    if not jobPayData then return 0 end
    return jobPayData
end)

exports('RegisterPayoutTable', RegisterPayoutTable)
exports('GetJobPayout', GetJobPayout)