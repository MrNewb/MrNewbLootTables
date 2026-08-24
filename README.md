# MrNewbLootTables

Weighted loot tables and job payout tables. Other resources call the exports; this one owns the rolls.

[Documentation](https://mrnewb.github.io/docs/mrnewbloottables) · [Install guide](https://mrnewb.github.io/docs/mrnewbloottables/install) · [Tebex](https://mrnewbscripts.tebex.io/) · [Discord](https://discord.gg/mrnewbscripts)

## Features

- Weighted loot tables via ox_lib `lib.selector` (`chance` is a weight, not a percent)
- Job payout tables with `low` / `mid` / `high` tiers
- `shared = true` pulls that row out of the live table after it hits once (server-wide)
- Config is **server-only** — weights and payout ranges never hit the client
- Pass a player source to `addItem` automatically, or just take the roll
- Runtime `RegisterLootTable` / `RegisterPayoutTable` for other resources

## Install

Needs [ox_lib](https://github.com/overextended/ox_lib) and [Newb_Bridge](https://github.com/MrNewb/Newb_Bridge). Start this **before** anything that calls the exports. Keep the folder named `MrNewbLootTables`.

Item names in the tables must already exist in your inventory. This resource does not ship items.

```cfg
ensure ox_lib
ensure Newb_Bridge
ensure MrNewbLootTables
```

Full start order and field tables: [install guide](https://mrnewb.github.io/docs/mrnewbloottables/install).

## Config

`configs/config.lua` is a **server script**. Shipped loot keys: `convenience_store`, `house_robbery`, `vehicle_search`, `dumpster`. Shipped payout jobs: `taxi`, `bus`, `trucker`, `tow`, `garbage`, `mechanic`, `vineyard`, `hotdog`, `reporter`.

```lua
local item = exports.MrNewbLootTables:GetLootRoll('convenience_store', 'single', src)
local items = exports.MrNewbLootTables:GetLootRoll('house_robbery', 'multiple', src, 3)
local pay = exports.MrNewbLootTables:GetJobPayout('taxi', 'mid')
```

Payout config keys are `*_tier`; the export argument is `'low'` / `'mid'` / `'high'`. Each range is rolled once when that job is registered.

Exports: [server](https://mrnewb.github.io/docs/mrnewbloottables/exports/server-exports) · [client](https://mrnewb.github.io/docs/mrnewbloottables/exports/client-exports).
