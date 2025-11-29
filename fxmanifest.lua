fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'MrNewbLootTables'
description 'A secure, easily configurable loot system and dynamic job payout system with runtime generation.'
version '0.2.0'

client_scripts {
	'core/init.lua',
	'modules/**/client.lua',
}

server_scripts {
	'configs/config.lua',
	'core/init.lua',
	'modules/**/server.lua',
}

dependencies {
	'/server:6116',
	'/onesync',
	'community_bridge'
}