fx_version "cerulean"
lua54 'yes'
game "gta5"

author 'Trase'
description 'An advanced shop system to integrate tebex to your server'
version '1.0.0'

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