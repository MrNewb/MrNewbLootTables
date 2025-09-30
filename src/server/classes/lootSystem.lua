print("[DEBUG] Loading loot system...")
CurrentLoot = {}
LootClass = {}
LootClass.__index = LootClass

function LootClass:new(id, contents)
    local obj = {
        id = id,
        contents = contents or {},
    }
    setmetatable(obj, self)
    CurrentLoot[id] = obj
    return obj
end

function LootClass:getLootTable()
    return self.contents
end

function LootClass:getSingleLootRoll()
    local total = 0
    for _, item in ipairs(self.contents) do
        total = total + item.chance
    end

    local roll = math.random() * total
    local cumulative = 0

    for _, item in ipairs(self.contents) do
        cumulative = cumulative + item.chance
        if roll <= cumulative then
            local count = math.random(item.min or 1, item.max or 1)
            if item.shared then
                if Config.Utility.Debug then
                    print(("[DEBUG] Item '%s' is marked as shared, removing from loot table '%s'"):format(item.name, self.id))
                end
                self:removeLootFromLootTable(item)
            end
            return {name = item.name, count = count, metadata = item.metadata or {}, shared = item.shared or false}
        end
    end

    return false
end

function LootClass:getMultipleLootRolls(maxRewards)
    local results = {}
    maxRewards = maxRewards or 1
    if Config.Utility.Debug then
        print(("[DEBUG] Getting %d loot rolls from table '%s'"):format(maxRewards, self.id))
    end

    local total = 0
    for _, item in ipairs(self.contents) do
        total = total + item.chance
    end

    for i = 1, maxRewards do
        if total <= 0 then break end -- no items left
        local roll = math.random(1, total)
        local cumulative = 0

        for _, item in ipairs(self.contents) do
            cumulative = cumulative + item.chance
            if roll <= cumulative then
                local count = math.random(item.min, item.max)
                local result = {
                    name = item.name,
                    count = count,
                    metadata = item.metadata or {},
                    shared = item.shared or false,
                }
                table.insert(results, result)

                if Config.Utility.Debug then
                    print(("[DEBUG] Selected %s x%d (Chance: %d, Shared: %s)"):format(result.name, result.count, item.chance, tostring(result.shared)))
                end

                if item.shared then
                    self:removeLootFromLootTable(item)
                    total = total - item.chance
                end
                break
            end
        end
    end

    return results
end

function LootClass:removeLootFromLootTable(itemToRemove)
    for i, item in ipairs(self.contents) do
        if item.name == itemToRemove.name then
            table.remove(self.contents, i)
            return true
        end
    end
    return false
end

local function addItemsForPlayer(src, data)
    for k, item in ipairs(data) do
        Bridge.Inventory.AddItem(src, item.name, item.count, item.metadata)
    end
end

function GetLootTable(id)
    local loot = CurrentLoot[id]
    if not loot then return {} end
    return loot:getLootTable()
end

function GetSingleLootRoll(id, playerID)
    local loot = CurrentLoot[id]
    if not loot then return {} end
    local data = loot:getSingleLootRoll()
    if playerID and data then
        addItemsForPlayer(playerID, data)
    end
    return data
end

function GetMultipleLootRolls(id, playerID, maxRewards)
    local loot = CurrentLoot[id]
    if not loot then return {} end
    local data = loot:getMultipleLootRolls(maxRewards)
    if playerID and data then
        addItemsForPlayer(playerID, data)
    end
    return data
end

---This will return either a single item or multiple items based on the type parameter.
---@param id string
---@param _type string "single" or "multiple"
---@param playerId number optional
---@param maxRewards number optional and only works with type "multiple"
---@return table
function GetLootRoll(id, _type, playerId, maxRewards)
    if _type == "single" then
        return GetSingleLootRoll(id, playerId)
    elseif _type == "multiple" then
        return GetMultipleLootRolls(id, playerId, maxRewards)
    end
    return {}
end

