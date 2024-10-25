fx_version "cerulean"
lua54 'yes'
game "gta5"

author 'Trase'
description 'An advanced shop system to integrate tebex to your server'

ui_page 'web/build/index.html'

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'locales/*.lua',
}

client_scripts {
	'client/open.lua',
	'client/client.lua'
}

server_scripts {
	"@oxmysql/lib/MySQL.lua", -- If not using SQL, then remove this line
	'server/open.lua',
	'framework/**/server.lua',
	"server/server.lua",
}

files {
	'web/build/index.html',
	'web/build/**/*',
	'web/images/*.png',
}



--[[
	Todo:
	- Option to enable/disable SQL (if disabled, save all data to a json file)
	- Add options for framework compatibility (ESX, QB, etc)
	- Add options for customizing the UI
	- Add options for changing text (e.g. "Coins" to "Money")
	- Add options for VIP system
]]