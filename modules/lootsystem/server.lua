CurrentLoot = {}
LootClass = {}
LootClass.__index = LootClass

---Creates a new LootClass instance and registers it in the CurrentLoot table
---@param id string The unique identifier for this loot table
---@param contents table An array of loot items with structure: {name, metadata, min, max, chance, shared}
---@return table The created LootClass instance
---@usage local loot = LootClass:new("bank_vault", {{name="cash", min=100, max=500, chance=50, shared=false}})
function LootClass:new(id, contents)
    local obj = {
        id = id,
        contents = contents or {},
    }
    setmetatable(obj, self)
    CurrentLoot[id] = obj
    return obj
end

---Returns the complete loot table contents for this instance
---@return table The contents array containing all loot items
---@usage local items = lootInstance:getLootTable()
function LootClass:getLootTable()
    return self.contents
end

---Performs a single weighted random roll on the loot table
---If an item is marked as 'shared', it will be removed from the table after being rolled
---@return table|false Returns item table {name, count, metadata, shared} or false if no item rolled
---@usage local item = lootInstance:getSingleLootRoll()
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
                DebugModePrint(("[DEBUG] Removing shared item '%s' from loot table '%s' after roll"):format(item.name, self.id))
                self:removeLootFromLootTable(item)
            end
            return {name = item.name, count = count, metadata = item.metadata or {}, shared = item.shared or false}
        end
    end

    return false
end

---Performs multiple weighted random rolls on the loot table
---Shared items are removed after being rolled, preventing duplicates
---@param maxRewards number The maximum number of items to roll (default: 1)
---@return table Array of item tables, each containing {name, count, metadata, shared}
---@usage local items = lootInstance:getMultipleLootRolls(3) -- Get up to 3 items
function LootClass:getMultipleLootRolls(maxRewards)
    local results = {}
    maxRewards = maxRewards or 1
    DebugModePrint(("[DEBUG] Getting %d loot rolls from table '%s'"):format(maxRewards, self.id))

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

                DebugModePrint(("[DEBUG] Selected %s x%d (Chance: %d, Shared: %s)"):format(result.name, result.count, item.chance, tostring(result.shared)))

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

---Removes a specific item from the loot table by name
---@param itemToRemove table The item object to remove from the loot table
---@return boolean True if item was found and removed, false otherwise
---@usage local success = lootInstance:removeLootFromLootTable({name="rare_item"})
function LootClass:removeLootFromLootTable(itemToRemove)
    for i, item in ipairs(self.contents) do
        if item.name == itemToRemove.name then
            table.remove(self.contents, i)
            return true
        end
    end
    return false
end

---Internal function to add items to a player's inventory using the Bridge
---@param src number The player's server ID
---@param data table|table[] Single item or array of items to add to player inventory
---@usage addItemsForPlayer(1, {name="bread", count=2, metadata={}})
local function addItemsForPlayer(src, data)
    for k, item in ipairs(data) do
        Bridge.Inventory.AddItem(src, item.name, item.count, item.metadata)
    end
end

---Gets the complete loot table contents by ID
---@param id string The unique identifier of the loot table
---@return table The loot table contents or empty table if not found
---@usage local items = GetLootTable("bank_vault")
function GetLootTable(id)
    local loot = CurrentLoot[id]
    if not loot then return {} end
    return loot:getLootTable()
end

---Performs a single loot roll and optionally gives it to a player
---@param id string The unique identifier of the loot table
---@param playerID number|nil Optional player server ID to automatically give the item to
---@return table|false Returns item data {name, count, metadata, shared} or false if no roll
---@usage local item = GetSingleLootRoll("convenience_store", 1) -- Roll and give to player 1
---@usage local item = GetSingleLootRoll("convenience_store") -- Just roll, don't give to player
function GetSingleLootRoll(id, playerID)
    local loot = CurrentLoot[id]
    if not loot then return {} end
    local data = loot:getSingleLootRoll()
    if playerID and data then
        addItemsForPlayer(playerID, data)
    end
    return data