function RemoveLootTable(id)
    if CurrentLoot[id] then
        CurrentLoot[id] = nil
        return true
    end
    return false
end

function RegisterLootTable(id, contents)
    if CurrentLoot[id] then RemoveLootTable(id) end
    return LootClass:new(id, contents)
end

RegisterCommand('getMultipleLootRoll', function(source, args, rawCommand)
    if Config.Utility.Debug then
        local lootId = args[1]
        local maxRewards = tonumber(args[2]) or 1
        if not lootId then
            print("[DEBUG] Usage: /getMultipleLootRoll <lootId> [maxRewards]")
            return
        end
        local results = GetMultipleLootRolls(lootId, maxRewards)
        print(("[DEBUG] Loot roll results for table '%s':"):format(lootId))
        for _, item in ipairs(results) do
            print(("[DEBUG] - %s x%d (Metadata: %s)"):format(item.name, math.random(item.min, item.max), json.encode(item.metadata)))
        end
    else
        print("Debug mode is disabled. Enable it in the config to use this command.")
    end
end, false)

RegisterCommand('getSingleLootRoll', function(source, args, rawCommand)
    if Config.Utility.Debug then
        local lootId = args[1]
        if not lootId then
            print("[DEBUG] Usage: /getSingleLootRoll <lootId>")
            return
        end
        local item = GetSingleLootRoll(lootId)
        if item then
            print(("[DEBUG] Loot roll result for table '%s': %s x%d (Metadata: %s)"):format(lootId, item.name, math.random(item.min, item.max), json.encode(item.metadata)))
        else
            print(("[DEBUG] No item rolled from loot table '%s'"):format(lootId))
        end
    else
        print("Debug mode is disabled. Enable it in the config to use this command.")
    end
end, false)

RegisterCommand('printLootTable', function(source, args, rawCommand)
    if Config.Utility.Debug then
        local lootId = args[1]
        if not lootId then
            print("[DEBUG] Usage: /printLootTable <lootId>")
            return
        end
        local lootTable = GetLootTable(lootId)
        if #lootTable == 0 then
            print(("[DEBUG] Loot table '%s' is empty or does not exist."):format(lootId))
            return
        end
        print(("[DEBUG] Contents of loot table '%s':"):format(lootId))
        for _, item in ipairs(lootTable) do
            print(("[DEBUG] - %s (Min: %d, Max: %d, Chance: %d, Shared: %s, Metadata: %s)"):format(item.name, item.min, item.max, item.chance, tostring(item.shared), json.encode(item.metadata)))
        end
    else
        print("Debug mode is disabled. Enable it in the config to use this command.")
    end
end, false)

exports('GetLootTable', GetLootTable)
exports('GetSingleLootRoll', GetSingleLootRoll)
exports('GetMultipleLootRolls', GetMultipleLootRolls)
exports('GetLootRoll', GetLootRoll)
exports('RemoveLootTable', RemoveLootTable)
exports('RegisterLootTable', RegisterLootTable)

local function buildConfigLootTables()
    local lootTables = Config.LootTables
    if not lootTables then return print("[DEBUG] No loot tables found in config.") end
    for id, contents in pairs(lootTables) do
        print(("[DEBUG] Registering loot table '%s' from config."):format(id))
        LootClass:new(id, contents)
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return print("[DEBUG] Resource started, but not the correct resource.") end
    print("[DEBUG] Resource started, building loot tables from config...")
    buildConfigLootTables()
end)

--[[
-- examples
exports.['MrNewbLootTables']:GetLootTable('pineapple robbery')
^^ will return a table of shit in the table

exports.['MrNewbLootTables']:GetLootRoll('pineapple robbery', 'single')
^^ will return a single item from the table

exports.['MrNewbLootTables']:GetLootRoll('pineapple robbery', 'multiple', 3)
^^ will give up to 3 items from the pineapple robbery loot table to player 3 automatically and return items they got from the table

-- 

]]