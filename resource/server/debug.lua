function LootDebugPrint(message)
    if not Config.Utility or not Config.Utility.Debug then return end
    print(('[MrNewbLootTables] %s'):format(message))
end
