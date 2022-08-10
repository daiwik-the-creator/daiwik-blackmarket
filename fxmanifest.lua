fx_version 'cerulean'
game 'gta5'

author 'DaiwiK'
description 'A Reputation based Black Market for QB-Core.'

support 'https://discord.gg/h78wJpSE6m'
version '1.0.0'

dependencies { 'qb-menu', 'qb-target', 'PolyZone', 'oxmysql' }

shared_script 'config.lua'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/client.lua',
    'client/cl_functions.lua'
} 

server_scripts { 
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/sv_functions.lua'
}

lua54 'yes'