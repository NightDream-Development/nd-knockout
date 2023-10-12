fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.0'



client_scripts {
	'client.lua',
	'Config.lua',
} 

shared_scripts {
	"@ox_lib/init.lua",
	"config.lua",
	'@qbx_core/import.lua',
}

modules {
    'qbx_core:playerdata',
    'qbx_core:utils',
}