end

---Performs multiple loot rolls and optionally gives them to a player
---@param id string The unique identifier of the loot table
---@param playerID number|nil Optional player server ID to automatically give items to
---@param maxRewards number|nil Maximum number of items to roll (default: 1)
---@return table Array of item data tables, each containing {name, count, metadata, shared}
---@usage local items = GetMultipleLootRolls("military_cache", 1, 3) -- Roll up to 3 items for player 1
---@usage local items = GetMultipleLootRolls("fishing_spot", nil, 2) -- Roll 2 items without giving to player
function GetMultipleLootRolls(id, playerID, maxRewards)
    local loot = CurrentLoot[id]
    if not loot then return {} end
    local data = loot:getMultipleLootRolls(maxRewards)
    if playerID and data then
        addItemsForPlayer(playerID, data)
    end
    return data
end

---Universal loot rolling function that handles both single and multiple rolls
---@param id string The unique identifier of the loot table
---@param _type string "single" for one item, "multiple" for multiple items
---@param playerId number|nil Optional player server ID to automatically give items to
---@param maxRewards number|nil Maximum items to roll (only used with "multiple" type, default: 1)
---@return table|false Single item data, array of items, empty table if invalid type, or false if no roll
---@usage local item = GetLootRoll("bank_vault", "single", 1) -- Single roll for player 1
---@usage local items = GetLootRoll("bank_vault", "multiple", 1, 3) -- Up to 3 items for player 1
---@usage local items = GetLootRoll("bank_vault", "multiple", nil, 2) -- 2 items without giving to player
function GetLootRoll(id, _type, playerId, maxRewards)
    if _type == "single" then
        return GetSingleLootRoll(id, playerId)
    elseif _type == "multiple" then
        return GetMultipleLootRolls(id, playerId, maxRewards)
    end
    return {}
end

---Removes a loot table from the CurrentLoot registry
---@param id string The unique identifier of the loot table to remove
---@return boolean True if table was found and removed, false otherwise
---@usage local success = RemoveLootTable("old_table")
function RemoveLootTable(id)
    if CurrentLoot[id] then
        CurrentLoot[id] = nil
        return true
    end
    return false
end

---Registers a new loot table, replacing any existing table with the same ID
---@param id string The unique identifier for the loot table
---@param contents table Array of loot items with structure: {name, metadata, min, max, chance, shared}
---@return table The created LootClass instance
---@usage local loot = RegisterLootTable("custom_drops", {{name="item1", min=1, max=3, chance=50, shared=false}})
function RegisterLootTable(id, contents)
    if CurrentLoot[id] then RemoveLootTable(id) end
    return LootClass:new(id, contents)
end

exports('GetLootTable', GetLootTable)
exports('GetSingleLootRoll', GetSingleLootRoll)
exports('GetMultipleLootRolls', GetMultipleLootRolls)
exports('GetLootRoll', GetLootRoll)
exports('RemoveLootTable', RemoveLootTable)
exports('RegisterLootTable', RegisterLootTable)

---Internal function that builds and registers all loot tables from the Config.LootTables
---Called automatically when the resource starts
---@usage buildConfigLootTables() -- Called internally on resource start
function BuildConfigLootTables()
    local lootTables = Config.LootTables
    if not lootTables then return print("[DEBUG] No loot tables found in config.") end
    for id, contents in pairs(lootTables) do
        DebugModePrint(("[DEBUG] Registering loot table '%s' from config."):format(id))
        LootClass:new(id, contents)
    end
end



--[[
-- examples
exports['MrNewbLootTables']:GetLootTable('pineapple robbery')
^^ will return a table of shit in the table

exports['MrNewbLootTables']:GetLootRoll('pineapple robbery', 'single')
^^ will return a single item from the table

exports['MrNewbLootTables']:GetLootRoll('pineapple robbery', 'multiple', 3)
^^ will give up to 3 items from the pineapple robbery loot table to player 3 automatically and return items they got from the table

-- 

]]