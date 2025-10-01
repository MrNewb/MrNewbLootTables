# MrNewbLootTables
**A centeralized loot table system for FiveM.**
A flexible and configurable loot generation system that supports weighted random rolls, shared items, and automatic inventory integration using [Community Bridge](https://github.com/TheOrderFivem/community_bridge).

[![Docs](https://img.shields.io/badge/Docs-GitBook-blue?style=for-the-badge&logo=gitbook)](https://mrnewbs-scrips.gitbook.io/guide)
[![Discord](https://img.shields.io/discord/1204398264812830720?label=Discord&logo=discord&color=7289DA&style=for-the-badge)](https://discord.gg/mrnewbscripts)
[![Ko-fi](https://img.shields.io/badge/Support-Ko--fi-FF5E5B?style=for-the-badge&logo=ko-fi)](https://ko-fi.com/R5R76BIM9)

---

## Features

* **Weighted Random Loot System** - Configure items with different reward chances
* **Shared Items** - Optional items that can only be looted once before being removed from the table
* **Multiple Roll Support** - Get single items or roll multiple items at once
* **Automatic Inventory Integration** - Seamlessly adds items to player inventories
* **Framework Compatibility** - Works with ESX, QBCore, and Qbox/QBX via Community Bridge
* **Configurable Loot Tables** - Easily define custom loot tables in the config or via runtime
* **Export Functions** - Use the loot system from other resources to control all loot across your server
* **Debug Mode** - Built-in debugging for development and troubleshooting

---

## Installation

1. Install [Community Bridge](https://github.com/TheOrderFivem/community_bridge)
2. Extract this resource into your `resources` folder
3. Add `ensure MrNewbLootTables` to your `server.cfg`
4. Configure your loot tables in `src/shared/config.lua`

---

## Configuration

Configure loot tables in `src/shared/config.lua`:

```lua
Config.LootTables = {
    ["your_loot_table"] = {
        { name = "item_name", metadata = {}, min = 1, max = 3, chance = 50, shared = false },
        { name = "rare_item", metadata = {}, min = 1, max = 1, chance = 10, shared = true },
    }
}
```

### Loot Item Properties:
- **name**: Item spawn name in your inventory system
- **metadata**: Item metadata/properties (optional)
- **min/max**: Minimum and maximum quantity to give
- **chance**: Drop chance percentage (higher = more likely)
- **shared**: If true, item is removed from table after being looted once

---

## Usage Examples

### From Other Resources:

```lua
-- Get a single random item from a loot table
local item = exports['MrNewbLootTables']:GetLootRoll('convenience_store', 'single')

-- Give a player a single random item
local item = exports['MrNewbLootTables']:GetLootRoll('bank_vault', 'single', playerId)

-- Roll multiple items (up to 3) for a player
local items = exports['MrNewbLootTables']:GetLootRoll('military_cache', 'multiple', playerId, 3)

-- Just get the loot table contents
local lootTable = exports['MrNewbLootTables']:GetLootTable('fishing_spot')

-- Register a new loot table at runtime
exports['MrNewbLootTables']:RegisterLootTable('custom_table', {
    { name = "water", min = 1, max = 2, chance = 100, shared = false }
})
```

---

## Pre-configured Loot Tables

The resource comes with several example loot tables:
- `pineapple robbery` - Basic robbery rewards
- `convenience_store` - Store robbery loot
- `bank_vault` - High-value bank heist rewards
- `fishing_spot` - Fishing activity rewards
- `military_cache` - Military equipment drops

---

## Requirements

* Community Bridge
* Compatible framework (ESX, QBCore, Qbox/QBX)
* FiveM Server build 6116 or higher
* OneSync enabled

---

## Support

Need help? Join our Discord server or check the documentation for detailed guides and examples.