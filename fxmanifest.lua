fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'MrNewbLootTables'
description 'Configurable loot tables and dynamic job payout generation'
author 'MrNewb'
version '0.4.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@Newb_Bridge/import.lua',
}

server_scripts {
    'configs/config.lua',
    'resource/server/debug.lua',
    'resource/server/loot.lua',
    'resource/server/payout.lua',
}

client_scripts {
    'resource/client/payout.lua',
}

dependencies {
    'ox_lib',
    'Newb_Bridge',
}

escrow_ignore {
    '**/*.lua',
}
