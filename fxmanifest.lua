fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
name 'ez_lib'
author 'Paradox'
version '0.2.3'
repository 'https://github.com/hi-i-am-andrew/ez_lib'
description 'A library of shared functions to utilise in other resources.'

dependencies {
    '/server:7290',
    '/onesync',
    'ox_lib',
}

ui_page 'web/build/index.html'

files {
    'init.lua',
    'web/build/index.html',
    'web/build/**/*',
}

shared_scripts {
    '@ox_lib/init.lua',
    'resource/init.lua',
}

client_scripts {
    'resource/**/client/*.lua',
    'resource/**/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'resource/**/server/*.lua',
    'resource/**/server.lua'
}
