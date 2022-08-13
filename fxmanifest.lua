fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

author 'EzekielJ Development Studios'
description 'Modern Immersive Pickpocket system for FiveM (ESX Only)'
version '0.0.1'

shared_scripts {
    '@ox_lib/init.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua'
}
client_scripts {
    'config.lua',
    'client/main.lua'
}

dependencies {
    'es_extended',
    'qtarget',
    'ox_lib',
    'ox_inventory'
}
