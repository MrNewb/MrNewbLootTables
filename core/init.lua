Bridge = exports.community_bridge:Bridge()

if not IsDuplicityVersion() then return end

function DebugModePrint(msg)
    if not Config.Utility.Debug then return end
    Bridge.Prints.Debug(msg)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Bridge.Version.AdvancedVersionChecker("MrNewb/patchnotes", resourceName)
    Bridge.Version.AdvancedVersionChecker("MrNewb/patchnotes", "community_bridge")
    DebugModePrint("[DEBUG] Resource started, building loot tables from config...")
    BuildConfigLootTables()
    BuildConfigPayoutTables()
end)