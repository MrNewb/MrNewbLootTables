local maxRewardsPerRoll = 25
local maxItemCount = 1000
local lootTables = {}

local function copyLootEntry(lootEntry)
    local metadata = {}
    if type(lootEntry.metadata) == 'table' then
        for key, value in pairs(lootEntry.metadata) do
            metadata[key] = value
        end
    end

    return {
        name = lootEntry.name,
        metadata = metadata,
        min = lootEntry.min,
        max = lootEntry.max,
        chance = lootEntry.chance,
        shared = lootEntry.shared,
    }
end

local function copyLootEntries(lootEntries)
    local snapshot = {}
    for entryIndex = 1, #lootEntries do
        snapshot[entryIndex] = copyLootEntry(lootEntries[entryIndex])
    end
    return snapshot
end

local function buildWeightedSelector(lootEntries)
    local weightedEntries = {}
    for entryIndex = 1, #lootEntries do
        local lootEntry = lootEntries[entryIndex]
        local weight = tonumber(lootEntry.chance) or 0
        if weight > 0 and type(lootEntry.name) == 'string' and lootEntry.name ~= '' then
            weightedEntries[#weightedEntries + 1] = { weight, lootEntry }
        end
    end
    if #weightedEntries < 1 then return end
    return lib.selector:new(weightedEntries)
end

local function rollItemCount(lootEntry)
    local minimumCount = math.floor(tonumber(lootEntry.min) or 1)
    local maximumCount = math.floor(tonumber(lootEntry.max) or minimumCount)
    if minimumCount < 1 then minimumCount = 1 end
    if maximumCount < minimumCount then maximumCount = minimumCount end
    if maximumCount > maxItemCount then maximumCount = maxItemCount end
    if minimumCount > maximumCount then minimumCount = maximumCount end
    return math.random(minimumCount, maximumCount)
end

local function removeSharedEntry(lootTable, itemName)
    local lootEntries = lootTable.lootEntries
    for entryIndex = 1, #lootEntries do
        if lootEntries[entryIndex].name == itemName then
            table.remove(lootEntries, entryIndex)
            lootTable.weightedSelector = buildWeightedSelector(lootEntries)
            return
        end
    end
end

local function takeRolledItem(lootTable, lootEntry)
    local copiedEntry = copyLootEntry(lootEntry)
    local rolledItem = {
        name = copiedEntry.name,
        count = rollItemCount(lootEntry),
        metadata = copiedEntry.metadata,
        shared = copiedEntry.shared or false,
    }

    if lootEntry.shared then
        LootDebugPrint(("Removing shared item '%s' from loot table '%s' after roll"):format(lootEntry.name, lootTable.lootTableId))
        removeSharedEntry(lootTable, lootEntry.name)
    end

    return rolledItem
end

local function rollSingleItem(lootTable)
    local weightedSelector = lootTable.weightedSelector
    if not weightedSelector then return false end

    local lootEntry = weightedSelector:getRandomWeighted()
    if not lootEntry then return false end
    return takeRolledItem(lootTable, lootEntry)
end

local function rollMultipleItems(lootTable, maxRewards)
    local rolledItems = {}
    maxRewards = math.floor(tonumber(maxRewards) or 1)
    if maxRewards < 1 then maxRewards = 1 end
    if maxRewards > maxRewardsPerRoll then maxRewards = maxRewardsPerRoll end

    LootDebugPrint(("Getting %d loot rolls from table '%s'"):format(maxRewards, lootTable.lootTableId))

    for _ = 1, maxRewards do
        local weightedSelector = lootTable.weightedSelector
        if not weightedSelector then break end

        local lootEntry = weightedSelector:getRandomWeighted()
        if not lootEntry then break end

        local rolledItem = takeRolledItem(lootTable, lootEntry)
        rolledItems[#rolledItems + 1] = rolledItem

        LootDebugPrint(("Selected %s x%d (chance: %d, shared: %s)"):format(
            rolledItem.name,
            rolledItem.count,
            lootEntry.chance,
            tostring(rolledItem.shared)
        ))
    end

    return rolledItems
end

local function addRolledItem(src, rolledItem)
    if type(src) ~= 'number' or type(rolledItem) ~= 'table' then return end
    if type(rolledItem.name) ~= 'string' then return end

    local ped = GetPlayerPed(src)
    if ped == 0 or not DoesEntityExist(ped) then return end

    local count = tonumber(rolledItem.count)
    if not count or count ~= count or count < 1 then return end
    count = math.floor(count)

    bridge.inventory.addItem(src, rolledItem.name, count, rolledItem.metadata)
end

local function getLootTable(lootTableId)
    if type(lootTableId) ~= 'string' then return {} end
    local lootTable = lootTables[lootTableId]
    if not lootTable then return {} end
    return copyLootEntries(lootTable.lootEntries)
end

local function getSingleLootRoll(lootTableId, src)
    if type(lootTableId) ~= 'string' then return {} end
    local lootTable = lootTables[lootTableId]
    if not lootTable then return {} end

    local rolledItem = rollSingleItem(lootTable)
    if src and rolledItem then
        addRolledItem(src, rolledItem)
    end

    return rolledItem
end

local function getMultipleLootRolls(lootTableId, src, maxRewards)
    if type(lootTableId) ~= 'string' then return {} end
    local lootTable = lootTables[lootTableId]
    if not lootTable then return {} end

    local rolledItems = rollMultipleItems(lootTable, maxRewards)
    if src then
        for itemIndex = 1, #rolledItems do
            addRolledItem(src, rolledItems[itemIndex])
        end
    end

    return rolledItems
end

local function getLootRoll(lootTableId, rollType, src, maxRewards)
    if rollType == 'single' then
        return getSingleLootRoll(lootTableId, src)
    end

    if rollType == 'multiple' then
        return getMultipleLootRolls(lootTableId, src, maxRewards)
    end

    return {}
end

local function removeLootTable(lootTableId)
    if type(lootTableId) ~= 'string' or not lootTables[lootTableId] then return false end
    lootTables[lootTableId] = nil
    return true
end

local function registerLootTable(lootTableId, lootEntries)
    if type(lootTableId) ~= 'string' or lootTableId == '' or type(lootEntries) ~= 'table' then return false end

    local copiedEntries = copyLootEntries(lootEntries)
    lootTables[lootTableId] = {
        lootTableId = lootTableId,
        lootEntries = copiedEntries,
        weightedSelector = buildWeightedSelector(copiedEntries),
    }
    return true
end

local configLootTables = Config.LootTables
if configLootTables then
    for lootTableId, lootEntries in pairs(configLootTables) do
        LootDebugPrint(("Registering loot table '%s' from config."):format(lootTableId))
        registerLootTable(lootTableId, lootEntries)
    end
else
    LootDebugPrint('No loot tables found in config.')
end

exports('GetLootTable', getLootTable)
exports('GetSingleLootRoll', getSingleLootRoll)
exports('GetMultipleLootRolls', getMultipleLootRolls)
exports('GetLootRoll', getLootRoll)
exports('RemoveLootTable', removeLootTable)
exports('RegisterLootTable', registerLootTable)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    exports[bridge.name]:VersionCheck('MrNewb/patchnotes', resourceName)
end)
