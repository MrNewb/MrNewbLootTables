Bridge = exports.community_bridge:Bridge()

function DebugModePrint(msg)
    if not Config.Utility.Debug then return end
    Bridge.Prints.Debug(msg)
end


if not IsDuplicityVersion() then return end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Bridge.Version.AdvancedVersionChecker("MrNewb/patchnotes", resourceName)
    DebugModePrint("[DEBUG] Resource started, building loot tables from config...")
    BuildConfigLootTables()
    BuildConfigPayoutTables()
end)
-- CreateThread(function()
-- 	Wait(10000)
-- 	local lootShit = GetLootRoll("convenience_store", "single", 1, 1)
-- 	print("Loot Roll Result:")
-- 	print(lootShit)
-- 	print(json.encode(lootShit))
-- end)