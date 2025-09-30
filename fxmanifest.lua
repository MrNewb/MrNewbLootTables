fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'MrNewbLootTables'
description 'A dynamic loot table system.'
version '0.0.1'

shared_scripts {
	'src/shared/config.lua',
}

server_scripts {
	'src/server/classes/*.lua',
}

dependencies {
	'/server:6116',
	'/onesync',
	'community_bridge'
}

escrow_ignore {
	'src/**/*.lua',
}