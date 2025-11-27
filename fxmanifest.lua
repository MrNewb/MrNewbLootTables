fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'MrNewbLootTables'
description 'A secure, easily configurable loot system with runtime generation.'
version '0.1.0'

server_scripts {
	'configs/config.lua',
	'core/init.lua',
	'modules/*.lua',
}

dependencies {
	'/server:6116',
	'/onesync',
	'community_bridge'
}