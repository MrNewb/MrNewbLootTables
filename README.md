# MrNewbLootTables

Weighted loot tables and job payout tables. Other resources call the exports; this one owns the rolls.

[Documentation](https://mrnewb.github.io/docs/mrnewbloottables) · [Discord](https://discord.gg/mrnewbscripts)

## Install

Needs [ox_lib](https://github.com/overextended/ox_lib) and [Newb_Bridge](https://github.com/MrNewb/Newb_Bridge).

```cfg
ensure ox_lib
ensure Newb_Bridge
ensure MrNewbLootTables
```

Start this **after** ox_lib and Newb_Bridge, and **before** any resource that calls the exports. Keep the folder named `MrNewbLootTables`.

## Config

`configs/config.lua` is **server-only**. Drop weights, shared flags, and payout ranges never leave the server.

`shared = true` removes that row from the live table after it hits once (server-wide, not per player).

Shipped loot keys: `convenience_store`, `house_robbery`, `vehicle_search`, `dumpster` (stock qb-core items).
Shipped payout jobs: `taxi`, `bus`, `trucker`, `tow`, `garbage`, `mechanic`, `vineyard`, `hotdog`, `reporter`.

```lua
Config.LootTables = {
    convenience_store = {
        { name = 'tosti', metadata = {}, min = 1, max = 2, chance = 25, shared = false },
        { name = 'water_bottle', metadata = {}, min = 1, max = 3, chance = 25, shared = false },
    },
}

Config.JobPayouts = {
    taxi = {
        low_tier = { min = 75, max = 150 },
        mid_tier = { min = 150, max = 275 },
        high_tier = { min = 250, max = 400 },
    },
}
```

`chance` is a `lib.selector` **weight**, not a percent. `min` / `max` are item counts (capped at `1000`). Payout config keys are `*_tier`; the export argument is `'low'` / `'mid'` / `'high'`. Each payout range is rolled once when that job is registered.

Set `Config.Utility.Debug = true` for console roll traces.

## Exports

```lua
local item = exports.MrNewbLootTables:GetLootRoll('convenience_store', 'single', src)
local items = exports.MrNewbLootTables:GetLootRoll('house_robbery', 'multiple', src, 3)
local pay = exports.MrNewbLootTables:GetJobPayout('taxi', 'mid')
```

| Export | Side | Notes |
| --- | --- | --- |
| `GetLootRoll(lootTableId, rollType, src?, maxRewards?)` | server | `'single'` or `'multiple'`. Pass `src` to `addItem`. `maxRewards` defaults to `1`, max `25`. |
| `GetSingleLootRoll(lootTableId, src?)` | server | Missing table → `{}`. Empty weights → `false`. |
| `GetMultipleLootRolls(lootTableId, src?, maxRewards?)` | server | Missing or empty → `{}`. |
| `GetLootTable(lootTableId)` | server | Snapshot of current rows. Does not roll. |
| `RegisterLootTable(lootTableId, lootEntries)` | server | Replaces an existing id. Returns `true` / `false`. |
| `RemoveLootTable(lootTableId)` | server | `true` if it was present. |
| `RegisterPayoutTable(jobName, payoutTiers)` | server | Does **not** replace an existing job. Returns `true` / `false`. |
| `GetJobPayout(jobName, payTier?)` | server + client | `'low'` / `'mid'` / `'high'` (default `'low'`). Client caches the server's rolled amounts. |

Full detail: [docs](https://mrnewb.github.io/docs/mrnewbloottables).
