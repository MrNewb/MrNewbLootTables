--		___  ___       _   _                  _      _____              _         _
--		|  \/  |      | \ | |                | |    /  ___|            (_)       | |
--		| .  . | _ __ |  \| |  ___ __      __| |__  \ `--.   ___  _ __  _  _ __  | |_  ___
--		| |\/| || '__|| . ` | / _ \\ \ /\ / /| '_ \  `--. \ / __|| '__|| || '_ \ | __|/ __|
--		| |  | || |   | |\  ||  __/ \ V  V / | |_) |/\__/ /| (__ | |   | || |_) || |_ \__ \
--		\_|  |_/|_|   \_| \_/ \___|  \_/\_/  |_.__/ \____/  \___||_|   |_|| .__/  \__||___/
--									          							  | |
--									          							  |_|
--
--		  Need support? Join our Discord server for help: https://discord.gg/mrnewbscripts
--		  If you need help with configuration or have any questions, please do not hesitate to ask.
--		  Docs Are Always Available At -- https://mrnewbs-scrips.gitbook.io/guide


Config = {}

Config.Utility = {
    Debug = false, -- Set to true for debug mode, this will enable debug prints
}

Config.LootTables = {
    ["convenience_store"] = {
        { name = "chips", metadata = {}, min = 1, max = 3, chance = 40, shared = false },
        { name = "soda", metadata = {}, min = 1, max = 2, chance = 35, shared = false },
        { name = "lottery_ticket", metadata = {}, min = 1, max = 1, chance = 10, shared = true },
        { name = "candy_bar", metadata = {}, min = 1, max = 5, chance = 15, shared = false },
    },

    ["bank_vault"] = {
        { name = "cash_stack", metadata = {}, min = 500, max = 1500, chance = 50, shared = false },
        { name = "gold_bar", metadata = {}, min = 1, max = 3, chance = 30, shared = true },
        { name = "diamond", metadata = {}, min = 1, max = 2, chance = 15, shared = true },
        { name = "bond_certificate", metadata = {}, min = 1, max = 5, chance = 5, shared = false },
    },

    ["fishing_spot"] = {
        { name = "fish", metadata = { type = "bass" }, min = 1, max = 3, chance = 60, shared = false },
        { name = "old_boot", metadata = {}, min = 1, max = 1, chance = 20, shared = false },
        { name = "treasure_chest", metadata = {}, min = 1, max = 1, chance = 5, shared = true },
        { name = "seaweed", metadata = {}, min = 2, max = 5, chance = 15, shared = false },
    },

    ["military_cache"] = {
        { name = "ammo_box", metadata = {}, min = 50, max = 200, chance = 40, shared = false },
        { name = "medkit", metadata = {}, min = 1, max = 2, chance = 25, shared = false },
        { name = "rifle", metadata = {}, min = 1, max = 1, chance = 20, shared = true },
        { name = "night_vision", metadata = {}, min = 1, max = 1, chance = 15, shared = true },
    }
}

Config.JobPayouts = {
    ["windowwashing"] = {
        low_tier = { min = 50, max = 150 },
        mid_tier = { min = 150, max = 300 },
        high_tier = { min = 200, max = 500 },
    },
    ["builder"] = {
        low_tier = { min = 50, max = 150 },
        mid_tier = { min = 150, max = 300 },
        high_tier = { min = 200, max = 500 },
    },
    ["delivery"] = {
        low_tier = { min = 50, max = 150 },
        mid_tier = { min = 150, max = 300 },
        high_tier = { min = 200, max = 500 },
    },
    ["garbage"] = {
        low_tier = { min = 50, max = 150 },
        mid_tier = { min = 150, max = 300 },
        high_tier = { min = 200, max = 500 },
    },
    ["oilrig"] = {
        low_tier = { min = 50, max = 150 },
        mid_tier = { min = 150, max = 300 },
        high_tier = { min = 200, max = 500 },
    },
}