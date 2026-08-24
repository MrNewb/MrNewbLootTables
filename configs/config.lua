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
--		  Check out my paid scripts and freebies at https://mrnewbscripts.tebex.io/
--		  If you need help with configuration or have any questions, please do not hesitate to ask.
--		  Docs Are Always Available At -- https://mrnewb.github.io/docs/
--

Config = {}

Config.Utility = {
    Debug = false,
}

-- Stock qb-core item and job names. Swap anything your inventory renamed.
Config.LootTables = {
    convenience_store = {
        { name = 'tosti', metadata = {}, min = 1, max = 2, chance = 25, shared = false },
        { name = 'sandwich', metadata = {}, min = 1, max = 2, chance = 20, shared = false },
        { name = 'water_bottle', metadata = {}, min = 1, max = 3, chance = 25, shared = false },
        { name = 'kurkakola', metadata = {}, min = 1, max = 2, chance = 15, shared = false },
        { name = 'snikkel_candy', metadata = {}, min = 1, max = 3, chance = 10, shared = false },
        { name = 'twerks_candy', metadata = {}, min = 1, max = 3, chance = 5, shared = false },
    },
    house_robbery = {
        { name = 'rolex', metadata = {}, min = 1, max = 1, chance = 15, shared = false },
        { name = 'goldchain', metadata = {}, min = 1, max = 2, chance = 20, shared = false },
        { name = 'diamond_ring', metadata = {}, min = 1, max = 1, chance = 10, shared = false },
        { name = 'laptop', metadata = {}, min = 1, max = 1, chance = 12, shared = false },
        { name = 'tablet', metadata = {}, min = 1, max = 1, chance = 12, shared = false },
        { name = 'phone', metadata = {}, min = 1, max = 1, chance = 18, shared = false },
        { name = '10kgoldchain', metadata = {}, min = 1, max = 1, chance = 8, shared = true },
        { name = 'markedbills', metadata = {}, min = 1, max = 1, chance = 5, shared = true },
    },
    vehicle_search = {
        { name = 'water_bottle', metadata = {}, min = 1, max = 1, chance = 25, shared = false },
        { name = 'sandwich', metadata = {}, min = 1, max = 1, chance = 20, shared = false },
        { name = 'phone', metadata = {}, min = 1, max = 1, chance = 15, shared = false },
        { name = 'lockpick', metadata = {}, min = 1, max = 1, chance = 15, shared = false },
        { name = 'lighter', metadata = {}, min = 1, max = 1, chance = 15, shared = false },
        { name = 'radio', metadata = {}, min = 1, max = 1, chance = 10, shared = false },
    },
    dumpster = {
        { name = 'tosti', metadata = {}, min = 1, max = 1, chance = 20, shared = false },
        { name = 'water_bottle', metadata = {}, min = 1, max = 1, chance = 20, shared = false },
        { name = 'lockpick', metadata = {}, min = 1, max = 1, chance = 15, shared = false },
        { name = 'rolling_paper', metadata = {}, min = 1, max = 3, chance = 20, shared = false },
        { name = 'stickynote', metadata = {}, min = 1, max = 2, chance = 15, shared = false },
        { name = 'repairkit', metadata = {}, min = 1, max = 1, chance = 10, shared = false },
    },
}

Config.JobPayouts = {
    taxi = {
        low_tier = { min = 75, max = 150 },
        mid_tier = { min = 150, max = 275 },
        high_tier = { min = 250, max = 400 },
    },
    bus = {
        low_tier = { min = 80, max = 160 },
        mid_tier = { min = 160, max = 280 },
        high_tier = { min = 260, max = 420 },
    },
    trucker = {
        low_tier = { min = 100, max = 200 },
        mid_tier = { min = 200, max = 350 },
        high_tier = { min = 300, max = 550 },
    },
    tow = {
        low_tier = { min = 90, max = 180 },
        mid_tier = { min = 180, max = 320 },
        high_tier = { min = 280, max = 480 },
    },
    garbage = {
        low_tier = { min = 70, max = 140 },
        mid_tier = { min = 140, max = 250 },
        high_tier = { min = 220, max = 400 },
    },
    mechanic = {
        low_tier = { min = 80, max = 160 },
        mid_tier = { min = 160, max = 300 },
        high_tier = { min = 250, max = 450 },
    },
    vineyard = {
        low_tier = { min = 60, max = 120 },
        mid_tier = { min = 120, max = 220 },
        high_tier = { min = 200, max = 350 },
    },
    hotdog = {
        low_tier = { min = 40, max = 90 },
        mid_tier = { min = 90, max = 160 },
        high_tier = { min = 140, max = 250 },
    },
    reporter = {
        low_tier = { min = 50, max = 110 },
        mid_tier = { min = 110, max = 200 },
        high_tier = { min = 180, max = 320 },
    },
}
